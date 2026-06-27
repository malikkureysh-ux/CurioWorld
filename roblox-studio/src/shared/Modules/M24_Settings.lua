--!strict
--[[
	M24_Settings.lua — Premium Settings-UI
	======================================

	User Story:
	  Als Spieler:in möchte ich ein Einstellungs-Menü öffnen können, in
	  dem ich Sound-Lautstärke, Sprache, Accessibility-Optionen (Bewegung,
	  Kontrast, Animation-Geschwindigkeit) einstellen kann, damit ich das
	  Spiel an meine Bedürfnisse anpassen kann.

	Premium-Anforderungen:
	- Modal-Design mit Backdrop
	- Slider + Dropdown + Toggle pro Option
	- Save/Apply-Button
	- Settings persistieren via DataStore (in Phase 3)
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local Log = require(ReplicatedStorage.Shared.Util.Log)

local M24_Settings = {}

M24_Settings.Theme = {
	Backdrop = Color3.fromRGB(0, 0, 0),
	BackdropTransparency = 0.5,
	ModalBackground = Color3.fromRGB(30, 33, 42),
	CornerRadius = UDim.new(0, 16),
	SectionColor = Color3.fromRGB(50, 55, 70),
	Primary = Color3.fromRGB(120, 200, 240),
	TextColor = Color3.fromRGB(245, 245, 250),
	LabelColor = Color3.fromRGB(180, 200, 220),
}

-- Default-Settings
M24_Settings.Defaults = {
	VolumeMaster = 1.0,
	VolumeMusic = 0.5,
	VolumeSFX = 0.7,
	Language = "de",  -- DE/EN/ES/FR/TR/HI/ZH/JA/AR
	AnimationsEnabled = true,
	HighContrast = false,
	ReducedMotion = false,
	ChatEnabled = true,
}

-- ============================================================
-- UI-Builder Helpers
-- ============================================================

local function makeUICorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = radius or M24_Settings.Theme.CornerRadius
	c.Parent = parent
end

local function makeSlider(parent, label, initialValue, callback)
	-- Frame mit Label + Slider-Track + Slider-Fill
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 50)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local labelText = Instance.new("TextLabel")
	labelText.Size = UDim2.new(0.4, 0, 1, 0)
	labelText.BackgroundTransparency = 1
	labelText.Font = Enum.Font.Gotham
	labelText.TextSize = 13
	labelText.TextColor3 = M24_Settings.Theme.LabelColor
	labelText.TextXAlignment = Enum.TextXAlignment.Left
	labelText.Text = label
	labelText.Parent = container

	-- Slider-Track
	local track = Instance.new("Frame")
	track.Size = UDim2.new(0.55, 0, 0, 8)
	track.Position = UDim2.new(0.42, 0, 0.5, -4)
	track.BackgroundColor3 = M24_Settings.Theme.SectionColor
	track.BorderSizePixel = 0
	track.Parent = container
	makeUICorner(track, UDim.new(0, 4))

	-- Fill
	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(initialValue, 0, 1, 0)
	fill.BackgroundColor3 = M24_Settings.Theme.Primary
	fill.BorderSizePixel = 0
	fill.Parent = track
	makeUICorner(fill, UDim.new(0, 4))

	-- Knob
	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 16, 0, 16)
	knob.Position = UDim2.new(initialValue, -8, 0.5, -8)
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.BorderSizePixel = 0
	knob.Parent = track
	makeUICorner(knob, UDim.new(1, 0))

	local valueLabel = Instance.new("TextLabel")
	valueLabel.Size = UDim2.new(0.05, 0, 1, 0)
	valueLabel.Position = UDim2.new(0.97, 0, 0, 0)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Font = Enum.Font.GothamBold
	valueLabel.TextSize = 12
	valueLabel.TextColor3 = M24_Settings.Theme.TextColor
	valueLabel.Text = tostring(math.floor(initialValue * 100)) .. "%"
	valueLabel.Parent = container

	-- Drag-Logik (vereinfacht: bei Click → Knob-Position)
	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			local mouse = Players.LocalPlayer:GetMouse()
			local updateValue
			updateValue = function()
				local relX = math.clamp((mouse.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
				TweenService:Create(fill, TweenInfo.new(0.1),
				                    { Size = UDim2.new(relX, 0, 1, 0) }):Play()
				TweenService:Create(knob, TweenInfo.new(0.1),
				                    { Position = UDim2.new(relX, -8, 0.5, -8) }):Play()
				valueLabel.Text = tostring(math.floor(relX * 100)) .. "%"
				if callback then callback(relX) end
			end
			updateValue()
			mouse.Move:Connect(function() updateValue() end)
		end
	end)

	return container
end

local function makeDropdown(parent, label, options, initialValue, callback)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 50)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local labelText = Instance.new("TextLabel")
	labelText.Size = UDim2.new(0.4, 0, 1, 0)
	labelText.BackgroundTransparency = 1
	labelText.Font = Enum.Font.Gotham
	labelText.TextSize = 13
	labelText.TextColor3 = M24_Settings.Theme.LabelColor
	labelText.TextXAlignment = Enum.TextXAlignment.Left
	labelText.Text = label
	labelText.Parent = container

	local dropdown = Instance.new("TextButton")
	dropdown.Size = UDim2.new(0.55, 0, 0.6, 0)
	dropdown.Position = UDim2.new(0.42, 0, 0.2, 0)
	dropdown.BackgroundColor3 = M24_Settings.Theme.SectionColor
	dropdown.BorderSizePixel = 0
	dropdown.Font = Enum.Font.GothamBold
	dropdown.TextSize = 13
	dropdown.TextColor3 = M24_Settings.Theme.TextColor
	dropdown.Text = initialValue
	dropdown.Parent = container
	makeUICorner(dropdown, UDim.new(0, 6))

	dropdown.MouseButton1Click:Connect(function()
		-- Cycle through options
		local idx = 0
		for i, opt in ipairs(options) do
			if opt == initialValue then idx = i; break end
		end
		idx = (idx % #options) + 1
		initialValue = options[idx]
		dropdown.Text = initialValue
		if callback then callback(initialValue) end
	end)

	return container
end

local function makeToggle(parent, label, initialValue, callback)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 36)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local labelText = Instance.new("TextLabel")
	labelText.Size = UDim2.new(0.7, 0, 1, 0)
	labelText.BackgroundTransparency = 1
	labelText.Font = Enum.Font.Gotham
	labelText.TextSize = 13
	labelText.TextColor3 = M24_Settings.Theme.LabelColor
	labelText.TextXAlignment = Enum.TextXAlignment.Left
	labelText.Text = label
	labelText.Parent = container

	local toggleBg = Instance.new("Frame")
	toggleBg.Size = UDim2.new(0.2, 0, 0, 24)
	toggleBg.Position = UDim2.new(0.78, 0, 0.5, -12)
	toggleBg.BackgroundColor3 = initialValue
		and M24_Settings.Theme.Primary
		or M24_Settings.Theme.SectionColor
	toggleBg.BorderSizePixel = 0
	toggleBg.Parent = container
	makeUICorner(toggleBg, UDim.new(0, 12))

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 18, 0, 18)
	knob.Position = UDim2.new(initialValue and 1 or 0, -9, 0.5, -9)
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.BorderSizePixel = 0
	knob.Parent = toggleBg
	makeUICorner(knob, UDim.new(1, 0))

	local currentState = initialValue
	toggleBg.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			currentState = not currentState
			TweenService:Create(toggleBg, TweenInfo.new(0.15),
				{ BackgroundColor3 = currentState and M24_Settings.Theme.Primary
				                   or M24_Settings.Theme.SectionColor }):Play()
			TweenService:Create(knob, TweenInfo.new(0.15),
				{ Position = UDim2.new(currentState and 1 or 0, -9, 0.5, -9) }):Play()
			if callback then callback(currentState) end
		end
	end)

	return container
