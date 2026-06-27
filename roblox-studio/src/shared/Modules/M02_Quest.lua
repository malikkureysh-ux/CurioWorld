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

export type QuestStepType = "objective" | "dialogue" | "puzzle" | "collect"

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
	["HH_01_kran_intro"] = {
		id = "HH_01_kran_intro",
		title_key = "quest.hh_01.title",
		description_key = "quest.hh_01.description",
		type = "solo",
		district = "HamburgHarbor",
		steps = {
			{
				id = "step_1_meet_mira",
				type = "dialogue",
				target = "Mira",
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
			{ type = "XP", amount = 100 },
		},
		age_band_target = "all",
		adaptive_range = { min = 0.3, max = 0.7 },
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