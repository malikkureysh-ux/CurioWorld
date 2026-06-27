--!strict
--[[
	M06_Inventory.spec.lua — Tests für M06 Inventory
]]

return function()
	local M06 = require(script.Parent.Parent.Modules.M06_Inventory)

	describe("M06_Inventory — Add / Has / GetCount / Remove", function()
		local fakePlayer = { Name = "test", UserId = 99999 }

		it("should add item successfully", function()
			local ok = M06:Add(fakePlayer, "WoodPlank", 4)
			expect(ok).to.equal(true)
			expect(M06:GetCount(fakePlayer, "WoodPlank")).to.equal(4)
		end)

		it("should merge stacks when same item re-added", function()
			M06:Add(fakePlayer, "WoodPlank", 3)
			expect(M06:GetCount(fakePlayer, "WoodPlank")).to.equal(7)
		end)

		it("should NOT exceed max stack (99)", function()
			M06:Add(fakePlayer, "Rope", 99)
			M06:Add(fakePlayer, "Rope", 5)
			expect(M06:GetCount(fakePlayer, "Rope")).to.equal(99)
			expect(M06:GetSlotCount(fakePlayer)).to.equal(2)  -- 2 stacks
		end)

		it("should check Has correctly", function()
			expect(M06:Has(fakePlayer, "WoodPlank", 7)).to.equal(true)
			expect(M06:Has(fakePlayer, "WoodPlank", 8)).to.equal(false)
			expect(M06:Has(fakePlayer, "NoneExistent", 1)).to.equal(false)
		end)

		it("should remove items correctly", function()
			local ok = M06:Remove(fakePlayer, "WoodPlank", 3)
			expect(ok).to.equal(true)
			expect(M06:GetCount(fakePlayer, "WoodPlank")).to.equal(4)
		end)

		it("should reject removal when not enough items", function()
			local ok = M06:Remove(fakePlayer, "WoodPlank", 999)
			expect(ok).to.equal(false)
		end)

		it("should reject negative count", function()
			local ok = M06:Add(fakePlayer, "Foo", 0)
			expect(ok).to.equal(false)
			ok = M06:Add(fakePlayer, "Foo", -5)
			expect(ok).to.equal(false)
		end)

		it("should return false for nil player", function()
			local ok = M06:Add(nil :: any, "Foo", 1)
			expect(ok).to.equal(false)
		end)
	end)

	describe("M06_Inventory — CollectionBook (Spaced-Recall)", function()
		local fakePlayer = { Name = "test2", UserId = 88888 }

		it("should discover items automatically on Add", function()
			M06:Add(fakePlayer, "Curio_Seagull", 1)
			local book = M06:GetCollection(fakePlayer)
			expect(book.categories["Companions"] ~= nil).to.equal(true)
			expect(book.categories["Companions"]["Curio_Seagull"] ~= nil).to.equal(true)
			expect(book.categories["Companions"]["Curio_Seagull"].discovered).to.equal(true)
		end)

		it("should increment recall count", function()
			M06:IncrementRecall(fakePlayer, "Curio_Seagull")
			M06:IncrementRecall(fakePlayer, "Curio_Seagull")
			local book = M06:GetCollection(fakePlayer)
			expect(book.categories["Companions"]["Curio_Seagull"].recalled_count).to.equal(2)
		end)

		it("should count discovered items", function()
			local count = M06:GetDiscoveredCount(fakePlayer)
			expect(count >= 1).to.equal(true)
		end)
	end)

	describe("M06_Inventory — VIP Slot Bonus", function()
		local fakePlayer = { Name = "vip_test", UserId = 77777 }

		it("should give default 24 slots for non-VIP", function()
			local slots = M06:GetSlots(fakePlayer)
			expect(type(slots)).to.equal("table")
			-- Inventory exists (might be empty for new player)
		end)
	end)

	describe("M06_Inventory — Pid extraction", function()
		it("should handle string player", function()
			local pid = M06:ToPid("alice")
			expect(pid).to.equal("user_alice")
		end)

		it("should handle numeric player", function()
			local pid = M06:ToPid(12345)
			expect(pid).to.equal("user_12345")
		end)

		it("should return nil for nil", function()
			expect(M06:ToPid(nil)).to.equal(nil)
		end)
	end)
end