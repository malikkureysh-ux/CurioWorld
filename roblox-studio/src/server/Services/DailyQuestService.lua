--!strict
--[[
	DailyQuestService.lua — Tägliche Quest-Rotation (Phase 3)
	=========================================================

	User Story:
	  Als Spieler:in möchte ich jeden Tag 3 frische Quests auf der
	  Quest-Tafel sehen, die um 00:00 UTC rotieren — damit die
	  QuestBoards (Werkbank) nicht langweilig wird und ich täglich
	  einen Grund habe, wiederzukommen.

	Architektur:
	  - Daily-Pool: 12 vordefinierte Mini-Quests (mix aus collect/explore/help)
	  - Per-Spieler-Pin: für 24h fest (UTC-Tag)
	  - Storage: in SaveService-Settings (Settings.dailyQuests_<date>)
	  - Refresh: um 00:00 UTC automatisch
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Log = require(ReplicatedStorage.Shared.Util.Log)

local DailyQuestService = {}

-- ============================================================
-- Daily-Quest-Pool
-- ============================================================

M02_Quest_PoolRef = nil  -- Lazy: M02_Quest wird geladen wenn vorhanden

DailyQuestService.Pool = {
	-- Collect-Quests (5)
	{
		id = "DQ_collect_wood_2",
		title_key = "daily.collect_wood.title",
		desc_key = "daily.collect_wood.description",
		type = "collect",
		target = "WoodPlank",
		count = 2,
		rewards = { { type = "Gold", amount = 30 } },
		emoji = "🪵",
	},
	{
		id = "DQ_collect_rope_1",
		title_key = "daily.collect_rope.title",
		desc_key = "daily.collect_rope.description",
		type = "collect",
		target = "Rope",
		count = 1,
		rewards = { { type = "Gold", amount = 20 } },
		emoji = "🪢",
	},

	-- Explore-Quests (4)
	{
		id = "DQ_explore_plaza",
		title_key = "daily.explore_plaza.title",
		desc_key = "daily.explore_plaza.description",
		type = "objective",
		target = "DropZoneA",
		rewards = { { type = "Gold", amount = 15 } },
		emoji = "📍",
	},
	{
		id = "DQ_explore_lighthouse",
		title_key = "daily.explore_lighthouse.title",
		desc_key = "daily.explore_lighthouse.description",
		type = "objective",
		target = "LighthouseIsland",
		rewards = { { type = "Gold", amount = 25 } },
		emoji = "🗼",
	},

	-- Help-Quests (3)
	{
		id = "DQ_talk_yuki",
		title_key = "daily.talk_yuki.title",
		desc_key = "daily.talk_yuki.description",
		type = "dialogue",
		target = "Yuki",
		rewards = { { type = "Gold", amount = 20 } },
		emoji = "💬",
	},
	{
		id = "DQ_talk_nils",
		title_key = "daily.talk_nils.title",
		desc_key = "daily.talk_nils.description",
		type = "dialogue",
		target = "Nils",
		rewards = { { type = "Gold", amount = 20 } },
		emoji = "💬",
	},

	-- Quest-Completion (gekoppelt an Main-Quests)
	{
		id = "DQ_complete_step",
		title_key = "daily.complete_step.title",
		desc_key = "daily.complete_step.description",
		type = "objective",
		target = "AnyQuestStep",
		rewards = { { type = "Gold", amount = 30 }, { type = "Gems", amount = 1 } },
		emoji = "✅",
	},

	-- Social-Quests
	{
		id = "DQ_praise_companion",
		title_key = "daily.praise_companion.title",
		desc_key = "daily.praise_companion.description",
		type = "companion",
		target = "Praise",
		rewards = { { type = "Gold", amount = 15 } },
		emoji = "🐾",
	},

	-- Mix für mehr Variety
	{
		id = "DQ_explore_werft",
		title_key = "daily.explore_werft.title",
		desc_key = "daily.explore_werft.description",
		type = "objective",
		target = "Werft",
		rewards = { { type = "Gold", amount = 25 } },
		emoji = "🔨",
	},
	{
		id = "DQ_explore_speicherhaus",
		title_key = "daily.explore_speicherhaus.title",
		desc_key = "daily.explore_speicherhaus.description",
		type = "objective",
		target = "Speicherhaus",
		rewards = { { type = "Gold", amount = 25 } },
		emoji = "🏛️",
	},
	{
		id = "DQ_collect_misc",
		title_key = "daily.collect_misc.title",
		desc_key = "daily.collect_misc.description",
		type = "collect",
		target = "AnyMaterial",
		count = 3,
		rewards = { { type = "Gold", amount = 35 } },
		emoji = "📦",
	},
	{
		id = "DQ_vip_bonus",
		title_key = "daily.vip_bonus.title",
		desc_key = "daily.vip_bonus.description",
		type = "vip",
		target = "Active",
		rewards = { { type = "Gold", amount = 50 } },
		emoji = "⭐",
	},
}

-- ============================================================
-- Per-Spieler-Quest-Rotation
-- ============================================================

local playerDailyQuests: { [string]: { date: string, quests: { any } } } = {}

local function todayUtcKey(): string
	return os.date("!%Y-%m-%d")  -- UTC
end

local function getOrGenerate(pid: string): { any }
	local today = todayUtcKey()
	if playerDailyQuests[pid]
		and playerDailyQuests[pid].date == today
		and #playerDailyQuests[pid].quests > 0 then
		return playerDailyQuests[pid].quests
	end

	-- Deterministische Auswahl (basierend auf Datum + PID) → gleiche Quests pro Tag
	local seed = 0
	for i = 1, #pid do
		seed = (seed * 31 + string.byte(pid, i)) % 2^31
	end
	for i = 1, #today do
		seed = (seed * 31 + string.byte(today, i)) % 2^31
	end

	-- Seeded shuffle (Fisher-Yates mit seed)
	local pool = {}
	for i, q in ipairs(DailyQuestService.Pool) do
		pool[i] = q
	end
	for i = #pool, 2, -1 do
		local j = (seed % i) + 1
		pool[i], pool[j] = pool[j], pool[i]
		seed = (seed * 1103515245 + 12345) % 2^31
	end

	local selected = { pool[1], pool[2], pool[3] }
	playerDailyQuests[pid] = { date = today, quests = selected }
	Log:Info(("[DailyQuest] %s → %d quests for %s"):format(pid, #selected, today))
	return selected
end

-- ============================================================
-- Public API
-- ============================================================

function DailyQuestService:GetTodaysQuests(player: Player): { any }
	local pid = "user_" .. tostring(player.UserId)
	return getOrGenerate(pid)
end

function DailyQuestService:IsQuestCompleted(player: Player, questId: string): boolean
	-- Placeholder: QuestService checken
	-- Phase 3: integrate with M02_Quest
	local ServiceRegistry = require(ReplicatedStorage.Shared.Util.ServiceRegistry)
	local questService = ServiceRegistry:Get("Quest")
	if not questService then return false end

	local progress = questService:GetProgress(player, questId)
	if not progress then return false end
	return progress.completed_at ~= nil
end

function DailyQuestService:AwardDailyQuest(player: Player, dailyQuestId: string)
	local M07_Economy = require(ReplicatedStorage.Shared.Modules.M07_Economy)
	local ServiceRegistry = require(ReplicatedStorage.Shared.Util.ServiceRegistry)
	local economy = ServiceRegistry:Get("Economy")
	if not economy then return end

	-- Find quest in today's pool
	local todays = self:GetTodaysQuests(player)
	for _, q in ipairs(todays) do
		if q.id == dailyQuestId then
			for _, reward in ipairs(q.rewards or {}) do
				if reward.type == "Gold" then
					economy:AddGold(player, reward.amount or 0, "daily_quest:" .. dailyQuestId)
				elseif reward.type == "Gems" then
					economy:AddGems(player, reward.amount or 0, "daily_quest:" .. dailyQuestId)
				end
			end
			Log:Info(("[DailyQuest] %s completed %s, awarded rewards"):format(
				player.Name, dailyQuestId))
			return
		end
	end
end

-- Cleanup
Players.PlayerRemoving:Connect(function(player)
	local pid = "user_" .. tostring(player.UserId)
	playerDailyQuests[pid] = nil
end)

return DailyQuestService