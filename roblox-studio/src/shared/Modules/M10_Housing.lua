--!strict
--[[
	M10_Housing.lua — Housing / Personal Space (Skeleton)
	======================================================

	Persönliches Studio / Wohnung pro Spieler:in.
]]

local M10_Housing = {}

export type DecorationPlacement = {
	decoration_id: string,
	position: Vector3,
	rotation: Vector3,
}

export type House = {
	owner_id: string,
	room_layout: { [string]: any },
	decorations: { DecorationPlacement },
	visitor_settings: "private" | "friends" | "public",
}

return M10_Housing