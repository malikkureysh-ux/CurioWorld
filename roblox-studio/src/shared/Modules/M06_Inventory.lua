--!strict
--[[
	M06_Inventory.lua — Inventar & Sammlung (Phase 3 Runtime)
	===========================================================

	User Story:
	  Als Spieler:in möchte ich Items sammeln (WoodPlank, Rope), die ich
	  zum Boot-Bau brauche; das Inventar zeigt mir, was ich habe, und
	  das Sammelbuch merkt sich, welche Items ich je entdeckt habe.

	Architektur:
	  - Per-Player-Inventory: pid → Inventory (in-Memory, Phase 4 = DataStore)
	  - Per-Player-Collection: pid → CollectionBook (Spaced-Recall-Source)
	  - Add/Remove/Has/GetCount: grundlegende CRUD
	  - Discover/IncrementRecall: für Sammlungs-Buch
	  - VIP-Bonus: VIP-Spieler bekommen +7 Outfit-Slots (M07.VIP.Benefits)
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Log = require(ReplicatedStorage.Shared.Util.Log)
local M07_Economy = require(ReplicatedStorage.Shared.Modules.M07_Economy)

local M06_Inventory = {}

-- ============================================================
-- Types
-- ============================================================

export type ItemStack = {
	item_id: string,
	quantity: number,
	metadata: { [string]: any }?,
}

export type CollectionEntry = {
	item_id: string,
	discovered: boolean,
	recalled_count: number,
	last_recalled_at: number?,
}

export type CollectionBook = {
	pid: string,
	categories: { [string]: { [string]: CollectionEntry } },
}

export type Inventory = {
	pid: string,
	slots: { ItemStack },
	max_slots: number,
}

-- ============================================================
-- Constants
-- ============================================================

local DEFAULT_SLOTS = 24
local VIP_EXTRA_SLOTS = 7  -- siehe M07.Economy.VIP.Benefits.ExtraOutfitSlots

-- Item-Category-Defaults (für CollectionBook-Kategorisierung)
local ITEM_CATEGORIES: { [string]: string } = {
	WoodPlank = "Materials",
	Rope = "Materials",
	BoatHull = "Builds",
	BoatSails = "Builds",
	Curio_Seagull = "Companions",
	Curio_Seagull_Golden = "Companions",
	Curio_PaperBoat = "Companions",
}

local MAX_STACK = 99  -- max quantity pro Stack

-- ============================================================
-- Per-Player State (in-Memory)
-- ============================================================

local inventories: { [string]: Inventory } = {}
local collectionBooks: { [string]: CollectionBook } = {}

local function getInventory(pid: string, isVip: boolean?): Inventory
	if not inventories[pid] then
		local slots = DEFAULT_SLOTS
		if isVip then slots = slots + VIP_EXTRA_SLOTS end
		inventories[pid] = {
			pid = pid,
			slots = {},
			max_slots = slots,
		}
	end
	return inventories[pid]
end

local function getCollection(pid: string): CollectionBook
	if not collectionBooks[pid] then
		collectionBooks[pid] = {
			pid = pid,
			categories = {},
		}
	end
	return collectionBooks[pid]
end

-- ============================================================
-- Inventory CRUD
-- ============================================================

function M06_Inventory:Add(player: any, itemId: string, count: number?, metadata: { [string]: any }?): boolean
	count = count or 1
	if count <= 0 then return false end

	local pid = self:ToPid(player)
	if not pid then return false end

	local inventory = getInventory(pid)
	local slots = inventory.slots

	-- Versuche, existierenden Stack zu mergen (wenn gleicher itemId + kein metadata-Mismatch)
	for _, stack in ipairs(slots) do
		if stack.item_id == itemId
			and (not metadata or not stack.metadata)
			and stack.quantity < MAX_STACK then
			local addable = math.min(count, MAX_STACK - stack.quantity)
			stack.quantity += addable
			count -= addable
			if count <= 0 then
				Log:Debug(("[M06] Added %d %s to existing stack"):format(addable, itemId))
				self:Discover(player, itemId)
				return true
			end
		end
	end

	-- Rest in neuen Stack
	while count > 0 do
		if #slots >= inventory.max_slots then
			Log:Warn(("[M06] Inventory full for %s, dropped %d %s"):format(pid, count, itemId))
			return false
		end
		local stackQty = math.min(count, MAX_STACK)
		table.insert(slots, {
			item_id = itemId,
			quantity = stackQty,
			metadata = metadata,
		})
		count -= stackQty
	end

	Log:Info(("[M06] Added %s x%d (new stacks) to %s"):format(itemId, count, pid))
	self:Discover(player, itemId)
	return true
end

function M06_Inventory:Remove(player: any, itemId: string, count: number?): boolean
	count = count or 1
	if count <= 0 then return false end

	local pid = self:ToPid(player)
	if not pid then return false end

	local inventory = inventories[pid] or getInventory(pid)
	if not inventory then return false end

	-- Iteriere rückwärts um Stacks sauber zu löschen
	for i = #inventory.slots, 1, -1 do
		local stack = inventory.slots[i]
		if stack.item_id == itemId then
			if stack.quantity <= count then
				count -= stack.quantity
				table.remove(inventory.slots, i)
			else
				stack.quantity -= count
				count = 0
				break
			end
		end
	end

	if count > 0 then
		Log:Warn(("[M06] Tried to remove %d %s from %s, only had %d"):format(
			(count + 0), itemId, pid, count))
		return false
	end

	Log:Debug(("[M06] Removed %s x%d from %s"):format(itemId, count, pid))
	return true
end

function M06_Inventory:Has(player: any, itemId: string, count: number?): boolean
	return self:GetCount(player, itemId) >= (count or 1)
end

function M06_Inventory:GetCount(player: any, itemId: string): number
	local pid = self:ToPid(player)
	if not pid then return 0 end
	local inventory = inventories[pid]
	if not inventory then return 0 end

	local total = 0
	for _, stack in ipairs(inventory.slots) do
		if stack.item_id == itemId then
			total += stack.quantity
		end
	end
	return total
end

function M06_Inventory:GetSlots(player: any): { ItemStack }
	local pid = self:ToPid(player)
	if not pid then return {} end
	local inventory = inventories[pid]
	return inventory and inventory.slots or {}
end

function M06_Inventory:GetSlotCount(player: any): number
	local pid = self:ToPid(player)
	if not pid then return 0 end
	local inventory = inventories[pid]
	return inventory and #inventory.slots or 0
end

-- ============================================================
-- Collection Book (Spaced-Recall-Source)
-- ============================================================

function M06_Inventory:Discover(player: any, itemId: string)
	local pid = self:ToPid(player)
	if not pid then return end
	local book = getCollection(pid)
	local category = ITEM_CATEGORIES[itemId] or "Misc"
	if not book.categories[category] then
		book.categories[category] = {}
	end
	local entry = book.categories[category][itemId]
	if entry and entry.discovered then return end
	book.categories[category][itemId] = {
		item_id = itemId,
		discovered = true,
		recalled_count = 0,
		last_recalled_at = nil,
	}
	Log:Info(("[M06] Discovered %s (%s)"):format(itemId, category))
end

function M06_Inventory:IncrementRecall(player: any, itemId: string)
	local pid = self:ToPid(player)
	if not pid then return end
	local book = collectionBooks[pid]
	if not book then return end
	for _, cat in pairs(book.categories) do
		local entry = cat[itemId]
		if entry then
			entry.recalled_count += 1
			entry.last_recalled_at = os.time()
			Log:Debug(("[M06] Recalled %s (count=%d)"):format(itemId, entry.recalled_count))
			return
		end
	end
end

function M06_Inventory:GetCollection(player: any): CollectionBook
	local pid = self:ToPid(player)
	if not pid then return { pid = "", categories = {} } end
	return collectionBooks[pid] or { pid = pid, categories = {} }
end

function M06_Inventory:GetDiscoveredCount(player: any): number
	local pid = self:ToPid(player)
	if not pid then return 0 end
	local book = collectionBooks[pid]
	if not book then return 0 end
	local count = 0
	for _, cat in pairs(book.categories) do
		for _, _ in pairs(cat) do count += 1 end
	end
	return count
end

-- ============================================================
-- Utility: PID-Extraktion (Player oder PlayerId-String)
-- ============================================================

function M06_Inventory:ToPid(player: any): string?
	if not player then return nil end
	if type(player) == "string" then return "user_" .. player end
	if typeof(player) == "Instance" and player:IsA("Player") then
		return "user_" .. tostring(player.UserId)
	end
	if type(player) == "number" then return "user_" .. tostring(player) end
	return nil
end

-- Cleanup
local Players = game:GetService("Players")
Players.PlayerRemoving:Connect(function(player)
	local pid = "user_" .. tostring(player.UserId)
	inventories[pid] = nil
	collectionBooks[pid] = nil
end)

return M06_Inventory