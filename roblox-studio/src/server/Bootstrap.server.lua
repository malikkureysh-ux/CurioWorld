--!strict
--[[
	Bootstrap.server.lua — Server Bootstrap (FINAL)
	================================================

	Bootstraps the server-side services + UI + NPCs + Sounds in dependency order:

	1. Map-Validate + Build (must succeed before anything else)
	2. NPC-Spawn (after Map, before UI)
	3. Services register themselves
	4. UI-Controllers spawned for each player on join
	5. Server-side callback wiring (M17/M19/M20/M24 → EconomyService/SaveService)
	6. Sound-Controllers started

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
local QuestService      = require(ServerScriptService.Services.QuestService)
local QuestVisibilityService = require(ServerScriptService.Services.QuestVisibilityService)
local M14_Parental      = require(ServerScriptService.Services.M14_Parental)
local MapInteractionService = require(ServerScriptService.Services.MapInteractionService)

ServiceRegistry:Register("Telemetry", TelemetryService)
ServiceRegistry:Register("Save", SaveService)
ServiceRegistry:Register("Economy", EconomyService)
ServiceRegistry:Register("Quest", QuestService)
ServiceRegistry:Register("QuestVisibility", QuestVisibilityService)
ServiceRegistry:Register("Parental", M14_Parental)
ServiceRegistry:Register("MapInteraction", MapInteractionService)

-- M08 Accessibility (client+server shared) — init hook
pcall(function()
	local M08_Accessibility = require(ReplicatedStorage.Shared.Modules.M08_Accessibility)
	M08_Accessibility:Init()
end)

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

-- QuestService: auto-evaluate WorldServices alle 2s
QuestService:Init()

-- QuestVisibility: scan Map für Attribute (VisibleAfterQuest, QuestHook, MaterialType)
QuestVisibilityService:Init()

-- MapInteraction: hook alle ProximityPrompts (Workbench/QuestBoards/NPCs)
MapInteractionService:Init()

-- ============================================================
-- 4. UI-Controllers: HUD + QuestTracker spawn on PlayerAdded
-- ============================================================

local M17_HUD = require(ReplicatedStorage.Shared.Modules.M17_HUD)
local M18_Dialogue = require(ReplicatedStorage.Shared.Modules.M18_Dialogue)
local M19_QuestTracker = require(ReplicatedStorage.Shared.Modules.M19_QuestTracker)
local M20_Shop = require(ReplicatedStorage.Shared.Modules.M20_Shop)
local M24_Settings = require(ReplicatedStorage.Shared.Modules.M24_Settings)
local M02_Quest = require(ReplicatedStorage.Shared.Modules.M02_Quest)
local Localization = require(ReplicatedStorage.Shared.Modules.M15_Localization)
local M07_Economy = require(ReplicatedStorage.Shared.Modules.M07_Economy)

-- ============================================================
-- 5. Server-Side Callback-Wiring (UI → Services)
-- ============================================================

-- M20.Shop: PurchaseHandler → EconomyService:TryPurchase
M20_Shop.PurchaseHandler = function(player, itemId, item)
	Log:Info(("[M20.PurchaseHandler] %s versucht %s zu kaufen"):format(player.Name, itemId))
	-- item hat price_gold/price_robux (lowercase) → M07.ShopItem hat PriceGold/PriceRobux
	local shopItem = {
		Id = itemId,
		Category = "Cosmetic",  -- Default; später aus Item-Katalog
		PriceGold = item.price_gold,
		PriceGems = item.price_gems,
		PriceRobux = item.price_robux,
		VIPOnly = item.vip_only,
		ReleasedAt = 0,
	}
	return EconomyService:TryPurchase(player, shopItem)
end

-- M19.QuestTracker: OnQuestClicked + OnMoreClicked
-- Detail-Modal ist Phase 3 — wir loggen erstmal + senden Client ein "open detail"-Remote
local questDetailRemote = ReplicatedStorage:FindFirstChild("QuestDetailRemote")
if not questDetailRemote then
	questDetailRemote = Instance.new("RemoteEvent")
	questDetailRemote.Name = "QuestDetailRemote"
	questDetailRemote.Parent = ReplicatedStorage
end
M19_QuestTracker.OnQuestClicked = function(player, questId)
	Log:Info(("[M19.OnQuestClicked] %s clicked quest %s"):format(player.Name, questId))
	questDetailRemote:FireClient(player, questId, "show_detail")
end
M19_QuestTracker.OnMoreClicked = function(player, total)
	Log:Info(("[M19.OnMoreClicked] %s wants to see all %d quests"):format(player.Name, total))
	questDetailRemote:FireClient(player, nil, "show_all")
end

-- M24.Settings: OnSave → SaveService:SaveSettings (Live-Persistenz)
M24_Settings.OnSave = function(player, key, value)
	-- Server-Validation: nur bekannte Keys akzeptieren
	local allowed = {
		VolumeMaster = "number", VolumeMusic = "number", VolumeSFX = "number",
		Language = "string",
		AnimationsEnabled = "boolean", HighContrast = "boolean",
		ReducedMotion = "boolean", ChatEnabled = "boolean",
	}
	if not allowed[key] then
		Log:Warn(("[M24] Rejected settings key: %s"):format(key))
		return
	end
	if typeof(value) ~= allowed[key] then
		Log:Warn(("[M24] Type mismatch for %s: expected %s, got %s"):format(
			key, allowed[key], typeof(value)))
		return
	end
	SaveService:SaveSetting(player, key, value)
end

-- M24.Settings: OnLanguageChange → M15 Localization.Set + Telemetry
M24_Settings.OnLanguageChange = function(player, newLang)
	Localization:Set(player, newLang)
	TelemetryService:Track(player, "settings.language_changed", { new_lang = newLang })
end

-- M24.Settings: OnAccessibilityChange → Telemetry + Live-Apply (HUD/UI consumers)
M24_Settings.OnAccessibilityChange = function(player, key, value)
	TelemetryService:Track(player, "settings.accessibility_changed", {
		key = key, value = value,
	})
	-- Phase 3: hier HUD-Refresh, ReducedMotion-Tween-Reducer, HighContrast-Theme
end

-- ============================================================
-- 6. Per-Player UI Setup
-- ============================================================

local function onPlayerAdded(player: Player)
	-- HUD
	local hud = M17_HUD:CreateForPlayer(player)
	-- Initial-Currency aus EconomyService
	pcall(function()
		local economy = ServiceRegistry:Get("Economy")
		if economy and economy.GetBalance then
			local bal = economy:GetBalance(player)
			if bal then
				M17_HUD:UpdateCurrency(hud, "Gold", bal.Gold or bal.gold or 0)
				M17_HUD:UpdateCurrency(hud, "Gems", bal.Gems or bal.gems or 0)
				if bal.VIPActive or bal.vipActive then
					M17_HUD:SetVIP(hud, true)
				end
			end
		end
	end)
	M17_HUD:SetDistrict(hud, "HamburgHarbor")

	-- QuestTracker
	M19_QuestTracker:CreateForPlayer(player)
	M19_QuestTracker:Update(player, {})

	-- Settings: bei erstem Join laden und auf Defaults anwenden
	SaveService:LoadSettings(player, function(loadedSettings)
		if loadedSettings then
			for k, v in pairs(loadedSettings) do
				(M24_Settings.Defaults :: any)[k] = v
			end
			-- Language aus Settings → Localization übernehmen
			if loadedSettings.Language then
				Localization:Set(player, loadedSettings.Language)
			end
		end
	end)

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
