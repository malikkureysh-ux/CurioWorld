--!strict
--[[
	Log.lua — Centralized logging (replaces _G.CURIO_WORLD_DEBUG pattern)
	====================================================================

	Selene-idiomatic way to gate debug output without using `_G` globals.

	Usage:
		local Log = require(Shared.Util.Log)
		Log:Debug("Server started")
		Log:Info("Player joined:", player.Name)
		Log:Warn("Deprecated API used")
		Log:Error("EconomyService not registered")

	Verbosity is controlled by SetLevel(); defaults to "Info".
]]

local Log = {}

export type Level = "Debug" | "Info" | "Warn" | "Error" | "Off"
export type LevelValue = { Debug: number, Info: number, Warn: number, Error: number, Off: number }

Log.Levels = {
	Debug = 1,
	Info  = 2,
	Warn  = 3,
	Error = 4,
	Off   = 5,
} :: LevelValue

local currentLevel: number = Log.Levels.Info

-- ============================================================
-- Configuration
-- ============================================================

function Log:SetLevel(level: Level)
	currentLevel = self.Levels[level] or self.Levels.Info
end

function Log:GetLevel(): Level
	for name, value in pairs(self.Levels) do
		if value == currentLevel then
			return name :: Level
		end
	end
	return "Info"
end

-- ============================================================
-- Output methods
-- ============================================================

function Log:Debug(...: any)
	if currentLevel > self.Levels.Debug then return end
	print("[CurioWorld DEBUG]", ...)
end

function Log:Info(...: any)
	if currentLevel > self.Levels.Info then return end
	print("[CurioWorld INFO]", ...)
end

function Log:Warn(...: any)
	if currentLevel > self.Levels.Warn then return end
	warn("[CurioWorld WARN]", ...)
end

function Log:Error(...: any)
	if currentLevel > self.Levels.Error then return end
	warn("[CurioWorld ERROR]", ...)
end

return Log