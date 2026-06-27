--!strict
--[[
	M15_Localization.lua — Sprachunterstützung (i18n)
	==================================================

	Unterstützte Sprachen: DE, EN, ES, FR, HI, TR, ZH, JA, AR
	Implementation: Roblox LocalizationService + externe Tabelle.

	Dieses Modul stellt Helfer bereit:
	- M15_Localization.Get(player, key, fallback) — übersetzten String holen
	- M15_Localization.Set(player, lang) — Sprache wechseln
	- M15_Localization.GetAvailableLanguages() — Liste

	Strings-Quelle: src/shared/Data/locales.lua (DE + EN Starter)
	           bzw. Roblox LocalizationService (für Studio-Workflow).
]]

local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Locales = require(ReplicatedStorage.Shared.Data.locales)

local M15_Localization = {}

-- ============================================================
-- Sprachen
-- ============================================================

M15_Localization.Languages = {
	{ Code = "de", Name = "Deutsch",      Rtl = false },
	{ Code = "en", Name = "English",      Rtl = false },
	{ Code = "es", Name = "Español",      Rtl = false },
	{ Code = "fr", Name = "Français",     Rtl = false },
	{ Code = "hi", Name = "हिन्दी",       Rtl = false },
	{ Code = "tr", Name = "Türkçe",       Rtl = false },
	{ Code = "zh", Name = "简体中文",     Rtl = false },
	{ Code = "ja", Name = "日本語",       Rtl = false },
	{ Code = "ar", Name = "العربية",      Rtl = true  },
} :: { { Code: string, Name: string, Rtl: boolean } }

-- ============================================================
-- Sprachwahl pro Spieler:in
-- ============================================================

local playerLanguages: { [Player]: string } = {}

function M15_Localization:Get(player: Player): string
	return playerLanguages[player] or "en"
end

function M15_Localization:Set(player: Player, langCode: string): boolean
	for _, lang in ipairs(self.Languages) do
		if lang.Code == langCode then
			playerLanguages[player] = langCode
			return true
		end
	end
	return false
end

function M15_Localization:GetAvailableLanguages(): { { Code: string, Name: string, Rtl: boolean } }
	return self.Languages
end

function M15_Localization:IsRtl(langCode: string): boolean
	for _, lang in ipairs(self.Languages) do
		if lang.Code == langCode then return lang.Rtl end
	end
	return false
end

-- ============================================================
-- String-Auflösung
-- ============================================================

--[[
	Get(player, key, args?)
	key: string — z.B. "ui.shop.buy_button"
	args: table — Platzhalter { name = "Mira" } → "Willkommen, {name}!"

	Fallback-Strategie:
	1. Spieler-Sprache
	2. EN
	3. Key selbst
]]
function M15_Localization:GetString(player: Player, key: string, args: { [string]: any }?): string
	local lang = self:Get(player)
	local table_ = Locales[lang] or Locales.en or {}
	local str = table_[key]

	if not str then
		str = (Locales.en or {})[key] or key
	end

	if args then
		for k, v in pairs(args) do
			str = string.gsub(str, "{" .. k .. "}", tostring(v))
		end
	end

	return str
end

-- ============================================================
-- Spieler-Sprache aus Roblox-Locale ableiten (Best Guess)
-- ============================================================

function M15_Localization:GuessFromLocale(player: Player): string
	local ok, locale = pcall(function()
		return LocalizationService:GetCountryRegionForPlayerAsync(player)
	end)
	if not ok or not locale then return "en" end

	-- Mapping: Land → Sprache (vereinfacht; User kann jederzeit wechseln)
	local map: { [string]: string } = {
		DE = "de", AT = "de", CH = "de",
		US = "en", GB = "en", CA = "en", AU = "en",
		ES = "es", MX = "es", AR = "es",
		FR = "fr", BE = "fr",
		IN = "hi",
		TR = "tr",
		CN = "zh", HK = "zh", TW = "zh",
		JP = "ja",
		SA = "ar", EG = "ar", AE = "ar",
	}

	local country = string.sub(locale, 1, 2)
	return map[country] or "en"
end

-- ============================================================
-- Lifecycle
-- ============================================================

local localizationSelf = M15_Localization
Players.PlayerAdded:Connect(function(player)
	playerLanguages[player] = localizationSelf:GuessFromLocale(player)
end)

Players.PlayerRemoving:Connect(function(player)
	playerLanguages[player] = nil
end)

return M15_Localization