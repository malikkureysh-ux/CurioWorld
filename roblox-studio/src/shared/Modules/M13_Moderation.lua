--!strict
--[[
	M13_Moderation.lua — Moderation & Sicherheit (Skeleton)
	=======================================================

	Vollständige Spec: docs/11_community_and_safety.md.

	Altersabhängige Chat-Limits (D-009):
	- 9–11: nur Pings, Emotes, vorgegebene Phrasen
	- 12–13: Phrasen + kurze Sätze, kein Freitext-Chat
	- 14–16: Standard-Chat mit aktivem Filter
]]

local M13_Moderation = {}

export type AgeBand = "9-11" | "12-13" | "14-16"

export type ChatPermissions = {
	CanEmote: boolean,
	CanPing: boolean,
	CanUsePhrases: boolean,
	CanUseShortText: boolean,
	CanUseFreeText: boolean,
	MaxMessageLength: number,
}

M13_Moderation.PermissionsForBand = {
	["9-11"]  = { CanEmote = true,  CanPing = true,  CanUsePhrases = true,  CanUseShortText = false, CanUseFreeText = false, MaxMessageLength = 0 },
	["12-13"] = { CanEmote = true,  CanPing = true,  CanUsePhrases = true,  CanUseShortText = true,  CanUseFreeText = false, MaxMessageLength = 60 },
	["14-16"] = { CanEmote = true,  CanPing = true,  CanUsePhrases = true,  CanUseShortText = true,  CanUseFreeText = true,  MaxMessageLength = 200 },
} :: { [AgeBand]: ChatPermissions }

-- ============================================================
-- Helper-Funktionen (Schutz für Kinder: 9-11 / 12-13)
-- ============================================================

-- URL-Detection: einfache Heuristik für http(s)://, www., oder TLD-Endungen
local function containsUrl(text: string): boolean
	if text:lower():find("https?://") then return true end
	if text:lower():find("www%.") then return true end
	-- gängige TLDs als Wortende
	for tld in text:lower():gmatch("[%w](%.[%a]+)") do
		if tld == ".com" or tld == ".net" or tld == ".org" or tld == ".io"
			or tld == ".gg" or tld == ".de" or tld == ".tk" or tld == ".tv" then
			return true
		end
	end
	return false
end

-- Caps-Lock-Detection: Wenn >70% der Buchstaben GROSS sind und mind. 4 Buchstaben.
local function isAllCaps(text: string): boolean
	local letters, caps = 0, 0
	for c in text:gmatch("%a") do
		letters += 1
		if c == c:upper() then caps += 1 end
	end
	if letters < 4 then return false end
	return (caps / letters) >= 0.7
end

-- Wort-Count
local function wordCount(text: string): number
	local count = 0
	for _ in text:gmatch("%S+") do count += 1 end
	return count
end

function M13_Moderation:CanSendMessage(band: AgeBand, message: string): (boolean, string?)
	local perms = self.PermissionsForBand[band]
	if not perms then return false, "unknown_band" end

	-- Defensiv: nil/empty → leerer Phrase-Ping ist OK
	if not message or #message == 0 then
		-- Nur erlaubt wenn Emote/Ping aktiv sind
		if perms.CanEmote or perms.CanPing then
			return true, nil
		end
		return false, "empty_message"
	end

	if #message > perms.MaxMessageLength then
		return false, "too_long"
	end

	-- FreeText (14-16): nur Längen-Check, Wortfilter in ChatService
	if perms.CanUseFreeText then
		-- Aber: keine URLs an 14-16? Compliance-konservativ: erlauben mit Wortfilter
		return true, nil
	end

	-- ShortText (12-13): max 6 Wörter, kein Caps-Lock, keine URLs
	if perms.CanUseShortText then
		if wordCount(message) > 6 then return false, "too_many_words" end
		if isAllCaps(message) then return false, "all_caps" end
		if containsUrl(message) then return false, "url_not_allowed" end
		return true, nil
	end

	-- 9-11: nur Emote/Ping/Phrasen — Whitelist-Pflicht
	-- Empty (= reines Emote) bereits oben OK
	-- Jeder Freitext-Char → muss gegen Phrase-Whitelist (ChatService)
	if wordCount(message) > 0 then
		-- Wir können hier nur die Struktur prüfen; Whitelist in ChatService
		-- Da kein Freitext erlaubt, MUSS der Server Wort für Wort validieren
		return false, "phrase_whitelist_required"
	end
	return true, nil
end

-- ============================================================
-- Safe-Phrase-Whitelist für 9-11 (ChatService erwartet diese Liste)
-- ============================================================

M13_Moderation.SafePhrases = {
	"hi", "hallo", "ciao", "bye", "tschuess", "ok", "yes", "no", "ja", "nein",
	"danke", "thanks", "bitte", "please", "sorry", "cool", "wow", "yay", "nope",
	"yeah", "super", "geil", "krass", "nice", "lol", "hehe",
	-- Emote-Trigger:
	"wave", "highfive", "dance", "clap", "laugh", "sad", "cry", "angry", "love",
}

-- ============================================================
-- Public-API-Hook für Anti-Bullying (Schimpfwort-Filter)
-- ============================================================

export type BlockedWord = string
M13_Moderation.BlockedWords: { BlockedWord } = {
	-- Conservative: beleidigende + diskriminierende Begriffe
	-- (Phase 3: vollständige Liste mit Locales)
	"idiot", "dumm", "noob", "hate", "kill yourself",
}

return M13_Moderation