--!strict
--[[
	MapBuilder.lua — Baut die Hamburg-Harbor-Map aus der Daten-Definition
	====================================================================

	Liest die Daten aus `hamburg_harbor_map.lua` und baut die Roblox-Instanz-
	Hierarchie programmatisch im Workspace auf. Vorteil: Wir können die Map
	deklarativ in einer reinen Daten-Datei definieren (einfach zu versionieren,
	zu reviewen, zu testen) und der Builder macht daraus echte Roblox-Instanzen.

	Phase 2: Build bei Server-Start.
	Phase 3: Hot-Reload via ReplicatedStorage, Client-Vorschau.

	Audit-Fixes (state/audit/map-assets-atmosphere.md §4 + §8):
	- Validate() erweitert um Size/Anchor/PrimaryPart/NpcId-Whitelist/
	  QuestHook-Registry/Material-Disallow-List
	- applyProperties() warnt jetzt bei unbekannten Properties (vorher silent)
	- MeshPart-Spezialfall: PENDING_UPLOAD_* AssetIds werden als Warnung
	  geloggt, aber Build bricht nicht ab
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Log = require(ReplicatedStorage.Shared.Util.Log)

local MapBuilder = {}

-- ============================================================
-- Konfiguration
-- ============================================================

-- Whitelist erlaubter NPC-IDs (siehe M02_Quest + WorldBible)
local NPC_ID_WHITELIST = {
	Hafenwirtin = true,
	Yuki = true,
	Maja = true,
	Nils = true,
}

-- Whitelist erlaubter Quest-Hooks (muss zu M02_Quest.SampleQuests passen)
local QUEST_HOOK_WHITELIST = {
	HH_01_kran_intro = true,
	HH_02_crane_firstlift = true,
	HH_03_werft_boat = true,
}

-- Materialien, die NICHT für statische Beleuchtung verwendet werden sollen
-- (Art-Direction: PBR-Emissive > Neon-Shader)
local DISALLOWED_MATERIALS = {
	Neon = true,  -- Enum.Material.Neon ist nur für simple Sterne/Partikel okay
}

-- Classes, bei denen Properties.Size Pflicht und Vector3 sein muss
local CLASSES_REQUIRING_SIZE = {
	Part = true,
	MeshPart = true,
	UnionOperation = true,
}

-- Classes, bei denen Anchored für statische Map true sein muss (NPC-Spawn-Points excluded)
local CLASSES_REQUIRING_ANCHORED = {
	Part = true,
	MeshPart = true,
	Model = true,
}

-- ============================================================
-- Builder-Logik
-- ============================================================

local function applyProperties(instance: Instance, properties: { [string]: any })
	if not properties then return end
	for key, value in pairs(properties) do
		if key == "Attributes" and typeof(value) == "table" then
			for attrName, attrValue in pairs(value) do
				instance:SetAttribute(attrName, attrValue)
			end
		else
			-- Normale Property; pcall weil Roblox-API bei ungültigen Werten wirft
			local ok, err = pcall(function()
				(instance :: any)[key] = value
			end)
			if not ok then
				Log:Warn(string.format(
					"MapBuilder: Property-Set fehlgeschlagen für %s.%s = %s: %s",
					instance:GetFullName(),
					key,
					tostring(value),
					tostring(err)
				))
			end

			-- Spezielle Warnungen für bekannte Probleme
			if key == "MeshId" and typeof(value) == "string" and string.find(value, "PENDING_UPLOAD") then
				Log:Warn(string.format(
					"MapBuilder: %s hat noch PENDING_UPLOAD-AssetId. Bitte FBX in Studio uploaden und ID ersetzen.",
					instance:GetFullName()
				))
			end
			if key == "Material" and DISALLOWED_MATERIALS[value] then
				Log:Warn(string.format(
					"MapBuilder: %s nutzt Material.Neon — Art-Direction verlangt PBR-Emissive (SurfaceAppearance).",
					instance:GetFullName()
				))
			end
		end
	end
end

local function buildInstance(definition: { [string]: any }, parent: Instance): Instance
	local instance = Instance.new(definition.ClassName or "Part")
	instance.Name = definition.Name or "Unnamed"

	if parent then
		instance.Parent = parent
	end

	applyProperties(instance, definition.Properties)

	-- Recursive children
	if definition.Children then
		for _, childDef in ipairs(definition.Children) do
			buildInstance(childDef, instance)
		end
	end

	return instance
end

-- ============================================================
-- Public API
-- ============================================================

--[[
	BuildInto(mapData, container) — Baut die komplette Map-Hierarchie.

	Usage:
		local HamburgHarbor = require(Shared.Data.hamburg_harbor_map)
		MapBuilder:BuildInto(HamburgHarbor, workspace.Districts.HamburgHarbor)
]]
function MapBuilder:BuildInto(mapData: { [string]: any }, container: Instance)
	if not container then
		Log:Error("MapBuilder:BuildInto — container is nil")
		return nil
	end

	Log:Info(string.format("Building map '%s' into '%s'", mapData.Name, container:GetFullName()))

	for _, childDef in ipairs(mapData.Layout or {}) do
		buildInstance(childDef, container)
	end

	Log:Info(string.format("Map '%s' build complete", mapData.Name))
	return container
end

--[[
	Validate(mapData) — Prüft die Map-Daten auf offensichtliche Fehler.

	Prüft:
	- Name + Layout-Presence
	- ClassName + Position-Typ (TypeScript-Validation)
	- Size als Vector3 (wo Pflicht)
	- Anchored = true für statische Parts (außer NPC-Spawn-Points)
	- Model: PrimaryPart gesetzt
	- NpcId-Attribute gegen Whitelist
	- QuestHook-Attribute gegen Whitelist
	- Disallow-Liste für Materialien
	- MeshId als rbxassetid://-URI formatiert
	- Eindeutigkeit der Namen innerhalb derselben Hierarchie-Ebene

	Returns (ok, errors). Im Fehlerfall NICHT silent — Bootstrap entscheidet
	ob error() geworfen wird.
]]
function MapBuilder:Validate(mapData: { [string]: any }): (boolean, { string })
	local errors: { string } = {}

	-- Top-Level Checks
	if not mapData.Name or mapData.Name == "" then
		table.insert(errors, "Map name missing")
	end
	if not mapData.Layout or #mapData.Layout == 0 then
		table.insert(errors, "Map layout is empty")
	end

	-- Recursive Walk mit Hierarchy-Eindeutigkeit
	local function checkNode(node: { [string]: any }, path: string, seenNames: { [string]: boolean })
		if not node.Name then
			table.insert(errors, path .. ": name missing")
		end
		if not node.ClassName then
			table.insert(errors, path .. ": className missing")
		end

		-- Hierarchy-Eindeutigkeit
		if node.Name then
			if seenNames[node.Name] then
				table.insert(errors, path .. ": duplicate Name '" .. node.Name .. "' in same parent")
			end
			seenNames[node.Name] = true
		end

		-- Class-spezifische Checks
		local className = node.ClassName
		local isNpcSpawn = node.Attributes and node.Attributes.NpcId ~= nil
		local isPickupable = node.Attributes and node.Attributes.Pickupable == true

		if node.Properties then
			local props = node.Properties

			-- Position muss Vector3 sein
			if props.Position and typeof(props.Position) ~= "Vector3" then
				table.insert(errors, path .. ": Position is not Vector3 (got " .. typeof(props.Position) .. ")")
			end

			-- Size muss Vector3 sein (für Part-artige Klassen)
			if CLASSES_REQUIRING_SIZE[className] then
				if props.Size and typeof(props.Size) ~= "Vector3" then
					table.insert(errors, path .. ": Size is not Vector3 (got " .. typeof(props.Size) .. ")")
				end
			end

			-- Anchored=true für statische Map (außer NPC-Spawn-Cubes und Pickupable-Items)
			if CLASSES_REQUIRING_ANCHORED[className] and not isNpcSpawn and not isPickupable then
				if props.Anchored == false then
					table.insert(errors, path .. ": Anchored=false für statisches " .. className .. " (Sturz-Risiko)")
				end
			end

			-- Material-Disallow-Check
			if props.Material and DISALLOWED_MATERIALS[props.Material] then
				table.insert(errors, path .. ": Material.Neon nicht erlaubt (Art-Direction)")
			end

			-- MeshId-Format-Check für MeshPart
			if props.MeshId and typeof(props.MeshId) == "string" then
				if not string.find(props.MeshId, "^rbxassetid://") then
					table.insert(errors, path .. ": MeshId '" .. props.MeshId .. "' nicht rbxassetid:// formatiert")
				end
			end
		end

		-- Model: PrimaryPart-Validierung
		-- Models mit Children brauchen einen PrimaryPart (sonst Crash bei :MoveTo etc.)
		-- PrimaryPart kann top-level oder in Properties sein (Roblox-API hat beides)
		if className == "Model" and node.Children and #node.Children > 0 then
			local pp = node.PrimaryPart
			if not pp and node.Properties and node.Properties.PrimaryPart then
				pp = node.Properties.PrimaryPart
			end
			if not pp then
				table.insert(errors, path
					.. ": Model hat Children aber keinen PrimaryPart gesetzt"
					.. " (bitte in Studio nach Build zuweisen)")
			end
		end

		-- Attributes-Whitelist-Checks
		if node.Attributes then
			local attrs = node.Attributes
			if attrs.NpcId and not NPC_ID_WHITELIST[attrs.NpcId] then
				table.insert(errors, path .. ": NpcId '" .. tostring(attrs.NpcId) .. "' nicht in NPC-Whitelist")
			end
			if attrs.QuestHook and not QUEST_HOOK_WHITELIST[attrs.QuestHook] then
				table.insert(errors, path .. ": QuestHook '" .. tostring(attrs.QuestHook) .. "' nicht in Quest-Whitelist")
			end
		end

		-- Recurse
		if node.Children then
			local childSeen: { [string]: boolean } = {}
			for i, child in ipairs(node.Children) do
				checkNode(child, path .. "." .. (child.Name or ("child_" .. i)), childSeen)
			end
		end
	end

	local topSeen: { [string]: boolean } = {}
	for i, child in ipairs(mapData.Layout or {}) do
		checkNode(child, "Layout[" .. i .. "]", topSeen)
	end

	local ok = #errors == 0
	return ok, errors
end

return MapBuilder
