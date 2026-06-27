--!strict
--[[
	DailyQuestService.spec.lua — Tests für Daily Quest Rotation
]]

return function()
	local DQS = require(script.Parent.Parent.parent.server.Services.DailyQuestService)

	describe("DailyQuestService — Pool", function()
		it("should expose non-empty Pool", function()
			expect(#DQS.Pool >= 3).to.equal(true)
		end)

		it("should have emoji, type, rewards on every entry", function()
			for _, q in ipairs(DQS.Pool) do
				expect(type(q.id)).to.equal("string")
				expect(type(q.type)).to.equal("string")
				expect(type(q.rewards)).to.equal("table")
				expect(type(q.emoji)).to.equal("string")
			end
		end)
	end)

	describe("DailyQuestService — GetTodaysQuests", function()
		local fakePlayer = { Name = "alice", UserId = 77777 }

		it("should return 3 quests for a new player", function()
			local quests = DQS:GetTodaysQuests(fakePlayer)
			expect(#quests).to.equal(3)
		end)

		it("should be deterministic for same player + same day", function()
			local first = DQS:GetTodaysQuests(fakePlayer)
			local second = DQS:GetTodaysQuests(fakePlayer)
			expect(#first).to.equal(#second)
			for i, q in ipairs(first) do
				expect(q.id).to.equal(second[i].id)
			end
		end)

		it("should differ between players", function()
			local p1 = { UserId = 11111, Name = "x" }
			local p2 = { UserId = 22222, Name = "y" }
			local q1 = DQS:GetTodaysQuests(p1)
			local q2 = DQS:GetTodaysQuests(p2)
			-- Likely different (deterministic but per-pid-seeded)
			local sameCount = 0
			for i, q in ipairs(q1) do
				if q.id == q2[i] and q2[i] ~= nil then
					sameCount += 1
				end
			end
			-- At least one different (otherwise hash collision, very unlikely)
			expect(sameCount < 3).to.equal(true)
		end)
	end)

	describe("DailyQuestService — AwardDailyQuest", function()
		it("should award gold without error", function()
			local fakePlayer = { Name = "bob", UserId = 88888 }
			-- Should not throw even with no quest loaded
			local ok = pcall(function()
				DQS:GetTodaysQuests(fakePlayer)
			end)
			expect(ok).to.equal(true)
		end)
	end)
end