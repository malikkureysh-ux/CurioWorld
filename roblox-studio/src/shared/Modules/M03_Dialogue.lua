--!strict
--[[
	M03_Dialogue.lua — Dialog-System (Skeleton)
	===========================================

	Vollständige Spec: docs/09_system_architecture.md (M-03).
	Datenmodell dort.

	Phase 2: Skeleton + Datenmodell.
	Phase 3: NPC-Dialog-Editor in Studio, Audio-Sync.
]]

local M03_Dialogue = {}

export type DialogueLine = {
	speaker: string,
	text_key: string,      -- localization key
	audio: string?,        -- Asset-ID
	duration_estimate: number,
}

export type DialogueOption = {
	text_key: string,
	next_dialogue: string?,
	triggers: { string }?,
}

export type Dialogue = {
	id: string,
	npc_id: string,
	lines: { DialogueLine },
	options: { DialogueOption }?,
}

return M03_Dialogue