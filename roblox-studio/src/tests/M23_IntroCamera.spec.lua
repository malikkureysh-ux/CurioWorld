--!strict
--!nolint
--[[
	M23_IntroCamera.spec.lua — TestEZ-Specs für die Cinematic Intro Camera
	======================================================================

	Tests:
	- CameraPath hat genau 5 Waypoints mit Time + CFrame
	- AutoPlayOnJoin existiert
]]

return function()
	local M23 = require(script.Parent.Parent.Modules.M23_IntroCamera)

	describe("M23_IntroCamera.CameraPath", function()
		it("contains exactly 5 waypoints", function()
			assert(type(M23.CameraPath) == "table", "CameraPath must be a table")
			assert(#M23.CameraPath == 5,
				"Expected 5 waypoints, got " .. #M23.CameraPath)
		end)

		it("each waypoint has Time (0..1) + CFrame", function()
			for i, wp in ipairs(M23.CameraPath) do
				assert(type(wp.Time) == "number",
					"Waypoint " .. i .. " missing Time")
				assert(wp.Time >= 0 and wp.Time <= 1,
					"Waypoint " .. i .. " Time must be in [0,1], got " .. tostring(wp.Time))
				assert(typeof(wp.CFrame) == "CFrame",
					"Waypoint " .. i .. " missing CFrame")
			end
		end)

		it("waypoints are sorted by ascending Time", function()
			local prev = -1
			for i, wp in ipairs(M23.CameraPath) do
				assert(wp.Time > prev,
					"Waypoint " .. i .. " Time " .. tostring(wp.Time)
					.. " not greater than previous " .. tostring(prev))
				prev = wp.Time
			end
		end)
	end)

	describe("M23_IntroCamera Config", function()
		it("defines Duration as positive number", function()
			assert(type(M23.Config.Duration) == "number")
			assert(M23.Config.Duration > 0, "Duration must be > 0")
		end)

		it("exposes Skippable boolean", function()
			assert(type(M23.Config.Skippable) == "boolean")
		end)

		it("uses Easing (not Linear) for cinematic feel", function()
			assert(type(M23.Config.EasingStyle) == "EnumItem",
				"EasingStyle must be EnumItem")
			assert(M23.Config.EasingStyle ~= Enum.EasingStyle.Linear,
				"Linear easing is not cinematic — should use Sine/Quad/Cubic")
		end)
	end)

	describe("M23_IntroCamera Public API", function()
		it("exposes AutoPlayOnJoin as a function", function()
			assert(type(M23.AutoPlayOnJoin) == "function",
				"AutoPlayOnJoin must be a function")
		end)

		it("exposes Play as a function", function()
			assert(type(M23.Play) == "function")
		end)
	end)
end