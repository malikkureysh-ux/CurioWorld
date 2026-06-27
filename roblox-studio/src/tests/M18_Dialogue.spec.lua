--!strict
--!nolint
--[[
	M18_Dialogue.spec.lua — TestEZ-Specs für das Premium-Dialog-Fenster
	====================================================================

	Tests:
	- Theme-Tokens (Backdrop/Modal/Option)
	- PortraitIcons für alle 4 NPCs + Default
	- Show-API Signatur
]]

return function()
	local M18 = require(script.Parent.Parent.Modules.M18_Dialogue)

	describe("M18_Dialogue.Theme", function()
		it("defines BackdropColor + BackdropTransparency", function()
			assert(typeof(M18.Theme.BackdropColor) == "Color3")
			assert(type(M18.Theme.BackdropTransparency) == "number")
			assert(M18.Theme.BackdropTransparency >= 0
				and M18.Theme.BackdropTransparency <= 1,
				"BackdropTransparency must be in [0,1]")
		end)

		it("defines Modal tokens (Background + CornerRadius)", function()
			assert(typeof(M18.Theme.ModalBackground) == "Color3")
			assert(typeof(M18.Theme.ModalCornerRadius) == "UDim")
			assert(typeof(M18.Theme.PortraitSize) == "UDim2")
		end)

		it("defines Option Idle/Hover/Selected colors", function()
			assert(typeof(M18.Theme.OptionIdle) == "Color3", "OptionIdle missing")
			assert(typeof(M18.Theme.OptionHover) == "Color3", "OptionHover missing")
			assert(typeof(M18.Theme.OptionSelected) == "Color3", "OptionSelected missing")
			assert(typeof(M18.Theme.TweenDuration) == "number")
		end)
	end)

	describe("M18_Dialogue.PortraitIcons", function()
		it("has icons for all 4 named NPCs", function()
			assert(type(M18.PortraitIcons.Hafenwirtin) == "string")
			assert(type(M18.PortraitIcons.Yuki) == "string")
			assert(type(M18.PortraitIcons.Maja) == "string")
			assert(type(M18.PortraitIcons.Nils) == "string")
		end)

		it("has a Default fallback icon", function()
			assert(type(M18.PortraitIcons.Default) == "string",
				"Default portrait icon missing")
			assert(#M18.PortraitIcons.Default > 0, "Default icon must not be empty")
		end)

		it("uses non-empty emoji for each NPC", function()
			for name, icon in pairs(M18.PortraitIcons) do
				assert(#icon > 0, "Icon for " .. name .. " must not be empty")
			end
		end)
	end)

	describe("M18_Dialogue Public API", function()
		it("exposes Show as a function", function()
			assert(type(M18.Show) == "function")
		end)

		it("exposes Hide as a function", function()
			assert(type(M18.Hide) == "function")
		end)

		it("Show handles missing PlayerGui gracefully", function()
			local fakePlayer = {
				Name = "test_player",
				UserId = 12345,
				FindFirstChild = function() return nil end,
			}
			local fakeNpc = { NpcId = "Hafenwirtin", DisplayName = "Test", Role = "Wirtin" }
			local ok, err = pcall(function()
				M18:Show(fakePlayer, fakeNpc, "Hallo!", nil, nil)
			end)
			assert(ok, "Show must not throw when PlayerGui missing: " .. tostring(err))
		end)
	end)
end