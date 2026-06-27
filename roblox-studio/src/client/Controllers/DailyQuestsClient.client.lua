--!strict
--[[
	DailyQuestsClient.client.lua — Client-UI für Tagesaufgaben
	===========================================================

	User Story:
	  Als Spieler:in möchte ich, wenn ich auf den QuestBoard klicke,
	  ein Modal mit meinen 3 Tagesaufgaben sehen, mit Titel, Belohnung
	  und "Annehmen"-Button — damit ich weiß, was heute zu tun ist.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Log = require(ReplicatedStorage.Shared.Util.Log)
local Localization = require(ReplicatedStorage.Shared.Modules.M15_Localization)

local DailyQuestsClient = {}

DailyQuestsClient.Theme = {
	BackdropColor = Color3.fromRGB(0, 0, 0),
	BackdropTransparency = 0.5,
	ModalBackground = Color3.fromRGB(25, 28, 35),
	CardBackground = Color3.fromRGB(40, 45, 55),
	CardBorder = Color3.fromRGB(180, 200, 220),
	Accent = Color3.fromRGB(120, 200, 240),
	GoldColor = Color3.fromRGB(255, 220, 110),
	CornerRadius = UDim.new(0, 12),
	TweenDuration = 0.25,
}

local function makeUICorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = radius or DailyQuestsClient.Theme.CornerRadius
	c.Parent = parent
end

-- ============================================================
-- Show Daily-Quests Modal
-- ============================================================

local function showDailyQuests(player, quests)
	local playerGui = player:FindFirstChild("PlayerGui")
	if not playerGui then return end

	-- Cleanup
	local existing = playerGui:FindFirstChild("CurioDailyQuests")
	if existing then existing:Destroy() end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "CurioDailyQuests"
	screenGui.ResetOnSpawn = false
	screenGui.DisplayOrder = 115
	screenGui.Parent = playerGui

	-- Backdrop
	local backdrop = Instance.new("Frame")
	backdrop.Size = UDim2.new(1, 0, 1, 0)
	backdrop.BackgroundColor3 = DailyQuestsClient.Theme.BackdropColor
	backdrop.BackgroundTransparency = DailyQuestsClient.Theme.BackdropTransparency
	backdrop.BorderSizePixel = 0
	backdrop.Parent = screenGui

	-- Modal
	local modal = Instance.new("Frame")
	modal.Name = "DailyQuestsModal"
	modal.Size = UDim2.new(0, 540, 0, 460)
	modal.AnchorPoint = Vector2.new(0.5, 0.5)
	modal.Position = UDim2.new(0.5, 0, 0.5, 0)
	modal.BackgroundColor3 = DailyQuestsClient.Theme.ModalBackground
	modal.BorderSizePixel = 0
	modal.BackgroundTransparency = 1
	modal.Parent = screenGui
	makeUICorner(modal, UDim.new(0, 16))

	-- Slide-In
	task.defer(function()
		if not modal or not modal.Parent then return end
		local scale = modal:FindFirstChildOfClass("UIScale")
		if not scale then
			scale = Instance.new("UIScale")
			scale.Parent = modal
		end
		scale.Scale = 0.85
		TweenService:Create(modal,
			TweenInfo.new(DailyQuestsClient.Theme.TweenDuration * 2,
				Enum.EasingStyle.Back, Enum.EasingDirection.Out),
			{ BackgroundTransparency = 0.05 }):Play()
		TweenService:Create(scale,
			TweenInfo.new(DailyQuestsClient.Theme.TweenDuration * 2,
				Enum.EasingStyle.Back, Enum.EasingDirection.Out),
			{ Scale = 1.0 }):Play()
	end)

	-- Header
	local header = Instance.new("TextLabel")
	header.Size = UDim2.new(1, -80, 0, 50)
	header.Position = UDim2.new(0, 20, 0, 16)
	header.BackgroundTransparency = 1
	header.Font = Enum.Font.GothamBold
	header.TextSize = 22
	header.TextColor3 = Color3.fromRGB(245, 245, 250)
	header.TextXAlignment = Enum.TextXAlignment.Left
	header.Text = "📜 " .. Localization:GetString(player, "ui.daily.title", {})
	header.Parent = modal

	-- Subheader (Date)
	local dateLabel = Instance.new("TextLabel")
	dateLabel.Size = UDim2.new(1, -80, 0, 20)
	dateLabel.Position = UDim2.new(0, 20, 0, 48)
	dateLabel.BackgroundTransparency = 1
	dateLabel.Font = Enum.Font.Gotham
	dateLabel.TextSize = 12
	dateLabel.TextColor3 = Color3.fromRGB(180, 200, 220)
	dateLabel.TextXAlignment = Enum.TextXAlignment.Left
	dateLabel.Text = os.date("%A, %d %B %Y")
	dateLabel.Parent = modal

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

	-- Quest-Liste
	for i, quest in ipairs(quests) do
		local card = Instance.new("Frame")
		card.Size = UDim2.new(1, -40, 0, 110)
		card.Position = UDim2.new(0, 20, 0, 80 + (i - 1) * 120)
		card.BackgroundColor3 = DailyQuestsClient.Theme.CardBackground
		card.BorderSizePixel = 0
		card.Parent = modal
		makeUICorner(card, UDim.new(0, 8))
		local stroke = Instance.new("UIStroke")
		stroke.Color = DailyQuestsClient.Theme.CardBorder
		stroke.Thickness = 1
		stroke.Transparency = 0.6
		stroke.Parent = card

		-- Emoji
		local emoji = Instance.new("TextLabel")
		emoji.Size = UDim2.new(0, 60, 0, 60)
		emoji.Position = UDim2.new(0, 12, 0, 12)
		emoji.BackgroundTransparency = 1
		emoji.Font = Enum.Font.GothamBold
		emoji.TextSize = 40
		emoji.Text = quest.emoji or "📜"
		emoji.Parent = card

		-- Title
		local title = Instance.new("TextLabel")
		title.Size = UDim2.new(1, -100, 0, 24)
		title.Position = UDim2.new(0, 80, 0, 12)
		title.BackgroundTransparency = 1
		title.Font = Enum.Font.GothamBold
		title.TextSize = 14
		title.TextColor3 = Color3.fromRGB(245, 245, 250)
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.Text = Localization:GetString(player, quest.title_key, {})
		title.Parent = card

		-- Description
		local desc = Instance.new("TextLabel")
		desc.Size = UDim2.new(1, -100, 0, 36)
		desc.Position = UDim2.new(0, 80, 0, 36)
		desc.BackgroundTransparency = 1
		desc.Font = Enum.Font.Gotham
		desc.TextSize = 12
		desc.TextColor3 = Color3.fromRGB(180, 200, 220)
		desc.TextWrapped = true
		desc.TextXAlignment = Enum.TextXAlignment.Left
		desc.TextYAlignment = Enum.TextYAlignment.Top
		desc.Text = Localization:GetString(player, quest.desc_key, {})
		desc.Parent = card

		-- Reward
		local rewardText = ""
		for _, r in ipairs(quest.rewards or {}) do
			if r.type == "Gold" then
				rewardText = rewardText .. " 💰" .. (r.amount or 0)
			elseif r.type == "Gems" then
				rewardText = rewardText .. " 💎" .. (r.amount or 0)
			end
		end
		local reward = Instance.new("TextLabel")
		reward.Size = UDim2.new(0, 200, 0, 22)
		reward.Position = UDim2.new(0, 80, 0, 78)
		reward.BackgroundTransparency = 1
		reward.Font = Enum.Font.GothamBold
		reward.TextSize = 13
		reward.TextColor3 = DailyQuestsClient.Theme.GoldColor
		reward.TextXAlignment = Enum.TextXAlignment.Left
		reward.Text = rewardText
		reward.Parent = card

		-- Accept-Button
		local acceptBtn = Instance.new("TextButton")
		acceptBtn.Size = UDim2.new(0, 100, 0, 32)
		acceptBtn.Position = UDim2.new(1, -120, 0, 38)
		acceptBtn.BackgroundColor3 = DailyQuestsClient.Theme.Accent
		acceptBtn.BorderSizePixel = 0
		acceptBtn.Font = Enum.Font.GothamBold
		acceptBtn.TextSize = 13
		acceptBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		acceptBtn.Text = Localization:GetString(player, "ui.dialogue.accept", {})
		acceptBtn.Parent = card
		makeUICorner(acceptBtn, UDim.new(0, 6))

		acceptBtn.MouseButton1Click:Connect(function()
			Log:Info(("[DailyQuestsClient] Accepted: %s"):format(quest.id))
			-- Visuelles Feedback
			TweenService:Create(acceptBtn,
				TweenInfo.new(0.15, Enum.EasingStyle.Quad),
				{ BackgroundColor3 = Color3.fromRGB(80, 200, 120) }):Play()
			acceptBtn.Text = "✓"
			task.delay(0.5, function()
				if acceptBtn.Parent then
					acceptBtn.Text = Localization:GetString(player, "ui.dialogue.accept", {})
				end
			end)
		end)
	end

	-- Backdrop closes
	backdrop.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			screenGui:Destroy()
		end
	end)
end

-- ============================================================
-- Init
-- ============================================================

function DailyQuestsClient:Init(player: Player)
	local player = player or Players.LocalPlayer
	if not player then
		Log:Warn("[DailyQuestsClient] No local player")
		return
	end

	local remote = ReplicatedStorage:FindFirstChild("MapInteractionRemotes")
		and ReplicatedStorage.MapInteractionRemotes:FindFirstChild("ShowDailyQuests")
	if not remote then
		Log:Warn("[DailyQuestsClient] ShowDailyQuests remote not found")
		return
	end

	remote.OnClientEvent:Connect(function(quests)
		showDailyQuests(player, quests or {})
	end)

	Log:Info("[DailyQuestsClient] Initialized")
end

return DailyQuestsClient