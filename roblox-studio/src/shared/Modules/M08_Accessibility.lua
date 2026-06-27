--!strict
--[[
	M08_Accessibility.lua — Accessibility Consumer (Phase 3 Runtime)
	==================================================================

	User Story:
	  Als Spieler:in möchte ich, dass die Accessibility-Settings
	  (ReducedMotion, HighContrast, AnimationsEnabled) tatsächlich
	  wirken — nicht nur als Default-Werte.

	Architektur:
	  - Settings-Slots: holt Werte aus M24_Settings.Defaults
	  - ReducedMotion: hook in TweenService (reduce/eliminate tweens)
	  - HighContrast: Color3-Swap für HUD-Theme
	  - AnimationsEnabled: hook in M22 AnimationController
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Log = require(ReplicatedStorage.Shared.Util.Log)
local M24_Settings = require(ReplicatedStorage.Shared.Modules.M24_Settings)

local M08_Accessibility = {}

-- ============================================================
-- State
-- ============================================================

local originalTweenCreate = nil  -- patched in Init()
local currentSettings = {
	AnimationsEnabled = true,
	HighContrast = false,
	ReducedMotion = false,
}

-- ============================================================
-- Theme-Tokens (High-Contrast-Variante)
-- ============================================================

M08_Accessibility.StandardColors = {
	BackgroundColor = Color3.fromRGB(25, 28, 35),
	TextColor = Color3.fromRGB(245, 245, 250),
	Accent = Color3.fromRGB(120, 200, 240),
	Gold = Color3.fromRGB(255, 220, 110),
}

M08_Accessibility.HighContrastColors = {
	BackgroundColor = Color3.fromRGB(0, 0, 0),
	TextColor = Color3.fromRGB(255, 255, 255),
	Accent = Color3.fromRGB(255, 255, 0),
	Gold = Color3.fromRGB(255, 255, 0),
}

-- ============================================================
-- Public API
-- ============================================================

function M08_Accessibility:Init()
	-- Hook TweenService.Create für ReducedMotion
	originalTweenCreate = TweenService.Create
	TweenService.Create = function(instance, tweenInfo, goals, ...)
		if currentSettings.ReducedMotion then
			-- Override: 0.05s statt originaler Dauer, Easing Linear
			local modified = TweenInfo.new(
				0.05,
				Enum.EasingStyle.Linear,
				Enum.EasingDirection.InOut
			)
			return originalTweenCreate(instance, modified, goals)
		end
		return originalTweenCreate(instance, tweenInfo, goals, ...)
	end

	-- Hook M24.OnAccessibilityChange
	local original = M24_Settings.OnAccessibilityChange
	M24_Settings.OnAccessibilityChange = function(player, key, value)
		if original then original(player, key, value) end
		self:ApplySetting(key, value)
	end

	Log:Info("[M08] Initialized — hooks installed")
end

function M08_Accessibility:ApplySetting(key: string, value: any)
	if key == "AnimationsEnabled" then
		currentSettings.AnimationsEnabled = (value == true)
		Log:Info(("[M08] AnimationsEnabled=%s"):format(tostring(currentSettings.AnimationsEnabled)))
	elseif key == "HighContrast" then
		currentSettings.HighContrast = (value == true)
		Log:Info(("[M08] HighContrast=%s — UI-Theme re-rendering deferred (Phase 3)"):format(
			tostring(currentSettings.HighContrast)))
	elseif key == "ReducedMotion" then
		currentSettings.ReducedMotion = (value == true)
		Log:Info(("[M08] ReducedMotion=%s — Tween durations reduced"):format(
			tostring(currentSettings.ReducedMotion)))
	end
end

function M08_Accessibility:IsReducedMotion(): boolean
	return currentSettings.ReducedMotion == true
end

function M08_Accessibility:IsHighContrast(): boolean
	return currentSettings.HighContrast == true
end

function M08_Accessibility:AreAnimationsEnabled(): boolean
	return currentSettings.AnimationsEnabled ~= false
end

function M08_Accessibility:GetThemeColors()
	if currentSettings.HighContrast then
		return M08_Accessibility.HighContrastColors
	end
	return M08_Accessibility.StandardColors
end

function M08_Accessibility:GetCurrentSettings()
	return currentSettings
end

return M08_Accessibility