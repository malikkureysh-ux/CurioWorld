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
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Log = require(ReplicatedStorage.Shared.Util.Log)

local MapBuilder = {}

-- ============================================================
-- Builder-Logik
-- ============================================================

local function applyProperties(instance: Instance, properties: { [string]: any })
	if not properties then return end
	for key, value in pairs(properties) do
		-- Attribute sind ein Spezialfall in modernem Roblox
		if key == "Attributes" and typeof(value) == "table" then
			for attrName, attrValue in pairs(value) do
				instance:SetAttribute(attrName, attrValue)
			end
		else
			-- Normale Property
			pcall(function()
				(instance :: any)[key] = value
			end)
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
	Build(mapData) — Baut die komplette Map-Hierarchie in einem Container.

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
	Hilfreich in TestEZ-Specs.
]]
function MapBuilder:Validate(mapData: { [string]: any }): (boolean, { string })
	local errors: { string } = {}

	if not mapData.Name or mapData.Name == "" then
		table.insert(errors, "Map name missing")
	end
	if not mapData.Layout or #mapData.Layout == 0 then
		table.insert(errors, "Map layout is empty")
	end

	-- Weitere Checks: Spawn-Punkte müssen in Hub-Sicht sein, NPCs müssen benannt sein, etc.
	local function checkNode(node: { [string]: any }, path: string)
		if not node.Name then
			table.insert(errors, path .. ": name missing")
		end
		if not node.ClassName then
			table.insert(errors, path .. ": className missing")
		end
		if node.Properties then
			if node.Properties.Position and typeof(node.Properties.Position) ~= "Vector3" then
				table.insert(errors, path .. ": Position is not Vector3")
			end
		end
		if node.Children then
			for i, child in ipairs(node.Children) do
				checkNode(child, path .. "." .. (child.Name or ("child_" .. i)))
			end
		end
	end

	for i, child in ipairs(mapData.Layout or {}) do
		checkNode(child, "Layout[" .. i .. "]")
	end

	local ok = #errors == 0
	return ok, errors
end

return MapBuilder