--!strict
--[[
	SoundController.client.lua — Volume-Propagation + Sound-Effects
	=================================================================

	User Story:
	  Als Spieler:in möchte ich, dass die in M24 eingestellten
	  Volume-Slider (Master/Music/SFX) live auf alle Sounds
	  angewendet werden, damit ich mein Audio-Erlebnis anpassen kann.

	Architektur:
	  M24.OnSave() (Server) → SaveService → DataStore
	  Bootstrap.server → SaveService:LoadSettings() → M24.Defaults
	  Dieser Controller liest M24.Defaults und propagiert zu SoundService
]]

local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Log = require(ReplicatedStorage.Shared.Util.Log)
local M24_Settings = require(ReplicatedStorage.Shared.Modules.M24_Settings)

local SoundController = {}

-- Cached Volume-Settings (sync mit M24.Defaults)
local currentVolumes = {
	Master = M24_Settings.Defaults.VolumeMaster or 1.0,
	Music = M24_Settings.Defaults.VolumeMusic or 0.5,
	SFX = M24_Settings.Defaults.VolumeSFX or 0.7,
}

-- Effektive Volume-Berechnung (Master × Category)
local function getEffectiveVolume(category: string): number
	local master = currentVolumes.Master
	local cat = if category == "music" then currentVolumes.Music
		elseif category == "sfx" then currentVolumes.SFX
		else 1.0
	return math.clamp(master * cat, 0, 1)
end

-- Apply zu allen Sounds der angegebenen Kategorie
local function applyVolumesToCategory(category: string)
	local targetVolume = getEffectiveVolume(category)
	-- Sound-Kategorien werden via Parent-Group erkannt:
	-- - "Music": Sounds im "Music" Ordner oder mit Name-Suffix "_music"
	-- - "SFX": Alle anderen
	-- - "Master": alle Sounds (wenn Master 0 → alles stumm)
	for _, sound in ipairs(SoundService:GetDescendants()) do
		if sound:IsA("Sound") then
			local isMusic = sound.Parent and sound.Parent.Name == "Music"
				or (sound.Name:lower():find("ambient")
					or sound.Name:lower():find("music"))
			local soundCat = isMusic and "music" or "sfx"
			if category == "master" or soundCat == category then
				sound.Volume = sound.Volume * targetVolume -- nicht kumulativ
			end
		end
	end
end

local function applyAllVolumes()
	-- Reset-Basis: alle Sounds auf ihre "natürliche" Volume (1.0 falls Custom)
	-- Dann multiplizieren mit aktueller effektiver Volume
	for _, sound in ipairs(SoundService:GetDescendants()) do
		if sound:IsA("Sound") then
			-- Skip wenn Sound eine eigene "baseVolume" gesetzt hat (z.B. Ambient_Hafen = 0.3)
			local baseVol = sound:GetAttribute("BaseVolume")
			if not baseVol then
				sound:SetAttribute("BaseVolume", sound.Volume)
				baseVol = sound.Volume
			end
			local isMusic = sound.Parent and sound.Parent.Name == "Music"
				or (sound.Name:lower():find("ambient") ~= nil)
			local cat = isMusic and "Music" or "SFX"
			local effective = getEffectiveVolume(cat:lower())
			sound.Volume = baseVol * effective
		end
	end
end

-- ============================================================
-- Public API
-- ============================================================

function SoundController:Init()
	-- Initiale Volume anwenden
	task.defer(function()
		applyAllVolumes()
		Log:Info("[SoundController] Initial volume applied",
			{ Master = currentVolumes.Master,
			  Music = currentVolumes.Music,
			  SFX = currentVolumes.SFX })
	end)

	-- M24.OnSave hook (live-apply bei Settings-Änderung)
	local originalSave = M24_Settings.OnSave
	M24_Settings.OnSave = function(player, key, value)
		-- Original-Callback aufrufen (persistieren etc.)
		if originalSave then
			originalSave(player, key, value)
		end

		-- Volume-Keys live anwenden
		if key == "VolumeMaster" and type(value) == "number" then
			currentVolumes.Master = math.clamp(value, 0, 1)
			applyAllVolumes()
			Log:Info("[SoundController] Master volume → " .. tostring(value))
		elseif key == "VolumeMusic" and type(value) == "number" then
			currentVolumes.Music = math.clamp(value, 0, 1)
			applyAllVolumes()
		elseif key == "VolumeSFX" and type(value) == "number" then
			currentVolumes.SFX = math.clamp(value, 0, 1)
			applyAllVolumes()
		end
	end

	Log:Info("[SoundController] Initialized — live volume propagation enabled")
end

-- Helper: Play a one-shot SFX
function SoundController:PlaySfx(soundName: string, volume: number?)
	if not soundName then return end
	local sfx = SoundService:FindFirstChild(soundName)
	if sfx and sfx:IsA("Sound") then
		local baseVol = sfx:GetAttribute("BaseVolume") or sfx.Volume
		sfx.Volume = baseVol * getEffectiveVolume("sfx") * (volume or 1)
		sfx:Play()
	end
end

function SoundController:PlayMusic(musicName: string)
	if not musicName then return end
	local music = SoundService:FindFirstChild(musicName)
	if music and music:IsA("Sound") then
		local baseVol = music:GetAttribute("BaseVolume") or music.Volume
		music.Volume = baseVol * getEffectiveVolume("music")
		music.Looped = true
		music:Play()
	end
end

return SoundController