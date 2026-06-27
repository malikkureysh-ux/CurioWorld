--!strict
--[[
	M15_Localization.spec.lua — TestEZ-Specs für i18n
	==================================================

	Tests:
	- Alle 9 Sprachen vorhanden
	- Fallback zu EN wenn Schlüssel fehlt
	- RTL-Sprachen korrekt markiert
	- Platzhalter-Substitution
]]

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
	end)

	describe("M15_Localization:GetString (placeholder substitution)", function()
		it("should substitute placeholders", function()
			local fakePlayer = { Name = "Mira" }
			M15_Localization:Set(fakePlayer, "en")
			local result = M15_Localization:GetString(fakePlayer, "ui.hud.welcome", { name = "Alice" })
			assert(string.find(result, "Alice"),
				"Placeholder should be substituted, got: " .. result)
		end)
	end)
end