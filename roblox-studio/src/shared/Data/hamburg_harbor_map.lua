--!strict
--[[
	HamburgHarborMap.lua — Workspace-Skeleton für Hamburg Harbor
	============================================================

	Diese Datei definiert die Workspace-Struktur für Hamburg Harbor.
	Wird via Rojo in Roblox Studio synchronisiert.

	Topographie:
	- Hub-Anbindung (Verbindung zu Sky Plaza)
	- Hafenbecken (zentraler See)
	- Kran-Bereich (3 Kräne als Highlight-Mechanik D-014)
	- Speicherhaus (Lager, Materialien, Bauquests)
	- Werft (Bootsbau, Werkzeuge)
	- Leuchtturm-Insel (Höhepunkt, Aussicht)

	NPCs (Vertical-Slice-Roster, 4 Rollen):
	- Hafenwirtin Lina (PlazaEntry, main quest giver)
	- Markt-Händlerin Yuki (Speicherhaus, merchant)
	- Bootsbauerin Maja (Werft, crafter)
	- Leuchtturmwächter Nils (Leuchtturm, story)

	ASSET-PIPELINE:
	===============
	Visuelle Assets werden via Blender → FBX → Roblox-Upload → AssetId referenziert.

	Upload-Workflow:
	1. Blender-Pipeline ausführen (siehe roblox-studio/assets/blender-scripts/)
	2. Output-FBX in roblox-studio/assets/fbx/ ist bereits vorhanden (16 Files)
	3. In Roblox Studio: View → Asset Manager → Bulk Import → FBX wählen
	4. Upload gibt AssetId (z.B. rbxassetid://123456789)
	5. AssetId unten in PENDING_UPLOAD_* Platzhaltern ersetzen
	6. Re-build mit `rojo build` → .rbxl enthält die echten Mesh-Refs

	Die Platzhalter-Strategie erlaubt uns, die Map-Struktur und Validierung
	vor dem Upload zu testen. Bei nicht-aufgelösten AssetIds rendert Roblox
	eine Standard-Box mit grauer Farbe (sichtbar im Studio, harmlos).
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
					-- Willkommens-Schild als MeshPart (FBX)
					ClassName = "MeshPart",
					Properties = {
						Anchored = true,
						CanCollide = false,
						MeshId = "rbxassetid://PENDING_UPLOAD_willkommen_schild_lod0",
						Size = Vector3.new(2.6, 1.4, 0.15),
						Position = Vector3.new(0, 8, -3),
						-- SurfaceAppearance (Emissive-Texturen) statt Material-Property
						-- wird nach Upload in Studio manuell zugewiesen
					},
					Attributes = { AssetSource = "Blender:willkommen_schild_lod0.fbx" },
				},
				{
					-- NPC-Spawn-Anker (kein Mesh — Spawner instanziiert echten NPC)
					Name = "NpcSpawn_Hafenwirtin",
					ClassName = "Part",
					Properties = {
						Anchored = true,
						CanCollide = false,
						Transparency = 1,  -- unsichtbar, nur Position+Metadaten
						Size = Vector3.new(0.5, 2, 0.5),
						Position = Vector3.new(0, 6, -2),
					},
					Attributes = {
						NpcId = "Hafenwirtin",
						Role = "QuestGiver",
						MeshAssetId = "rbxassetid://PENDING_UPLOAD_npc_basis_female_lod0",
						Outfit = "Hafenwirtin_Default",
					},
				},
			},
		},

		-- ============================================================
		-- Zentrales Hafenbecken (Wasser-Plane)
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
				Transparency = 0.3,  -- leicht durchsichtig für Tiefenwirkung
			},
			Children = {
				{
					Name = "WaterMist",
					ClassName = "ParticleEmitter",
					Properties = {
						Texture = "rbxassetid://6490035152",  -- Standard-Roblox-Smoke
						Color = ColorSequence.new(Color3.fromRGB(180, 200, 220)),
						Transparency = NumberSequence.new({
							NumberSequenceKeypoint.new(0, 0.6),
							NumberSequenceKeypoint.new(1, 1),
						}),
						Size = NumberSequence.new({
							NumberSequenceKeypoint.new(0, 0.5),
							NumberSequenceKeypoint.new(1, 2.0),
						}),
						Lifetime = NumberRange.new(3, 5),
						Rate = 8,
						Speed = NumberRange.new(0.5, 1.5),
						SpreadAngle = Vector2.new(15, 15),
						Enabled = true,
					},
					Attributes = { VfxType = "WaterMist" },
				},
			},
		},

		-- ============================================================
		-- Kran-Bereich (3 Kräne als Highlight-Mechanik D-014)
		-- ============================================================
		{
			Name = "CraneArea",
			ClassName = "Model",
			Properties = {
				PrimaryPart = "CraneA",
			},
			Children = {
				{
					Name = "CraneA",
					ClassName = "MeshPart",
					Properties = {
						Anchored = true,
						CanCollide = true,
						MeshId = "rbxassetid://PENDING_UPLOAD_kran_lod0",
						-- Kran-FBX ist 14 BU hoch (Mast 12 + Container-Höhe), centered
						Size = Vector3.new(20, 14, 4),
						Position = Vector3.new(-15, 7, 15),
					},
					Attributes = {
						AssetSource = "Blender:kran_lod0.fbx",
						QuestHook = "HH_02_crane_firstlift",
						CraneId = "CraneA",
						Grappleable = true,
					},
					Children = {
						{
							-- Quest-Trigger: Container-Crate am Haken
							Name = "ContainerSpawn",
							ClassName = "MeshPart",
							Properties = {
								Anchored = false,
								CanCollide = true,
								MeshId = "rbxassetid://PENDING_UPLOAD_kiste_lod0",
								Size = Vector3.new(1.6, 1.6, 1.6),
								Position = Vector3.new(-5, 9, 15),
							},
							Attributes = {
								QuestHook = "HH_02_crane_firstlift",
								ContainerType = "Crate",
								Pickupable = true,
							},
						},
					},
				},
				{
					Name = "CraneB",
					ClassName = "MeshPart",
					Properties = {
						Anchored = true,
						CanCollide = true,
						MeshId = "rbxassetid://PENDING_UPLOAD_kran_lod0",
						Size = Vector3.new(20, 14, 4),
						Position = Vector3.new(10, 7, 35),
					},
					Attributes = {
						AssetSource = "Blender:kran_lod0.fbx",
						CraneId = "CraneB",
						Grappleable = true,
					},
				},
				{
					Name = "CraneC",
					ClassName = "MeshPart",
					Properties = {
						Anchored = true,
						CanCollide = true,
						MeshId = "rbxassetid://PENDING_UPLOAD_kran_lod0",
						Size = Vector3.new(20, 14, 4),
						Position = Vector3.new(15, 7, 15),
					},
					Attributes = {
						AssetSource = "Blender:kran_lod0.fbx",
						CraneId = "CraneC",
						Grappleable = true,
					},
				},
			},
		},

		-- ============================================================
		-- Speicherhaus (Lager, Materialien, Bauquests)
		-- ============================================================
		{
			Name = "Speicherhaus",
			ClassName = "MeshPart",
			Properties = {
				Anchored = true,
				CanCollide = true,
				MeshId = "rbxassetid://PENDING_UPLOAD_speicherhaus_lod0",
				-- Speicherhaus-FBX ist ~16 BU breit, ~14 BU hoch
				Size = Vector3.new(17, 14, 13),
				Position = Vector3.new(-40, 7, 30),
			},
			Attributes = {
				AssetSource = "Blender:speicherhaus_lod0.fbx",
				BuildingType = "Warehouse",
			},
			Children = {
				{
					-- Kistenstapel im Speicherhaus (Deko)
					Name = "MaterialStorage",
					ClassName = "MeshPart",
					Properties = {
						Anchored = true,
						CanCollide = true,
						MeshId = "rbxassetid://PENDING_UPLOAD_kiste_lod0",
						Size = Vector3.new(1.6, 1.6, 1.6),
						Position = Vector3.new(-44, 1.5, 28),
					},
					Attributes = {
						MaterialType = "Wood",
						Quantity = 100,
						Pickupable = true,
					},
				},
				{
					-- NPC-Spawn-Anker für Yuki
					Name = "NpcSpawn_Yuki",
					ClassName = "Part",
					Properties = {
						Anchored = true,
						CanCollide = false,
						Transparency = 1,
						Size = Vector3.new(0.5, 2, 0.5),
						Position = Vector3.new(-40, 6, 32),
					},
					Attributes = {
						NpcId = "Yuki",
						Role = "Merchant",
						MeshAssetId = "rbxassetid://PENDING_UPLOAD_npc_basis_female_lod0",
						Outfit = "Yuki_Merchant",
					},
				},
			},
		},

		-- ============================================================
		-- Werft (Bootsbau)
		-- ============================================================
		{
			Name = "Werft",
			ClassName = "MeshPart",
			Properties = {
				Anchored = true,
				CanCollide = true,
				MeshId = "rbxassetid://PENDING_UPLOAD_dock_planke_lod0",
				-- Dock-Planke als Boden-Basis (5 BU lang, 1 BU breit, 0.2 BU hoch)
				Size = Vector3.new(16, 0.5, 12),
				Position = Vector3.new(40, 4, 35),
			},
			Attributes = {
				AssetSource = "Blender:dock_planke_lod0.fbx",
				BuildingType = "Shipyard",
			},
			Children = {
				{
					Name = "Workbench",
					ClassName = "MeshPart",
					Properties = {
						Anchored = true,
						CanCollide = true,
						MeshId = "rbxassetid://PENDING_UPLOAD_dock_planke_lod0",
						Size = Vector3.new(4, 1, 2),
						Position = Vector3.new(38, 4.5, 33),
						BrickColor = BrickColor.new("Brown"),
					},
					Attributes = {
						QuestHook = "HH_03_werft_boat",
						InteractType = "QuestStart",
					},
					Children = {
						{
							Name = "WorkbenchPrompt",
							ClassName = "ProximityPrompt",
							Properties = {
								ActionText = "Werkbank benutzen",
								HoldDuration = 0,
								MaxActivationDistance = 6,
								RequiresLineOfSight = true,
							},
						},
					},
				},
				{
					-- Boot (Quest-Resultat HH_03)
					Name = "Boat_Built",
					ClassName = "MeshPart",
					Properties = {
						Anchored = true,
						CanCollide = true,
						MeshId = "rbxassetid://PENDING_UPLOAD_boot_lod0",
						Size = Vector3.new(4.6, 1, 1.5),
						Position = Vector3.new(42, 1.5, 33),
					},
					Attributes = {
						AssetSource = "Blender:boot_lod0.fbx",
						QuestReward = "HH_03_werft_boat",
						VisibleAfterQuest = "HH_03_werft_boat",
					},
				},
				{
					Name = "Fass_Deko",
					ClassName = "MeshPart",
					Properties = {
						Anchored = true,
						CanCollide = true,
						MeshId = "rbxassetid://PENDING_UPLOAD_fass_lod0",
						Size = Vector3.new(1.4, 1.4, 1.4),
						Position = Vector3.new(43, 1.7, 36),
					},
					Attributes = { AssetSource = "Blender:fass_lod0.fbx" },
				},
				{
					Name = "Anker_Deko",
					ClassName = "MeshPart",
					Properties = {
						Anchored = true,
						CanCollide = false,
						MeshId = "rbxassetid://PENDING_UPLOAD_anker_lod0",
						Size = Vector3.new(1, 2.2, 1),
						Position = Vector3.new(36, 1.3, 36),
					},
					Attributes = { AssetSource = "Blender:anker_lod0.fbx" },
				},
				{
					Name = "NpcSpawn_Maja",
					ClassName = "Part",
					Properties = {
						Anchored = true,
						CanCollide = false,
						Transparency = 1,
						Size = Vector3.new(0.5, 2, 0.5),
						Position = Vector3.new(42, 6, 33),
					},
					Attributes = {
						NpcId = "Maja",
						Role = "Crafter",
						MeshAssetId = "rbxassetid://PENDING_UPLOAD_npc_basis_female_lod0",
						Outfit = "Maja_Crafter",
					},
				},
			},
		},

		-- ============================================================
		-- Leuchtturm-Insel (Höhepunkt, Aussicht)
		-- ============================================================
		{
			Name = "LighthouseIsland",
			ClassName = "MeshPart",
			Properties = {
				Anchored = true,
				CanCollide = true,
				MeshId = "rbxassetid://PENDING_UPLOAD_leuchtturm_lod0",
				-- Leuchtturm-FBX ist ~14 BU hoch, ~3 BU breit
				Size = Vector3.new(3, 14, 3),
				Position = Vector3.new(0, 7, 60),
			},
			Attributes = {
				AssetSource = "Blender:leuchtturm_lod0.fbx",
				BuildingType = "Landmark",
				-- Die Laterne (oberster Part des Leuchtturms) emittiert Licht.
				-- SurfaceAppearance + Emission-Map werden in Studio nach Upload gesetzt.
				EmitsLight = true,
				LightColorHex = "FFDC64",
				LightRadius = 60,
			},
			Children = {
				{
					Name = "Island_Base",
					ClassName = "Part",
					Properties = {
						Anchored = true,
						CanCollide = true,
						Shape = Enum.PartType.Cylinder,
						-- Sand-Insel-Sockel (Cylinder statt FBX-Placeholder, damit ohne Asset-Upload sichtbar)
						Size = Vector3.new(2, 14, 14),  -- Cylinder: diameter=Size.X, height=Size.Y
						Position = Vector3.new(0, 1, 60),
						Material = Enum.Material.Sand,
						BrickColor = BrickColor.new("Brick yellow"),
					},
					Attributes = { AssetSource = "Primitive:Sand-Cylinder (replace with island FBX in Phase 3)" },
				},
				{
					Name = "NpcSpawn_Nils",
					ClassName = "Part",
					Properties = {
						Anchored = true,
						CanCollide = false,
						Transparency = 1,
						Size = Vector3.new(0.5, 2, 0.5),
						Position = Vector3.new(0, 4, 62),
					},
					Attributes = {
						NpcId = "Nils",
						Role = "Story",
						MeshAssetId = "rbxassetid://PENDING_UPLOAD_npc_basis_male_lod0",
						Outfit = "Nils_Watchman",
					},
				},
			},
		},

		-- ============================================================
		-- Quest-Starter-Tafel (für Hafenwirtin & Tagesaufgaben)
		-- ============================================================
		{
			Name = "QuestBoards",
			ClassName = "MeshPart",
			Properties = {
				Anchored = true,
				CanCollide = false,
				MeshId = "rbxassetid://PENDING_UPLOAD_quest_tafel_lod0",
				Size = Vector3.new(2.5, 2.0, 0.5),
				Position = Vector3.new(5, 3.5, 5),
				BrickColor = BrickColor.new("Dark stone grey"),
			},
			Attributes = {
				AssetSource = "Blender:quest_tafel_lod0.fbx",
				QuestType = "Daily",
				RefreshHours = 24,
				InteractType = "QuestBoard",
			},
			Children = {
				{
					Name = "QuestBoardPrompt",
					ClassName = "ProximityPrompt",
					Properties = {
						ActionText = "Tagesaufgaben ansehen",
						HoldDuration = 0,
						MaxActivationDistance = 7,
						RequiresLineOfSight = true,
					},
				},
			},
		},

		-- ============================================================
		-- Hafen-Laternen (Atmosphäre entlang der Kaimauern)
		-- ============================================================
		{
			Name = "Lanterns",
			ClassName = "Folder",
			Properties = {},
			Children = {
				{ Name = "Lantern_1", ClassName = "MeshPart",
				  Properties = {
					  Anchored = true, CanCollide = false,
					  MeshId = "rbxassetid://PENDING_UPLOAD_laterne_lod0",
					  Size = Vector3.new(0.5, 3.5, 0.5),
					  Position = Vector3.new(-10, 1.75, -5),
				  },
				  Children = {
					  {
						  Name = "LanternGlow",
						  ClassName = "PointLight",
						  Properties = {
							  Color = Color3.fromRGB(255, 220, 110),
							  Brightness = 1.2,
							  Range = 14,
							  Enabled = true,
							  ShadowsEnabled = true,
						  },
						  Attributes = { VfxType = "LanternGlow" },
					  },
				  }},
				{ Name = "Lantern_2", ClassName = "MeshPart",
				  Properties = {
					  Anchored = true, CanCollide = false,
					  MeshId = "rbxassetid://PENDING_UPLOAD_laterne_lod0",
					  Size = Vector3.new(0.5, 3.5, 0.5),
					  Position = Vector3.new(-15, 1.75, 10),
				  },
				  Children = {
					  {
						  Name = "LanternGlow",
						  ClassName = "PointLight",
						  Properties = {
							  Color = Color3.fromRGB(255, 220, 110),
							  Brightness = 1.2,
							  Range = 14,
							  Enabled = true,
							  ShadowsEnabled = true,
						  },
						  Attributes = { VfxType = "LanternGlow" },
					  },
				  }},
				{ Name = "Lantern_3", ClassName = "MeshPart",
				  Properties = {
					  Anchored = true, CanCollide = false,
					  MeshId = "rbxassetid://PENDING_UPLOAD_laterne_lod0",
					  Size = Vector3.new(0.5, 3.5, 0.5),
					  Position = Vector3.new(10, 1.75, 0),
				  },
				  Children = {
					  {
						  Name = "LanternGlow",
						  ClassName = "PointLight",
						  Properties = {
							  Color = Color3.fromRGB(255, 220, 110),
							  Brightness = 1.2,
							  Range = 14,
							  Enabled = true,
							  ShadowsEnabled = true,
						  },
						  Attributes = { VfxType = "LanternGlow" },
					  },
				  }},
				{ Name = "Lantern_4", ClassName = "MeshPart",
				  Properties = {
					  Anchored = true, CanCollide = false,
					  MeshId = "rbxassetid://PENDING_UPLOAD_laterne_lod0",
					  Size = Vector3.new(0.5, 3.5, 0.5),
					  Position = Vector3.new(20, 1.75, 25),
				  },
				  Children = {
					  {
						  Name = "LanternGlow",
						  ClassName = "PointLight",
						  Properties = {
							  Color = Color3.fromRGB(255, 220, 110),
							  Brightness = 1.2,
							  Range = 14,
							  Enabled = true,
							  ShadowsEnabled = true,
						  },
						  Attributes = { VfxType = "LanternGlow" },
					  },
				  }},
				{ Name = "Lantern_5", ClassName = "MeshPart",
				  Properties = {
					  Anchored = true, CanCollide = false,
					  MeshId = "rbxassetid://PENDING_UPLOAD_laterne_lod0",
					  Size = Vector3.new(0.5, 3.5, 0.5),
					  Position = Vector3.new(-25, 1.75, 30),
				  },
				  Children = {
					  {
						  Name = "LanternGlow",
						  ClassName = "PointLight",
						  Properties = {
							  Color = Color3.fromRGB(255, 220, 110),
							  Brightness = 1.5,
							  Range = 18,
							  Enabled = true,
							  ShadowsEnabled = true,
						  },
						  Attributes = { VfxType = "LanternGlow" },
					  },
					  {
						  Name = "LanternDust",
						  ClassName = "ParticleEmitter",
						  Properties = {
							  Texture = "rbxassetid://6490035152",
							  Color = ColorSequence.new(Color3.fromRGB(255, 220, 110)),
							  Transparency = NumberSequence.new({
								  NumberSequenceKeypoint.new(0, 0.4),
								  NumberSequenceKeypoint.new(1, 1),
							  }),
							  Size = NumberSequence.new({
								  NumberSequenceKeypoint.new(0, 0.2),
								  NumberSequenceKeypoint.new(1, 1.2),
								}),
							  Lifetime = NumberRange.new(2, 4),
							  Rate = 3,
							  Speed = NumberRange.new(0.3, 1.0),
							  SpreadAngle = Vector2.new(20, 20),
							  EmissionDirection = Enum.NormalId.Top,
							  Enabled = true,
						  },
						  Attributes = { VfxType = "LanternDust" },
					  },
				  },
				},
			},
		},
	},
}

return HamburgHarbor
