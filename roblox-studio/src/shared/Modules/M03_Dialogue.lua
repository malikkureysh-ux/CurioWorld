--!strict
--[[
	M03_Dialogue.lua — Dialog-System (Phase 3 Runtime)
	====================================================

	User Story:
	  Als Spieler:in möchte ich mit NPCs echte Gespräche führen, die
	  verzweigen — Lina fragt mich, ob ich den Kran lernen will, ich
	  antworte "Ja" und der nächste Dialog öffnet sich, der mich tiefer
	  in die Geschichte führt.

	Architektur:
	  - DialogueRegistry: dialogue_id → Dialogue (Daten)
	  - ActiveDialogues: player → dialogueId (welcher Dialog läuft)
	  - Start(player, dialogueId): öffnet via M18_Dialogue:Show + speichert State
	  - Choose(player, optionIndex): triggert events + Advance to next_dialogue
	  - End(player): schließt + cleanup
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Log = require(ReplicatedStorage.Shared.Util.Log)
local Localization = require(ReplicatedStorage.Shared.Modules.M15_Localization)
local M18_Dialogue = require(ReplicatedStorage.Shared.Modules.M18_Dialogue)

local M03_Dialogue = {}

-- ============================================================
-- Types (re-export für Spec-Tests)
-- ============================================================

export type DialogueLine = {
	speaker: string,
	text_key: string,
	audio: string?,
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
	start_line: number?,           -- default 1
	lines: { DialogueLine },
	options: { DialogueOption }?,
}

-- ============================================================
-- Sample-Dialogues (für Hamburg Harbor NPCs)
-- ============================================================

M03_Dialogue.Registry = {
	-- Lina begrüßt Spieler:in + bietet Quest an
	hafenwirtin_greeting = {
		id = "hafenwirtin_greeting",
		npc_id = "Hafenwirtin",
		start_line = 1,
		lines = {
			{
				speaker = "Hafenwirtin Lina",
				text_key = "npc.hafenwirtin.greeting",
				audio = nil,
				duration_estimate = 4,
			},
		},
		options = {
			{
				text_key = "ui.dialogue.ask_quest",
				next_dialogue = "hafenwirtin_offer_quest",
				triggers = { "asked_about_quest" },
			},
			{
				text_key = "ui.dialogue.ask_cranes",
				next_dialogue = "hafenwirtin_about_cranes",
				triggers = nil,
			},
			{
				text_key = "ui.dialogue.goodbye",
				next_dialogue = nil,
				triggers = { "conversation_ended" },
			},
		},
	},

	-- Lina erklärt die Kran-Welt (lore)
	hafenwirtin_about_cranes = {
		id = "hafenwirtin_about_cranes",
		npc_id = "Hafenwirtin",
		lines = {
			{
				speaker = "Hafenwirtin Lina",
				text_key = "dialogue.hafenwirtin.cranes_explanation",
				audio = nil,
				duration_estimate = 8,
			},
		},
		options = {
			{
				text_key = "ui.dialogue.interested",
				next_dialogue = "hafenwirtin_offer_quest",
				triggers = { "asked_about_quest" },
			},
			{
				text_key = "ui.dialogue.goodbye",
				next_dialogue = nil,
			},
		},
	},

	-- Lina bietet HH_01 Quest an
	hafenwirtin_offer_quest = {
		id = "hafenwirtin_offer_quest",
		npc_id = "Hafenwirtin",
		lines = {
			{
				speaker = "Hafenwirtin Lina",
				text_key = "dialogue.hafenwirtin.quest_offer",
				audio = nil,
				duration_estimate = 6,
			},
		},
		options = {
			{
				text_key = "ui.dialogue.accept",
				next_dialogue = nil,
				triggers = { "quest_started:HH_01_kran_intro" },
			},
			{
				text_key = "ui.dialogue.later",
				next_dialogue = nil,
			},
		},
	},

	-- Maja: Werft-Begrüßung
	maja_greeting = {
		id = "maja_greeting",
		npc_id = "Maja",
		lines = {
			{
				speaker = "Bootsbauerin Maja",
				text_key = "npc.maja.greeting",
				audio = nil,
				duration_estimate = 5,
			},
		},
		options = {
			{
				text_key = "ui.dialogue.help_build",
				next_dialogue = nil,
				triggers = { "quest_started:HH_03_werft_boat" },
			},
			{
				text_key = "ui.dialogue.goodbye",
				next_dialogue = nil,
			},
		},
	},
}

-- ============================================================
-- Active-Dialogue-Tracking (per Spieler:in)
-- ============================================================

local activeDialogues: { [Player]: string } = {}
local pendingEvents: { [Player]: { string } } = {}

-- ============================================================
-- Public API
-- ============================================================

function M03_Dialogue:Start(player: Player, dialogueId: string): boolean
	local dialogue = self.Registry[dialogueId]
	if not dialogue then
		Log:Warn(("[M03] Unknown dialogue: %s"):format(dialogueId))
		return false
	end

	activeDialogues[player] = dialogueId
	pendingEvents[player] = pendingEvents[player] or {}

	-- Erste Line als Text
	local firstLine = dialogue.lines[dialogue.start_line or 1]
	if not firstLine then
		Log:Warn(("[M03] Dialogue %s has no lines"):format(dialogueId))
		return false
	end

	local text = Localization:GetString(player, firstLine.text_key, {})
	local npcConfig = {
		DisplayName = firstLine.speaker,
		NpcId = dialogue.npc_id,
		Role = "NPC",
		Color = Color3.fromRGB(180, 100, 60),
	}

	-- Optionen übersetzen
	local options
	if dialogue.options then
		options = {}
		for i, opt in ipairs(dialogue.options) do
			table.insert(options, {
				text = Localization:GetString(player, opt.text_key, {}),
				responseKey = opt.text_key,
				_nextDialogue = opt.next_dialogue,
				_triggers = opt.triggers,
			})
		end
	end

	-- M18:Show mit Option-Callback
	M18_Dialogue.Show(player, npcConfig, text, options, function(responseKey, optionIndex)
		self:Choose(player, optionIndex)
	end)

	Log:Info(("[M03] Started dialogue %s for %s"):format(dialogueId, player.Name))
	return true
end

function M03_Dialogue:Choose(player: Player, optionIndex: number)
	local dialogueId = activeDialogues[player]
	if not dialogueId then
		Log:Warn("[M03] Choose called but no active dialogue")
		return
	end

	local dialogue = self.Registry[dialogueId]
	local option = dialogue.options and dialogue.options[optionIndex]
	if not option then
		Log:Warn(("[M03] Invalid option index %d for dialogue %s"):format(optionIndex, dialogueId))
		return
	end

	-- Trigger-Events sammeln
	if option.triggers then
		pendingEvents[player] = pendingEvents[player] or {}
		for _, trigger in ipairs(option.triggers) do
			table.insert(pendingEvents[player], trigger)
		end
	end

	-- Advance to next dialogue
	if option.next_dialogue then
		task.defer(function()
			self:Start(player, option.next_dialogue)
		end)
	else
		-- Dialog endet → cleanup
		activeDialogues[player] = nil
		Log:Info(("[M03] Dialogue ended for %s"):format(player.Name))
	end
end

function M03_Dialogue:PullEvents(player: Player): { string }
	local events = pendingEvents[player] or {}
	pendingEvents[player] = {}
	return events
end

function M03_Dialogue:End(player: Player)
	activeDialogues[player] = nil
	M18_Dialogue.Hide(player)
end

-- Cleanup
Players.PlayerRemoving:Connect(function(player)
	activeDialogues[player] = nil
	pendingEvents[player] = nil
end)

return M03_Dialogue