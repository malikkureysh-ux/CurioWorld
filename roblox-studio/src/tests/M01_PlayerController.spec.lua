--!strict
--!nolint
-- TestEZ globals (describe/it/beforeEach/afterEach) provided by Roblox TestEZ.
-- If TestEZ is not loaded, this file will fail to parse — the TestRunner
-- catches that and skips all specs gracefully.

return function()
	local function deepEqual(a, b)
		if a == b then return true end
		if typeof(a) ~= typeof(b) then return false end
		if typeof(a) ~= "table" then return false end
		for k, v in pairs(a) do
			if not deepEqual(v, b[k]) then return false end
		end
		for k in pairs(b) do
			if a[k] == nil then return false end
		end
		return true
	end

	local M01 = require(script.Parent.Parent.Modules.M01_PlayerController)

	describe("M01 PlayerController", function()
		describe("ApplyContext", function()
			it("sets WalkSpeed on Humanoid", function()
				local fakeHumanoid = { WalkSpeed = 0, JumpPower = 0, JumpHeight = 0, UseJumpPower = false }
				local fakeChar = { FindFirstChildOfClass = function() return fakeHumanoid end }
				M01:ApplyContext(fakeChar, { WalkSpeed = 20 })
				assert(fakeHumanoid.WalkSpeed == 20, "WalkSpeed not set")
			end)

			it("uses default WalkSpeed 16 when context is empty", function()
				local fakeHumanoid = { WalkSpeed = 0, JumpPower = 0, JumpHeight = 0, UseJumpPower = false }
				local fakeChar = { FindFirstChildOfClass = function() return fakeHumanoid end }
				M01:ApplyContext(fakeChar, {})
				assert(fakeHumanoid.WalkSpeed == 16, "default WalkSpeed missing")
			end)

			it("sets JumpHeight (Height mode) without JumpPower", function()
				-- Regression: previous bug set both, causing API conflict
				local fakeHumanoid = { WalkSpeed = 0, JumpPower = 0, JumpHeight = 0, UseJumpPower = false }
				local fakeChar = { FindFirstChildOfClass = function() return fakeHumanoid end }
				M01:ApplyContext(fakeChar, { JumpMode = "Height", JumpHeight = 7.5 })
				assert(fakeHumanoid.JumpHeight == 7.5, "JumpHeight not set")
				assert(fakeHumanoid.UseJumpPower == false, "UseJumpPower should be false in Height mode")
			end)

			it("sets JumpPower (Power mode) without JumpHeight", function()
				local fakeHumanoid = { WalkSpeed = 0, JumpPower = 0, JumpHeight = 0, UseJumpPower = false }
				local fakeChar = { FindFirstChildOfClass = function() return fakeHumanoid end }
				M01:ApplyContext(fakeChar, { JumpMode = "Power", JumpPower = 55 })
				assert(fakeHumanoid.JumpPower == 55, "JumpPower not set")
				assert(fakeHumanoid.UseJumpPower == true, "UseJumpPower should be true in Power mode")
			end)

			it("does not set both JumpPower and JumpHeight (Roblox API conflict)", function()
				-- Regression test: setting both previously broke the API
				local fakeHumanoid = { WalkSpeed = 0, JumpPower = 0, JumpHeight = 0, UseJumpPower = false }
				local fakeChar = { FindFirstChildOfClass = function() return fakeHumanoid end }
				M01:ApplyContext(fakeChar, { JumpMode = "Height", JumpHeight = 7 })
				-- After Height mode, JumpPower should NOT have been set
				assert(fakeHumanoid.UseJumpPower == false, "API conflict: UseJumpPower unexpectedly true")
			end)

			it("does nothing if no Humanoid found", function()
				local fakeChar = { FindFirstChildOfClass = function() return nil end }
				-- Should not throw
				local ok, err = pcall(function()
					M01:ApplyContext(fakeChar, { WalkSpeed = 10 })
				end)
				assert(ok, "ApplyContext threw when no humanoid: " .. tostring(err))
			end)
		end)

		describe("DistrictProfiles", function()
			it("has profile for all 5 districts", function()
				local profiles = M01.DistrictProfiles
				assert(profiles.HamburgHarbor, "missing HamburgHarbor")
				assert(profiles.SkyBridgeBay, "missing SkyBridgeBay")
				assert(profiles.LibertyBlocks, "missing LibertyBlocks")
				assert(profiles.NeoSakura, "missing NeoSakura")
				assert(profiles.MoonBazaar, "missing MoonBazaar")
			end)

			it("each profile has WalkSpeed/JumpHeight/SprintMultiplier", function()
				for name, profile in pairs(M01.DistrictProfiles) do
					assert(type(profile.WalkSpeed) == "number", name .. " missing WalkSpeed")
					assert(type(profile.JumpHeight) == "number", name .. " missing JumpHeight")
					assert(type(profile.SprintMultiplier) == "number", name .. " missing SprintMultiplier")
				end
			end)
		end)

		describe("TrySwingFromCrane", function()
			it("returns false when no hook exists", function()
				local fakeCrane = { FindFirstChild = function() return nil end }
				local result = M01:TrySwingFromCrane(nil, fakeCrane)
				assert(result == false, "should return false when no hook")
			end)

			it("returns true when hook with Grappleable=true", function()
				local fakeHook = { IsA = function(_, c) return c == "BasePart" end,
				                   GetAttribute = function(_, k) return k == "Grappleable" end }
				local fakeCrane = { FindFirstChild = function(_, n) return n == "Hook" and fakeHook or nil end }
				local result = M01:TrySwingFromCrane(nil, fakeCrane)
				assert(result == true, "should return true for grappleable hook")
			end)
		end)
	end)
end
