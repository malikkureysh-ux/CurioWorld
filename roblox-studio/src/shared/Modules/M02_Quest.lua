--!strict
--[[
	M02_Quest.lua — Quest-System (Skeleton)
	=======================================

	Vollständige Spec: docs/09_system_architecture.md (M-02).
	Datenmodell in docs/09_system_architecture.md § M-02.

	Quest-Typen:
	- solo, duo, team, mini, exploration, event

	Phase 2: Skeleton mit Datenmodell + Trigger-API.
	Phase 3: vollständige Implementierung mit UI + Adaptive-Kopplung.
]]

local M02_Quest = {}

-- ============================================================
-- Datenmodell
-- ============================================================

export type QuestStepType = "objective" | "dialogue" | "puzzle" | "collect" | "build" | "team"

export type QuestStep = {
	id: string,
	type: QuestStepType,
	target: string,
	completion_condition: ((player: Player, questState: any) -> (boolean, string?)),
}

export type Quest = {
	id: string,
	title_key: string,            -- localization key
	description_key: string,
	type: "solo" | "duo" | "team" | "mini" | "exploration" | "event",
	district: string,
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
}

-- ============================================================
-- Beispiel-Quest: Hamburg Harbor — Erste Mission
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
		steps = {
			{
				id = "step_1_meet_hafenwirtin",
				type = "dialogue",
				target = "Hafenwirtin",
				completion_condition = function(_, _) return true end,
			},
			{
				id = "step_2_learn_crane",
				type = "puzzle",
				target = "CraneTutorial",
				completion_condition = function(_, _) return true end,
			},
			{
				id = "step_3_first_lift",
				type = "objective",
				target = "MoveContainerAtoB",
				completion_condition = function(_, _) return true end,
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
		steps = {
			{
				id = "step_1_choose_crane",
				type = "puzzle",
				target = "CraneSelector",
				completion_condition = function(_, _) return true end,
			},
			{
				id = "step_2_load_container",
				type = "objective",
				target = "PickUpContainer",
				completion_condition = function(_, _) return true end,
			},
			{
				id = "step_3_navigate_to_dropzone",
				type = "objective",
				target = "DropZoneA",
				completion_condition = function(_, _) return true end,
			},
			{
				id = "step_4_release",
				type = "puzzle",
				target = "ReleaseContainer",
				completion_condition = function(_, _) return true end,
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
				target = "Materials",
				required_count = 4,
				completion_condition = function(_, _) return true end,
			},
			{
				id = "step_2_assemble_hull",
				type = "build",
				target = "BoatHull",
				completion_condition = function(_, _) return true end,
			},
			{
				id = "step_3_fit_sails",
				type = "build",
				target = "BoatSails",
				completion_condition = function(_, _) return true end,
			},
			{
				id = "step_4_launch",
				type = "objective",
				target = "LaunchBoat",
				completion_condition = function(_, _) return true end,
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

-- ============================================================
-- Public API
-- ============================================================

function M02_Quest:StartQuest(player: Player, questId: string, state: { [string]: any }): QuestProgress?
	local quest = self.SampleQuests[questId]
	if not quest then return nil end

	return {
		pid = tostring(player.UserId),
		quest_id = questId,
		current_step = 1,
		state = state or {},
		started_at = os.time(),
	}
end

function M02_Quest:AdvanceStep(progress: QuestProgress): boolean
	progress.current_step += 1
	return true
end

function M02_Quest:Complete(progress: QuestProgress)
	progress.completed_at = os.time()
end

return M02_Quest