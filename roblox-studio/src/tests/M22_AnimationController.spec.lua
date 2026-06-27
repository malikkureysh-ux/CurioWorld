--!strict
--!nolint
--[[
	M22_AnimationController.spec.lua — TestEZ-Specs für NPC/Kran-Animationen
	=======================================================================

	Tests:
	- Init existiert
	- PlayNpcIdle/PlayKranSwing/PlayBoatRow existieren als Funktionen
]]

return function()
	local M22 = require(script.Parent.Parent.Modules.M22_AnimationController)

	describe("M22_AnimationController Public API", function()
		it("exposes Init as a function", function()
			assert(type(M22.Init) == "function",
				"Init must be a function")
		end)

		it("exposes PlayNpcIdle as a function", function()
			assert(type(M22.PlayNpcIdle) == "function",
				"PlayNpcIdle must be a function")
		end)

		it("exposes PlayKranSwing as a function", function()
			assert(type(M22.PlayKranSwing) == "function",
				"PlayKranSwing must be a function")
		end)

		it("exposes PlayBoatRow as a function", function()
			assert(type(M22.PlayBoatRow) == "function",
				"PlayBoatRow must be a function")
		end)
	end)

	describe("M22_AnimationController Safety", function()
		local fakePlayer
		beforeEach(function()
			fakePlayer = {
				Name = "test_player",
				UserId = 12345,
				FindFirstChild = function() return nil end,
			}
		end)

		it("PlayNpcIdle no-ops on Model without Humanoid", function()
			local dummy = Instance.new("Model")
			dummy.Name = "DummyNpc"
			local ok, err = pcall(function() M22:PlayNpcIdle(dummy) end)
			dummy:Destroy()
			assert(ok, "PlayNpcIdle must not error on empty Model: " .. tostring(err))
		end)

		it("PlayKranSwing returns false on Model without Humanoid", function()
			local dummy = Instance.new("Model")
			dummy.Name = "DummyChar"
			local result
			local ok = pcall(function()
				result = M22:PlayKranSwing(dummy)
			end)
			dummy:Destroy()
			assert(ok, "PlayKranSwing must not error")
			assert(result == false, "Should return false when no Humanoid")
		end)

		it("Init handles missing AssetDefinitions gracefully", function()
			local ok, err = pcall(function() M22:Init() end)
			assert(ok, "Init must not error on missing AssetDefinitions: " .. tostring(err))
		end)
	end)
end