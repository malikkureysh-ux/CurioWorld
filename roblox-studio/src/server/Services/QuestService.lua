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
local ServerScriptService = game:GetService("ServerScriptService")

local Log = require(ReplicatedStorage.Shared.Util.Log)
local M02_Quest = require(ReplicatedStorage.Shared.Modules.M02_Quest)
local M06_Inventory = require(ReplicatedStorage.Shared.Modules.M06_Inventory)
local M05_Puzzle = require(ReplicatedStorage.Shared.Modules.M05_Puzzle)
local TelemetryService = require(ServerScriptService.Services.TelemetryService)
local ServiceRegistry = require(ReplicatedStorage.Shared.Util.ServiceRegistry)

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
		hasItem = function(player, itemId, count)
			return M06_Inventory:Has(player, itemId, count)
		end,
		hasRecentEvent = function(_player, _eventName, _withinSeconds)
			return false
		end,
		isInZone = isInZone,
		hasSolvedPuzzle = function(player, puzzleId)
			return M05_Puzzle:IsSolved(player, puzzleId)
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
							local advanced = M02_Quest:AdvanceStep(progress)
							if not advanced then
								-- Quest completed
								local quest = M02_Quest.SampleQuests[questId]
								if quest and quest.rewards then
									self:AwardReward(player, quest.rewards)
									Log:Info(("[QuestService] %s completed %s, awarded %d rewards"):format(
										player.Name, questId, #quest.rewards))
								end
								-- QuestVisibility reveal
								local questVis = ServiceRegistry:Get("QuestVisibility")
								if questVis then
									questVis:OnQuestCompleted(player, questId)
								end
								TelemetryService:Track(player, "quest.completed", { quest_id = questId })
							end
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

-- Award reward (Gold/Gems/Companion/Filter)
function QuestService:AwardReward(player: Player, rewards: { { type: string, amount: number, item: string? } })
	local economy = ServiceRegistry:Get("Economy")
	for _, reward in ipairs(rewards or {}) do
		if reward.type == "Gold" and economy then
			economy:AddGold(player, reward.amount or 0, "quest_reward")
		elseif reward.type == "Gems" and economy then
			economy:AddGems(player, reward.amount or 0, "quest_reward")
		elseif reward.type == "Companion" or reward.type == "Companion_Skin" then
			M06_Inventory:Add(player, reward.item or "Unknown_Companion", 1)
		elseif reward.type == "Photo_Filter" then
			M06_Inventory:Add(player, reward.item or "Unknown_Filter", 1)
		end
	end
end

-- Cleanup
Players.PlayerRemoving:Connect(function(player)
	playerProgress[player] = nil
end)

return QuestService