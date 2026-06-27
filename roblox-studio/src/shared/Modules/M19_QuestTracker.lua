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

-- Optional callback when player taps a quest card or "Mehr" button
-- Signature: (player, questId) -> ()
M19_QuestTracker.OnQuestClicked = nil
M19_QuestTracker.OnMoreClicked = nil

local function makeUICorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = radius or M19_QuestTracker.Theme.CornerRadius
	c.Parent = parent
end

local function makeQuestCard(parent, quest, progress, player)
	local card = Instance.new("Frame")
	card.Name = "QuestCard_" .. quest.id
	card.Size = UDim2.new(1, 0, 0, 60)
	-- Bestimme Quest-State-Color (Complete > Active > Idle)
	local isComplete = progress.completed_at ~= nil
		or (progress.current_step > #quest.steps)
	card.BackgroundColor3 = isComplete and M19_QuestTracker.Theme.QuestComplete
		or (progress.current_step > 1 and M19_QuestTracker.Theme.QuestActive)
		or M19_QuestTracker.Theme.QuestIdle
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
	                                math.min(progress.current_step, #quest.steps),
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

	-- Progress clamped 0..1 (vorher overflow möglich)
	local ratio = math.clamp(
		(progress.current_step - 1) / #quest.steps, 0, 1)
	local barFill = Instance.new("Frame")
	barFill.Name = "Fill"
	barFill.Size = UDim2.new(ratio, 0, 1, 0)
	barFill.BackgroundColor3 = M19_QuestTracker.Theme.QuestActive
	barFill.BorderSizePixel = 0
	barFill.Parent = barBg
	makeUICorner(barFill, UDim.new(0, 2))

	-- Klickbar → öffnet Quest-Detail
	local clickBtn = Instance.new("TextButton")
	clickBtn.Name = "CardClick"
	clickBtn.Size = UDim2.new(1, 0, 1, 0)
	clickBtn.BackgroundTransparency = 1
	clickBtn.Text = ""
	clickBtn.AutoButtonColor = false
	clickBtn.Parent = card
	clickBtn.MouseButton1Click:Connect(function()
		Log:Info("[M19] Quest-Card clicked: " .. quest.id)
		if M19_QuestTracker.OnQuestClicked then
			local ok, err = pcall(M19_QuestTracker.OnQuestClicked, player, quest.id)
			if not ok then
				Log:Warn("[M19] OnQuestClicked callback failed: " .. tostring(err))
			end
		end
	end)

	-- Hover-Effekt
	clickBtn.MouseEnter:Connect(function()
		TweenService:Create(card,
			TweenInfo.new(M19_QuestTracker.Theme.TweenDuration,
				Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ BackgroundTransparency = 0.15 }):Play()
	end)
	clickBtn.MouseLeave:Connect(function()
		TweenService:Create(card,
			TweenInfo.new(M19_QuestTracker.Theme.TweenDuration,
				Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ BackgroundTransparency = 0 }):Play()
	end)

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

	-- Container (oben rechts) — mit Slide-In von rechts
	local container = Instance.new("Frame")
	container.Name = "QuestTrackerContainer"
	container.Size = UDim2.new(0, 260, 0, 240)
	container.Position = UDim2.new(1, 60, 0, 20)  -- Start: 60px außerhalb rechts
	container.BackgroundColor3 = M19_QuestTracker.Theme.BackgroundColor
	container.BackgroundTransparency = M19_QuestTracker.Theme.BackgroundTransparency
	container.BorderSizePixel = 0
	container.Parent = screenGui
	makeUICorner(container)
	local stroke = Instance.new("UIStroke")
	stroke.Color = M19_QuestTracker.Theme.BorderColor
	stroke.Thickness = M19_QuestTracker.Theme.BorderThickness
	stroke.Parent = container

	-- Slide-In-Animation: von rechts rein
	task.defer(function()
		if container and container.Parent then
			TweenService:Create(container,
				TweenInfo.new(M19_QuestTracker.Theme.TweenDuration * 2,
					Enum.EasingStyle.Back, Enum.EasingDirection.Out),
				{ Position = UDim2.new(1, -280, 0, 20) }):Play()
		end
	end)

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

	-- Sort by quest ID for deterministic order (no UI jitter)
	local sortedIds = {}
	for questId, _ in pairs(activeQuests) do
		table.insert(sortedIds, questId)
	end
	table.sort(sortedIds)

	-- Add active quests (max 3 + "Mehr"-Button)
	local count = 0
	local total = #sortedIds
	for _, questId in ipairs(sortedIds) do
		local progress = activeQuests[questId]
		if count < M19_QuestTracker.Theme.MaxVisibleQuests then
			local quest = M02_Quest.SampleQuests[questId]
			if quest then
				local card = makeQuestCard(list, quest, progress, player)
				card.LayoutOrder = count + 1
				count += 1
			else
				Log:Warn("[M19] Unknown quest in activeQuests: " .. questId)
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

		moreBtn.MouseButton1Click:Connect(function()
			Log:Info("[M19] +N weitere clicked, opening full list")
			if M19_QuestTracker.OnMoreClicked then
				local ok, err = pcall(M19_QuestTracker.OnMoreClicked, player, total)
				if not ok then
					Log:Warn("[M19] OnMoreClicked callback failed: " .. tostring(err))
				end
			end
		end)

		-- Hover
		moreBtn.MouseEnter:Connect(function()
			TweenService:Create(moreBtn,
				TweenInfo.new(M19_QuestTracker.Theme.TweenDuration,
					Enum.EasingStyle.Quad),
				{ BackgroundColor3 = Color3.fromRGB(80, 85, 100) }):Play()
		end)
		moreBtn.MouseLeave:Connect(function()
			TweenService:Create(moreBtn,
				TweenInfo.new(M19_QuestTracker.Theme.TweenDuration,
					Enum.EasingStyle.Quad),
				{ BackgroundColor3 = Color3.fromRGB(60, 65, 78) }):Play()
		end)
	end

	Log:Info(string.format("[M19] Updated with %d active quests (%d shown)", total, count))
end

return M19_QuestTracker
