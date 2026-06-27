--!strict
--[[
	M03_Dialogue.spec.lua — Tests für M03 Dialogue Engine
]]

return function()
	local M03 = require(script.Parent.Parent.Modules.M03_Dialogue)

	describe("M03_Dialogue — Registry", function()
		it("should expose Registry with dialogues", function()
			expect(type(M03.Registry)).to.equal("table")
			expect(#M03.Registry > 0).to.equal(true)
		end)

		it("should include hafenwirtin_greeting", function()
			expect(M03.Registry["hafenwirtin_greeting"] ~= nil).to.equal(true)
		end)

		it("should have npc_id set on each dialogue", function()
			for id, d in pairs(M03.Registry) do
				expect(d.npc_id).to.be.a("string")
				expect(type(d.lines)).to.equal("table")
				expect(#d.lines >= 1).to.equal(true)
			end
		end)

		it("should have localized text_keys in lines", function()
			for _, d in pairs(M03.Registry) do
				for _, line in ipairs(d.lines) do
					expect(type(line.text_key)).to.equal("string")
					expect(#line.text_key > 0).to.equal(true)
				end
			end
		end)

		it("should have options with next_dialogue or triggers", function()
			for _, d in pairs(M03.Registry) do
				if d.options then
					for _, opt in ipairs(d.options) do
						expect(type(opt.text_key)).to.equal("string")
						local hasNext = opt.next_dialogue ~= nil
						local hasTrig = opt.triggers ~= nil
						expect(hasNext or hasTrig).to.equal(true)
					end
				end
			end
		end)
	end)

	describe("M03_Dialogue — Start", function()
		it("should reject unknown dialogue id", function()
			local fakePlayer = { Name = "test" }
			local ok = M03:Start(fakePlayer, "nonexistent_dialogue")
			expect(ok).to.equal(false)
		end)

		it("should return false for nil player (defensive)", function()
			local ok = M03:Start(nil :: any, "hafenwirtin_greeting")
			expect(ok).to.equal(false)
		end)
	end)

	describe("M03_Dialogue — End / PullEvents", function()
		it("should return empty events for unknown player", function()
			local events = M03:PullEvents({ Name = "newplayer" })
			expect(type(events)).to.equal("table")
			expect(#events).to.equal(0)
		end)
	end)
end