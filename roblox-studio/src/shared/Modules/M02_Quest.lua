--!strict
--[[
	M02_Quest.lua — Quest-System
	=============================

	Vollständige Spec: docs/09_system_architecture.md (M-02)

	Quest-Typen: solo, duo, team, mini, exploration, event

	Phase 2: Datamodel + Trigger-API + Completion-Hooks via WorldService.
	Phase 3: vollständige Implementierung mit UI + Adaptive-Kopplung.

	Completion-Logik:
	Die completion_condition eines Quest-Steps erhält (player, questState, world).
	world ist ein von Bootstrap.server.lua gefüllter Service-Bundle, der Zugriff
	auf Dialogue-, Inventory-, Event-, Puzzle-State bietet. Damit sind Quest-Bedingungen
	echt auswertbar — nicht hartcodiert true.

	User Story (HH_01 Beispiel):
	  Als 10-jährige Spielerin in Hamburg Harbor möchte ich von Hafenwirtin Lina
	  eine Aufgabe bekommen und sie durch Dialog + Puzzle + Kran-Action lösen,
	  damit ich Hebelgesetz spielerisch lerne.
]]

local M02_Quest = {}

-- ============================================================
-- Datenmodell
-- ============================================================

export type QuestStepType = "dialogue" | "puzzle" | "objective" | "collect" | "build" | "team"

export type WorldServices = {
	-- Dialogue-Check: wurde Spieler:in mit NPC dialog已经 geführt?
	hasTalkedToNpc: (player: Player, npcId: string) -> boolean,
	-- Inventory-Check: hat Spieler:in mind. count Items vom Typ itemId?
	hasItem: (player: Player, itemId: string, count: number) -> boolean,
	-- Event-Check: ist ein benutzerdefiniertes Event (z.B. "container_placed") in den letzten N Sekunden passiert?
	hasRecentEvent: (player: Player, eventName: string, withinSeconds: number) -> boolean,
	-- Position-Check: ist Spieler:in in Zone (Position in Radius)?
	isInZone: (player: Player, center: Vector3, radius: number) -> boolean,
	-- Puzzle-Check: hat Spieler:in Puzzle mit gegebener ID gelöst?
	hasSolvedPuzzle: (player: Player, puzzleId: string) -> boolean,
	-- Build-Check: hat Spieler:in Item gebaut (in Inventory)?
	hasBuilt: (player: Player, buildId: string) -> boolean,
	-- Team-Check: haben alle Team-Mitglieder ihre Teilschritte erfüllt?
	allTeamDone: (player: Player, questId: string, stepIdx: number) -> boolean,
}

export type QuestStep = {
	id: string,
	type: QuestStepType,
	target: string,
	-- Real completion check. Returns (completed, reason?).
	completion_condition: (player: Player, questState: any, world: WorldServices) -> (boolean, string?),
}

export type Quest = {
	id: string,
	title_key: string,
	description_key: string,
	type: "solo" | "duo" | "team" | "mini" | "exploration" | "event",
	district: string,
	quest_giver: string?,
	min_team_size: number?,
	max_team_size: number?,
	steps: { QuestStep },
	prerequisites: { string },
	rewards: { { type: string, amount: number, item: string? } },
	age_band_target: "9-11" | "12-13" | "14-16" | "all",
	adaptive_range: { min: number, max: number },
}

export type QuestProgress = {
	pid: string,
	quest_id: string,
	current_step: number,
	state: { [string]: any },
	started_at: number,
	completed_at: number?,
	step_completed_at: { [number]: number },
}

-- ============================================================
-- Built-in Step-Validators
-- ============================================================
-- Generische Completion-Funktionen, die in Quest-Definitionen verwendet werden.

local Validators = {}

-- Dialogue-Step: Spieler muss mit NPC gesprochen haben
Validators.dialogue = function(step: QuestStep): (Player, any, WorldServices) -> (boolean, string?)
	return function(_player: Player, _state: any, world: WorldServices): (boolean, string?)
		if not world or not world.hasTalkedToNpc then
			return false, "WorldServices.hasTalkedToNpc nicht verfügbar"
		end
		return world.hasTalkedToNpc(_player, step.target)
	end
end

-- Puzzle-Step: Spieler muss Puzzle gelöst haben
Validators.puzzle = function(step: QuestStep): (Player, any, WorldServices) -> (boolean, string?)
	return function(_player: Player, _state: any, world: WorldServices): (boolean, string?)
		if not world or not world.hasSolvedPuzzle then
			return false, "WorldServices.hasSolvedPuzzle nicht verfügbar"
		end
		return world.hasSolvedPuzzle(_player, step.target)
	end
end

