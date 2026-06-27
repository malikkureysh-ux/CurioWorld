--!strict
--[[
	init.server.lua — Server-Bootstrap
	==================================

	Lädt alle Services in der richtigen Reihenfolge:
	1. TelemetryService — zuerst, damit alle anderen tracken können
	2. SaveService — vor allem, was Persistenz braucht
	3. EconomyService — nutzt SaveService + TelemetryService
	4. (weitere Services in Phase 3)
]]

-- Telemetry & Save zuerst
local TelemetryService = require(script.Parent.Services.TelemetryService)
local SaveService       = require(script.Parent.Services.SaveService)

-- EconomyService benötigt beide oben
local EconomyService    = require(script.Parent.Services.EconomyService)

-- Globale Registry (Phase 3: durch Knit/ECS ersetzen)
local Services = script.Parent.Parent:FindFirstChild("Services") or Instance.new("Folder")
Services.Name = "Services"
Services.Parent = script.Parent

_G.CurioWorld = {
	Services = {
		Economy    = EconomyService,
		Save       = SaveService,
		Telemetry  = TelemetryService,
	},
}

-- Dev-Logging
if _G.CURIO_WORLD_DEBUG then
	print("[CurioWorld] Server gestartet. Services:", _G.CurioWorld.Services)
end