--!strict
--[[
	HamburgHarborMap.lua — Workspace-Skeleton für Hamburg Harbor
	============================================================

	Diese Datei definiert die Workspace-Struktur für Hamburg Harbor.
	Wird via Rojo in Roblox Studio synchronisiert.

	Topographie:
	- Hub-Plaza (Eingang, Teleport zu anderen Districts)
	- Hafenbecken (zentraler See mit Kränen)
	- Kran-Bereich (3 Kräne, Highlight-Mechanik)
	- Speicherhaus (Lager, Materialien, Bauquests)
	- Werft (Bootsbau, Werkzeuge)
	- Leuchtturm-Insel (Höhepunkt, Aussicht)

	NPCs (Vertical-Slice-Roster, 4 Rollen):
	- Hafenwirtin Lina (PlazaEntry, main quest giver)
	- Markt-Händlerin Yuki (Speicherhaus, merchant)
	- Bootsbauerin Maja (Werft, crafter)
	- Leuchtturmwächter Nils (Leuchtturm, story)
]]

local HamburgHarbor = {
	Name = "HamburgHarbor",
	Layout = {
		-- ============================================================
		-- Hub-Anbindung (Verbindung zu Sky Plaza)
		-- ============================================================
		{
			Name = "PlazaEntry",
			ClassName = "SpawnLocation",
			Properties = {
				Anchored = true,
				Duration = 0,
				Neutral = true,
				Position = Vector3.new(0, 5, 0),
			},
			Children = {
				{
					Name = "WelcomeSign",
					ClassName = "Part",
					Properties = {
						Anchored = true,
						CanCollide = false,
						Size = Vector3.new(8, 4, 0.5),
						Position = Vector3.new(0, 8, -3),
					},
				},
				{
					Name = "HafenwirtinSpawn",
					ClassName = "Part",
					Properties = {
						Anchored = true,
						CanCollide = false,
						Transparency = 1,
						Size = Vector3.new(1, 2, 1),
						Position = Vector3.new(0, 6, -2),
						Attributes = { NpcId = "Hafenwirtin", Role = "QuestGiver" },
					},
				},
			},
		},

		-- ============================================================
		-- Zentrales Hafenbecken
		-- ============================================================
		{
			Name = "HarborBasin",
			ClassName = "Part",
			Properties = {
				Anchored = true,
				Material = Enum.Material.Water,
				Size = Vector3.new(80, 1, 60),
				Position = Vector3.new(0, 0.5, 20),
				BrickColor = BrickColor.new("Bright blue"),
			},
		},

		-- ============================================================
		-- Kran-Bereich (3 Kräne als Highlight-Mechanik D-014)
		-- ============================================================
		{
			Name = "CraneArea",
			ClassName = "Model",
			Properties = {},
			Children = {
				{
					Name = "CraneA",
					ClassName = "Model",
					Properties = {
						PrimaryPart = "Base",
					},
					Children = {
						{
							Name = "Base",
							ClassName = "Part",
							Properties = {
								Anchored = true,
								Material = Enum.Material.Metal,
								Color = Color3.fromRGB(242, 140, 51), -- Werft-Orange
								Size = Vector3.new(4, 12, 4),
								Position = Vector3.new(-25, 6, 15),
							},
						},
						{
							Name = "Arm",
							ClassName = "Part",
							Properties = {
								Anchored = true,
								Material = Enum.Material.Metal,
								Color = Color3.fromRGB(242, 140, 51),
								Size = Vector3.new(20, 2, 2),
								Position = Vector3.new(-15, 12, 15),
							},
						},
						{
							Name = "ContainerSpawn",
							ClassName = "Part",
							Properties = {
								Anchored = true,
								CanCollide = false,
								Transparency = 1, -- Invisible spawn point
								Size = Vector3.new(2, 2, 2),
								Position = Vector3.new(-5, 9, 15),
								Attributes = {
									QuestHook = "HH_02_crane_firstlift",
									ContainerType = "Crate",
								},
							},
						},
					},
				},
				{
					Name = "CraneB",
					ClassName = "Model",
					Properties = { PrimaryPart = "Base" },
					Children = {
						{
							Name = "Base",
							ClassName = "Part",
							Properties = {
								Anchored = true,
								Material = Enum.Material.Metal,
								Color = Color3.fromRGB(242, 140, 51),
								Size = Vector3.new(4, 12, 4),
								Position = Vector3.new(0, 6, 35),
							},
						},
						{
							Name = "Arm",
							ClassName = "Part",
							Properties = {
								Anchored = true,
								Material = Enum.Material.Metal,
								Color = Color3.fromRGB(242, 140, 51),
								Size = Vector3.new(20, 2, 2),
								Position = Vector3.new(10, 12, 35),
							},
						},
					},
				},
				{
					Name = "CraneC",
					ClassName = "Model",
					Properties = { PrimaryPart = "Base" },
					Children = {
						{
							Name = "Base",
							ClassName = "Part",
							Properties = {
								Anchored = true,
								Material = Enum.Material.Metal,
								Color = Color3.fromRGB(242, 140, 51),
								Size = Vector3.new(4, 12, 4),
								Position = Vector3.new(25, 6, 15),
							},
						},
						{
							Name = "Arm",
							ClassName = "Part",
							Properties = {
								Anchored = true,
								Material = Enum.Material.Metal,
								Color = Color3.fromRGB(242, 140, 51),
								Size = Vector3.new(20, 2, 2),
								Position = Vector3.new(15, 12, 15),
							},
						},
					},
				},
			},
		},

		-- ============================================================
		-- Speicherhaus (Lager, Materialien, Bauquests)
		-- ============================================================
		{
			Name = "Speicherhaus",
			ClassName = "Model",
			Properties = { PrimaryPart = "Floor" },
			Children = {
				{
					Name = "Floor",
					ClassName = "Part",
					Properties = {
						Anchored = true,
						Material = Enum.Material.WoodPlanks,
						Color = Color3.fromRGB(217, 178, 127), -- Hafen-Beige
						Size = Vector3.new(20, 0.5, 16),
						Position = Vector3.new(-40, 4, 30),
					},
				},
				{
					Name = "Walls",
					ClassName = "Part",
					Properties = {
						Anchored = true,
						Material = Enum.Material.Brick,
						Color = Color3.fromRGB(180, 100, 60),
						Size = Vector3.new(20, 8, 16),
						Position = Vector3.new(-40, 8, 30),
						Transparency = 0.2, -- see-through for now
					},
				},
				{
					Name = "YukiSpawn",
					ClassName = "Part",
					Properties = {
						Anchored = true,
						CanCollide = false,
						Transparency = 1,
						Size = Vector3.new(1, 2, 1),
						Position = Vector3.new(-40, 6, 32),
						Attributes = { NpcId = "Yuki", Role = "Merchant" },
					},
				},
				{
					Name = "MaterialStorage",
					ClassName = "Part",
					Properties = {
						Anchored = true,
						Material = Enum.Material.Wood,
						Color = Color3.fromRGB(160, 100, 50),
						Size = Vector3.new(3, 3, 3),
						Position = Vector3.new(-44, 6, 28),
						Attributes = { MaterialType = "Wood", Quantity = 100 },
					},
				},
			},
		},

		-- ============================================================
		-- Werft (Bootsbau)
		-- ============================================================
		{
			Name = "Werft",
			ClassName = "Model",
			Properties = { PrimaryPart = "Floor" },
			Children = {
				{
					Name = "Floor",
					ClassName = "Part",
					Properties = {
						Anchored = true,
						Material = Enum.Material.Concrete,
						Color = Color3.fromRGB(150, 150, 150),
						Size = Vector3.new(16, 0.5, 12),
						Position = Vector3.new(40, 4, 35),
					},
				},
				{
					Name = "Workbench",
					ClassName = "Part",
					Properties = {
						Anchored = true,
						Material = Enum.Material.Wood,
						Color = Color3.fromRGB(140, 80, 40),
						Size = Vector3.new(4, 1, 2),
						Position = Vector3.new(38, 4.5, 33),
						Attributes = { QuestHook = "HH_03_werft_boat" },
					},
				},
				{
					Name = "MajaSpawn",
					ClassName = "Part",
					Properties = {
						Anchored = true,
						CanCollide = false,
						Transparency = 1,
						Size = Vector3.new(1, 2, 1),
						Position = Vector3.new(42, 6, 33),
						Attributes = { NpcId = "Maja", Role = "Crafter" },
					},
				},
			},
		},

		-- ============================================================
		-- Leuchtturm-Insel (Höhepunkt, Aussicht)
		-- ============================================================
		{
			Name = "LighthouseIsland",
			ClassName = "Model",
			Properties = { PrimaryPart = "Lighthouse" },
			Children = {
				{
					Name = "Island",
					ClassName = "Part",
					Properties = {
						Anchored = true,
						Material = Enum.Material.Sand,
						Color = Color3.fromRGB(220, 200, 160),
						Size = Vector3.new(8, 2, 8),
						Position = Vector3.new(0, 1, 60),
					},
				},
				{
					Name = "Lighthouse",
					ClassName = "Part",
					Properties = {
						Anchored = true,
						Material = Enum.Material.Metal,
						Color = Color3.fromRGB(255, 255, 255),
						Size = Vector3.new(2, 18, 2),
						Position = Vector3.new(0, 11, 60),
					},
				},
				{
					Name = "LighthouseTop",
					ClassName = "Part",
					Properties = {
						Anchored = true,
						Material = Enum.Material.Neon,
						Color = Color3.fromRGB(255, 220, 100), -- Laterne-Gelb
						Size = Vector3.new(3, 2, 3),
						Position = Vector3.new(0, 21, 60),
						Attributes = { EmitsLight = true, ColorHex = "FFDC64" },
					},
				},
				{
					Name = "NilsSpawn",
					ClassName = "Part",
					Properties = {
						Anchored = true,
						CanCollide = false,
						Transparency = 1,
						Size = Vector3.new(1, 2, 1),
						Position = Vector3.new(0, 4, 62),
						Attributes = { NpcId = "Nils", Role = "Story" },
					},
				},
			},
		},

		-- ============================================================
		-- Quest-Starter-Schilder (für Hafenwirtin & Tagesaufgaben)
		-- ============================================================
		{
			Name = "QuestBoards",
			ClassName = "Folder",
			Children = {
				{
					Name = "DailyQuestBoard",
					ClassName = "Part",
					Properties = {
						Anchored = true,
						Material = Enum.Material.Wood,
						Color = Color3.fromRGB(110, 75, 50),
						Size = Vector3.new(4, 6, 0.5),
						Position = Vector3.new(5, 7, 5),
						Attributes = { QuestType = "Daily", RefreshHours = 24 },
					},
				},
			},
		},
	},
}

return HamburgHarbor