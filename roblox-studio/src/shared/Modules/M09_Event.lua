--!strict
--[[
	M09_Event.lua — Event-Framework (Skeleton)
	==========================================

	Saisonale + Community + Live-Events.
]]

local M09_Event = {}

export type EventType = "seasonal" | "community" | "live"

export type Event = {
	id: string,
	type: EventType,
	start_time: number,
	end_time: number,
	global_progress: number, -- 0..1
	contributions: { [string]: number }, -- pid → beitrag
	config: { [string]: any },
}

return M09_Event