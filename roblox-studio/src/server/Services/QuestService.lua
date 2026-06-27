--!strict
--[[
	QuestService.lua — World-Services für Quest-Engine (M-02)
	==========================================================

	User Story:
	  Als Spieler:in möchte ich, dass Quests basierend auf echten
	  World-Events (NPC-Gespräch, Position, Puzzle) completen können —
	  nicht hardcoded true.

	Architektur:
	  - PlayerProgress: pro Spieler:in { questId → QuestProgress }
	  - WorldServices: Helper-Bundle für Quest-Validators
	  - DialogueHook: NPC-ProximityPrompt → hasTalkedToNpc-Flag setzen
	  - ZoneHook: Touched → isInZone-Check (Phase 3)

	Diese Datei registriert sich selbst in ServiceRegistry als "Quest".
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Log = require(ReplicatedStorage.Shared.Util.Log)
local M02_Quest = require(ReplicatedStorage.Shared.Modules.M02_Quest)

local QuestService = {}

-- ============================================================
-- Per-Player-Progress
-- ============================================================

local playerProgress: { [Player]: { [string]: any } } = {}

local function getProgress(player: Player, questId: string): any
	if not playerProgress[player] then
		playerProgress[player] = {}
	end
	if not playerProgress[player][questId] then
		playerProgress[player][questId] = M02_Quest:StartQuest(player, questId)
	end
	return playerProgress[player][questId]
end

-- ============================================================
-- World-Services für Quest-Validators
-- ============================================================

local function hasTalkedToNpc(player: Player, npcId: string): boolean
	-- Spieler hat mit NPC gesprochen, wenn ein NPCSpawn_* Part mit
	-- diesem NpcId jemals triggered wurde (via ProximityPrompt)
	-- Vereinfachung: true sobald Spieler-Module das markiert hat
	local flag = player:GetAttribute("talked_to_" .. npcId)
	return flag == true
end

local function isInZone(player: Player, center: Vector3, radius: number): boolean
	local char = player.Character
	if not char then return false end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return false end
	return (hrp.Position - center).Magnitude <= radius
end

local function buildWorldServices(): M02_Quest.WorldServices
	return {
		hasTalkedToNpc = hasTalkedToNpc,
		hasItem = function(_player, _itemId, _count)
			-- Phase 3: Inventory-Integration
			return false
		end,
		hasRecentEvent = function(_player, _eventName, _withinSeconds)
			return false
		end,
		isInZone = isInZone,
		hasSolvedPuzzle = function(_player, _puzzleId)
			-- Phase 3: Puzzle-Service-Integration
			return false
		end,
		hasBuilt = function(_player, _buildId)
			return false
		end,
		allTeamDone = function(_player, _questId, _stepIdx)
			return false
		end,
	}
end

-- ============================================================
-- Public API
-- ============================================================

function QuestService:Init()
	-- Auto-Evaluate alle laufenden Quests alle 2 Sekunden
	task.spawn(function()
		while true do
			task.wait(2)
			for player, quests in pairs(playerProgress) do
				for questId, progress in pairs(quests) do
					if not progress.completed_at then
						local ok, reason = M02_Quest:EvaluateStep(player, progress, buildWorldServices())
						if ok then
							Log:Info(("[QuestService] %s advanced %s (step %d)"):format(
								player.Name, questId, progress.current_step or "?"))
							M02_Quest:AdvanceStep(progress)
							-- Phase 3: reward aus QuestData.rewards austeilen
						end
					end
				end
			end
		end
	end)

	Log:Info("[QuestService] Initialized — auto-evaluate every 2s")
end

function QuestService:StartQuest(player: Player, questId: string): any
	local progress = getProgress(player, questId)
	Log:Info(("[QuestService] %s started %s"):format(player.Name, questId))
	return progress
end

function QuestService:MarkNpcTalked(player: Player, npcId: string)
	player:SetAttribute("talked_to_" .. npcId, true)
	Log:Debug(("[QuestService] %s talked to %s"):format(player.Name, npcId))
end

function QuestService:GetProgress(player: Player, questId: string): any
	return playerProgress[player] and playerProgress[player][questId] or nil
end

function QuestService:GetAllProgress(player: Player): { [string]: any }
	return playerProgress[player] or {}
end

-- Cleanup
Players.PlayerRemoving:Connect(function(player)
	playerProgress[player] = nil
end)

return QuestService