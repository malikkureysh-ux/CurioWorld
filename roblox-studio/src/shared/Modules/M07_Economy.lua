--!strict
--[[
	M07_Economy.lua — Wirtschafts-Modul (Shared Types + Client-Read)
	=============================================================

	Wirtschafts-Definition für Curio World:
	- Gold (Soft-Massen): durch Gameplay, für Standard-Cosmetics/Deko
	- Gems (Soft-Selten): durch Hauptquests/Events, für Premium-Cosmetics
	- Robux (Echtgeld): VIP-Pass, exklusive Cosmetics
	- KEIN Stamina (Anti-Frust, Compliance C-007)

	Server-Implementierung in `server/Services/EconomyService.lua`.
	Dieses Modul definiert nur Konstanten + Typen + clientseitige Reads.
]]

local M07_Economy = {}

-- ============================================================
-- Währungs-Definitionen
-- ============================================================

export type CurrencyKind = "Gold" | "Gems" | "RobuxSpent"

export type Wallet = {
	Gold: number,
	Gems: number,
	RobuxSpent: number, -- Lifetime-Tracker für Analytics (kein Verbrauch)
	VIPActive: boolean,
	VIPExpiresAt: number, -- Unix-Timestamp, 0 wenn nicht VIP
}

export type CurrencyLimits = {
	SoftCap: number, -- weiche Obergrenze, ab hier sinken Drops
	HardCap: number, -- harte Obergrenze (für UI-Anzeige)
}

M07_Economy.Limits = {
	Gold = { SoftCap = 999_999, HardCap = 9_999_999 },
	Gems = { SoftCap = 9_999,    HardCap = 99_999 },
} :: { [CurrencyKind]: CurrencyLimits }

-- ============================================================
-- Kaufbare Kategorien (Whitelist)
-- ============================================================

export type PurchaseCategory = "Cosmetic" | "Comfort" | "Event" | "VIP"

export type ShopItem = {
	Id: string,
	Name: string,            -- localization key
	Description: string,     -- localization key
	Category: PurchaseCategory,
	PriceGold: number?,
	PriceGems: number?,
	PriceRobux: number?,
	VIPOnly: boolean,
	LimitPerPlayer: number?, -- nil = unbegrenzt
	AgeBandMin: number?,     -- nil = alle
	ReleasedAt: number,      -- Unix-Timestamp
	RetiredAt: number?,      -- nil = aktiv
}

-- Compliance: Power-Verkäufe sind EXPLIZIT verboten.
-- Vor jedem Verkauf muss Category ∈ {Cosmetic, Comfort, Event, VIP}.
M07_Economy.AllowedCategories = { "Cosmetic", "Comfort", "Event", "VIP" } :: { PurchaseCategory }

-- Tages-Bonus (ehem. "Stamina"-Slot, refit auf Belohnungs-Boost)
M07_Economy.DailyBonus = {
	MaxCharges = 3,
	RechargeSeconds = 600, -- 10 Min pro Charge
	GoldMultiplier = 1.2,  -- +20% Gold-Bonus auf nächste Quest
}

-- ============================================================
-- VIP-Pass-Details
-- ============================================================

M07_Economy.VIP = {
	PriceRobuxMonthly = 399,
	DurationSeconds = 30 * 24 * 60 * 60, -- 30 Tage
	Benefits = {
		ExtraCompanionSlot = 1,
		DailyFreeLootbox = true,
		ExtraPhotoFilters = 8,
		EarlyAccessDays = 7,
		ExtraOutfitSlots = 7,
	},
	-- EXPLIZIT verbotene VIP-Vorteile (Audit-Liste):
	ForbiddenBenefits = {
		"XPBoost",
		"GoldBoost",
		"GemsBoost",
		"GameplayBoost",
		"StaminaRefill",   -- gibts sowieso nicht
		"StorySkip",
		"LearningTaskSkip",
	},
}

-- ============================================================
-- Hilfsfunktionen
-- ============================================================

function M07_Economy.IsVipActive(wallet: Wallet, now: number): boolean
	if not wallet.VIPActive then return false end
	return wallet.VIPExpiresAt > now
end

function M07_Economy.CanAfford(wallet: Wallet, item: ShopItem): (boolean, string?)
	if item.PriceGold and wallet.Gold < item.PriceGold then
		return false, "not_enough_gold"
	end
	if item.PriceGems and wallet.Gems < item.PriceGems then
		return false, "not_enough_gems"
	end
	if item.VIPOnly and not M07_Economy.IsVipActive(wallet, os.time()) then
		return false, "vip_required"
	end
	return true, nil
end

-- Compliance-Check: verhindert versehentliches Pay-to-Win
function M07_Economy.AuditItem(item: ShopItem): (boolean, string?)
	local allowed = false
	for _, c in ipairs(M07_Economy.AllowedCategories) do
		if c == item.Category then allowed = true; break end
	end
	if not allowed then
		return false, "category_not_allowed: " .. tostring(item.Category)
	end
	if item.PriceGold and item.PriceGold < 0 then
		return false, "negative_price_gold"
	end
	if item.PriceGems and item.PriceGems < 0 then
		return false, "negative_price_gems"
	end
	if item.PriceRobux and item.PriceRobux < 0 then
		return false, "negative_price_robux"
	end
	return true, nil
end

return M07_Economy