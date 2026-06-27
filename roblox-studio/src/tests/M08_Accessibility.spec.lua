--!strict
--[[
	M08_Accessibility.spec.lua — Tests für M08 Accessibility
]]

return function()
	local M08 = require(script.Parent.Parent.Modules.M08_Accessibility)

	describe("M08_Accessibility — Defaults", function()
		it("should have standard colors", function()
			expect(M08.StandardColors).to.be.a("table")
			expect(M08.StandardColors.BackgroundColor).to.be.a("userdata")
		end)

		it("should have high-contrast colors", function()
			expect(M08.HighContrastColors).to.be.a("table")
			expect(M08.HighContrastColors.BackgroundColor).to.be.a("userdata")
		end)
	end)

	describe("M08_Accessibility — Getter (before Init)", function()
		it("should default to reduced-motion = false", function()
			expect(M08:IsReducedMotion()).to.equal(false)
		end)

		it("should default to high-contrast = false", function()
			expect(M08:IsHighContrast()).to.equal(false)
		end)

		it("should default to animations = enabled", function()
			expect(M08:AreAnimationsEnabled()).to.equal(true)
		end)
	end)

	describe("M08_Accessibility — ApplySetting", function()
		it("should enable reduced motion", function()
			M08:ApplySetting("ReducedMotion", true)
			expect(M08:IsReducedMotion()).to.equal(true)
		end)

		it("should disable reduced motion", function()
			M08:ApplySetting("ReducedMotion", false)
			expect(M08:IsReducedMotion()).to.equal(false)
		end)

		it("should enable high contrast", function()
			M08:ApplySetting("HighContrast", true)
			expect(M08:IsHighContrast()).to.equal(true)
			-- Reset for other tests
			M08:ApplySetting("HighContrast", false)
		end)

		it("should disable animations", function()
			M08:ApplySetting("AnimationsEnabled", false)
			expect(M08:AreAnimationsEnabled()).to.equal(false)
			M08:ApplySetting("AnimationsEnabled", true)
			expect(M08:AreAnimationsEnabled()).to.equal(true)
		end)
	end)

	describe("M08_Accessibility — Theme Selection", function()
		it("should return standard theme by default", function()
			local theme = M08:GetThemeColors()
			expect(theme.BackgroundColor).to.equal(M08.StandardColors.BackgroundColor)
		end)

		it("should return high-contrast theme when enabled", function()
			M08:ApplySetting("HighContrast", true)
			local theme = M08:GetThemeColors()
			expect(theme.BackgroundColor).to.equal(M08.HighContrastColors.BackgroundColor)
			M08:ApplySetting("HighContrast", false)
		end)
	end)
end