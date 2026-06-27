--!strict
--[[
	Bootstrap.client.lua — Client Bootstrap (FINAL)
	================================================

	Sets up client-side controllers:
	- Language auto-detect (M15)
	- HUD initial wallet sync
	- QuestDetailController (consumes QuestDetailRemote)
	- SoundController (live volume propagation from M24)
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Utilities + Localization
local Log = require(ReplicatedStorage.Shared.Util.Log)
local ServiceRegistry = require(ReplicatedStorage.Shared.Util.ServiceRegistry)
local M15_Localization = require(ReplicatedStorage.Shared.Modules.M15_Localization)

-- Setup player language from locale
local function setupLanguage(): string
	local player = Players.LocalPlayer
	local lang = M15_Localization:GuessFromLocale(player)
	M15_Localization:Set(player, lang)
	return lang
end

-- HUD setup — wait for EconomyService then show initial balance
local function setupHud()
	local player = Players.LocalPlayer
	local economy = ServiceRegistry:WaitFor("Economy", 30)
	if not economy then
		Log:Warn("EconomyService not available after 30s timeout, HUD will retry on first server event")
		return
	end

	if type(economy) ~= "table" and type(economy) ~= "userdata" then
		Log:Warn("EconomyService registered but is not callable:", typeof(economy))
		return
	end

	local wallet = economy:GetBalance(player)
	if wallet then
		Log:Info("Wallet loaded:", wallet)
	else
		Log:Warn("Wallet is nil after GetBalance (should not happen)")
	end
end

-- ============================================================
-- Controller-Init (parallelisiert)
-- ============================================================

local QuestDetailController = require(
	script.Parent.Controllers.QuestDetailController)
local SoundController = require(
	script.Parent.Controllers.SoundController)

-- Bootstrap
local lang = setupLanguage()
Log:Info("Client started. Language:", lang)

if game:GetService("RunService"):IsStudio() then
	Log:SetLevel("Debug")
end

task.spawn(setupHud)

-- Controllers init (Client-only, kein Race mit Server)
QuestDetailController:Init(Players.LocalPlayer)
SoundController:Init()