--!strict
--[[
	Bootstrap.server.lua — Server Bootstrap (FINAL)
	================================================

	Bootstraps the server-side services + UI + NPCs + Sounds in dependency order:

	1. Map-Validate + Build (must succeed before anything else)
	2. NPC-Spawn (after Map, before UI)
	3. Services register themselves
	4. UI-Controllers spawned for each player on join
	5. Sound-Controllers started

	Failures abort with error() (Fail-Loud-Strategy).
]]

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")

local Log = require(ReplicatedStorage.Shared.Util.Log)
local ServiceRegistry = require(ReplicatedStorage.Shared.Util.ServiceRegistry)
local MapBuilder = require(ReplicatedStorage.Shared.Modules.MapBuilder)
local M16_NpcSpawner = require(ReplicatedStorage.Shared.Modules.M16_NpcSpawner)

-- ============================================================
-- 1. Map-Validate + Build
-- ============================================================

local HamburgHarborData = require(ReplicatedStorage.Shared.Data.hamburg_harbor_map)

if game:GetService("RunService"):IsStudio() then
	Log:SetLevel("Debug")
end

local valid, errors = MapBuilder:Validate(HamburgHarborData)
if not valid then
	Log:Error("Map validation failed:")
	for _, err in ipairs(errors) do
		Log:Error("  - " .. err)
	end
	error("Map data invalid — see logs above")
end

local harborContainer = Workspace:FindFirstChild("Districts")
    and Workspace.Districts:FindFirstChild("HamburgHarbor")

if harborContainer then
	MapBuilder:BuildInto(HamburgHarborData, harborContainer)
else
	Log:Warn("Workspace.Districts.HamburgHarbor not found — skipping map build")
end

-- ============================================================
-- 2. Domain-Services (register BEFORE NPC-Spawn so NPCs can query them)
-- ============================================================

local TelemetryService = require(ServerScriptService.Services.TelemetryService)
local SaveService       = require(ServerScriptService.Services.SaveService)
local EconomyService    = require(ServerScriptService.Services.EconomyService)

ServiceRegistry:Register("Telemetry", TelemetryService)
ServiceRegistry:Register("Save", SaveService)
ServiceRegistry:Register("Economy", EconomyService)

-- ============================================================
-- 3. NPC-Spawn (uses Map + emits ProximityPrompts for UI-Trigger)
-- ============================================================

M16_NpcSpawner:RegisterService()
if harborContainer then
	local spawnedNpcs = M16_NpcSpawner:SpawnAll(Workspace.Districts)
	local count = 0
	for _ in pairs(spawnedNpcs) do count += 1 end
	Log:Info(("NPCs gespawnt: %d"):format(count))
end

-- ============================================================
-- 4. UI-Controllers: HUD + QuestTracker spawn on PlayerAdded
-- ============================================================

local M17_HUD = require(ReplicatedStorage.Shared.Modules.M17_HUD)
local M19_QuestTracker = require(ReplicatedStorage.Shared.Modules.M19_QuestTracker)

local function onPlayerAdded(player: Player)
	-- HUD
	local hud = M17_HUD:CreateForPlayer(player)
	-- Initial-Currency aus EconomyService
	pcall(function()
		local economy = ServiceRegistry:Get("Economy")
		if economy and economy.GetBalance then
			local bal = economy:GetBalance(player)
			if bal then
				M17_HUD:UpdateCurrency(hud, "Gold", bal.gold or 0)
				M17_HUD:UpdateCurrency(hud, "Gems", bal.gems or 0)
				if bal.vipActive then
					M17_HUD:SetVIP(hud, true)
				end
			end
		end
	end)
	M17_HUD:SetDistrict(hud, "HamburgHarbor")

	-- QuestTracker
	M19_QuestTracker:CreateForPlayer(player)
	M19_QuestTracker:Update(player, {})

	-- Sound: Auto-Play Ambient wenn Studio / Test-Server läuft
	spawn(function()
		if game:GetService("RunService"):IsStudio() then
			local ambient = SoundService:FindFirstChild("Ambient_Hafen")
			if ambient and ambient:IsA("Sound") then
				ambient.Looped = true
				ambient.Volume = 0.3
				ambient:Play()
				Log:Info("Ambient_Hafen gestartet (Studio)")
			end
		end
	end)

	Log:Info("[Bootstrap] UI created for " .. player.Name)
end

Players.PlayerAdded:Connect(onPlayerAdded)
for _, existingPlayer in ipairs(Players:GetPlayers()) do
	task.spawn(onPlayerAdded, existingPlayer)
end

Log:Info("Server started. Services registered:", ServiceRegistry:List())
