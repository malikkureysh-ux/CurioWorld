--!strict
--[[
	init.client.lua — Client Bootstrap
	===================================

	Sets up the client-side controllers and waits for server services to be ready.
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
		-- Defensive: do NOT call any method on a nil service
		-- The user can still play; HUD will retry via event later
		return
	end

	-- Type guard: WaitFor returns any? — verify before calling
	if type(economy) ~= "table" and type(economy) ~= "userdata" then
		Log:Warn("EconomyService registered but is not callable:", typeof(economy))
		return
	end

	-- Safe: GetBalance always returns a Wallet table
	local wallet = economy:GetBalance(player)
	if wallet then
		Log:Info("Wallet loaded:", wallet)
	else
		Log:Warn("Wallet is nil after GetBalance (should not happen)")
	end
	-- TODO Phase 3: roact-based HUD widgets
end

-- Bootstrap
local lang = setupLanguage()
Log:Info("Client started. Language:", lang)

if game:GetService("RunService"):IsStudio() then
	Log:SetLevel("Debug")
end

task.spawn(setupHud)