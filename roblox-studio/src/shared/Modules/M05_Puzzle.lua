--!strict
--[[
	M05_Puzzle.lua — Puzzle-Engine (Phase 3 Runtime)
	==================================================

	User Story:
	  Als Spieler:in möchte ich in Quests kleine Puzzle lösen
	  (Sortierreihenfolge, Bau-Sequenzen, Memory-Karten, Logik-Rätsel),
	  ohne dass es sich nach Quiz anfühlt — die Puzzle sind inszenierte
	  Mini-Spiele in der Welt (Kran-Steuerung, Werft-Bau-Reihenfolge).

	Architektur:
	  - PuzzleRegistry: puzzleId → Puzzle-Definition
	  - Start(player, puzzleId, params): erstellt Player-Puzzle-State
	  - Submit(player, puzzleId, input): prüft Lösung
	  - Hint(player, puzzleId, level): 3 Stufen (subtle → clear)
	  - Adaptive: nutzt M04_Adaptive für Hint-Depth
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Log = require(ReplicatedStorage.Shared.Util.Log)
local M04_Adaptive = require(ReplicatedStorage.Shared.Modules.M04_Adaptive)

local M05_Puzzle = {}

-- ============================================================
-- Types
-- ============================================================

export type PuzzleType = "sort" | "build" | "memory" | "logic"

export type Puzzle = {
	id: string,
	type: PuzzleType,
	domain: "Math" | "Physics" | "Logic" | "Language" | "Memory" | "Planning",
	difficulty_range: { min: number, max: number },
	prompt_key: string,
	-- Returns (success, score 0..1)
	solution_check: (input: any, params: { [string]: any }?) -> (boolean, number),
	hint_keys: { string },
}

export type PuzzleState = {
	puzzle_id: string,
	pid: string,
	start_time: number,
	attempts: number,
	hints_used: number,
	solved: boolean,
}

-- ============================================================
-- Sample-Puzzles (Hamburg Harbor)
-- ============================================================

M05_Puzzle.Registry = {
	-- CraneTutorial: Sort the sequence of crane operations
	-- Spieler:in muss die richtige Reihenfolge wählen (Hebelgesetz)
	CraneTutorial = {
		id = "CraneTutorial",
		type = "sort",
		domain = "Physics",
		difficulty_range = { min = 0.3, max = 0.7 },
		prompt_key = "puzzle.crane_tutorial.prompt",
		-- Korrekte Reihenfolge: Seil-Befestigen → Hebel-Positionieren → Last-Heben → Senken
		solution_check = function(input, _params)
			if type(input) ~= "table" then return false, 0 end
			local correct = { "Seil-Befestigen", "Hebel-Positionieren", "Last-Heben", "Senken" }
			if #input ~= #correct then return false, 0 end
			local matches = 0
			for i, v in ipairs(input) do
				if v == correct[i] then matches += 1 end
			end
			return matches == #correct, matches / #correct
		end,
		hint_keys = {
			"puzzle.crane_tutorial.hint1",  -- "Was ist das Hebelgesetz?"
			"puzzle.crane_tutorial.hint2",  -- "Befestigung vor Bewegung!"
			"puzzle.crane_tutorial.hint3",  -- "Konkrete Reihenfolge: Befestigen, Positionieren, Heben, Senken"
		},
	},

	-- CraneSelector: Welcher Kran für welche Last?
	-- Logic-Puzzle: Spieler:in wählt Crane A/B/C basierend auf Gewicht
	CraneSelector = {
		id = "CraneSelector",
		type = "logic",
		domain = "Math",
		difficulty_range = { min = 0.4, max = 0.8 },
		prompt_key = "puzzle.crane_selector.prompt",
		solution_check = function(input, params)
			local weight = params and params.weight or 100
			-- Crane A: 50-200kg, B: 200-500kg, C: 500-1000kg
			local correct
			if weight < 200 then correct = "CraneA"
			elseif weight < 500 then correct = "CraneB"
			else correct = "CraneC" end
			return input == correct, 1.0
		end,
		hint_keys = {
			"puzzle.crane_selector.hint1",
			"puzzle.crane_selector.hint2",
			"puzzle.crane_selector.hint3",
		},
	},

	-- ReleaseContainer: Memory-Puzzle
	-- Spieler:in merkt sich Farb-Sequenz und gibt sie zurück
	ReleaseContainer = {
		id = "ReleaseContainer",
		type = "memory",
		domain = "Memory",
		difficulty_range = { min = 0.3, max = 0.9 },
		prompt_key = "puzzle.release_container.prompt",
		solution_check = function(input, params)
			local correct = params and params.sequence or {}
			if type(input) ~= "table" or #input ~= #correct then return false, 0 end
			local matches = 0
			for i, v in ipairs(input) do
				if v == correct[i] then matches += 1 end
			end
			return matches == #correct, matches / #correct
		end,
		hint_keys = {
			"puzzle.release_container.hint1",
			"puzzle.release_container.hint2",
		},
	},
}

-- ============================================================
-- Per-Player-State
-- ============================================================

local activeStates: { [string]: PuzzleState } = {}  -- key = pid + puzzle_id

local function stateKey(player: any, puzzleId: string): string
	local M06_Inventory = require(ReplicatedStorage.Shared.Modules.M06_Inventory)
	return M06_Inventory:ToPid(player) .. ":" .. puzzleId
end

-- ============================================================
-- Public API
-- ============================================================

function M05_Puzzle:Start(player: any, puzzleId: string): PuzzleState?
	local puzzle = self.Registry[puzzleId]
	if not puzzle then
		Log:Warn(("[M05] Unknown puzzle: %s"):format(puzzleId))
		return nil
	end

	local key = stateKey(player, puzzleId)
	if activeStates[key] and not activeStates[key].solved then
		Log:Debug(("[M05] Resuming puzzle %s for %s"):format(puzzleId, tostring(player)))
		return activeStates[key]
	end

	local state: PuzzleState = {
		puzzle_id = puzzleId,
		pid = require(ReplicatedStorage.Shared.Modules.M06_Inventory):ToPid(player),
		start_time = os.time(),
		attempts = 0,
		hints_used = 0,
		solved = false,
	}
	activeStates[key] = state
	Log:Info(("[M05] Started puzzle %s"):format(puzzleId))
	return state
end

function M05_Puzzle:Submit(player: any, puzzleId: string, input: any, params: { [string]: any }?): (boolean, number)
	local puzzle = self.Registry[puzzleId]
	if not puzzle then return false, 0 end

	local key = stateKey(player, puzzleId)
	local state = activeStates[key]
	if not state then
		Log:Warn(("[M05] Submit without Start: %s"):format(puzzleId))
		return false, 0
	end
	state.attempts += 1

	local ok, score = puzzle.solution_check(input, params)
	if ok then
		state.solved = true
		Log:Info(("[M05] Solved %s (score=%.2f, attempts=%d, hints=%d)"):format(
			puzzleId, score, state.attempts, state.hints_used))
	else
		Log:Debug(("[M05] Failed attempt %d for %s (score=%.2f)"):format(
			state.attempts, puzzleId, score))
	end
	return ok, score
end

function M05_Puzzle:Hint(player: any, puzzleId: string, level: number): string?
	local puzzle = self.Registry[puzzleId]
	if not puzzle then return nil end

	local key = stateKey(player, puzzleId)
	local state = activeStates[key]
	if not state then return nil end

	-- level: 1=first subtle, 2=gentle, 3=clear
	state.hints_used = math.min(level, #puzzle.hint_keys)
	if state.hints_used > #puzzle.hint_keys then return nil end

	return puzzle.hint_keys[state.hints_used]
end

function M05_Puzzle:IsSolved(player: any, puzzleId: string): boolean
	local key = stateKey(player, puzzleId)
	return activeStates[key] ~= nil and activeStates[key].solved == true
end

function M05_Puzzle:GetState(player: any, puzzleId: string): PuzzleState?
	local key = stateKey(player, puzzleId)
	return activeStates[key]
end

-- Cleanup
Players.PlayerRemoving:Connect(function(player)
	local pidPrefix = require(ReplicatedStorage.Shared.Modules.M06_Inventory):ToPid(player) .. ":"
	for key in pairs(activeStates) do
		if string.sub(key, 1, #pidPrefix) == pidPrefix then
			activeStates[key] = nil
		end
	end
end)

return M05_Puzzle