-- Objective-Step: Spieler muss in Zone sein (target = "ZoneName" mit Zone in world)
Validators.objective = function(step: QuestStep, zones: { [string]: { center: Vector3, radius: number } }?): (Player, any, WorldServices) -> (boolean, string?)
	return function(_player: Player, _state: any, world: WorldServices): (boolean, string?)
		if not world or not world.isInZone then
			return false, "WorldServices.isInZone nicht verfügbar"
		end
		local zone = zones and zones[step.target]
		if not zone then
			return false, "Objective-Zone unbekannt: " .. step.target
		end
		return world.isInZone(_player, zone.center, zone.radius)
	end
end

-- Collect-Step: Spieler muss count Items vom Typ target haben
Validators.collect = function(step: QuestStep, defaults: { count: number? }?): (Player, any, WorldServices) -> (boolean, string?)
	local requiredCount = (defaults and defaults.count) or 1
	return function(_player: Player, _state: any, world: WorldServices): (boolean, string?)
		if not world or not world.hasItem then
			return false, "WorldServices.hasItem nicht verfügbar"
		end
		return world.hasItem(_player, step.target, requiredCount)
	end
end

-- Build-Step: Spieler muss Item gebaut haben
Validators.build = function(step: QuestStep): (Player, any, WorldServices) -> (boolean, string?)
	return function(_player: Player, _state: any, world: WorldServices): (boolean, string?)
		if not world or not world.hasBuilt then
			return false, "WorldServices.hasBuilt nicht verfügbar"
		end
		return world.hasBuilt(_player, step.target)
	end
end

-- Team-Step: alle Team-Mitglieder müssen ihren Part erfüllt haben
Validators.team = function(quest: Quest, stepIdx: number): (Player, any, WorldServices) -> (boolean, string?)
	return function(_player: Player, _state: any, world: WorldServices): (boolean, string?)
		if not world or not world.allTeamDone then
			return false, "WorldServices.allTeamDone nicht verfügbar"
		end
		return world.allTeamDone(_player, quest.id, stepIdx)
	end
end

-- ============================================================
-- Sample-Quests (Hamburg Harbor)
-- ============================================================

M02_Quest.SampleQuests = {
	-- ============================================================
	-- HH_01: Kran-Intro (Einstiegsquest, alle Altersbänder)
	-- Lernziele: Hebelgesetz (Physik), Mengenpriorisierung (Mathe)
	-- Quest-Giver: Hafenwirtin Lina (HH PlazaEntry, main NPC)
	-- ============================================================
	["HH_01_kran_intro"] = {
		id = "HH_01_kran_intro",
		title_key = "quest.hh_01.title",
		description_key = "quest.hh_01.description",
		type = "solo",
		district = "HamburgHarbor",
		quest_giver = "Hafenwirtin",
		steps = {
			{
				id = "step_1_meet_hafenwirtin",
				type = "dialogue",
				target = "Hafenwirtin",
				completion_condition = Validators.dialogue,
			},
			{
				id = "step_2_learn_crane",
				type = "puzzle",
				target = "CraneTutorial",
				completion_condition = Validators.puzzle,
			},
			{
				id = "step_3_first_lift",
				type = "objective",
				target = "DropZoneA",
				completion_condition = Validators.objective,
			},
		},
		prerequisites = {},
		rewards = {
			{ type = "Gold", amount = 50 },
			{ type = "Gems", amount = 5 },
			{ type = "Companion", item = "Curio_Seagull" },
		},
		age_band_target = "all",
		adaptive_range = { min = 0.3, max = 0.7 },
	},

	-- ============================================================
	-- HH_02: Kran-First-Lift (Vertiefung, höhere Schwierigkeit)
	-- Lernziele: Koordinaten (Math), Material-Logistik (Planung)
	-- ============================================================
	["HH_02_crane_firstlift"] = {
		id = "HH_02_crane_firstlift",
		title_key = "quest.hh_02.title",
		description_key = "quest.hh_02.description",
		type = "solo",
		district = "HamburgHarbor",
		quest_giver = "Hafenwirtin",
		steps = {
			{
				id = "step_1_choose_crane",
				type = "puzzle",
				target = "CraneSelector",
				completion_condition = Validators.puzzle,
			},
			{
				id = "step_2_load_container",
				type = "objective",
				target = "ContainerPickupA",
				completion_condition = Validators.objective,
			},
			{
				id = "step_3_navigate_to_dropzone",
				type = "objective",
				target = "DropZoneA",
				completion_condition = Validators.objective,
			},
			{
				id = "step_4_release",
				type = "puzzle",
				target = "ReleaseContainer",
				completion_condition = Validators.puzzle,
			},
		},
		prerequisites = { "HH_01_kran_intro" },
		rewards = {
			{ type = "Gold", amount = 120 },
			{ type = "Gems", amount = 12 },
			{ type = "Companion_Skin", item = "Curio_Seagull_Golden" },
		},
		age_band_target = "12-13",
		adaptive_range = { min = 0.4, max = 0.8 },
	},

	-- ============================================================
	-- HH_03: Werft-Bootsbau (Teamwork-Quest)
	-- Lernziele: Team-Koordination, Werkzeug-Reihenfolge (Planung)
	-- Quest-Giver: Bootsbauerin Maja (HH Werft)
	-- ============================================================
	["HH_03_werft_boat"] = {
		id = "HH_03_werft_boat",
		title_key = "quest.hh_03.title",
		description_key = "quest.hh_03.description",
		type = "team",
		district = "HamburgHarbor",
		quest_giver = "Maja",
		min_team_size = 2,
		max_team_size = 4,
		steps = {
			{
				id = "step_1_gather_materials",
				type = "collect",
				target = "WoodPlank",
				completion_condition = Validators.collect,
			},
			{
				id = "step_2_assemble_hull",
				type = "build",
				target = "BoatHull",
				completion_condition = Validators.build,
			},
			{
				id = "step_3_fit_sails",
				type = "build",
				target = "BoatSails",
				completion_condition = Validators.build,
			},
			{
				id = "step_4_launch",
				type = "objective",
				target = "BoatLaunchZone",
				completion_condition = Validators.objective,
			},
		},
		prerequisites = { "HH_01_kran_intro" },
		rewards = {
			{ type = "Gold", amount = 200 },
			{ type = "Gems", amount = 25 },
			{ type = "Companion", item = "Curio_PaperBoat" },
			{ type = "Photo_Filter", item = "Maritime" },
		},
		age_band_target = "all",
		adaptive_range = { min = 0.3, max = 0.9 },
	},
}

