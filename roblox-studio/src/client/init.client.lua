--!strict
--[[
	init.client.lua — Client-Bootstrap
	===================================

	Lädt client-seitige Controller und richtet die Verbindung zum Server ein.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

-- Shared-Module
local M07_Economy      = require(ReplicatedStorage.Shared.Modules.M07_Economy)
local M15_Localization = require(ReplicatedStorage.Shared.Modules.M15_Localization)

-- Wait for services
local function waitForService(name: string, timeout: number): any
	local start = os.clock()
	while not _G.CurioWorld do
		if os.clock() - start > timeout then
			warn("[Client] Timeout waiting for services")
			return nil
		end
		task.wait(0.1)
	end
	return _G.CurioWorld.Services[name]
end

-- HUD-Setup (Skeleton; Phase 3 mit Roact-UI)
local function setupHud()
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	-- Beispiel: Welcome-Message anzeigen
	local EconomyService = waitForService("Economy")
	if EconomyService then
		local wallet = EconomyService:GetBalance(player)
		print("[Client] Wallet geladen:", wallet)
	end
end

-- Spieler-Sprache erraten und anwenden
local function setupLanguage()
	local player = Players.LocalPlayer
	local lang = M15_Localization:GuessFromLocale(player)
	M15_Localization:Set(player, lang)
	print("[Client] Sprache:", lang)
end

-- Boot
task.spawn(setupLanguage)
task.spawn(setupHud)

if _G.CURIO_WORLD_DEBUG then
	print("[CurioWorld] Client gestartet.")
end