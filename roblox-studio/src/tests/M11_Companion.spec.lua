--!strict
--[[
	M11_Companion.spec.lua — Tests für M11 Companion System
]]

return function()
	local M11 = require(script.Parent.Parent.Modules.M11_Companion)

	describe("M11_Companion — Registry", function()
		it("should expose non-empty Registry", function()
			expect(#M11.Registry > 0).to.equal(true)
		end)

		it("should include Curio_Seagull", function()
			expect(M11.Registry["Curio_Seagull"] ~= nil).to.equal(true)
		end)

		it("should have rarity on every companion", function()
			local validRarities = {
				common = true, uncommon = true, rare = true,
				epic = true, legendary = true,
			}
			for _, c in pairs(M11.Registry) do
				expect(validRarities[c.rarity]).to.equal(true)
			end
		end)
	end)

	describe("M11_Companion — Unlock / Rename", function()
		local fakePlayer = { Name = "p1", UserId = 12345 }

		it("should unlock a companion", function()
			local ok = M11:Unlock(fakePlayer, "Curio_Seagull")
			expect(ok).to.equal(true)
			expect(#M11:GetOwned(fakePlayer)).to.equal(1)
		end)

		it("should not unlock twice", function()
			local ok = M11:Unlock(fakePlayer, "Curio_Seagull")
			expect(ok).to.equal(false)
		end)

		it("should rename companion with valid name", function()
			local ok = M11:Rename(fakePlayer, "Curio_Seagull", "Möwe")
			expect(ok).to.equal(true)
		end)

		it("should reject too-long nicknames", function()
			local ok = M11:Rename(fakePlayer, "Curio_Seagull", string.rep("x", 30))
			expect(ok).to.equal(false)
		end)

		it("should reject nicknames with special chars", function()
			local ok = M11:Rename(fakePlayer, "Curio_Seagull", "Möwe!")
			expect(ok).to.equal(false)
		end)

		it("should not rename unlocked companion", function()
			local ok = M11:Rename(fakePlayer, "NonExistent", "Foo")
			expect(ok).to.equal(false)
		end)
	end)

	describe("M11_Companion — SetActive / GetActive", function()
		local fakePlayer = { Name = "p2", UserId = 67890 }

		it("should set active companion", function()
			M11:Unlock(fakePlayer, "Curio_PaperBoat")
			local ok = M11:SetActive(fakePlayer, "Curio_PaperBoat")
			expect(ok).to.equal(true)
			expect(M11:GetActive(fakePlayer).companion_id).to.equal("Curio_PaperBoat")
		end)

		it("should not set unlocked companion as active", function()
			local ok = M11:SetActive(fakePlayer, "NotOwned")
			expect(ok).to.equal(false)
		end)

		it("should clear active when set to nil", function()
			local ok = M11:SetActive(fakePlayer, nil)
			expect(ok).to.equal(true)
			expect(M11:GetActive(fakePlayer)).to.equal(nil)
		end)
	end)

	describe("M11_Companion — Praise (Affection)", function()
		local fakePlayer = { Name = "p3", UserId = 11111 }

		it("should increase affection by 5", function()
			M11:Unlock(fakePlayer, "Curio_Crab")
			local before = M11:GetOwned(fakePlayer)[1].affection
			M11:Praise(fakePlayer, "Curio_Crab")
			local after = M11:GetOwned(fakePlayer)[1].affection
			expect(after - before).to.equal(5)
		end)

		it("should cap affection at 100", function()
			local owned = M11:GetOwned(fakePlayer)[1]
			for _ = 1, 50 do M11:Praise(fakePlayer, "Curio_Crab") end
			expect(owned.affection <= 100).to.equal(true)
		end)
	end)
end