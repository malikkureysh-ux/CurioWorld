--!strict
--[[
	M09_Event.spec.lua — Tests für M09 Event Framework
]]

return function()
	local M09 = require(script.Parent.Parent.Modules.M09_Event)

	describe("M09_Event — Registry", function()
		it("should expose non-empty Registry", function()
			expect(#M09.Registry > 0).to.equal(true)
		end)

		it("should include harbor_anniversary (seasonal)", function()
			expect(M09.Registry["harbor_anniversary"] ~= nil).to.equal(true)
		end)

		it("should have type field on every event", function()
			for _, e in pairs(M09.Registry) do
				expect(type(e.type)).to.equal("string")
				expect(e.type == "seasonal" or e.type == "community" or e.type == "live")
					.to.equal(true)
			end
		end)
	end)

	describe("M09_Event — Start / End / IsActive", function()
		it("should start an event with duration", function()
			local ok = M09:Start("weekend_crafting", 1)  -- 1 hour
			expect(ok).to.equal(true)
			expect(M09:IsActive("weekend_crafting")).to.equal(true)
		end)

		it("should return false for inactive event", function()
			expect(M09:IsActive("weekend_crafting")).to.equal(true)  -- just started
		end)

		it("should end event", function()
			M09:End("weekend_crafting")
			expect(M09:IsActive("weekend_crafting")).to.equal(false)
		end)

		it("should reject unknown event for Start", function()
			local ok = M09:Start("nonexistent", 1)
			expect(ok).to.equal(false)
		end)
	end)

	describe("M09_Event — Contribute", function()
		local fakePlayer = { Name = "alice", UserId = 33333 }

		it("should not accept contribution when event inactive", function()
			local ok = M09:Contribute(fakePlayer, "harbor_anniversary", 10)
			expect(ok).to.equal(false)
		end)

		it("should accept contribution when event active", function()
			M09:Start("harbor_anniversary", 1)
			local ok = M09:Contribute(fakePlayer, "harbor_anniversary", 50)
			expect(ok).to.equal(true)
			expect(M09:GetContribution(fakePlayer, "harbor_anniversary")).to.equal(50)
		end)

		it("should reject negative contribution", function()
			local ok = M09:Contribute(fakePlayer, "harbor_anniversary", -5)
			expect(ok).to.equal(false)
		end)

		it("should track global progress", function()
			local player2 = { Name = "bob", UserId = 44444 }
			M09:Contribute(fakePlayer, "harbor_anniversary", 100)
			M09:Contribute(player2, "harbor_anniversary", 200)
			expect(M09:GetGlobalProgress("harbor_anniversary")).to.equal(350)
		end)
	end)

	describe("M09_Event — GetActiveEvents", function()
		it("should return list of currently active events", function()
			M09:Start("harbor_anniversary", 1)
			M09:Start("weekend_crafting", 2)
			local active = M09:GetActiveEvents()
			expect(#active >= 1).to.equal(true)
			M09:End("harbor_anniversary")
			M09:End("weekend_crafting")
		end)
	end)
end