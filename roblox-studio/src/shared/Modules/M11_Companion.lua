--!strict
--[[
	M11_Companion.lua — Companion / Pet System (Skeleton)
	======================================================

	Sammelbare Begleiter, kosmetisch, keine Gameplay-Vorteile.
]]

local M11_Companion = {}

export type CompanionRarity = "common" | "uncommon" | "rare" | "epic" | "legendary"

export type Companion = {
	id: string,
	name_key: string,
	model_asset_id: string,
	rarity: CompanionRarity,
	unlock_condition: string,
}

export type CompanionInstance = {
	companion_id: string,
	pid: string,
	nickname: string?,
	affection: number, -- kosmetisch, keine Mechanik
}

return M11_Companion