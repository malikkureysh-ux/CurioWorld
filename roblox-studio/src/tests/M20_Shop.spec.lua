--!strict
--!nolint
--[[
	M20_Shop.spec.lua — TestEZ-Specs für den Premium-Shop
	=====================================================

	Tests:
	- Theme-Tokens (Background/Item/VIPBadge/GridColumns)
	- SampleItems hat genau 6 Einträge
	- PurchaseHandler-Slot
]]

return function()
	local M20 = require(script.Parent.Parent.Modules.M20_Shop)

	describe("M20_Shop.Theme", function()
		it("defines BackgroundColor + CornerRadius", function()
			assert(typeof(M20.Theme.BackgroundColor) == "Color3")
			assert(typeof(M20.Theme.CornerRadius) == "UDim")
		end)

		it("defines Item state colors (Idle/Hover/Affordable/Unaffordable)", function()
			assert(typeof(M20.Theme.ItemIdle) == "Color3")
			assert(typeof(M20.Theme.ItemHover) == "Color3")
			assert(typeof(M20.Theme.ItemAffordable) == "Color3")
			assert(typeof(M20.Theme.ItemUnaffordable) == "Color3")
		end)

		it("defines VIPBadge color and 3-column Grid", function()
			assert(typeof(M20.Theme.VIPBadge) == "Color3")
			assert(M20.Theme.GridColumns == 3, "GridColumns must be 3")
		end)
	end)

	describe("M20_Shop.SampleItems", function()
		it("contains exactly 6 sample items", function()
			assert(#M20.SampleItems == 6,
				"Expected 6 sample items, got " .. #M20.SampleItems)
		end)

		it("each item has id + icon + name_key", function()
			for i, item in ipairs(M20.SampleItems) do
				assert(type(item.id) == "string" and #item.id > 0,
					"Item " .. i .. " missing id")
				assert(type(item.icon) == "string" and #item.icon > 0,
					"Item " .. i .. " missing icon")
				assert(type(item.name_key) == "string",
					"Item " .. i .. " missing name_key")
			end
		end)

		it("each item has at least one price (gold or robux)", function()
			for i, item in ipairs(M20.SampleItems) do
				local hasGold = type(item.price_gold) == "number"
				local hasRobux = type(item.price_robux) == "number"
				assert(hasGold or hasRobux,
					"Item " .. item.id .. " has no price set")
			end
		end)
	end)

	describe("M20_Shop Callback Slots", function()
		it("exposes PurchaseHandler slot (nil by default)", function()
			assert(M20.PurchaseHandler == nil or type(M20.PurchaseHandler) == "function",
				"PurchaseHandler must be nil or function")
		end)

		it("exposes Show as a function", function()
			assert(type(M20.Show) == "function")
		end)
	end)
end