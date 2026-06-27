--!strict
--[[
	locales.lua — Übersetzungs-Tabelle (DE + EN Starter)
	====================================================

	Format: { key = "Wert mit {platzhaltern}" }

	Für die anderen 7 Sprachen (ES, FR, HI, TR, ZH, JA, AR)
	in Phase 2-3 mit professionellen Übersetzern ergänzen.
	Studio-Workflow: Game Settings → Localization → Translator.
]]

local Locales = {}

Locales.de = {
	-- UI
	["ui.shop.buy_button"]      = "Kaufen",
	["ui.shop.buy_for_gold"]    = "{price} Gold",
	["ui.shop.buy_for_gems"]    = "{price} Gems",
	["ui.shop.not_enough_gold"] = "Nicht genug Gold",
	["ui.shop.not_enough_gems"] = "Nicht genug Gems",
	["ui.shop.vip_required"]    = "VIP-Pass erforderlich",
	["ui.shop.compliance_notice"] = "Rein kosmetisch — kein Spielvorteil.",

	["ui.hud.welcome"]          = "Willkommen, {name}!",
	["ui.hud.gold"]             = "Gold",
	["ui.hud.gems"]             = "Gems",
	["ui.hud.daily_bonus"]      = "Tages-Bonus",
	["ui.hud.daily_bonus_full"] = "3/3",
	["ui.hud.vip"]              = "VIP",

	-- Districts
	["district.hamburg_harbor.name"] = "Hamburg Harbor",
	["district.hamburg_harbor.tagline"] = "Wo Kräne tanzen und Wasser Geschichten erzählt.",
	["district.skybridge_bay.name"]   = "SkyBridge Bay",
	["district.skybridge_bay.tagline"] = "Brücken spannen, Seile spannen.",
	["district.liberty_blocks.name"]  = "Liberty Blocks",
	["district.liberty_blocks.tagline"] = "Die Stadt, die niemals schläft.",
	["district.neo_sakura.name"]      = "Neo Sakura",
	["district.neo_sakura.tagline"]   = "Neon-Lichter, endlose Codes.",
	["district.moon_bazaar.name"]     = "Moon Bazaar",
	["district.moon_bazaar.tagline"]  = "Gewürze, Sterne, Geschichten.",

	-- NPCs
	["npc.mira.greeting"]    = "Hallo! Ich bin Mira. Brauchst du Hilfe bei einer Quest?",
	["npc.tomo.greeting"]    = "Reisende Händler kommen und gehen. Schau dir meine Waren an!",

	-- Compliance
	["compliance.under_13_notice"] = "Du bist unter 13 — Käufe benötigen die Zustimmung deiner Eltern.",
}

Locales.en = {
	["ui.shop.buy_button"]      = "Buy",
	["ui.shop.buy_for_gold"]    = "{price} Gold",
	["ui.shop.buy_for_gems"]    = "{price} Gems",
	["ui.shop.not_enough_gold"] = "Not enough Gold",
	["ui.shop.not_enough_gems"] = "Not enough Gems",
	["ui.shop.vip_required"]    = "VIP Pass required",
	["ui.shop.compliance_notice"] = "Cosmetic only — no gameplay advantage.",

	["ui.hud.welcome"]          = "Welcome, {name}!",
	["ui.hud.gold"]             = "Gold",
	["ui.hud.gems"]             = "Gems",
	["ui.hud.daily_bonus"]      = "Daily Bonus",
	["ui.hud.daily_bonus_full"] = "3/3",
	["ui.hud.vip"]              = "VIP",

	["district.hamburg_harbor.name"] = "Hamburg Harbor",
	["district.hamburg_harbor.tagline"] = "Where cranes dance and water tells stories.",
	["district.skybridge_bay.name"]   = "SkyBridge Bay",
	["district.skybridge_bay.tagline"] = "Spanning bridges, tightening ropes.",
	["district.liberty_blocks.name"]  = "Liberty Blocks",
	["district.liberty_blocks.tagline"] = "The city that never sleeps.",
	["district.neo_sakura.name"]      = "Neo Sakura",
	["district.neo_sakura.tagline"]   = "Neon lights, endless code.",
	["district.moon_bazaar.name"]     = "Moon Bazaar",
	["district.moon_bazaar.tagline"]  = "Spices, stars, stories.",

	["npc.mira.greeting"]    = "Hi! I'm Mira. Need help with a quest?",
	["npc.tomo.greeting"]    = "Traveling merchants come and go. Browse my wares!",

	["compliance.under_13_notice"] = "You're under 13 — purchases need a parent's okay.",
}

return Locales