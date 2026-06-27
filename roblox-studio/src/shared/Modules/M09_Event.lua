--!strict
--[[
	M09_Event.lua — Event-Framework (Phase 3 Runtime)
	====================================================

	User Story:
	  Als Spieler:in möchte ich, dass zu besonderen Zeiten (Hafengeburtstag,
	  Halloween-Special, Wochenend-Event) spezielle Quests/Belohnungen
	  aktiviert werden — global für alle und mit meinem persönlichen
	  Beitrag (z.B. "Ich habe 50 Boote gefangen, das bringt mir 500 Gold").

	Architektur:
	  - EventRegistry: eventId → Event-Definition
	  - ActiveEvents: laufende Events mit Start/End-Time
	  - Contribute(player, eventId, amount): addiert zum Spieler-Beitrag
	  - IsActive(eventId, now): check ob Event läuft
	  - GetGlobalProgress(eventId): berechnet aus allen Contributions
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local Log = require(ReplicatedStorage.Shared.Util.Log)

local M09_Event = {}

-- ============================================================
-- Types
-- ============================================================

export type EventType = "seasonal" | "community" | "live"

export type Event = {
	id: string,
	type: EventType,
	name_key: string,
	description_key: string,
	start_time: number,
	end_time: number,
	goal: number,             -- Global-Goal für Community-Events
	rewards: { { type: string, amount: number, item: string? } },
}

-- ============================================================
-- Sample-Events (Hamburg Harbor)
-- ============================================================

M09_Event.Registry = {
	harbor_anniversary = {
		id = "harbor_anniversary",
		type = "seasonal",
		name_key = "event.harbor_anniversary.name",
		description_key = "event.harbor_anniversary.description",
		start_time = 0,        -- wird zur Laufzeit gesetzt
		end_time = 0,
		goal = 1000,
		rewards = {
			{ type = "Gold", amount = 500 },
			{ type = "Companion", item = "Curio_Crab" },
		},
	},

	weekend_crafting = {
		id = "weekend_crafting",
		type = "community",
		name_key = "event.weekend_crafting.name",
		description_key = "event.weekend_crafting.description",
		start_time = 0,
		end_time = 0,
		goal = 500,
		rewards = {
			{ type = "Gold", amount = 200 },
			{ type = "Photo_Filter", item = "Birthday_Cake" },
		},
	},
}

-- ============================================================
-- Runtime-State
-- ============================================================

local contributions: { [string]: { [Player]: number } } = {}  -- eventId → player → amount

local function eventKey(eventId: string): string
	return "event_" .. eventId
end

-- ============================================================
-- Public API
-- ============================================================

function M09_Event:Start(eventId: string, durationHours: number): boolean
	local event = self.Registry[eventId]
	if not event then
		Log:Warn(("[M09] Unknown event: %s"):format(eventId))
		return false
	end

	local now = os.time()
	event.start_time = now
	event.end_time = now + (durationHours * 3600)
	contributions[eventId] = contributions[eventId] or {}

	Log:Info(("[M09] Started event %s until %s"):format(eventId, os.date("%c", event.end_time)))
	return true
end

function M09_Event:End(eventId: string)
	local event = self.Registry[eventId]
	if event then
		event.start_time = 0
		event.end_time = 0
		Log:Info(("[M09] Ended event %s"):format(eventId))
	end
end

function M09_Event:IsActive(eventId: string, now: number?): boolean
	local event = self.Registry[eventId]
	if not event or event.start_time == 0 then return false end
	now = now or os.time()
	return now >= event.start_time and now <= event.end_time
end

function M09_Event:Contribute(player: Player, eventId: string, amount: number): boolean
	if not self:IsActive(eventId) then return false end
	if amount <= 0 then return false end

	contributions[eventId] = contributions[eventId] or {}
	contributions[eventId][player] = (contributions[eventId][player] or 0) + amount

	Log:Info(("[M09] %s contributed %d to %s (now %d)"):format(
		player.Name, amount, eventId, contributions[eventId][player]))

	-- Check global goal
	local event = self.Registry[eventId]
	if event then
		local total = self:GetGlobalProgress(eventId)
		if total >= event.goal then
			Log:Info(("[M09] Event %s reached global goal!"):format(eventId))
			-- Phase 3: distribute rewards to all contributors
		end
	end

	return true
end

function M09_Event:GetContribution(player: Player, eventId: string): number
	if not contributions[eventId] then return 0 end
	return contributions[eventId][player] or 0
end

function M09_Event:GetGlobalProgress(eventId: string): number
	if not contributions[eventId] then return 0 end
	local total = 0
	for _, amount in pairs(contributions[eventId]) do
		total += amount
	end
	return total
end

function M09_Event:GetActiveEvents(): { Event }
	local active = {}
	local now = os.time()
	for _, event in pairs(self.Registry) do
		if event.start_time > 0 and now <= event.end_time then
			table.insert(active, event)
		end
	end
	return active
end

-- Cleanup
Players.PlayerRemoving:Connect(function(player)
	for eventId, contribs in pairs(contributions) do
		contribs[player] = nil
	end
end)

return M09_Event