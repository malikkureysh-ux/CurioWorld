--!strict
--[[
	M23_IntroCamera.lua — Cinematic Intro Camera
	==============================================

	User Story:
	  Als Spieler:in, der zum ersten Mal Hamburg Harbor betritt, möchte
	  ich eine kurze cinematische Kamerafahrt sehen, die über den Hafen
	  schwenkt, bevor mein Charakter spawnt, damit ich ein Gefühl für
	  die Welt bekomme.

	Premium-Anforderungen:
	- Kamera-Schwenk über 5-8 Sekunden
	- Easing-Funktion (kein linearer Schwenk)
	- Skip via Klick/Touch
	- Music-Begleitung (optional)
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local Log = require(ReplicatedStorage.Shared.Util.Log)

local M23_IntroCamera = {}

M23_IntroCamera.Config = {
	Duration = 6.0,
	StartPosition = CFrame.new(60, 35, 60),
	EndPosition = CFrame.new(0, 12, 25),
	StartLookAt = Vector3.new(0, 8, 0),
	EndLookAt = Vector3.new(-40, 5, 30),  -- Speicherhaus-Bereich
	EasingStyle = Enum.EasingStyle.Sine,
	EasingDirection = Enum.EasingDirection.InOut,
	Skippable = true,
}

-- ============================================================
-- Camera-Path Definition
-- ============================================================

-- Pfad-Punkte (CFrame) — vom weiten Überblick zum Detail
M23_IntroCamera.CameraPath = {
	{ Time = 0.00, CFrame = CFrame.new(80, 40, 80)
		 * CFrame.lookAt(Vector3.new(80, 40, 80), Vector3.new(0, 10, 0)) },
	{ Time = 0.25, CFrame = CFrame.new(50, 25, 50)
			* CFrame.lookAt(Vector3.new(50, 25, 50), Vector3.new(0, 10, 0)) },
	{ Time = 0.50, CFrame = CFrame.new(30, 18, 40)
			* CFrame.lookAt(Vector3.new(30, 18, 40), Vector3.new(-15, 8, 15)) },
	{ Time = 0.75, CFrame = CFrame.new(15, 14, 35)
			* CFrame.lookAt(Vector3.new(15, 14, 35), Vector3.new(-25, 8, 15)) },
	{ Time = 1.00, CFrame = CFrame.new(5, 10, 30)
			* CFrame.lookAt(Vector3.new(5, 10, 30), Vector3.new(-40, 6, 30)) },
}

-- ============================================================
-- Play Intro for Player
-- ============================================================

function M23_IntroCamera:Play(player: Player)
	if not player then return end
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	local camera = Workspace.CurrentCamera
	if not camera then return end

	-- Save original camera type
	local originalType = camera.CameraType
	local originalCFrame = camera.CFrame

	-- Lock camera + set to scriptable
	camera.CameraType = Enum.CameraType.Scriptable

	-- Animate via Tweens entlang Pfad
	local tweenInfos = {}
	for i = 1, #M23_IntroCamera.CameraPath do
		local duration = M23_IntroCamera.Config.Duration
			* (M23_IntroCamera.CameraPath[i].Time - (M23_IntroCamera.CameraPath[i - 1] and M23_IntroCamera.CameraPath[i - 1].Time or 0))
		local tweenInfo = TweenInfo.new(duration,
		                                M23_IntroCamera.Config.EasingStyle,
		                                M23_IntroCamera.Config.EasingDirection)
		local tween = TweenService:Create(camera, tweenInfo,
		                                { CFrame = M23_IntroCamera.CameraPath[i].CFrame })
		table.insert(tweenInfos, tween)
	end

	-- Sequentiell abspielen
	task.spawn(function()
		for _, tween in ipairs(tweenInfos) do
			tween:Play()
			tween.Completed:Wait()
		end

		-- Nach Intro: zurück zu Spieler-Kamera
		camera.CameraType = originalType
		Log:Info(("[M23] Intro complete für %s"):format(player.Name))
	end)

	-- Skip via Click
	if M23_IntroCamera.Config.Skippable then
		local conn
		conn = player:GetMouse().Button1Down:Connect(function()
			for _, tween in ipairs(tweenInfos) do
				tween:Cancel()
			end
			camera.CameraType = originalType
			conn:Disconnect()
			Log:Info(("[M23] Intro skipped für %s"):format(player.Name))
		end)
	end

	Log:Info(("[M23] Intro gestartet für %s (%ds)"):format(player.Name, M23_IntroCamera.Config.Duration))
end

-- Auto-play on first join (optional)
function M23_IntroCamera:AutoPlayOnJoin()
	Players.PlayerAdded:Connect(function(player)
		-- Nur wenn Spieler zum ersten Mal joint (kein DataStore-Check hier, da Phase 2)
		task.wait(2)  -- kurze Verzögerung damit Map geladen ist
		self:Play(player)
	end)
end

return M23_IntroCamera
