--!strict
--[[
	M15_Localization.spec.lua — TestEZ-Specs für i18n
	==================================================

	Tests:
	- Alle 9 Sprachen vorhanden
	- Fallback zu EN wenn Schlüssel fehlt
	- Fallback zu Key wenn Schlüssel auch in EN fehlt
	- RTL-Sprachen korrekt markiert
	- Platzhalter-Substitution (single + multi + AR)
]]

-- Module loader (TestEZ-konform: require am Anfang)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local M15_Localization = require(ReplicatedStorage.Shared.Modules.M15_Localization)
local Locales = require(ReplicatedStorage.Shared.Data.locales)

return function()
	describe("M15_Localization.Languages", function()
		it("should have all 9 supported languages", function()
			assert(#M15_Localization.Languages == 9,
				"Expected 9 languages, got " .. #M15_Localization.Languages)
		end)

		it("should include required languages", function()
			local codes = {}
			for _, lang in ipairs(M15_Localization.Languages) do
				codes[lang.Code] = true
			end
			for _, code in ipairs({"de", "en", "es", "fr", "hi", "tr", "zh", "ja", "ar"}) do
				assert(codes[code], "Missing language: " .. code)
			end
		end)

		it("should mark Arabic as RTL", function()
			assert(M15_Localization:IsRtl("ar"), "Arabic must be RTL")
		end)

		it("should mark other languages as non-RTL", function()
			for _, code in ipairs({"de", "en", "es", "fr", "hi", "tr", "zh", "ja"}) do
				assert(not M15_Localization:IsRtl(code), code .. " must not be RTL")
			end
		end)
	end)

	describe("M15_Localization:Set/Get", function()
		it("should accept valid language codes", function()
			local fakePlayer = { Name = "TestPlayer" }
			assert(M15_Localization:Set(fakePlayer, "de") == true)
			assert(M15_Localization:Set(fakePlayer, "en") == true)
		end)

		it("should reject invalid language codes", function()
			local fakePlayer = { Name = "TestPlayer" }
			assert(M15_Localization:Set(fakePlayer, "klingon") == false)
		end)

		it("should default to en when not set", function()
			local fakePlayer = { Name = "TestPlayer2" }
			assert(M15_Localization:Get(fakePlayer) == "en")
		end)

		it("should not inherit language from previous player", function()
			local p1 = { Name = "Player1" }
			local p2 = { Name = "Player2" }
			M15_Localization:Set(p1, "de")
			M15_Localization:Get(p1) -- triggers potential state
			assert(M15_Localization:Get(p2) == "en", "New player should default to en, not inherit from p1")
		end)
	end)

	describe("M15_Localization:GetString (placeholder substitution)", function()
		it("should substitute single placeholder in English", function()
			local fakePlayer = { Name = "Alice" }
			M15_Localization:Set(fakePlayer, "en")
			local result = M15_Localization:GetString(fakePlayer, "ui.hud.welcome", { name = "Alice" })
			assert(string.find(result, "Alice"),
				"Placeholder should be substituted, got: " .. result)
		end)

		it("should substitute placeholders in Arabic (RTL)", function()
			local fakePlayer = { Name = "TestAR" }
			M15_Localization:Set(fakePlayer, "ar")
			local result = M15_Localization:GetString(fakePlayer, "ui.hud.welcome", { name = "علي" })
			assert(string.find(result, "علي"),
				"Arabic substitution should work, got: " .. result)
		end)

		it("should substitute placeholders in Hindi (non-Latin script)", function()
			local fakePlayer = { Name = "TestHI" }
			M15_Localization:Set(fakePlayer, "hi")
			local result = M15_Localization:GetString(fakePlayer, "ui.hud.welcome", { name = "राम" })
			assert(string.find(result, "राम"),
				"Hindi substitution should work, got: " .. result)
		end)

		it("should handle multiple placeholders", function()
			local fakePlayer = { Name = "Test" }
			M15_Localization:Set(fakePlayer, "en")
			-- Find a key with multiple placeholders or test by adding one
			local Locales_en = Locales.en
			Locales_en["test.multi_placeholder"] = "Hello {first} {last}!"
			local result = M15_Localization:GetString(fakePlayer, "test.multi_placeholder", {
				first = "Alice", last = "Wonder"
			})
			assert(string.find(result, "Alice") and string.find(result, "Wonder"),
				"Both placeholders should be substituted, got: " .. result)
			Locales_en["test.multi_placeholder"] = nil -- cleanup
		end)

		it("should fall back to EN when key missing in player's language", function()
			local fakePlayer = { Name = "Test" }
			M15_Localization:Set(fakePlayer, "de")
			-- Insert a key only in EN
			Locales.en["test.fallback_key"] = "English fallback works"
			local result = M15_Localization:GetString(fakePlayer, "test.fallback_key", {})
			assert(string.find(result, "English"),
				"Should fall back to EN, got: " .. result)
			Locales.en["test.fallback_key"] = nil
		end)

		it("should fall back to key when missing in both player language AND EN", function()
			local fakePlayer = { Name = "Test" }
			M15_Localization:Set(fakePlayer, "de")
			local result = M15_Localization:GetString(fakePlayer, "totally.nonexistent.key.zzz", {})
			assert(result == "totally.nonexistent.key.zzz",
				"Should return key as last resort, got: " .. result)
		end)

		it("should handle nil args gracefully", function()
			local fakePlayer = { Name = "Test" }
			M15_Localization:Set(fakePlayer, "en")
			local result = M15_Localization:GetString(fakePlayer, "ui.shop.buy_button", nil)
			assert(result == "Buy", "nil args should work, got: " .. tostring(result))
		end)

		it("should handle empty args gracefully", function()
			local fakePlayer = { Name = "Test" }
			M15_Localization:Set(fakePlayer, "en")
			local result = M15_Localization:GetString(fakePlayer, "ui.shop.buy_button", {})
			assert(result == "Buy", "Empty args should work, got: " .. tostring(result))
		end)

		it("should tostring number values", function()
			local fakePlayer = { Name = "Test" }
			M15_Localization:Set(fakePlayer, "en")
			Locales.en["test.numeric"] = "You have {count} items"
			local result = M15_Localization:GetString(fakePlayer, "test.numeric", { count = 42 })
			assert(string.find(result, "42"),
				"Numbers should be tostring'd, got: " .. result)
			Locales.en["test.numeric"] = nil
		end)
	end)
end