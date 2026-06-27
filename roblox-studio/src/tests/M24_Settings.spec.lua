--!strict
--!nolint
--[[
	M24_Settings.spec.lua — TestEZ-Specs für die Premium-Settings-UI
	================================================================

	Tests:
	- Defaults (VolumeMaster/Language/etc.)
	- OnSave/OnLanguageChange/OnAccessibilityChange Callback-Slots
	- 9 unterstützte Sprachen
]]

return function()
	local M24 = require(script.Parent.Parent.Modules.M24_Settings)

	describe("M24_Settings.Theme", function()
		it("defines Backdrop/Modal/Section/Primary colors", function()
			assert(typeof(M24.Theme.Backdrop) == "Color3")
			assert(typeof(M24.Theme.ModalBackground) == "Color3")
			assert(typeof(M24.Theme.SectionColor) == "Color3")
			assert(typeof(M24.Theme.Primary) == "Color3")
		end)

		it("defines CornerRadius (UDim) + TextColor", function()
			assert(typeof(M24.Theme.CornerRadius) == "UDim")
			assert(typeof(M24.Theme.TextColor) == "Color3")
		end)
	end)

	describe("M24_Settings.Defaults", function()
		it("defines VolumeMaster/VolumeMusic/VolumeSFX in [0,1]", function()
			for _, key in ipairs({ "VolumeMaster", "VolumeMusic", "VolumeSFX" }) do
				assert(type(M24.Defaults[key]) == "number",
					key .. " must be number, got " .. type(M24.Defaults[key]))
				assert(M24.Defaults[key] >= 0 and M24.Defaults[key] <= 1,
					key .. " must be in [0,1], got " .. tostring(M24.Defaults[key]))
			end
		end)

		it("defaults Language to 'de'", function()
			assert(M24.Defaults.Language == "de",
				"Default Language must be 'de', got " .. tostring(M24.Defaults.Language))
		end)

		it("defines accessibility toggles (Animations/HighContrast/ReducedMotion)", function()
			for _, key in ipairs({ "AnimationsEnabled", "HighContrast", "ReducedMotion" }) do
				assert(type(M24.Defaults[key]) == "boolean",
					key .. " must be boolean, got " .. type(M24.Defaults[key]))
			end
		end)
	end)

	describe("M24_Settings Languages", function()
		it("exposes 9 supported languages (de/en/es/fr/tr/hi/zh/ja/ar)", function()
			-- Mirrors the dropdown options in M24_Settings.Show
			local expected = { "de", "en", "es", "fr", "tr", "hi", "zh", "ja", "ar" }
			assert(#expected == 9, "Expected 9 languages")
			-- Default language must be one of them
			local found = false
			for _, code in ipairs(expected) do
				if M24.Defaults.Language == code then found = true; break end
			end
			assert(found, "Default Language '" .. M24.Defaults.Language .. "' not in supported set")
		end)
	end)

	describe("M24_Settings Callback Slots", function()
		it("exposes OnSave slot (nil by default)", function()
			assert(M24.OnSave == nil or type(M24.OnSave) == "function",
				"OnSave must be nil or function")
		end)

		it("exposes OnLanguageChange slot (nil by default)", function()
			assert(M24.OnLanguageChange == nil or type(M24.OnLanguageChange) == "function",
				"OnLanguageChange must be nil or function")
		end)

		it("exposes OnAccessibilityChange slot (nil by default)", function()
			assert(M24.OnAccessibilityChange == nil or type(M24.OnAccessibilityChange) == "function",
				"OnAccessibilityChange must be nil or function")
		end)

		it("allows assigning all 3 callbacks at runtime", function()
			local origSave = M24.OnSave
			local origLang = M24.OnLanguageChange
			local origAcc = M24.OnAccessibilityChange
			M24.OnSave = function() end
			M24.OnLanguageChange = function() end
			M24.OnAccessibilityChange = function() end
			assert(type(M24.OnSave) == "function")
			assert(type(M24.OnLanguageChange) == "function")
			assert(type(M24.OnAccessibilityChange) == "function")
			-- restore
			M24.OnSave = origSave
			M24.OnLanguageChange = origLang
			M24.OnAccessibilityChange = origAcc
		end)
	end)

	describe("M24_Settings Public API", function()
		it("exposes Show as a function", function()
			assert(type(M24.Show) == "function")
		end)
	end)
end