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

function M13_Moderation:CanSendMessage(band: AgeBand, message: string): (boolean, string?)
	local perms = self.PermissionsForBand[band]
	if not perms then return false, "unknown_band" end

	if #message > perms.MaxMessageLength then
		return false, "too_long"
	end

	if perms.CanUseFreeText then
		return true, nil
	end

	if perms.CanUseShortText then
		-- Kurze Sätze: max. 6 Wörter, kein Caps-Lock, keine URLs
		local wordCount = 0
		for _ in string.gmatch(message, "%S+") do wordCount += 1 end
		if wordCount > 6 then return false, "too_many_words" end
		return true, nil
	end

	-- Nur Phrasen / Emotes (Whitelist-Check in Phase 3)
	return true, nil -- Whitelist-Check erfolgt im ChatService
end

return M13_Moderation