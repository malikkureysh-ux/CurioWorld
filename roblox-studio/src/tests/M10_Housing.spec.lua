--!strict
--[[
	M10_Housing.spec.lua — Tests für M10 Housing
]]

return function()
	local M10 = require(script.Parent.Parent.Modules.M10_Housing)

	describe("M10_Housing — Place / Remove", function()
		local fakePlayer = { Name = "p1", UserId = 55555 }

		it("should place a decoration (player must have item in inventory)", function()
			-- First, give the player an item
			local M06 = require(script.Parent.Parent.Modules.M06_Inventory)
			M06:Add(fakePlayer, "Boat_Model_Deco", 1)

			local ok = M10:Place(fakePlayer, "Boat_Model_Deco",
				Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), nil)
			expect(ok).to.equal(true)
		end)

		it("should not place if item not in inventory", function()
			local ok = M10:Place(fakePlayer, "NotInInventory",
				Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), nil)
			expect(ok).to.equal(false)
		end)

		it("should remove decoration and return item to inventory", function()
			local M06 = require(script.Parent.Parent.Modules.M06_Inventory)
			local beforeCount = M06:GetCount(fakePlayer, "Boat_Model_Deco")

			local ok = M10:Remove(fakePlayer, 1)
			expect(ok).to.equal(true)
			expect(M06:GetCount(fakePlayer, "Boat_Model_Deco")).to.equal(beforeCount + 1)
		end)

		it("should return false for invalid index", function()
			local ok = M10:Remove(fakePlayer, 9999)
			expect(ok).to.equal(false)
		end)
	end)

	describe("M10_Housing — Visitor Settings", function()
		local fakeOwner = { Name = "owner", UserId = 66666 }
		local fakeVisitor = { Name = "visitor", UserId = 77777 }

		it("should allow self to visit own house", function()
			expect(M10:CanVisit(fakeOwner, fakeOwner)).to.equal(true)
		end)

		it("should reject visitor when house is private", function()
			M10:SetVisitorSettings(fakeOwner, "private")
			expect(M10:CanVisit(fakeVisitor, fakeOwner)).to.equal(false)
		end)

		it("should allow visitor when house is public", function()
			M10:SetVisitorSettings(fakeOwner, "public")
			expect(M10:CanVisit(fakeVisitor, fakeOwner)).to.equal(true)
		end)

		it("should reject visitor when house is friends (no friend lookup yet)", function()
			M10:SetVisitorSettings(fakeOwner, "friends")
			expect(M10:CanVisit(fakeVisitor, fakeOwner)).to.equal(false)
		end)
	end)

	describe("M10_Housing — GetHouse / GetDecorations", function()
		local fakePlayer = { Name = "p2", UserId = 88888 }

		it("should return nil for new player", function()
			local house = M10:GetHouse(fakePlayer)
			expect(house).to.equal(nil)
		end)

		it("should create house after Place", function()
			local M06 = require(script.Parent.Parent.Modules.M06_Inventory)
			M06:Add(fakePlayer, "Test_Deco", 1)
			M10:Place(fakePlayer, "Test_Deco",
				Vector3.new(1, 2, 3), Vector3.new(0, 90, 0), nil)
			local house = M10:GetHouse(fakePlayer)
			expect(house ~= nil).to.equal(true)
			expect(#M10:GetDecorations(fakePlayer)).to.equal(1)
		end)
	end)
end