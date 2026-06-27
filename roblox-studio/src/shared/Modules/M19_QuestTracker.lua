--!strict
--[[
	M19_QuestTracker.lua — Premium Quest-Tracker Panel
	==================================================

	User Story:
	  Als Spieler:in möchte ich oben rechts jederzeit sehen, welche
	  Quests ich aktiv habe und wie weit ich bin, damit ich weiß, was
	  ich als Nächstes tun kann, ohne das Quest-Menü öffnen zu müssen.

	Premium-Anforderungen:
	- Top-3 aktive Quests (Rest einklappbar)
	- Step-Progress (z.B. "2/4")
	- Bezirks-Icon (für visuelle Identifikation)
	- "Mehr"-Button wenn >3 Quests
	- Slide-In von rechts
	- Klickbar → öffnet Quest-Detail
]]

local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Log = require(ReplicatedStorage.Shared.Util.Log)
local M02_Quest = require(ReplicatedStorage.Shared.Modules.M02_Quest)
local Localization = require(ReplicatedStorage.Shared.Modules.M15_Localization)

local M19_QuestTracker = {}

M19_QuestTracker.Theme = {
	BackgroundColor = Color3.fromRGB(25, 28, 35),
	BackgroundTransparency = 0.05,
	BorderColor = Color3.fromRGB(180, 200, 220),
	BorderThickness = 2,
	CornerRadius = UDim.new(0, 12),
	QuestIdle = Color3.fromRGB(50, 55, 70),
	QuestActive = Color3.fromRGB(70, 130, 180),
	QuestComplete = Color3.fromRGB(80, 180, 120),
	StepIndicator = Color3.fromRGB(180, 200, 220),
	TweenDuration = 0.2,
	MaxVisibleQuests = 3,
}

local function makeUICorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = radius or M19_QuestTracker.Theme.CornerRadius
	c.Parent = parent
end

