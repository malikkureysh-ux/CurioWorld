--!strict
--[[
	M20_Shop.lua — Premium Shop-UI
	===============================

	User Story:
	  Als Spieler:in möchte ich im Shop zwischen Items wählen, die
	  Preise sehen (Gold oder Robux) und kaufen, mit VIP-only-Badges,
	  damit ich mein hart verdientes Geld sinnvoll ausgeben kann.

	Premium-Anforderungen:
	- Item-Grid (3 Spalten)
	- Hover-Effekt (Item vergrößert sich leicht)
	- Preis-Tag mit GoldIcon/RobuxIcon
	- VIP-only-Badge für VIP-Items
	- Sound-Effekt beim Kauf (TODO Phase 3)
	- Sanfte Item-Appearance-Animation
]]

local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Log = require(ReplicatedStorage.Shared.Util.Log)
local M07_Economy = require(ReplicatedStorage.Shared.Modules.M07_Economy)
local Localization = require(ReplicatedStorage.Shared.Modules.M15_Localization)

local M20_Shop = {}

M20_Shop.Theme = {
	BackgroundColor = Color3.fromRGB(25, 28, 35),
	ItemIdle = Color3.fromRGB(50, 55, 70),
	ItemHover = Color3.fromRGB(70, 90, 120),
	ItemAffordable = Color3.fromRGB(80, 130, 90),
	ItemUnaffordable = Color3.fromRGB(120, 60, 60),
	VIPBadge = Color3.fromRGB(255, 180, 60),
	CornerRadius = UDim.new(0, 10),
	TweenDuration = 0.2,
	GridColumns = 3,
}

-- Item-Definition (in Phase 3 aus DataStore geladen)
M20_Shop.SampleItems = {
	{
		id = "skin_red",
		name_key = "shop.skin_red.name",
		description_key = "shop.skin_red.description",
		icon = "🔴",
		price_gold = 500,
		price_robux = nil,
		vip_only = false,
	},
	{
		id = "pet_seagull",
		name_key = "shop.pet_seagull.name",
		description_key = "shop.pet_seagull.description",
		icon = "🐦",
		price_gold = 1500,
		price_robux = nil,
		vip_only = false,
	},
	{
		id = "vip_pass_30d",
		name_key = "shop.vip_pass.name",
		description_key = "shop.vip_pass.description",
		icon = "⭐",
		price_gold = nil,
		price_robux = 99,
		vip_only = false,
	},
	{
		id = "skin_golden",
		name_key = "shop.skin_golden.name",
		description_key = "shop.skin_golden.description",
		icon = "🌟",
		price_gold = 5000,
		price_robux = nil,
		vip_only = true,
	},
	{
		id = "filter_maritime",
		name_key = "shop.filter_maritime.name",
		description_key = "shop.filter_maritime.description",
		icon = "📷",
		price_gold = 200,
		price_robux = nil,
		vip_only = false,
	},
	{
		id = "skin_sailor",
		name_key = "shop.skin_sailor.name",
		description_key = "shop.skin_sailor.description",
		icon = "⚓",
		price_gold = 1200,
		price_robux = nil,
		vip_only = false,
	},
}

local function makeUICorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = radius or M20_Shop.Theme.CornerRadius
	c.Parent = parent
end

