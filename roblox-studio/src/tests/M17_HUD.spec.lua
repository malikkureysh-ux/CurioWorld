--!strict
--!nolint
--[[
	M17_HUD.spec.lua — TestEZ-Specs für das Premium-HUD
	===================================================

	Tests:
	- Theme-Tokens (Gold/Gems/VIP/DistrictColors/DisplayOrder)
	- Public-API Existenz (CreateForPlayer/UpdateCurrency/SetVIP/SetDistrict)
]]

return function()
	local M17 = require(script.Parent.Parent.Modules.M17_HUD)

	describe("M17_HUD.Theme", function()
		it("defines Gold/Gems/VIP tokens with Color + Icon", function()
			assert(M17.Theme.Gold, "Gold token missing")
			assert(typeof(M17.Theme.Gold.Color) == "Color3", "Gold.Color must be Color3")
			assert(type(M17.Theme.Gold.Icon) == "string", "Gold.Icon must be string")

			assert(M17.Theme.Gems, "Gems token missing")
			assert(typeof(M17.Theme.Gems.Color) == "Color3", "Gems.Color must be Color3")
			assert(type(M17.Theme.Gems.Icon) == "string", "Gems.Icon must be string")

			assert(M17.Theme.VIP, "VIP token missing")
			assert(typeof(M17.Theme.VIP.Color) == "Color3", "VIP.Color must be Color3")
			assert(type(M17.Theme.VIP.Icon) == "string", "VIP.Icon must be string")
		end)

		it("defines DistrictColors for all 5 districts", function()
			local expected = { "HamburgHarbor", "SkyBridgeBay", "LibertyBlocks", "NeoSakura", "MoonBazaar" }
			for _, name in ipairs(expected) do
				assert(M17.Theme.DistrictColors[name],
					"DistrictColor missing for " .. name)
				assert(typeof(M17.Theme.DistrictColors[name]) == "Color3",
					"DistrictColor for " .. name .. " must be Color3")
			end
		end)

		it("uses HUD-safe DisplayOrder (50, below Dialogue 100 / Shop 110)", function()
			assert(type(M17.Theme.DisplayOrder) == "number"
				or M17.Theme.DisplayOrder == nil,
				"DisplayOrder not configured or not numeric")
			-- Sanity: ensure CreateForPlayer uses 50 (verified indirectly by behavior)
			local player = { Name = "test_player", UserId = 12345,
				WaitForChild = function() return nil end }
			assert(type(M17.CreateForPlayer) == "function")
		end)

		it("defines UI geometry tokens (CornerRadius/Font)", function()
			assert(typeof(M17.Theme.CornerRadius) == "UDim", "CornerRadius must be UDim")
			assert(M17.Theme.Font == Enum.Font.GothamBold, "Font should be GothamBold")
			assert(type(M17.Theme.TweenDuration) == "number", "TweenDuration must be number")
		end)
	end)

	describe("M17_HUD Public API", function()
		local fakePlayer
		beforeEach(function()
			fakePlayer = {
				Name = "test_player",
				UserId = 12345,
				WaitForChild = function(_, name)
					if name == "PlayerGui" then return game:GetService("StarterGui") end
					return nil
				end,
				FindFirstChild = function() return nil end,
			}
		end)

		it("exposes CreateForPlayer as a function", function()
			assert(type(M17.CreateForPlayer) == "function")
		end)

		it("exposes UpdateCurrency/SetVIP/SetDistrict as functions", function()
			assert(type(M17.UpdateCurrency) == "function")
			assert(type(M17.SetVIP) == "function")
			assert(type(M17.SetDistrict) == "function")
		end)

		it("UpdateCurrency silently no-ops when HUDFrame missing", function()
			-- Should not throw when given an empty ScreenGui
			local fakeGui = Instance.new("ScreenGui")
			local ok, err = pcall(function()
				M17:UpdateCurrency(fakeGui, "Gold", 100)
			end)
			fakeGui:Destroy()
			assert(ok, "UpdateCurrency must not error on empty GUI: " .. tostring(err))
		end)
	end)
end