end

-- ============================================================
-- Public API
-- ============================================================

function M24_Settings:Show(player: Player)
	local playerGui = player:WaitForChild("PlayerGui")
	local existing = playerGui:FindFirstChild("CurioSettings")
	if existing then existing:Destroy() end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "CurioSettings"
	screenGui.ResetOnSpawn = false
	screenGui.DisplayOrder = 120
	screenGui.Parent = playerGui

	-- Backdrop
	local backdrop = Instance.new("Frame")
	backdrop.Size = UDim2.new(1, 0, 1, 0)
	backdrop.BackgroundColor3 = M24_Settings.Theme.Backdrop
	backdrop.BackgroundTransparency = M24_Settings.Theme.BackdropTransparency
	backdrop.BorderSizePixel = 0
	backdrop.Parent = screenGui

	-- Modal
	local modal = Instance.new("Frame")
	modal.Name = "SettingsModal"
	modal.Size = UDim2.new(0.55, 0, 0.7, 0)
	modal.Position = UDim2.new(0.225, 0, 0.15, 0)
	modal.BackgroundColor3 = M24_Settings.Theme.ModalBackground
	modal.BorderSizePixel = 0
	modal.Parent = screenGui
	makeUICorner(modal, UDim.new(0, 16))

	-- Header
	local header = Instance.new("TextLabel")
	header.Size = UDim2.new(1, 0, 0, 50)
	header.BackgroundTransparency = 1
	header.Font = Enum.Font.GothamBold
	header.TextSize = 24
	header.TextColor3 = M24_Settings.Theme.TextColor
	header.Text = "⚙️ Einstellungen"
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

	-- Sections-Container (Scrollable in Phase 3)
	local sections = Instance.new("ScrollingFrame")
	sections.Name = "Sections"
	sections.Size = UDim2.new(1, -32, 1, -70)
	sections.Position = UDim2.new(0, 16, 0, 60)
	sections.BackgroundTransparency = 1
	sections.ScrollBarThickness = 4
	sections.CanvasSize = UDim2.new(0, 0, 0, 700)
	sections.Parent = modal

	local list = Instance.new("UIListLayout")
	list.Padding = UDim.new(0, 12)
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Parent = sections

	-- Audio-Section
	local audioSection = Instance.new("TextLabel")
	audioSection.Size = UDim2.new(1, 0, 0, 30)
	audioSection.BackgroundTransparency = 1
	audioSection.Font = Enum.Font.GothamBold
	audioSection.TextSize = 16
	audioSection.TextColor3 = M24_Settings.Theme.Primary
	audioSection.TextXAlignment = Enum.TextXAlignment.Left
	audioSection.Text = "🔊 Audio"
	audioSection.LayoutOrder = 1
	audioSection.Parent = sections

	makeSlider(sections, "Master-Lautstärke",
		M24_Settings.Defaults.VolumeMaster,
		function(v) M24_Settings.Defaults.VolumeMaster = v end).LayoutOrder = 2

	makeSlider(sections, "Musik-Lautstärke",
		M24_Settings.Defaults.VolumeMusic,
		function(v) M24_Settings.Defaults.VolumeMusic = v end).LayoutOrder = 3

	makeSlider(sections, "SFX-Lautstärke",
		M24_Settings.Defaults.VolumeSFX,
		function(v) M24_Settings.Defaults.VolumeSFX = v end).LayoutOrder = 4

	-- Language-Section
	local langSection = Instance.new("TextLabel")
	langSection.Size = UDim2.new(1, 0, 0, 30)
	langSection.BackgroundTransparency = 1
	langSection.Font = Enum.Font.GothamBold
	langSection.TextSize = 16
	langSection.TextColor3 = M24_Settings.Theme.Primary
	langSection.TextXAlignment = Enum.TextXAlignment.Left
	langSection.Text = "🌍 Sprache"
	langSection.LayoutOrder = 5
	langSection.Parent = sections

	makeDropdown(sections, "Anzeigesprache",
		{ "de", "en", "es", "fr", "tr", "hi", "zh", "ja", "ar" },
		M24_Settings.Defaults.Language,
		function(v) M24_Settings.Defaults.Language = v end).LayoutOrder = 6

	-- Accessibility-Section
	local accSection = Instance.new("TextLabel")
	accSection.Size = UDim2.new(1, 0, 0, 30)
	accSection.BackgroundTransparency = 1
	accSection.Font = Enum.Font.GothamBold
	accSection.TextSize = 16
	accSection.TextColor3 = M24_Settings.Theme.Primary
	accSection.TextXAlignment = Enum.TextXAlignment.Left
	accSection.Text = "♿ Barrierefreiheit"
	accSection.LayoutOrder = 7
	accSection.Parent = sections

	makeToggle(sections, "Animationen aktiv",
		M24_Settings.Defaults.AnimationsEnabled,
		function(v) M24_Settings.Defaults.AnimationsEnabled = v end).LayoutOrder = 8

	makeToggle(sections, "Hoher Kontrast",
		M24_Settings.Defaults.HighContrast,
		function(v) M24_Settings.Defaults.HighContrast = v end).LayoutOrder = 9

	makeToggle(sections, "Reduzierte Bewegung",
		M24_Settings.Defaults.ReducedMotion,
		function(v) M24_Settings.Defaults.ReducedMotion = v end).LayoutOrder = 10

	-- Backdrop closes
	backdrop.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			screenGui:Destroy()
		end
	end)

	Log:Info("[M24] Settings opened for " .. player.Name)
	return screenGui
end

return M24_Settings
