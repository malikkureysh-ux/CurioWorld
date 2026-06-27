--!strict
--[[
	M06_Inventory.lua — Inventar & Sammlung (Skeleton)
	====================================================

	Vollständige Spec: docs/09_system_architecture.md (M-06).
]]

local M06_Inventory = {}

export type ItemStack = {
	item_id: string,
	quantity: number,
	metadata: { [string]: any }?,
}

export type CollectionEntry = {
	item_id: string,
	discovered: boolean,
	recalled_count: number,
}

export type CollectionBook = {
	pid: string,
	categories: { [string]: { CollectionEntry } },
}

export type Inventory = {
	pid: string,
	slots: { ItemStack },
	max_slots: number,
}

return M06_Inventory