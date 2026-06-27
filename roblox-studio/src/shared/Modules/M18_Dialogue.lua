--!strict
--[[
	M18_Dialogue.lua — Premium Dialogue-UI
	======================================

	User Story:
	  Als Spieler:in möchte ich, wenn ich mit einem NPC spreche, ein
	  schönes Dialog-Fenster mit Portrait und Antwort-Optionen sehen,
	  damit das Gespräch sich hochwertig anfühlt und ich multiple-choice
	  Antworten geben kann.

	Premium-Anforderungen:
	- Modal mit Backdrop (50% Schwarz)
	- NPC-Portrait (Square, links, mit Glow-Ring)
	- NPC-Name + DisplayName
	- Dialogue-Text mit Typewriter-Effekt (optional in Phase 3)
	- 3 Antwort-Buttons mit Hover-States
	- "Weiter"-Pfeil bei nicht-Frage-Dialogen
	- Lokalisierung via M15
	- Sanfte Slide-In-Animation von unten
]]

local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Log = require(ReplicatedStorage.Shared.Util.Log)

local M18_Dialogue = {}

M18_Dialogue.Theme = {
	BackdropColor = Color3.fromRGB(0, 0, 0),
	BackdropTransparency = 0.5,
	ModalBackground = Color3.fromRGB(30, 33, 42),
	ModalCornerRadius = UDim.new(0, 16),
	PortraitSize = UDim2.new(0, 120, 0, 120),
	NameColor = Color3.fromRGB(255, 220, 110),
	TextColor = Color3.fromRGB(245, 245, 250),
	OptionIdle = Color3.fromRGB(60, 65, 78),
	OptionHover = Color3.fromRGB(80, 90, 110),
	OptionSelected = Color3.fromRGB(120, 200, 240),
	TweenDuration = 0.25,
}

-- Per-NPC-Portrait-Icons (statt ein Smiley für alle)
M18_Dialogue.PortraitIcons = {
	Hafenwirtin = "👩‍🍳",
	Yuki        = "🧝‍♀️",
	Maja        = "👩‍🔧",
	Nils        = "🧔",
	Default     = "😊",
}

local function makeUICorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = radius or M18_Dialogue.Theme.ModalCornerRadius
	c.Parent = parent
end

-- ============================================================
-- Public API
-- ============================================================

