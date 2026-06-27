--!strict
--[[
	M16_NpcSpawner.lua — NPC-Spawn-System
	=======================================

	Liest NpcSpawn_* Parts aus der Map (siehe hamburg_harbor_map.lua) und
	instantiiert dort echte NPC-Meshes aus den in Attributes.MeshAssetId
	referenzierten Roblox-Assets.

	User Story:
	  Als Spieler:in möchte ich beim Erkunden von Hamburg Harbor
	  Hafenwirtin Lina, Yuki, Maja und Nils als echte Charaktere sehen
	  (nicht unsichtbare Spawn-Cubes), damit die Welt bevölkert wirkt
	  und ich weiß, wo ich Hilfe bekomme.

	Phase 2: Spawn + ProximityPrompt für Dialogue-Trigger.
	Phase 3: Animationen, Idle-Wander, Quest-Trigger-Integration.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local Log = require(ReplicatedStorage.Shared.Util.Log)
local ServiceRegistry = require(ReplicatedStorage.Shared.Util.ServiceRegistry)

local M16_NpcSpawner = {}

-- ============================================================
-- NPC-Definition (statisch — könnte in Phase 3 aus Data geladen werden)
-- ============================================================

M16_NpcSpawner.NpcConfig = {
	Hafenwirtin = {
		DisplayName = "Hafenwirtin Lina",
		DialogueKey = "npc.hafenwirtin.greeting",
		Role = "QuestGiver",
		Color = Color3.fromRGB(180, 100, 60),  -- Hafen-Orange
	},
	Yuki = {
		DisplayName = "Markt-Händlerin Yuki",
		DialogueKey = "npc.yuki.greeting",
		Role = "Merchant",
		Color = Color3.fromRGB(255, 182, 193),  -- Sakura-Pink
	},
	Maja = {
		DisplayName = "Bootsbauerin Maja",
		DialogueKey = "npc.maja.greeting",
		Role = "Crafter",
		Color = Color3.fromRGB(110, 75, 50),  -- Werkstatt-Braun
	},
	Nils = {
		DisplayName = "Leuchtturmwächter Nils",
		DialogueKey = "npc.nils.greeting",
		Role = "Story",
		Color = Color3.fromRGB(80, 100, 140),  -- Marine-Blau
	},
}

-- ============================================================
-- Helper
-- ============================================================

local function isPendingAsset(assetId: string): boolean
	return typeof(assetId) ~= "string" or string.find(assetId, "PENDING_UPLOAD") ~= nil
end

local function createPlaceholderMesh(spawn: BasePart, npcId: string): Model
	-- Fallback wenn echtes Asset noch nicht hochgeladen:
	-- Erzeugt einen stilisierten Chibi-Charakter aus Primitives,
	-- damit die Welt im Studio nicht leer wirkt.
	local placeholder = Instance.new("Model")
	placeholder.Name = npcId .. "_Placeholder"

	local config = M16_NpcSpawner.NpcConfig[npcId]
	local bodyColor = config and config.Color or Color3.fromRGB(180, 100, 60)

	-- Beine
	local legs = Instance.new("Part")
	legs.Name = "Legs"
	legs.Size = Vector3.new(0.6, 0.8, 0.4)
	legs.Position = spawn.Position + Vector3.new(0, 0.4, 0)
	legs.Anchored = true
	legs.CanCollide = false
	legs.BrickColor = BrickColor.new("Navy blue")
	legs.Parent = placeholder

	-- Torso
	local torso = Instance.new("Part")
	torso.Name = "Torso"
	torso.Size = Vector3.new(0.9, 0.9, 0.6)
	torso.Position = spawn.Position + Vector3.new(0, 1.3, 0)
	torso.Anchored = true
	torso.CanCollide = false
	torso.Color = bodyColor
	torso.Parent = placeholder

	-- Kopf
	local head = Instance.new("Part")
	head.Name = "Head"
	head.Shape = Enum.PartType.Ball
	head.Size = Vector3.new(0.8, 0.8, 0.8)
	head.Position = spawn.Position + Vector3.new(0, 2.1, 0)
	head.Anchored = true
	head.CanCollide = false
	head.BrickColor = BrickColor.new("Nougat")
	head.Parent = placeholder

	-- Gesicht (Smiley-Decal-Surface)
	local face = Instance.new("Decal")
	face.Name = "Face"
	face.Face = Enum.NormalId.Front
	face.Texture = "rbxassetid://14861556650"  -- Default-Smiley (in Studio ersetzbar)
	face.Parent = head

	-- DisplayName als BillboardGui (Name-Tag über Kopf)
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "NameTag"
	billboard.Size = UDim2.new(4, 0, 1, 0)
	billboard.StudsOffset = Vector3.new(0, 1.2, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = head

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, 0, 1, 0)
	nameLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	nameLabel.BackgroundTransparency = 0.4
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextSize = 14
	nameLabel.Text = config and config.DisplayName or npcId
	nameLabel.Parent = billboard

	-- PrimaryPart setzen für Model.MoveTo etc.
	placeholder.PrimaryPart = torso

	return placeholder
end

local function spawnNpcFromAsset(spawn: BasePart, npcId: string, assetId: string, outfit: string?): Model
	-- Echtes Mesh aus Roblox-Asset laden via InsertService
	-- InsertService funktioniert nur für vom User hochgeladene Assets.
	local ok, model = pcall(function()
		return game:GetService("InsertService"):LoadAsset(
			tostring(tonumber(string.match(assetId, "%d+")) or 0)
		)
	end)

	if not ok or not model then
		Log:Warn(string.format(
			"[M16] Asset-Load für NPC '%s' (assetId=%s) fehlgeschlagen: %s. Fallback auf Placeholder.",
			npcId, assetId, tostring(model)
		))
		return createPlaceholderMesh(spawn, npcId)
	end

	-- Model umbenennen + positionieren
	model.Name = npcId
	local primary = model.PrimaryPart
	if not primary then
		-- Fallback: erstes BasePart als Primary
		for _, desc in ipairs(model:GetDescendants()) do
			if desc:IsA("BasePart") then
				primary = desc
				break
			end
		end
	end
	if primary then
		model.PrimaryPart = primary
		primary.Anchored = true
		model:PivotTo(CFrame.new(spawn.Position))
	end

	-- Outfit-Tag setzen
	if outfit then
		model:SetAttribute("Outfit", outfit)
	end
	model:SetAttribute("NpcId", npcId)

	return model
end

local function attachProximityPrompt(model: Model, npcId: string)
	-- ProximityPrompt für Dialogue-Interaktion
	local primary = model.PrimaryPart
	if not primary then return end

	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "TalkTo" .. npcId
	prompt.ActionText = "Sprechen"
	prompt.HoldDuration = 0.0  -- instant trigger
	prompt.MaxActivationDistance = 8
	prompt.RequiresLineOfSight = true
	prompt.Parent = primary

	-- Wire up: bei Trigger → M18 Dialogue UI öffnen
	prompt.Triggered:Connect(function(playerWhoTriggered)
		local config = M16_NpcSpawner.NpcConfig[npcId]
		if not config then return end

		-- Versuche M18 Dialogue zu laden (kann fehlen in Phase 2 wenn UI noch nicht verkabelt)
		local ok, M18 = pcall(function()
			return require(ReplicatedStorage.Shared.Modules.M18_Dialogue)
		end)
		if not ok or not M18 then
			Log:Warn("[M16] M18_Dialogue nicht verfügbar — ProximityPrompt ohne UI-Verkabelung")
			return
		end

		-- Lokalisierter Greeting-Text
		local greetingKey = config.DialogueKey
		local greetingText = greetingKey  -- Fallback = key selbst
		pcall(function()
			local M15 = require(ReplicatedStorage.Shared.Modules.M15_Localization)
			greetingText = M15:T(greetingKey) or greetingKey
		end)

		-- Dialogue öffnen
		M18:Show(playerWhoTriggered, config, greetingText)
		Log:Info(("[M16] Dialogue geöffnet für %s mit %s"):format(playerWhoTriggered.Name, npcId))

		-- Sound-Feedback (NPC-Greeting falls vorhanden)
		pcall(function()
			local soundService = game:GetService("SoundService")
			local ambient = soundService:FindFirstChild("Kran_Mechanik")
			-- (Wir haben aktuell keinen NPC-Specific-Sound; Kran_Mechanik als Fallback)
		end)
	end)
end

-- ============================================================
-- Spawn-Logic
-- ============================================================

function M16_NpcSpawner:SpawnAll(districtsFolder: Folder): { [string]: Model }
	local spawned: { [string]: Model } = {}

	if not districtsFolder then
		Log:Error("[M16] districtsFolder is nil")
		return spawned
	end

	local hamburgHarbor = districtsFolder:FindFirstChild("HamburgHarbor")
	if not hamburgHarbor then
		Log:Warn("[M16] HamburgHarbor not found in districts")
		return spawned
	end

	-- Finde alle NpcSpawn_* Parts (rekursiv, da sie unter Sub-Areas liegen)
	for _, descendant in ipairs(hamburgHarbor:GetDescendants()) do
		if descendant:IsA("BasePart") and descendant.Name:match("^NpcSpawn_") then
			local npcId = string.match(descendant.Name, "^NpcSpawn_(.+)$")
			if not npcId then continue end

			local meshAssetId = descendant:GetAttribute("MeshAssetId")
			local outfit = descendant:GetAttribute("Outfit")

			if not meshAssetId or isPendingAsset(meshAssetId) then
				Log:Info(string.format("[M16] NPC '%s' noch ohne AssetId, verwende Placeholder", npcId))
				spawned[npcId] = createPlaceholderMesh(descendant, npcId)
			else
				spawned[npcId] = spawnNpcFromAsset(descendant, npcId, meshAssetId, outfit)
			end

			local model = spawned[npcId]
			if model then
				model.Parent = descendant.Parent  -- direkt neben dem Spawn-Anker
				attachProximityPrompt(model, npcId)
				Log:Info(string.format("[M16] NPC '%s' gespawnt", npcId))
			end
		end
	end

	return spawned
end

-- ============================================================
-- Service-Integration
-- ============================================================

function M16_NpcSpawner:RegisterService()
	ServiceRegistry:Register("NpcSpawner", self)

	-- Spawn Npcs nach MapBuild
	-- Bootstrap orchestriert die Reihenfolge (siehe Bootstrap.server.lua)
end

return M16_NpcSpawner
