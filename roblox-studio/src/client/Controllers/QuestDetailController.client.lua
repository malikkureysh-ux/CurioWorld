--!strict
--[[
	QuestDetailController.client.lua — Client-side Quest-Detail-Handler
	====================================================================

	User Story:
	  Als Spieler:in möchte ich, wenn ich auf eine Quest im QuestTracker
	  klicke oder auf "+N weitere", ein schönes Detail-Modal sehen mit
	  allen Steps, Zielen und Belohnungen — damit ich weiß, was als
	  Nächstes zu tun ist.

	Architektur:
	  Server (Bootstrap) → feuert QuestDetailRemote an Client
	  Client (dieser Controller) → empfängt + rendert Detail-Modal
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Log = require(ReplicatedStorage.Shared.Util.Log)
local M02_Quest = require(ReplicatedStorage.Shared.Modules.M02_Quest)
local M15_Localization = require(ReplicatedStorage.Shared.Modules.M15_Localization)
local Localization = M15_Localization

local QuestDetailController = {}

QuestDetailController.Theme = {
	BackgroundColor = Color3.fromRGB(25, 28, 35),
	BackgroundTransparency = 0.05,
	BorderColor = Color3.fromRGB(180, 200, 220),
	BorderThickness = 2,
	CornerRadius = UDim.new(0, 16),
	HeaderColor = Color3.fromRGB(220, 230, 240),
	BodyColor = Color3.fromRGB(245, 245, 250),
	Accent = Color3.fromRGB(120, 200, 240),
	RewardGold = Color3.fromRGB(255, 220, 110),
	RewardGems = Color3.fromRGB(120, 200, 240),
	TweenDuration = 0.25,
}

local function makeUICorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = radius or QuestDetailController.Theme.CornerRadius
	c.Parent = parent
end

-- ============================================================
-- Detail-Modal Bauen
-- ============================================================

local function showQuestDetail(player, questId)
	local quest = questId and M02_Quest.SampleQuests[questId]
	local playerGui = player:FindFirstChild("PlayerGui")
	if not playerGui then return end

	-- Cleanup existing
	local existing = playerGui:FindFirstChild("CurioQuestDetail")
	if existing then existing:Destroy() end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "CurioQuestDetail"
	screenGui.ResetOnSpawn = false
	screenGui.DisplayOrder = 105  -- über HUD (50), unter Dialogue (100), Settings (120)
	screenGui.Parent = playerGui

	-- Backdrop
	local backdrop = Instance.new("Frame")
	backdrop.Size = UDim2.new(1, 0, 1, 0)
	backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	backdrop.BackgroundTransparency = 0.4
	backdrop.BorderSizePixel = 0
	backdrop.Parent = screenGui

	-- Modal
	local modal = Instance.new("Frame")
	modal.Name = "DetailModal"
	modal.Size = UDim2.new(0, 520, 0, 480)
	modal.Position = UDim2.new(0.5, -260, 0.5, -240)  -- zentriert
	modal.BackgroundColor3 = QuestDetailController.Theme.BackgroundColor
	modal.BackgroundTransparency = QuestDetailController.Theme.BackgroundTransparency
	modal.BorderSizePixel = 0
	modal.Parent = screenGui
	makeUICorner(modal)
	local stroke = Instance.new("UIStroke")
	stroke.Color = QuestDetailController.Theme.BorderColor
	stroke.Thickness = QuestDetailController.Theme.BorderThickness
	stroke.Parent = modal

	-- Slide-In-Scale-Animation (von 0.8 zu 1.0)
	modal.Size = UDim2.new(0, 0, 0, 0)
	TweenService:Create(modal,
		TweenInfo.new(QuestDetailController.Theme.TweenDuration,
			Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{ Size = UDim2.new(0, 520, 0, 480) }):Play()

	-- Close-Button
	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 44, 0, 44)
	closeBtn.Position = UDim2.new(1, -52, 0, 8)
	closeBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
	closeBtn.BorderSizePixel = 0
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 20
	closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeBtn.Text = "✕"
	closeBtn.Parent = modal
	makeUICorner(closeBtn, UDim.new(0, 8))
	closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

	if not quest then
		-- Show "all quests" list (from OnMoreClicked)
		local header = Instance.new("TextLabel")
		header.Size = UDim2.new(1, -32, 0, 50)
		header.Position = UDim2.new(0, 16, 0, 16)
		header.BackgroundTransparency = 1
		header.Font = Enum.Font.GothamBold
		header.TextSize = 22
		header.TextColor3 = QuestDetailController.Theme.HeaderColor
		header.TextXAlignment = Enum.TextXAlignment.Left
		header.Text = "📜 " .. Localization:GetString(player, "ui.quest.detail.title", {})
		header.Parent = modal

		local body = Instance.new("TextLabel")
		body.Size = UDim2.new(1, -32, 0, 200)
		body.Position = UDim2.new(0, 16, 0, 76)
		body.BackgroundTransparency = 1
		body.Font = Enum.Font.Gotham
		body.TextSize = 14
		body.TextColor3 = QuestDetailController.Theme.BodyColor
		body.TextWrapped = true
		body.TextXAlignment = Enum.TextXAlignment.Left
		body.TextYAlignment = Enum.TextYAlignment.Top
		body.Text = Localization:GetString(player, "ui.quest.detail.coming_soon", {})
		body.Parent = modal
		return screenGui
	end

	-- ============================================================
	-- Specific-Quest-Detail
	-- ============================================================

	-- Header (Quest-Title)
	local header = Instance.new("TextLabel")
	header.Size = UDim2.new(1, -80, 0, 50)
	header.Position = UDim2.new(0, 16, 0, 16)
	header.BackgroundTransparency = 1
	header.Font = Enum.Font.GothamBold
	header.TextSize = 22
	header.TextColor3 = QuestDetailController.Theme.HeaderColor
	header.TextXAlignment = Enum.TextXAlignment.Left
	header.Text = Localization:GetString(player, quest.title_key, {}) or quest.id
	header.Parent = modal

	-- Description
	local descLabel = Instance.new("TextLabel")
	descLabel.Size = UDim2.new(1, -32, 0, 60)
	descLabel.Position = UDim2.new(0, 16, 0, 70)
	descLabel.BackgroundTransparency = 1
	descLabel.Font = Enum.Font.Gotham
	descLabel.TextSize = 13
	descLabel.TextColor3 = Color3.fromRGB(180, 200, 220)
	descLabel.TextWrapped = true
	descLabel.TextXAlignment = Enum.TextXAlignment.Left
	descLabel.TextYAlignment = Enum.TextYAlignment.Top
	descLabel.Text = Localization:GetString(player, quest.description_key, {})
	descLabel.Parent = modal

	-- Steps-Section
	local stepsHeader = Instance.new("TextLabel")
	stepsHeader.Size = UDim2.new(1, -32, 0, 24)
	stepsHeader.Position = UDim2.new(0, 16, 0, 140)
	stepsHeader.BackgroundTransparency = 1
	stepsHeader.Font = Enum.Font.GothamBold
	stepsHeader.TextSize = 14
	stepsHeader.TextColor3 = QuestDetailController.Theme.Accent
	stepsHeader.TextXAlignment = Enum.TextXAlignment.Left
	stepsHeader.Text = "▶ " .. Localization:GetString(player, "ui.quest.detail.steps", {})
	stepsHeader.Parent = modal

	-- Steps-Liste
	for i, step in ipairs(quest.steps) do
		local stepRow = Instance.new("Frame")
		stepRow.Size = UDim2.new(1, -32, 0, 28)
		stepRow.Position = UDim2.new(0, 16, 0, 170 + (i - 1) * 32)
		stepRow.BackgroundTransparency = 1
		stepRow.Parent = modal

		-- Step-Number
		local numLabel = Instance.new("TextLabel")
		numLabel.Size = UDim2.new(0, 28, 1, 0)
		numLabel.Position = UDim2.new(0, 0, 0, 0)
		numLabel.BackgroundColor3 = QuestDetailController.Theme.Accent
		numLabel.BackgroundTransparency = 0.3
		numLabel.BorderSizePixel = 0
		numLabel.Font = Enum.Font.GothamBold
		numLabel.TextSize = 12
		numLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		numLabel.Text = tostring(i)
		numLabel.Parent = stepRow
		makeUICorner(numLabel, UDim.new(1, 0))

		-- Step-Description
		local descText = string.format("%s (%s)",
			step.type:sub(1, 1):upper() .. step.type:sub(2),
			step.target)
		local stepDesc = Instance.new("TextLabel")
		stepDesc.Size = UDim2.new(1, -36, 1, 0)
		stepDesc.Position = UDim2.new(0, 36, 0, 0)
		stepDesc.BackgroundTransparency = 1
		stepDesc.Font = Enum.Font.Gotham
		stepDesc.TextSize = 13
		stepDesc.TextColor3 = QuestDetailController.Theme.BodyColor
		stepDesc.TextXAlignment = Enum.TextXAlignment.Left
		stepDesc.Text = descText
		stepDesc.Parent = stepRow
	end

	-- Rewards-Section
	local rewardsY = 170 + #quest.steps * 32 + 16
	local rewardsHeader = Instance.new("TextLabel")
	rewardsHeader.Size = UDim2.new(1, -32, 0, 24)
	rewardsHeader.Position = UDim2.new(0, 16, 0, rewardsY)
	rewardsHeader.BackgroundTransparency = 1
	rewardsHeader.Font = Enum.Font.GothamBold
	rewardsHeader.TextSize = 14
	rewardsHeader.TextColor3 = QuestDetailController.Theme.Accent
	rewardsHeader.TextXAlignment = Enum.TextXAlignment.Left
	rewardsHeader.Text = "🎁 " .. Localization:GetString(player, "ui.quest.detail.rewards", {})
	rewardsHeader.Parent = modal

	-- Rewards-Liste
	for i, reward in ipairs(quest.rewards or {}) do
		local rewardRow = Instance.new("Frame")
		rewardRow.Size = UDim2.new(1, -32, 0, 28)
		rewardRow.Position = UDim2.new(0, 16, 0, rewardsY + 24 + (i - 1) * 28)
		rewardRow.BackgroundTransparency = 1
		rewardRow.Parent = modal

		local rewardText = ""
		local rewardColor = QuestDetailController.Theme.BodyColor
		if reward.type == "Gold" then
			rewardText = string.format("💰 %d %s", reward.amount or 0,
				Localization:GetString(player, "ui.hud.gold", {}))
			rewardColor = QuestDetailController.Theme.RewardGold
		elseif reward.type == "Gems" then
			rewardText = string.format("💎 %d %s", reward.amount or 0,
				Localization:GetString(player, "ui.hud.gems", {}))
			rewardColor = QuestDetailController.Theme.RewardGems
		elseif reward.type == "Companion" or reward.type == "Companion_Skin" then
			rewardText = "🐾 " .. (reward.item or "?")
		elseif reward.type == "Photo_Filter" then
			rewardText = "📷 " .. (reward.item or "?")
		else
			rewardText = (reward.type or "?") .. ": " .. (reward.item or tostring(reward.amount))
		end

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.GothamBold
		label.TextSize = 13
		label.TextColor3 = rewardColor
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Text = rewardText
		label.Parent = rewardRow
	end

	-- Backdrop-Click schließt (optional)
	backdrop.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			screenGui:Destroy()
		end
	end)

	return screenGui
end

-- ============================================================
-- Public API
-- ============================================================

function QuestDetailController:Init(player: Player)
	local player = player or Players.LocalPlayer
	if not player then
		Log:Warn("[QuestDetailController] No local player available")
		return
	end

	local remote = ReplicatedStorage:FindFirstChild("QuestDetailRemote")
	if not remote then
		Log:Warn("[QuestDetailController] QuestDetailRemote not found, retrying in 1s...")
		task.delay(1, function() QuestDetailController:Init(player) end)
		return
	end

	remote.OnClientEvent:Connect(function(questId, mode)
		if mode == "show_all" then
			Log:Info("[QuestDetailController] Showing all-quests view")
			showQuestDetail(player, nil)
		else
			Log:Info("[QuestDetailController] Showing quest: " .. tostring(questId))
			showQuestDetail(player, questId)
		end
	end)

	Log:Info("[QuestDetailController] Initialized for " .. player.Name)
end

return QuestDetailController