function M18_Dialogue:Show(player: Player, npcConfig: { [string]: any },
                            dialogueText: string,
                            options: { { text: string, responseKey: string } }?,
                            onOptionSelected: ((responseKey: string, optionIndex: number) -> ())?)
	local playerGui = player:FindFirstChild("PlayerGui")
	if not playerGui then return end

	-- Cleanup existing
	local existing = playerGui:FindFirstChild("CurioDialogue")
	if existing then existing:Destroy() end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "CurioDialogue"
	screenGui.ResetOnSpawn = false
	screenGui.DisplayOrder = 100  -- über HUD
	screenGui.Parent = playerGui

	-- Backdrop
	local backdrop = Instance.new("Frame")
	backdrop.Name = "Backdrop"
	backdrop.Size = UDim2.new(1, 0, 1, 0)
	backdrop.BackgroundColor3 = M18_Dialogue.Theme.BackdropColor
	backdrop.BackgroundTransparency = M18_Dialogue.Theme.BackdropTransparency
	backdrop.BorderSizePixel = 0
	backdrop.Parent = screenGui

	-- Modal (slide-in from bottom)
	local modal = Instance.new("Frame")
	modal.Name = "Modal"
	modal.Size = UDim2.new(0.7, 0, 0, 320)
	modal.Position = UDim2.new(0.15, 0, 1, 0)  -- startet unterhalb
	modal.AnchorPoint = Vector2.new(0, 1)
	modal.BackgroundColor3 = M18_Dialogue.Theme.ModalBackground
	modal.BorderSizePixel = 0
	modal.Parent = screenGui
	makeUICorner(modal)

	-- Slide-In-Animation
	local targetPos = UDim2.new(0.15, 0, 0.85, 0)
	local tweenInfo = TweenInfo.new(M18_Dialogue.Theme.TweenDuration,
	                                 Enum.EasingStyle.Back,
	                                 Enum.EasingDirection.Out)
	TweenService:Create(modal, tweenInfo, { Position = targetPos }):Play()

	-- Portrait (links)
	local portrait = Instance.new("Frame")
	portrait.Name = "Portrait"
	portrait.Size = M18_Dialogue.Theme.PortraitSize
	portrait.Position = UDim2.new(0, 20, 0, 20)
	portrait.BackgroundColor3 = npcConfig.Color or Color3.fromRGB(180, 100, 60)
	portrait.BorderSizePixel = 0
	portrait.Parent = modal
	makeUICorner(portrait, UDim.new(0, 12))

	-- Portrait-Smiley (per-NPC, mit Glow-Ring via UIStroke)
	local portraitIcon = M18_Dialogue.PortraitIcons[npcConfig.NpcId or ""]
		or M18_Dialogue.PortraitIcons.Default
	local face = Instance.new("TextLabel")
	face.Size = UDim2.new(1, 0, 1, 0)
	face.BackgroundTransparency = 1
	face.Font = Enum.Font.GothamBold
	face.TextSize = 60
	face.TextColor3 = Color3.fromRGB(255, 255, 255)
	face.Text = portraitIcon
	face.Parent = portrait

	-- Glow-Ring (Premium-Polish): UIStroke um Portrait
	local portraitStroke = Instance.new("UIStroke")
	portraitStroke.Name = "Glow"
	portraitStroke.Color = Color3.fromRGB(255, 240, 180)  -- warm Glow
	portraitStroke.Thickness = 3
	portraitStroke.Transparency = 0.2
	portraitStroke.Parent = portrait

	-- NPC-Name (oben rechts vom Portrait)
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "NpcName"
	nameLabel.Size = UDim2.new(1, -160, 0, 30)
	nameLabel.Position = UDim2.new(0, 155, 0, 20)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextSize = 22
	nameLabel.TextColor3 = M18_Dialogue.Theme.NameColor
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Text = npcConfig.DisplayName or "NPC"
	nameLabel.Parent = modal

	-- Rolle-Tag
	local roleTag = Instance.new("TextLabel")
	roleTag.Name = "Role"
	roleTag.Size = UDim2.new(0, 100, 0, 20)
	roleTag.Position = UDim2.new(0, 155, 0, 50)
	roleTag.BackgroundColor3 = npcConfig.Color or Color3.fromRGB(80, 80, 80)
	roleTag.BackgroundTransparency = 0.4
	roleTag.BorderSizePixel = 0
	roleTag.Font = Enum.Font.Gotham
	roleTag.TextSize = 12
	roleTag.TextColor3 = Color3.fromRGB(255, 255, 255)
	roleTag.Text = npcConfig.Role or "NPC"
	roleTag.Parent = modal
	makeUICorner(roleTag, UDim.new(0, 6))

	-- Dialogue-Text (mit Typewriter-Effekt)
	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "DialogueText"
	textLabel.Size = UDim2.new(1, -40, 0, 110)
	textLabel.Position = UDim2.new(0, 20, 0, 155)
	textLabel.BackgroundTransparency = 1
	textLabel.Font = Enum.Font.Gotham
	textLabel.TextSize = 16
	textLabel.TextColor3 = M18_Dialogue.Theme.TextColor
	textLabel.TextWrapped = true
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.TextYAlignment = Enum.TextYAlignment.Top
	textLabel.Text = ""  -- leer → Typewriter füllt
	textLabel.Parent = modal

	-- Typewriter-Effekt: Zeichen-für-Zeichen mit Task.spawn
	-- Speed: ~30 chars/sec (lesbar + cinematisch)
	local TypewriterSpeed = 30  -- chars per second
	task.spawn(function()
		if not textLabel or not textLabel.Parent then return end
		local fullText = dialogueText or ""
		-- Skip-Typewriter bei sehr langem Text (z.B. >300 chars)
		if #fullText > 300 then
			textLabel.Text = fullText
			return
		end
		local delayPerChar = 1.0 / TypewriterSpeed
		for i = 1, #fullText do
			if not textLabel or not textLabel.Parent then return end
			-- Skip wenn User auf "Skip"-Button gedrückt (Phase 3)
			textLabel.Text = string.sub(fullText, 1, i)
			task.wait(delayPerChar)
		end
	end)

	-- Antwort-Optionen (oder Weiter-Pfeil)
	local optionsFrame = Instance.new("Frame")
	optionsFrame.Name = "Options"
	optionsFrame.Size = UDim2.new(1, -40, 0, 60)
	optionsFrame.Position = UDim2.new(0, 20, 0, 245)
	optionsFrame.BackgroundTransparency = 1
	optionsFrame.Parent = modal

	local listLayout = Instance.new("UIListLayout")
	listLayout.FillDirection = Enum.FillDirection.Horizontal
	listLayout.Padding = UDim.new(0, 8)
	listLayout.Parent = optionsFrame

	if options and #options > 0 then
		for i, opt in ipairs(options) do
			local btn = Instance.new("TextButton")
			btn.Name = "Option" .. i
			btn.Size = UDim2.new(1 / #options, -8 * (#options - 1), 1, 0)
			btn.BackgroundColor3 = M18_Dialogue.Theme.OptionIdle
			btn.BorderSizePixel = 0
			btn.Font = Enum.Font.GothamBold
			btn.TextSize = 14
			btn.TextColor3 = M18_Dialogue.Theme.TextColor
			btn.TextWrapped = true
			btn.Text = opt.text
			btn.Parent = optionsFrame
			makeUICorner(btn, UDim.new(0, 8))

			-- Hover-State
			btn.MouseEnter:Connect(function()
				TweenService:Create(btn,
					TweenInfo.new(M18_Dialogue.Theme.TweenDuration),
					{ BackgroundColor3 = M18_Dialogue.Theme.OptionHover }):Play()
			end)
			btn.MouseLeave:Connect(function()
				TweenService:Create(btn,
					TweenInfo.new(M18_Dialogue.Theme.TweenDuration),
					{ BackgroundColor3 = M18_Dialogue.Theme.OptionIdle }):Play()
			end)
			btn.MouseButton1Click:Connect(function()
				TweenService:Create(btn,
					TweenInfo.new(M18_Dialogue.Theme.TweenDuration),
					{ BackgroundColor3 = M18_Dialogue.Theme.OptionSelected }):Play()
				Log:Info("[M18] Selected option: " .. tostring(opt.responseKey))

				-- Forward to Quest-Engine / Dialog-Logic
				if onOptionSelected then
					local ok, err = pcall(onOptionSelected, opt.responseKey, i)
					if not ok then
						Log:Warn("[M18] onOptionSelected callback failed: " .. tostring(err))
					end
				end

				-- Slide-out animation
				local slideOut = TweenService:Create(modal,
					TweenInfo.new(M18_Dialogue.Theme.TweenDuration,
						Enum.EasingStyle.Back,
						Enum.EasingDirection.In),
					{ Position = UDim2.new(0.15, 0, 1.2, 0) })
				slideOut:Play()
				slideOut.Completed:Connect(function()
					if screenGui and screenGui.Parent then
						screenGui:Destroy()
					end
				end)
			end)
		end
	else
		-- Weiter-Pfeil
		local nextBtn = Instance.new("TextButton")
		nextBtn.Name = "NextButton"
		nextBtn.Size = UDim2.new(0, 120, 0, 44)
		nextBtn.Position = UDim2.new(1, -140, 0.5, -22)
		nextBtn.BackgroundColor3 = M18_Dialogue.Theme.OptionSelected
		nextBtn.BorderSizePixel = 0
		nextBtn.Font = Enum.Font.GothamBold
		nextBtn.TextSize = 16
		nextBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		nextBtn.Text = "Weiter ▶"
		nextBtn.Parent = optionsFrame
		makeUICorner(nextBtn, UDim.new(0, 10))
		nextBtn.MouseButton1Click:Connect(function()
			screenGui:Destroy()
		end)
	end

	-- Backdrop-Click schließt nicht (force user to choose)
	Log:Info("[M18] Dialogue opened with " .. npcConfig.DisplayName)
	return screenGui
end

function M18_Dialogue:Hide(player: Player)
	local playerGui = player:FindFirstChild("PlayerGui")
	if not playerGui then return end
	local dialogue = playerGui:FindFirstChild("CurioDialogue")
	if dialogue then dialogue:Destroy() end
end

return M18_Dialogue
