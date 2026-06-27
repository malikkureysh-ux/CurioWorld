--!strict
--[[
	MapInteractionService.lua — ProximityPrompt-Handler für Map-Objekte
	====================================================================

	User Story:
	  Als Spieler:in möchte ich, wenn ich auf "Werkbank benutzen" oder
	  "Tagesaufgaben ansehen" klicke, dass tatsächlich etwas passiert —
	  die Quest startet oder das Tagesaufgaben-Modal öffnet sich.

	Architektur:
	  - Workspace.DescendantAdded: scan neue ProximityPrompts
	  - Triggered → lese Parent.InteractType → route zu Service
	  - QuestStart: QuestService.StartQuest + Dialogue-Hint
	  - QuestBoard: öffnet Daily-Quests UI (Phase 3: M19 Liste)
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Log = require(ReplicatedStorage.Shared.Util.Log)
local ServiceRegistry = require(ReplicatedStorage.Shared.Util.ServiceRegistry)

local MapInteractionService = {}

-- ============================================================
-- Remote-Events für Client-Benachrichtigungen
-- ============================================================

local remotesFolder = Instance.new("Folder")
remotesFolder.Name = "MapInteractionRemotes"
remotesFolder.Parent = ReplicatedStorage

local remoteShowDailyQuests = Instance.new("RemoteEvent")
remoteShowDailyQuests.Name = "ShowDailyQuests"
remoteShowDailyQuests.Parent = remotesFolder

local remoteQuestStarted = Instance.new("RemoteEvent")
remoteQuestStarted.Name = "QuestStarted"
remoteQuestStarted.Parent = remotesFolder

-- ============================================================
-- ProximityPrompt-Handler
-- ============================================================

local function handleInteraction(player: Player, prompt: ProximityPrompt)
	local parent = prompt.Parent
	if not parent then return end

	local interactType = parent:GetAttribute("InteractType")
	if not interactType then
		Log:Debug(("[MapInteraction] %s triggered prompt without InteractType"):format(
			player.Name))
		return
	end

	Log:Info(("[MapInteraction] %s → %s on %s"):format(
		player.Name, interactType, parent.Name))

	if interactType == "QuestStart" then
		-- QuestStart: z.B. Workbench mit QuestHook="HH_03_werft_boat"
		local questHook = parent:GetAttribute("QuestHook")
		if not questHook then
			Log:Warn(("[MapInteraction] QuestStart without QuestHook: %s"):format(parent.Name))
			return
		end

		-- Starte Quest über QuestService
		local questService = ServiceRegistry:Get("Quest")
		if questService then
			local progress = questService:StartQuest(player, questHook)
			if progress then
				Log:Info(("[MapInteraction] Started %s for %s"):format(questHook, player.Name))
				remoteQuestStarted:FireClient(player, questHook)
				-- Mark NpcTalked (für Quest-Validators) — Workbench-Interaktion zählt als Quest-Start
				questService:MarkNpcTalked(player, "Workbench")
			end
		end
	elseif interactType == "QuestBoard" then
		-- Tagesaufgaben anzeigen
		Log:Info(("[MapInteraction] Opening daily quests for %s"):format(player.Name))
		remoteShowDailyQuests:FireClient(player)
	elseif interactType == "NPC" then
		-- NPC-ProximityPrompt wird bereits von M16 gehandhabt — no-op
		Log:Debug("[MapInteraction] NPC prompt handled by M16")
	else
		Log:Warn(("[MapInteraction] Unknown InteractType: %s"):format(tostring(interactType)))
	end
end

-- ============================================================
-- Workspace-Scan: alle ProximityPrompts mit InteractType
-- ============================================================

local connectedPrompts: { ProximityPrompt } = {}

local function connectPrompt(prompt: ProximityPrompt)
	if not prompt:IsA("ProximityPrompt") then return end
	if connectedPrompts[prompt] then return end

	-- Nur Prompts, deren Parent InteractType hat
	local parent = prompt.Parent
	if not parent then return end
	if not parent:GetAttribute("InteractType") then return end

	local conn = prompt.Triggered:Connect(function(playerWhoTriggered)
		handleInteraction(playerWhoTriggered, prompt)
	end)

	-- Cleanup-Tracking: Connection disconnecten wenn Prompt zerstört wird
	prompt.Destroying:Connect(function()
		if conn and conn.Connected then conn:Disconnect() end
		connectedPrompts[prompt] = nil
	end)

	connectedPrompts[prompt] = prompt
	Log:Debug(("[MapInteraction] Hooked prompt on %s (%s)"):format(
		parent.Name, tostring(parent:GetAttribute("InteractType"))))
end

local function scanWorkspace(root: Instance)
	for _, desc in ipairs(root:GetDescendants()) do
		if desc:IsA("ProximityPrompt") then
			connectPrompt(desc)
		end
	end
end

-- ============================================================
-- Public API
-- ============================================================

function MapInteractionService:Init()
	scanWorkspace(Workspace)
	Log:Info("[MapInteraction] Initialized")

	-- Hot-Reload: neue ProximityPrompts nach Init connecten
	Workspace.DescendantAdded:Connect(function(desc)
		if desc:IsA("ProximityPrompt") then
			task.defer(function()
				connectPrompt(desc)
			end)
		end
	end)
end

-- Cleanup
Players.PlayerRemoving:Connect(function(player)
	-- Aktuell keine Per-Player-State in diesem Service
end)

return MapInteractionService