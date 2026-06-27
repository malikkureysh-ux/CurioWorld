--!strict
--[[
	M22_AnimationController.lua — NPC + Kran Animationen
	====================================================

	Spielt Idle-Animationen auf NPCs + Kran-Hook-Schwing-Animation.
	Liest Animation-IDs aus ReplicatedStorage.AssetDefinitions.Animations.

	User Story:
	  Als Spieler:in möchte ich, dass NPCs lebendig wirken — kleine
	  Wellen-Bewegungen, gelegentliches Winken — damit die Welt
	  bevölkert und nicht statisch aussieht.

	Phase 2: Server-seitige Steuerung (Animation-IDs vom Server geladen,
	Client spielt via RemoteEvent ab).
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Log = require(ReplicatedStorage.Shared.Util.Log)

local M22_AnimationController = {}

-- ============================================================
-- Animation-Registry (Maps Animation-ID → instance)
-- ============================================================

local animRegistry = {}

local function loadAnimations()
	local assetDefs = ReplicatedStorage:FindFirstChild("AssetDefinitions")
	if not assetDefs then
		Log:Warn("[M22] AssetDefinitions nicht gefunden — Animationen deaktiviert")
		return
	end
	local anims = assetDefs:FindFirstChild("Animations")
	if not anims then
		Log:Warn("[M22] Animations nicht gefunden")
		return
	end

	for _, animObj in ipairs(anims:GetChildren()) do
		if animObj:IsA("Animation") then
			animRegistry[animObj.Name] = animObj
			Log:Info(("[M22] Animation geladen: %s (id=%s)"):format(animObj.Name, animObj.AnimationId))
		end
	end
end

local function hasPendingId(animationId: string): boolean
	return typeof(animationId) ~= "string"
		or string.find(animationId, "PENDING_UPLOAD") ~= nil
end

-- ============================================================
-- NPC Idle-Animation Player
-- ============================================================

function M22_AnimationController:PlayNpcIdle(npcModel: Model)
	local humanoid = npcModel:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	-- Versuche NPC_Idle_Wave oder NPC_Idle_Look zu spielen
	local animator = humanoid:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = humanoid
	end

	-- Versuche erste verfügbare Idle-Animation
	local idleAnim = animRegistry["NPC_Idle_Wave"] or animRegistry["NPC_Idle_Look"]
	if not idleAnim then return end
	if hasPendingId(idleAnim.AnimationId) then
		-- PENDING: versuche die Animation trotzdem zu laden (Roblox wirft dann)
		-- In Studio zeigt das nur eine Warnung
	end

	local track = animator:LoadAnimation(idleAnim)
	track.Looped = true
	track.Priority = Enum.AnimationPriority.Idle
	track:Play()
	Log:Info(("[M22] NPC-Idle gestartet für %s"):format(npcModel.Name))
end

-- ============================================================
-- Kran-Schwing-Animation (an Spieler:in geheftet)
-- ============================================================

function M22_AnimationController:PlayKranSwing(character: Model): boolean
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return false end

	local animator = humanoid:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = humanoid
	end

	local swingAnim = animRegistry["Kran_Swing"]
	if not swingAnim then return false end
	if hasPendingId(swingAnim.AnimationId) then
		-- Ohne echte AssetId nicht abspielbar
		return false
	end

	local track = animator:LoadAnimation(swingAnim)
	track.Looped = false
	track.Priority = Enum.AnimationPriority.Action
	track:Play()
	Log:Info("[M22] Kran-Swing gestartet")
	return true
end

-- ============================================================
-- Boot-Animation (Rudern)
-- ============================================================

function M22_AnimationController:PlayBoatRow(character: Model): boolean
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return false end

	local animator = humanoid:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = humanoid
	end

	local rowAnim = animRegistry["Boat_Row"]
	if not rowAnim then return false end
	if hasPendingId(rowAnim.AnimationId) then return false end

	local track = animator:LoadAnimation(rowAnim)
	track.Looped = true
	track.Priority = Enum.AnimationPriority.Movement
	track:Play()
	return true
end

-- ============================================================
-- Init: Animationen einmal beim Server-Start laden
-- ============================================================

function M22_AnimationController:Init()
	loadAnimations()
	Log:Info("[M22] AnimationController initialisiert")
end

return M22_AnimationController
