--!strict
--[[
	QuestVisibilityService.lua — Map-Attribute Consumer
	====================================================

	Liest Map-Attribute und macht sie lebendig:
	- VisibleAfterQuest: Boat_Built wird erst nach Quest-Abschluss sichtbar
	- QuestHook (Data): Logging + Audit-Trail
	- MaterialType/Quantity (Pickupable): Phase 3 (Inventory-Integration)

	User Story:
	  Als Spieler:in möchte ich nach Abschluss von HH_03 sehen, dass das
	  gebaute Boot plötzlich am Dock erscheint — als sichtbare Belohnung.
]]

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local Log = require(game:GetService("ReplicatedStorage").Shared.Util.Log)

local QuestVisibilityService = {}

-- ============================================================
-- Walk alle Map-Instanzen und prüfe Attribute
-- ============================================================

local function processInstance(instance: Instance)
	if not instance:IsA("Instance") then return end

	local visibleAfter = instance:GetAttribute("VisibleAfterQuest")
	if type(visibleAfter) == "string" then
		-- Default: versteckt bis Quest completed
		instance.Transparency = 1
		instance.CanCollide = false
		Log:Info(("[QuestVisibility] %s starts hidden until %s completed"):format(
			instance:GetFullName(), visibleAfter))
	end

	local questHook = instance:GetAttribute("QuestHook")
	if type(questHook) == "string" then
		Log:Debug(("[QuestVisibility] %s carries QuestHook=%s"):format(
			instance:GetFullName(), questHook))
	end

	local materialType = instance:GetAttribute("MaterialType")
	if materialType then
		Log:Debug(("[QuestVisibility] %s is pickupable material: %s qty=%s"):format(
			instance:GetFullName(), tostring(materialType),
			tostring(instance:GetAttribute("Quantity"))))
	end
end

local function walkAndProcess(root: Instance)
	for _, desc in ipairs(root:GetDescendants()) do
		processInstance(desc)
	end
end

-- ============================================================
-- Quest-Completion-Tracker
-- ============================================================

local completedQuests: { [Player]: { [string]: boolean } } = {}

local function hasCompletedQuest(player: Player, questId: string): boolean
	return completedQuests[player] ~= nil
		and completedQuests[player][questId] == true
end

local function revealAfterQuest(questId: string)
	local revealedCount = 0
	for _, desc in ipairs(Workspace:GetDescendants()) do
		if desc:GetAttribute("VisibleAfterQuest") == questId then
			desc.Transparency = 0
			desc.CanCollide = true
			revealedCount += 1
			Log:Info(("[QuestVisibility] Revealed %s (quest %s completed)"):format(
				desc:GetFullName(), questId))
		end
	end
	return revealedCount
end

-- ============================================================
-- Public API
-- ============================================================

function QuestVisibilityService:Init()
	walkAndProcess(Workspace)
	Log:Info("[QuestVisibilityService] Initial walk complete")

	-- Workspace.ChildAdded: neue Objekte ebenfalls scannen (Hot-Reload)
	Workspace.DescendantAdded:Connect(function(desc)
		task.defer(function()
			processInstance(desc)
		end)
	end)
end

function QuestVisibilityService:OnQuestCompleted(player: Player, questId: string)
	if not completedQuests[player] then
		completedQuests[player] = {}
	end
	completedQuests[player][questId] = true

	-- Reveal alle VisibleAfterQuest-Map-Teile für diesen Spieler
	-- (in Phase 3: Per-Player-Reveal via LayerCollector; aktuell global)
	local count = revealAfterQuest(questId)
	Log:Info(("[QuestVisibility] %s completed %s → revealed %d items"):format(
		player.Name, questId, count))
end

function QuestVisibilityService:HasCompleted(player: Player, questId: string): boolean
	return hasCompletedQuest(player, questId)
end

-- Cleanup bei PlayerRemoving
Players.PlayerRemoving:Connect(function(player)
	completedQuests[player] = nil
end)

return QuestVisibilityService