local function makeItemCard(parent, item, playerGold, playerIsVip)
	local card = Instance.new("Frame")
	card.Name = "ItemCard_" .. item.id
	card.Size = UDim2.new(1 / M20_Shop.Theme.GridColumns, -8, 0, 110)
	card.BackgroundColor3 = M20_Shop.Theme.ItemIdle
	card.BorderSizePixel = 0
	card.Parent = parent
	makeUICorner(card)

	local canAfford = (item.price_gold and playerGold >= item.price_gold) or (item.price_robux and playerIsVip)
	card.BackgroundColor3 = canAfford and M20_Shop.Theme.ItemAffordable
		or M20_Shop.Theme.ItemUnaffordable

	-- Icon
	local iconLabel = Instance.new("TextLabel")
	iconLabel.Size = UDim2.new(1, 0, 0, 50)
	iconLabel.Position = UDim2.new(0, 0, 0, 8)
	iconLabel.BackgroundTransparency = 1
	iconLabel.Font = Enum.Font.GothamBold
	iconLabel.TextSize = 36
	iconLabel.Text = item.icon
	iconLabel.Parent = card

	-- Name
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, -8, 0, 18)
	nameLabel.Position = UDim2.new(0, 4, 0, 56)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextSize = 11
	nameLabel.TextColor3 = Color3.fromRGB(245, 245, 250)
	nameLabel.TextScaled = true
	nameLabel.Text = Localization:T(item.name_key) or item.id
	nameLabel.Parent = card

	-- Price
	local priceText = ""
	if item.price_gold then
		priceText = string.format("💰 %d", item.price_gold)
	elseif item.price_robux then
		priceText = string.format("R$ %d", item.price_robux)
	end
	local priceLabel = Instance.new("TextLabel")
	priceLabel.Size = UDim2.new(1, -8, 0, 18)
	priceLabel.Position = UDim2.new(0, 4, 0, 76)
	priceLabel.BackgroundTransparency = 1
	priceLabel.Font = Enum.Font.Gotham
	priceLabel.TextSize = 11
	priceLabel.TextColor3 = Color3.fromRGB(255, 220, 110)
	priceLabel.Text = priceText
	priceLabel.Parent = card

	-- VIP-Badge
	if item.vip_only then
		local badge = Instance.new("TextLabel")
		badge.Name = "VIPBadge"
		badge.Size = UDim2.new(0, 32, 0, 14)
		badge.Position = UDim2.new(1, -36, 0, 4)
		badge.BackgroundColor3 = M20_Shop.Theme.VIPBadge
		badge.BorderSizePixel = 0
		badge.Font = Enum.Font.GothamBold
		badge.TextSize = 9
		badge.TextColor3 = Color3.fromRGB(40, 30, 10)
		badge.Text = "VIP"
		badge.Parent = card
		makeUICorner(badge, UDim.new(0, 4))
	end

	-- Hover
	card.MouseEnter:Connect(function()
		TweenService:Create(card, TweenInfo.new(M20_Shop.Theme.TweenDuration),
		                    { BackgroundColor3 = M20_Shop.Theme.ItemHover }):Play()
	end)
	card.MouseLeave:Connect(function()
		TweenService:Create(card, TweenInfo.new(M20_Shop.Theme.TweenDuration),
		                    { BackgroundColor3 = canAfford and M20_Shop.Theme.ItemAffordable
		                                       or M20_Shop.Theme.ItemUnaffordable }):Play()
	end)

	return card
end

function M20_Shop:Show(player: Player)
	local playerGui = player:WaitForChild("PlayerGui")
	local existing = playerGui:FindFirstChild("CurioShop")
	if existing then existing:Destroy() end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "CurioShop"
	screenGui.ResetOnSpawn = false
	screenGui.DisplayOrder = 110
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
	modal.Name = "ShopModal"
	modal.Size = UDim2.new(0.75, 0, 0.7, 0)
	modal.Position = UDim2.new(0.125, 0, 0.15, 0)
	modal.BackgroundColor3 = M20_Shop.Theme.BackgroundColor
	modal.BorderSizePixel = 0
	modal.Parent = screenGui
	makeUICorner(modal, UDim.new(0, 18))

	-- Header
	local header = Instance.new("TextLabel")
	header.Size = UDim2.new(1, 0, 0, 50)
	header.BackgroundTransparency = 1
	header.Font = Enum.Font.GothamBold
	header.TextSize = 24
	header.TextColor3 = Color3.fromRGB(245, 245, 250)
	header.Text = "🛒 Curio Shop"
	header.Parent = modal

	-- Close-Button
	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 40, 0, 40)
	closeBtn.Position = UDim2.new(1, -50, 0, 5)
	closeBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
	closeBtn.BorderSizePixel = 0
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 20
	closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeBtn.Text = "✕"
	closeBtn.Parent = modal
	makeUICorner(closeBtn)
	closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

	-- Grid
	local grid = Instance.new("Frame")
	grid.Name = "ItemGrid"
	grid.Size = UDim2.new(1, -32, 1, -70)
	grid.Position = UDim2.new(0, 16, 0, 60)
	grid.BackgroundTransparency = 1
	grid.Parent = modal

	local gridLayout = Instance.new("UIGridLayout")
	gridLayout.CellSize = UDim2.new(1 / M20_Shop.Theme.GridColumns, -8, 0, 110)
	gridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
	gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
	gridLayout.Parent = grid

	-- Get player state
	local playerGold = 0
	local playerIsVip = false
	pcall(function()
		local balance = M07_Economy:GetBalance and M07_Economy:GetBalance(player) or nil
		if balance then playerGold = balance.gold or 0 end
	end)

	-- Add items
	for i, item in ipairs(M20_Shop.SampleItems) do
		local card = makeItemCard(grid, item, playerGold, playerIsVip)
		card.LayoutOrder = i
	end

	-- Backdrop closes shop
	backdrop.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			screenGui:Destroy()
		end
	end)

	Log:Info("[M20] Shop opened for " .. player.Name)
	return screenGui
end

return M20_Shop