-- Zone-Definitionen für Objective-Steps (von Bootstrap registriert)
-- Maps step.target → { center, radius }
M02_Quest.QuestZones = {
	DropZoneA = { center = Vector3.new(-5, 9, 15), radius = 8 },
	ContainerPickupA = { center = Vector3.new(-25, 6, 15), radius = 6 },
	BoatLaunchZone = { center = Vector3.new(42, 4, 35), radius = 10 },
}

-- Material-Defaults für Collect-Steps (Item → Anzahl)
M02_Quest.QuestCollectDefaults = {
	["HH_03_werft_boat"] = { WoodPlank = 4, Rope = 2 },
}

-- ============================================================
-- Public API
-- ============================================================

function M02_Quest:StartQuest(player: Player, questId: string, state: { [string]: any }?): QuestProgress?
	local quest = self.SampleQuests[questId]
	if not quest then return nil end

	-- Prüfe Prerequisites
	for _, prereqId in ipairs(quest.prerequisites) do
		local prereq = self.SampleQuests[prereqId]
		if not prereq then
			warn(("[M02] Quest '%s' verlangt Prerequisite '%s', der nicht existiert"):format(questId, prereqId))
			return nil
		end
	end

	return {
		pid = tostring(player.UserId),
		quest_id = questId,
		current_step = 1,
		state = state or {},
		started_at = os.time(),
		step_completed_at = {},
	}
end

function M02_Quest:EvaluateStep(player: Player, progress: QuestProgress, world: WorldServices?): (boolean, string?)
	local quest = self.SampleQuests[progress.quest_id]
	if not quest then return false, "Quest nicht gefunden: " .. progress.quest_id end

	local stepIdx = progress.current_step
	local step = quest.steps[stepIdx]
	if not step then return true, "Alle Steps erfüllt" end  -- bereits fertig

	-- World-Services-Pflichtprüfung (Fail-Loud bei fehlender Verkabelung)
	if not world then
		return false, "WorldServices nicht übergeben (Bootstrap-Bug)"
	end

	-- Completion-Check
	local ok, reason = step.completion_condition(player, progress.state, world)
	if not ok then
		return false, reason or ("Step '%s' nicht erfüllt"):format(step.id)
	end

	-- Step als abgeschlossen markieren
	progress.step_completed_at[stepIdx] = os.time()
	return true
end

function M02_Quest:AdvanceStep(progress: QuestProgress): boolean
	local quest = self.SampleQuests[progress.quest_id]
	if not quest then return false end

	if progress.current_step >= #quest.steps then
		self:Complete(progress)
		return false  -- keine weiteren Steps
	end

	progress.current_step += 1
	return true
end

function M02_Quest:Complete(progress: QuestProgress)
	progress.completed_at = os.time()
end

-- Hilfsfunktion: QuestZones für objective-steps auflösen
function M02_Quest:GetZone(zoneName: string): { center: Vector3, radius: number }?
	return self.QuestZones[zoneName]
end

return M02_Quest
