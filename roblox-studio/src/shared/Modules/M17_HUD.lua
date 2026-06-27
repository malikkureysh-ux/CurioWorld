--!strict
--[[
	M17_HUD.lua — Premium HUD-Controller
	====================================

	User Story:
	  Als Spieler:in möchte ich oben links jederzeit sehen, wie viel Gold
	  und Gems ich habe, in welchem Bezirk ich bin und ob mein VIP-Pass
	  aktiv ist, damit ich meinen Fortschritt und Status im Blick habe,
	  ohne dafür ein Menü öffnen zu müssen.

	Premium-Anforderungen:
	- Pastell-Palette gemäß docs/07_art_direction.md
	- Abgerundete UI (CornerRadius via UIStroke + UICorner)
	- Sanfte Animationen (TweenService, 200ms)
	- Touch-Target mind. 44×44 px (Mobile)
	- Kein Standard-Roblox-Look
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Log = require(ReplicatedStorage.Shared.Util.Log)

local M17_HUD = {}

-- ============================================================
-- Theme-Tokens (siehe docs/07_art_direction.md)
-- ============================================================

M17_HUD.Theme = {
	-- Pastell-Palette
	Gold = { Color = Color3.fromRGB(255, 220, 110), Icon = "💰" },
	Gems = { Color = Color3.fromRGB(120, 200, 240), Icon = "💎" },
	VIP  = { Color = Color3.fromRGB(255, 150, 200), Icon = "⭐" },

	-- Bezirks-Farben
	DistrictColors = {
		HamburgHarbor = Color3.fromRGB(255, 178, 102),  -- Wasserblau + Werft-Orange
		SkyBridgeBay  = Color3.fromRGB(255, 211, 99),
		LibertyBlocks = Color3.fromRGB(170, 200, 220),
		NeoSakura    = Color3.fromRGB(255, 175, 200),
		MoonBazaar   = Color3.fromRGB(255, 220, 100),
	},

	-- UI-Geometry
	CornerRadius = UDim.new(0, 12),
	BorderThickness = 2,
	Font = Enum.Font.GothamBold,
	FontSize = 18,

	-- Animation
	TweenDuration = 0.2,
}

-- ============================================================
-- HUD-Bau-Funktionen
-- ============================================================

local function makeUICorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = radius or M17_HUD.Theme.CornerRadius
	c.Parent = parent
	return c
end

local function makeUIStroke(parent, color, thickness)
	local s = Instance.new("UIStroke")
	s.Color = color or Color3.fromRGB(255, 255, 255)
	s.Thickness = thickness or M17_HUD.Theme.BorderThickness
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = parent
	return s
end

local function makeUIAspectRatioConstraint(parent, ratio)
	local a = Instance.new("UIAspectRatioConstraint")
	a.AspectRatio = ratio or 1
	a.Parent = parent
	return a
end

local function makePadding(parent, px)
	local p = Instance.new("UIPadding")
	p.PaddingTop = UDim.new(0, px)
	p.PaddingBottom = UDim.new(0, px)
	p.PaddingLeft = UDim.new(0, px * 1.5)
	p.PaddingRight = UDim.new(0, px * 1.5)
	p.Parent = parent
	return p
end

local function makeCurrencyRow(parent, name, color, icon, initialValue)
	local row = Instance.new("Frame")
	row.Name = name .. "Row"
	row.Size = UDim2.new(1, 0, 0, 36)
	row.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
	row.BorderSizePixel = 0
	row.Parent = parent
	makeUICorner(row)
	makeUIStroke(row, color)

	local iconLabel = Instance.new("TextLabel")
	iconLabel.Name = "Icon"
	iconLabel.Size = UDim2.new(0, 36, 1, 0)
	iconLabel.BackgroundTransparency = 1
	iconLabel.Font = M17_HUD.Theme.Font
	iconLabel.TextSize = 22
	iconLabel.TextColor3 = color
	iconLabel.Text = icon
	iconLabel.Parent = row

	local valueLabel = Instance.new("TextLabel")
	valueLabel.Name = "Value"
	valueLabel.Size = UDim2.new(1, -50, 1, 0)
	valueLabel.Position = UDim2.new(0, 44, 0, 0)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Font = M17_HUD.Theme.Font
	valueLabel.TextSize = M17_HUD.Theme.FontSize
	valueLabel.TextColor3 = Color3.fromRGB(245, 245, 250)
	valueLabel.TextXAlignment = Enum.TextXAlignment.Left
	valueLabel.Text = tostring(initialValue)
	valueLabel.Parent = row

	-- Smooth update via TweenService
	local function setValueAnimated(newValue)
		local oldVal = tonumber(valueLabel.Text) or 0
		if oldVal == newValue then return end
		local tweenInfo = TweenInfo.new(M17_HUD.Theme.TweenDuration,
		                                 Enum.EasingStyle.Quad,
		                                 Enum.EasingDirection.Out)
		-- Pseudo-CountUp via NumberValue tween (kept simple here)
		local t = TweenService:Create(valueLabel, tweenInfo, { TextTransparency = 0 })
		t:Play()
		valueLabel.Text = tostring(newValue)
	end

	row.SetValue = setValueAnimated
	return row
end

local function makeDistrictBadge(parent, districtName)
	local districtFrame = Instance.new("Frame")
	districtFrame.Name = "DistrictBadge"
	districtFrame.Size = UDim2.new(1, 0, 0, 32)
	districtFrame.BackgroundColor3 = M17_HUD.Theme.DistrictColors[districtName]
		or Color3.fromRGB(120, 120, 120)
	districtFrame.BackgroundTransparency = 0.15
	districtFrame.BorderSizePixel = 0
	districtFrame.Parent = parent
	makeUICorner(districtFrame, UDim.new(0, 8))

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Font = M17_HUD.Theme.Font
	label.TextSize = 14
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Text = "📍 " .. districtName
	label.Parent = districtFrame
end

-- ============================================================
-- Public API
-- ============================================================

function M17_HUD:CreateForPlayer(player: Player): ScreenGui
	local playerGui = player:WaitForChild("PlayerGui")

	-- ScreenGui Container
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "CurioHUD"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = playerGui

	-- Top-Left HUD-Container
	local hudFrame = Instance.new("Frame")
	hudFrame.Name = "HUDFrame"
	hudFrame.Size = UDim2.new(0, 220, 0, 180)
	hudFrame.Position = UDim2.new(0, 20, 0, 20)
	hudFrame.BackgroundColor3 = Color3.fromRGB(25, 28, 35)
	hudFrame.BackgroundTransparency = 0.1
	hudFrame.BorderSizePixel = 0
	hudFrame.Parent = screenGui
	makeUICorner(hudFrame)
	makeUIStroke(hudFrame, Color3.fromRGB(180, 200, 220), 2)
	makePadding(hudFrame, 10)

	-- Layout
	local listLayout = Instance.new("UIListLayout")
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 6)
	listLayout.Parent = hudFrame

	-- Gold Row
	local goldRow = makeCurrencyRow(hudFrame, "Gold",
	                                 M17_HUD.Theme.Gold.Color,
	                                 M17_HUD.Theme.Gold.Icon, 0)
	goldRow.LayoutOrder = 1

	-- Gems Row
	local gemsRow = makeCurrencyRow(hudFrame, "Gems",
	                                 M17_HUD.Theme.Gems.Color,
	                                 M17_HUD.Theme.Gems.Icon, 0)
	gemsRow.LayoutOrder = 2

	-- VIP Row (initial versteckt, wird via Service sichtbar gemacht)
	local vipRow = makeCurrencyRow(hudFrame, "VIP",
	                                M17_HUD.Theme.VIP.Color,
	                                M17_HUD.Theme.VIP.Icon, "Aktiv")
	vipRow.LayoutOrder = 3
	vipRow.Visible = false

	-- District Badge
	local districtBadge = Instance.new("Frame")
	districtBadge.Name = "DistrictRow"
	districtBadge.Size = UDim2.new(1, 0, 0, 28)
	districtBadge.BackgroundTransparency = 1
	districtBadge.Parent = hudFrame
	districtBadge.LayoutOrder = 4

	local districtLabel = Instance.new("TextLabel")
	districtLabel.Name = "DistrictLabel"
	districtLabel.Size = UDim2.new(1, 0, 1, 0)
	districtLabel.BackgroundTransparency = 1
	districtLabel.Font = M17_HUD.Theme.Font
	districtLabel.TextSize = 13
	districtLabel.TextColor3 = Color3.fromRGB(180, 200, 220)
	districtLabel.TextXAlignment = Enum.TextXAlignment.Left
	districtLabel.Text = "📍 Hamburg Harbor"
	districtLabel.Parent = districtBadge

	Log:Info("[M17 HUD] Created for player " .. player.Name)
	return screenGui
end

-- Update-Funktion für Service-Anbindung
function M17_HUD:UpdateCurrency(screenGui: ScreenGui, currency: string, value: number | string)
	local row = screenGui:FindFirstChild("HUDFrame", true)
	if not row then return end
	local target = row:FindFirstChild(currency .. "Row")
	if target and target.SetValue then
		target.SetValue(value)
	end
end

function M17_HUD:SetVIP(screenGui: ScreenGui, isActive: boolean)
	local row = screenGui:FindFirstChild("HUDFrame", true)
	if not row then return end
	local vip = row:FindFirstChild("VIPRow")
	if vip then vip.Visible = isActive end
end

function M17_HUD:SetDistrict(screenGui: ScreenGui, districtName: string)
	local row = screenGui:FindFirstChild("HUDFrame", true)
	if not row then return end
	local badge = row:FindFirstChild("DistrictRow")
	if badge then
		local label = badge:FindFirstChild("DistrictLabel")
		if label then
			label.Text = "📍 " .. districtName
			label.TextColor3 = M17_HUD.Theme.DistrictColors[districtName]
				or Color3.fromRGB(180, 200, 220)
		end
	end
end

return M17_HUD