local function makeQuestCard(parent, quest, progress)
	local card = Instance.new("Frame")
	card.Name = "QuestCard_" .. quest.id
	card.Size = UDim2.new(1, 0, 0, 60)
	card.BackgroundColor3 = M19_QuestTracker.Theme.QuestIdle
	card.BorderSizePixel = 0
	card.Parent = parent
	makeUICorner(card, UDim.new(0, 8))

	-- Quest-Titel
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, -16, 0, 24)
	title.Position = UDim2.new(0, 8, 0, 6)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamBold
	title.TextSize = 13
	title.TextColor3 = Color3.fromRGB(245, 245, 250)
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Text = Localization:T(quest.title_key) or quest.id
	title.Parent = card

	-- Step-Progress
	local stepText = string.format("Schritt %d / %d",
	                                progress.current_step,
	                                #quest.steps)
	local stepLabel = Instance.new("TextLabel")
	stepLabel.Name = "Steps"
	stepLabel.Size = UDim2.new(1, -16, 0, 18)
	stepLabel.Position = UDim2.new(0, 8, 0, 32)
	stepLabel.BackgroundTransparency = 1
	stepLabel.Font = Enum.Font.Gotham
	stepLabel.TextSize = 11
	stepLabel.TextColor3 = M19_QuestTracker.Theme.StepIndicator
	stepLabel.TextXAlignment = Enum.TextXAlignment.Left
	stepLabel.Text = stepText
	stepLabel.Parent = card

	-- Progress-Bar (mini)
	local barBg = Instance.new("Frame")
	barBg.Name = "ProgressBar"
	barBg.Size = UDim2.new(0.9, 0, 0, 4)
	barBg.Position = UDim2.new(0.05, 0, 1, -8)
	barBg.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
	barBg.BorderSizePixel = 0
	barBg.Parent = card
	makeUICorner(barBg, UDim.new(0, 2))

	local barFill = Instance.new("Frame")
	barFill.Name = "Fill"
	barFill.Size = UDim2.new((progress.current_step - 1) / #quest.steps, 0, 1, 0)
	barFill.BackgroundColor3 = M19_QuestTracker.Theme.QuestActive
	barFill.BorderSizePixel = 0
	barFill.Parent = barBg
	makeUICorner(barFill, UDim.new(0, 2))

	return card
end

-- ============================================================
-- Public API
-- ============================================================

function M19_QuestTracker:CreateForPlayer(player: Player): ScreenGui
	local playerGui = player:WaitForChild("PlayerGui")
	local existing = playerGui:FindFirstChild("CurioQuestTracker")
	if existing then existing:Destroy() end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "CurioQuestTracker"
	screenGui.ResetOnSpawn = false
	screenGui.DisplayOrder = 90
	screenGui.Parent = playerGui

	-- Container (oben rechts)
	local container = Instance.new("Frame")
	container.Name = "QuestTrackerContainer"
	container.Size = UDim2.new(0, 260, 0, 240)
	container.Position = UDim2.new(1, -280, 0, 20)
	container.BackgroundColor3 = M19_QuestTracker.Theme.BackgroundColor
	container.BackgroundTransparency = M19_QuestTracker.Theme.BackgroundTransparency
	container.BorderSizePixel = 0
	container.Parent = screenGui
	makeUICorner(container)
	local stroke = Instance.new("UIStroke")
	stroke.Color = M19_QuestTracker.Theme.BorderColor
	stroke.Thickness = M19_QuestTracker.Theme.BorderThickness
	stroke.Parent = container

	-- Header
	local header = Instance.new("TextLabel")
	header.Name = "Header"
	header.Size = UDim2.new(1, -16, 0, 28)
	header.Position = UDim2.new(0, 8, 0, 8)
	header.BackgroundTransparency = 1
	header.Font = Enum.Font.GothamBold
	header.TextSize = 16
	header.TextColor3 = Color3.fromRGB(220, 230, 240)
	header.TextXAlignment = Enum.TextXAlignment.Left
	header.Text = "📜 Aktive Quests"
	header.Parent = container

	-- Quest-Liste (UIListLayout)
	local list = Instance.new("Frame")
	list.Name = "QuestList"
	list.Size = UDim2.new(1, -16, 1, -50)
	list.Position = UDim2.new(0, 8, 0, 40)
	list.BackgroundTransparency = 1
	list.Parent = container

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 6)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = list

	return screenGui
end

function M19_QuestTracker:Update(player: Player, activeQuests: { [string]: any })
	local playerGui = player:FindFirstChild("PlayerGui")
	local screenGui = playerGui and playerGui:FindFirstChild("CurioQuestTracker")
	if not screenGui then return end
	local container = screenGui:FindFirstChild("QuestTrackerContainer")
	if not container then return end
	local list = container:FindFirstChild("QuestList")
	if not list then return end

	-- Clear existing
	for _, child in ipairs(list:GetChildren()) do
		if child:IsA("Frame") then child:Destroy() end
	end

	-- Add active quests (max 3 + "Mehr"-Button)
	local count = 0
	local total = 0
	for questId, progress in pairs(activeQuests) do
		total += 1
		if count < M19_QuestTracker.Theme.MaxVisibleQuests then
			local quest = M02_Quest.SampleQuests[questId]
			if quest then
				local card = makeQuestCard(list, quest, progress)
				card.LayoutOrder = count + 1
				count += 1
			end
		end
	end

	if total > M19_QuestTracker.Theme.MaxVisibleQuests then
		local moreBtn = Instance.new("TextButton")
		moreBtn.Size = UDim2.new(1, 0, 0, 30)
		moreBtn.BackgroundColor3 = Color3.fromRGB(60, 65, 78)
		moreBtn.BorderSizePixel = 0
		moreBtn.Font = Enum.Font.GothamBold
		moreBtn.TextSize = 12
		moreBtn.TextColor3 = Color3.fromRGB(200, 220, 240)
		moreBtn.Text = string.format("+%d weitere", total - M19_QuestTracker.Theme.MaxVisibleQuests)
		moreBtn.LayoutOrder = 99
		moreBtn.Parent = list
		makeUICorner(moreBtn, UDim.new(0, 6))
	end

	Log:Info(string.format("[M19] Updated with %d active quests (%d shown)", total, count))
end

return M19_QuestTracker
