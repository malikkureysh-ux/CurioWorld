--!strict
--[[
	M10_Housing.lua — Housing-System (Phase 3 Runtime)
	====================================================

	User Story:
	  Als Spieler:in möchte ich eine persönliche Wohnung, in der ich
	  Deko-Objekte (Bootsmodell, Möbel, Souvenirs) platzieren kann, mit
	  Besucher-Regeln (privat, Freunde, öffentlich).

	Architektur:
	  - Per-Spieler-House: pid → House mit room_layout + decorations
	  - Place/Remove: Dekoration hinzufügen/entfernen
	  - CanVisit(visitorPid): prüft visitor-settings
	  - Phase 3: AssetService für House-Templates
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Log = require(ReplicatedStorage.Shared.Util.Log)

local M10_Housing = {}

-- ============================================================
-- Types
-- ============================================================

export type DecorationPlacement = {
	decoration_id: string,
	position: Vector3,
	rotation: Vector3,
	scale: Vector3?,
}

export type House = {
	owner_pid: string,
	room_layout: string,         -- template id ("default_harbor", "small_dock", etc.)
	decorations: { DecorationPlacement },
	visitor_settings: "private" | "friends" | "public",
	max_decorations: number,
	last_modified: number,
}

-- ============================================================
-- Constants
-- ============================================================

local MAX_DECORATIONS_DEFAULT = 20
local VIP_EXTRA_DECORATIONS = 10

-- ============================================================
-- Per-Spieler State
-- ============================================================

local houses: { [string]: House } = {}

local function getOrCreateHouse(pid: string, isVip: boolean?): House
	if not houses[pid] then
		local maxDec = MAX_DECORATIONS_DEFAULT
		if isVip then maxDec = maxDec + VIP_EXTRA_DECORATIONS end
		houses[pid] = {
			owner_pid = pid,
			room_layout = "default_harbor",
			decorations = {},
			visitor_settings = "private",
			max_decorations = maxDec,
			last_modified = os.time(),
		}
	end
	return houses[pid]
end

-- ============================================================
-- Public API
-- ============================================================

function M10_Housing:Place(player: any, decorationId: string,
                            position: Vector3, rotation: Vector3,
                            scale: Vector3?): boolean
	local M06_Inventory = require(ReplicatedStorage.Shared.Modules.M06_Inventory)
	local pid = M06_Inventory:ToPid(player)
	if not pid then return false end

	local house = getOrCreateHouse(pid)
	if #house.decorations >= house.max_decorations then
		Log:Warn(("[M10] House %s at max decorations"):format(pid))
		return false
	end

	-- Spieler:in muss das Item im Inventar haben (mind. 1)
	if not M06_Inventory:Has(player, decorationId, 1) then
		Log:Warn(("[M10] %s hat %s nicht im Inventar"):format(pid, decorationId))
		return false
	end

	-- Item aus Inventar entfernen (1× verbrauchen)
	M06_Inventory:Remove(player, decorationId, 1)

	table.insert(house.decorations, {
		decoration_id = decorationId,
		position = position,
		rotation = rotation,
		scale = scale,
	})
	house.last_modified = os.time()

	Log:Info(("[M10] %s placed %s at %s"):format(pid, decorationId, tostring(position)))
	return true
end

function M10_Housing:Remove(player: any, index: number): boolean
	local M06_Inventory = require(ReplicatedStorage.Shared.Modules.M06_Inventory)
	local pid = M06_Inventory:ToPid(player)
	if not pid then return false end

	local house = houses[pid]
	if not house or not house.decorations[index] then return false end

	local dec = house.decorations[index]
	-- Item zurück ins Inventar
	M06_Inventory:Add(player, dec.decoration_id, 1)

	table.remove(house.decorations, index)
	house.last_modified = os.time()
	Log:Info(("[M10] %s removed decoration at index %d"):format(pid, index))
	return true
end

function M10_Housing:CanVisit(visitor: any, owner: any): boolean
	local M06_Inventory = require(ReplicatedStorage.Shared.Modules.M06_Inventory)
	local visitorPid = M06_Inventory:ToPid(visitor)
	local ownerPid = M06_Inventory:ToPid(owner)
	if not visitorPid or not ownerPid then return false end

	if visitorPid == ownerPid then return true end  -- eigene Wohnung

	local house = houses[ownerPid]
	if not house then return true end  -- default = private → aber ohne House = public by default?

	if house.visitor_settings == "public" then return true end
	if house.visitor_settings == "friends" then
		-- Phase 3: Roblox Friend-Check via Players:GetFriendsAsync
		-- Aktuell: false (keine Freunde-Lookup ohne FriendService)
		return false
	end
	-- private
	return false
end

function M10_Housing:SetVisitorSettings(player: any, setting: "private" | "friends" | "public"): boolean
	local M06_Inventory = require(ReplicatedStorage.Shared.Modules.M06_Inventory)
	local pid = M06_Inventory:ToPid(player)
	if not pid then return false end
	local house = getOrCreateHouse(pid)
	house.visitor_settings = setting
	house.last_modified = os.time()
	Log:Info(("[M10] %s set visitors=%s"):format(pid, setting))
	return true
end

function M10_Housing:GetHouse(player: any): House?
	local M06_Inventory = require(ReplicatedStorage.Shared.Modules.M06_Inventory)
	local pid = M06_Inventory:ToPid(player)
	return houses[pid]
end

function M10_Housing:GetDecorations(player: any): { DecorationPlacement }
	local house = self:GetHouse(player)
	return house and house.decorations or {}
end

-- Cleanup
Players.PlayerRemoving:Connect(function(player)
	local M06_Inventory = require(ReplicatedStorage.Shared.Modules.M06_Inventory)
	local pid = M06_Inventory:ToPid(player)
	houses[pid] = nil
end)

return M10_Housing