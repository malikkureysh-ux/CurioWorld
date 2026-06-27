--!strict
--[[
	M11_Companion.lua — Companion/Pet-System (Phase 3 Runtime)
	============================================================

	User Story:
	  Als Spieler:in möchte ich niedliche Begleiter (Möwe, Krebs, Papierboot)
	  sammeln, sie mit Spitznamen taufen und als kosmetisches Pet mit mir
	  tragen — keine Gameplay-Boosts (compliance).

	Architektur:
	  - CompanionRegistry: companionId → Companion-Template
	  - Per-Spieler-Inventar: pid → { active_companion_id, owned }
	  - Unlock/Nickname/SetActive
	  - Affection ist rein kosmetisch (max 100, kein Decay)
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Log = require(ReplicatedStorage.Shared.Util.Log)
local M06_Inventory = require(ReplicatedStorage.Shared.Modules.M06_Inventory)

local M11_Companion = {}

-- ============================================================
-- Types
-- ============================================================

export type CompanionRarity = "common" | "uncommon" | "rare" | "epic" | "legendary"

export type Companion = {
	id: string,
	name_key: string,
	model_asset_id: string,
	rarity: CompanionRarity,
	unlock_condition: string,   -- "quest:HH_03" / "purchase:gold" / "event:harbor_anniversary"
	emoji_icon: string,
}

export type CompanionInstance = {
	companion_id: string,
	pid: string,
	nickname: string?,
	affection: number,            -- 0..100, rein kosmetisch
	unlocked_at: number,
}

-- ============================================================
-- Registry
-- ============================================================

M11_Companion.Registry = {
	Curio_Seagull = {
		id = "Curio_Seagull",
		name_key = "companion.seagull.name",
		model_asset_id = "rbxassetid://PENDING_UPLOAD_companion_seagull",
		rarity = "common",
		unlock_condition = "quest:HH_01_kran_intro",
		emoji_icon = "🐦",
	},

	Curio_Seagull_Golden = {
		id = "Curio_Seagull_Golden",
		name_key = "companion.seagull_golden.name",
		model_asset_id = "rbxassetid://PENDING_UPLOAD_companion_seagull_golden",
		rarity = "rare",
		unlock_condition = "quest:HH_02_crane_firstlift",
		emoji_icon = "✨",
	},

	Curio_PaperBoat = {
		id = "Curio_PaperBoat",
		name_key = "companion.paperboat.name",
		model_asset_id = "rbxassetid://PENDING_UPLOAD_companion_paperboat",
		rarity = "uncommon",
		unlock_condition = "quest:HH_03_werft_boat",
		emoji_icon = "⛵",
	},

	Curio_Crab = {
		id = "Curio_Crab",
		name_key = "companion.crab.name",
		model_asset_id = "rbxassetid://PENDING_UPLOAD_companion_crab",
		rarity = "common",
		unlock_condition = "event:harbor_anniversary",
		emoji_icon = "🦀",
	},
}

-- ============================================================
-- Per-Player State
-- ============================================================

local playerCompanions: { [string]: { [string]: CompanionInstance } } = {}
local activeCompanions: { [string]: string } = {}  -- pid → active companionId

local MAX_AFFECTION = 100
local DEFAULT_AFFECTION = 50

-- ============================================================
-- Public API
-- ============================================================

function M11_Companion:Unlock(player: any, companionId: string): boolean
	local template = self.Registry[companionId]
	if not template then
		Log:Warn(("[M11] Unknown companion: %s"):format(companionId))
		return false
	end

	local pid = M06_Inventory:ToPid(player)
	if not pid then return false end

	playerCompanions[pid] = playerCompanions[pid] or {}
	if playerCompanions[pid][companionId] then
		Log:Debug(("[M11] %s already has %s"):format(pid, companionId))
		return false
	end

	playerCompanions[pid][companionId] = {
		companion_id = companionId,
		pid = pid,
		nickname = nil,
		affection = DEFAULT_AFFECTION,
		unlocked_at = os.time(),
	}
	Log:Info(("[M11] %s unlocked %s"):format(pid, companionId))
	return true
end

function M11_Companion:Rename(player: any, companionId: string, nickname: string): boolean
	local M06 = M06_Inventory
	local pid = M06:ToPid(player)
	if not pid or not playerCompanions[pid] then return false end
	local comp = playerCompanions[pid][companionId]
	if not comp then return false end

	-- Validation: max 20 chars, alphanumeric + spaces
	if type(nickname) ~= "string" or #nickname > 20 then return false end
	if nickname:match("[^%w%s]") then return false end

	comp.nickname = nickname
	Log:Info(("[M11] %s renamed %s to '%s'"):format(pid, companionId, nickname))
	return true
end

function M11_Companion:SetActive(player: any, companionId: string): boolean
	local pid = M06_Inventory:ToPid(player)
	if not pid then return false end

	if companionId and not playerCompanions[pid][companionId] then
		return false  -- muss erst unlocked sein
	end

	activeCompanions[pid] = companionId
	Log:Info(("[M11] %s set active companion: %s"):format(pid, tostring(companionId)))
	return true
end

function M11_Companion:Praise(player: any, companionId: string): boolean
	-- Affection +5 (cap 100) — kosmetisch, kein Decay
	local pid = M06_Inventory:ToPid(player)
	if not pid or not playerCompanions[pid] then return false end
	local comp = playerCompanions[pid][companionId]
	if not comp then return false end

	comp.affection = math.min(comp.affection + 5, MAX_AFFECTION)
	return true
end

function M11_Companion:GetOwned(player: any): { CompanionInstance }
	local pid = M06_Inventory:ToPid(player)
	if not pid or not playerCompanions[pid] then return {} end
	local out = {}
	for _, comp in pairs(playerCompanions[pid]) do
		table.insert(out, comp)
	end
	return out
end

function M11_Companion:GetActive(player: any): CompanionInstance?
	local pid = M06_Inventory:ToPid(player)
	if not pid then return nil end
	local activeId = activeCompanions[pid]
	if not activeId then return nil end
	return playerCompanions[pid] and playerCompanions[pid][activeId] or nil
end

-- Cleanup
Players.PlayerRemoving:Connect(function(player)
	local pid = M06_Inventory:ToPid(player)
	playerCompanions[pid] = nil
	activeCompanions[pid] = nil
end)

return M11_Companion