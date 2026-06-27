--!strict
--[[
	init.server.lua — Server Bootstrap
	==================================

	Bootstraps the server-side services in dependency order:
	1. Log + ServiceRegistry + MapBuilder — utility infrastructure
	2. TelemetryService — first, so other services can track
	3. SaveService — before everything that persists data
	4. EconomyService — depends on Save + Telemetry
	5. (Phase 3+ services register here)

	Map-Building:
	- Liest hamburg_harbor_map.lua und baut die Hierarchie im Workspace.
	- Validierung läuft zuerst; bei Fehlern wird der Build abgebrochen.
]]

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Utilities
local Log = require(ReplicatedStorage.Shared.Util.Log)
local ServiceRegistry = require(ReplicatedStorage.Shared.Util.ServiceRegistry)
local MapBuilder = require(ReplicatedStorage.Shared.Modules.MapBuilder)

-- Map data
local HamburgHarborData = require(ReplicatedStorage.Shared.Data.hamburg_harbor_map)

-- In Studio, enable Debug logging for visible feedback
if game:GetService("RunService"):IsStudio() then
	Log:SetLevel("Debug")
end

-- Validate map data BEFORE building
local valid, errors = MapBuilder:Validate(HamburgHarborData)
if not valid then
	Log:Error("Map validation failed:")
	for _, err in ipairs(errors) do
		Log:Error("  - " .. err)
	end
	error("Map data invalid — see logs above")
end

-- Build Hamburg Harbor map into Workspace
local harborContainer = Workspace:FindFirstChild("Districts")
	and Workspace.Districts:FindFirstChild("HamburgHarbor")

if harborContainer then
	MapBuilder:BuildInto(HamburgHarborData, harborContainer)
else
	Log:Warn("Workspace.Districts.HamburgHarbor not found — skipping map build")
end

-- Domain services (require in dependency order)
local TelemetryService = require(ServerScriptService.Services.TelemetryService)
local SaveService       = require(ServerScriptService.Services.SaveService)
local EconomyService    = require(ServerScriptService.Services.EconomyService)

-- Register all services
ServiceRegistry:Register("Telemetry", TelemetryService)
ServiceRegistry:Register("Save", SaveService)
ServiceRegistry:Register("Economy", EconomyService)

-- NPC Spawn-System (Phase 2 audit fix)
local NpcSpawner = require(ReplicatedStorage.Shared.Modules.M16_NpcSpawner)
NpcSpawner:RegisterService()
if harborContainer then
    local spawnedNpcs = NpcSpawner:SpawnAll(Workspace.Districts)
    local count = 0
    for _ in pairs(spawnedNpcs) do count += 1 end
    Log:Info(("NPCs gespawnt: %d"):format(count))
end

Log:Info("Server started. Services registered:", ServiceRegistry:List())