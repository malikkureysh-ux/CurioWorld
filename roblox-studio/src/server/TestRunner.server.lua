--!strict
--[[
	TestRunner.server.lua — TestEZ Bootstrap
	========================================

	Runs all TestEZ specs in the project. Place in ServerScriptService.
	Tests will run automatically when the game starts in Studio / on a test server.

	How to run:
	- Place this script under ServerScriptService (auto via default.project.json).
	- Hit "Play" in Studio. The TestEZ output will appear in the console.
	- On a live server, tests run on startup; failures log to the output.

	Source layout:
	- roblox-studio/src/tests/*.spec.lua
]]

-- TestEZ is bundled with the project via Wally (see tooling/wally.toml).
-- If TestEZ is not available, log a clear error and exit gracefully.
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TestEZ
local ok, err = pcall(function()
	-- TestEZ exposes itself as a global when loaded as a side effect
	TestEZ = require(ReplicatedStorage.Packages.TestEZ)
end)

if not ok then
	warn("[TestRunner] TestEZ not found. Add roblox/testez via Wally or place TestEZ at ReplicatedStorage.Packages.TestEZ")
	return
end

-- Discover all test specs in the project
-- We use a sub-folder approach: tests live under ReplicatedStorage.Shared.Tests.
-- The spec files use `require(ReplicatedStorage.Shared.Modules.X)` to access the
-- modules under test.
local TestBootstrap = TestEZ.TestBootstrap

-- Collect all ModuleScripts under Shared.Tests (if it exists)
local testFolder = ReplicatedStorage:FindFirstChild("Shared")
	and ReplicatedStorage.Shared:FindFirstChild("Tests")
local specs = {}
if testFolder then
	for _, child in ipairs(testFolder:GetChildren()) do
		if child:IsA("ModuleScript") and string.match(child.Name, "%.spec$") then
			table.insert(specs, child)
		end
	end
end

local results
if #specs > 0 then
	results = TestBootstrap:Run(specs)
else
	warn("[TestRunner] No test specs found at ReplicatedStorage.Shared.Tests")
	return
end

-- Print summary
print(string.format("[TestRunner] Tests complete: %d passed, %d failed (of %d total)",
	results.passedCount or 0,
	results.failedCount or 0,
	results.testCount or 0
))

if (results.failedCount or 0) > 0 then
	warn("[TestRunner] FAILURES DETECTED — see above for details")
end