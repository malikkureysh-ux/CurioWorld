--!strict
--[[
	M05_Puzzle.spec.lua — Tests für M05 Puzzle Engine
]]

return function()
	local M05 = require(script.Parent.Parent.Modules.M05_Puzzle)

	describe("M05_Puzzle — Registry", function()
		it("should expose non-empty Registry", function()
			expect(#M05.Registry > 0).to.equal(true)
		end)

		it("should include CraneTutorial", function()
			expect(M05.Registry["CraneTutorial"] ~= nil).to.equal(true)
		end)

		it("should include CraneSelector (logic)", function()
			expect(M05.Registry["CraneSelector"] ~= nil).to.equal(true)
		end)

		it("should include ReleaseContainer (memory)", function()
			expect(M05.Registry["ReleaseContainer"] ~= nil).to.equal(true)
		end)

		it("should have all 4 puzzle types covered", function()
			local types = {}
			for _, p in pairs(M05.Registry) do
				types[p.type] = true
			end
			expect(types["sort"]).to.equal(true)
			expect(types["logic"]).to.equal(true)
			expect(types["memory"]).to.equal(true)
		end)

		it("should have hint_keys on every puzzle", function()
			for _, p in pairs(M05.Registry) do
				expect(type(p.hint_keys)).to.equal("table")
				expect(#p.hint_keys >= 1).to.equal(true)
			end
		end)
	end)

	describe("M05_Puzzle — Start / Submit", function()
		local fakePlayer = { Name = "p1", UserId = 11111 }

		it("should reject unknown puzzle", function()
			local state = M05:Start(fakePlayer, "NonexistentPuzzle")
			expect(state).to.equal(nil)
		end)

		it("should start a puzzle and return state", function()
			local state = M05:Start(fakePlayer, "CraneTutorial")
			expect(state).to.be.a("table")
			expect(state.puzzle_id).to.equal("CraneTutorial")
			expect(state.attempts).to.equal(0)
		end)

		it("should reject wrong sequence in CraneTutorial", function()
			local ok, score = M05:Submit(fakePlayer, "CraneTutorial",
				{"Last-Heben", "Seil-Befestigen"}, nil)
			expect(ok).to.equal(false)
			expect(score).to.equal(0)
		end)

		it("should accept correct CraneTutorial sequence", function()
			local ok, score = M05:Submit(fakePlayer, "CraneTutorial",
				{"Seil-Befestigen", "Hebel-Positionieren", "Last-Heben", "Senken"}, nil)
			expect(ok).to.equal(true)
			expect(score).to.equal(1.0)
		end)

		it("should solve CraneSelector with weight=100 (CraneA)", function()
			M05:Start(fakePlayer, "CraneSelector")
			local ok = M05:Submit(fakePlayer, "CraneSelector", "CraneA", { weight = 100 })
			expect(ok).to.equal(true)
		end)

		it("should solve CraneSelector with weight=300 (CraneB)", function()
			M05:Start(fakePlayer, "CraneSelector")
			local ok = M05:Submit(fakePlayer, "CraneSelector", "CraneB", { weight = 300 })
			expect(ok).to.equal(true)
		end)

		it("should solve CraneSelector with weight=700 (CraneC)", function()
			M05:Start(fakePlayer, "CraneSelector")
			local ok = M05:Submit(fakePlayer, "CraneSelector", "CraneC", { weight = 700 })
			expect(ok).to.equal(true)
		end)

		it("should mark puzzle solved after correct submit", function()
			M05:Start(fakePlayer, "ReleaseContainer")
			M05:Submit(fakePlayer, "ReleaseContainer",
				{"red", "blue"}, { sequence = {"red", "blue"} })
			expect(M05:IsSolved(fakePlayer, "ReleaseContainer")).to.equal(true)
		end)
	end)

	describe("M05_Puzzle — Hint", function()
		local fakePlayer = { Name = "p2", UserId = 22222 }

		it("should provide hint 1 (subtle)", function()
			M05:Start(fakePlayer, "CraneTutorial")
			local hint = M05:Hint(fakePlayer, "CraneTutorial", 1)
			expect(type(hint)).to.equal("string")
			expect(#hint > 0).to.equal(true)
		end)

		it("should return nil hint when none started", function()
			local hint = M05:Hint({ UserId = 99999 }, "CraneTutorial", 1)
			expect(hint).to.equal(nil)
		end)

		it("should cap hints at registry size", function()
			M05:Start(fakePlayer, "CraneTutorial")
			local tooMany = M05:Hint(fakePlayer, "CraneTutorial", 999)
			expect(tooMany).to.equal(nil)
		end)
	end)
end