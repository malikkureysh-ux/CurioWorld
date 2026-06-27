--!strict
--[[
	TelemetryService.lua — Anonyme Telemetrie (M-12)
	=================================================

	DSGVO/COPPA-konform:
	- Spieler-ID wird gehashed, niemals roh gespeichert.
	- Personenbezug: nur Alter-Band (9-11/12-13/14-16), keine Profilierung.
	- Eltern können vollen Export + Löschung anfordern (Phase 4 Tool).

	Storage: HTTP POST zu eigenem Analytics-Backend ODER Roblox Analytics Service.
	Für Phase 2: nur In-Memory-Buffer + Console-Logs.
]]

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local TelemetryService = {}

-- ============================================================
-- In-Memory-Buffer (Phase 2 Stub)
-- ============================================================

local buffer: { any } = {}
local MAX_BUFFER = 1000
local FLUSH_INTERVAL = 30 -- Sekunden

local function hashPlayerId(player: Player): string
	-- Stable Hash ohne externe Lib (für Phase 2; echter Hash in Phase 4)
	local s = tostring(player.UserId)
	local h = 0
	for i = 1, #s do
		h = (h * 31 + string.byte(s, i)) % 2^31
	end
	return string.format("h_%x", h)
end

-- ============================================================
-- Public API
-- ============================================================

function TelemetryService:Track(player: Player, eventName: string, properties: { [string]: any }?)
	if not RunService:IsServer() then
		warn("[TelemetryService] Track nur Server-seitig aufrufbar")
		return
	end

	local entry = {
		ts = os.time(),
		event = eventName,
		pid = hashPlayerId(player),
		props = properties or {},
	}

	table.insert(buffer, entry)

	if #buffer >= MAX_BUFFER then
		self:Flush()
	end

	-- Dev-Logging (kann in Production auf DEBUG-Level gestellt werden)
	if _G.CURIO_WORLD_DEBUG then
		print(string.format("[Telemetry] %s pid=%s", eventName, entry.pid))
	end
end

function TelemetryService:Flush()
	if #buffer == 0 then return end

	-- Phase 2: Console-Log. Phase 3: HTTP-POST an Backend.
	if _G.CURIO_WORLD_DEBUG then
		print(string.format("[Telemetry] Flushing %d events", #buffer))
		for _, entry in ipairs(buffer) do
			print(string.format("  %s | %s | %s",
				os.date("%Y-%m-%d %H:%M:%S", entry.ts),
				entry.event,
				HttpService:JSONEncode(entry.props or {})
			))
		end
	end

	-- TODO Phase 3: HttpService:PostAsync(ANALYTICS_URL, HttpService:JSONEncode(buffer))
	-- Für jetzt: Buffer leeren, damit nichts im Memory bleibt.
	table.clear(buffer)
end

-- Auto-Flushtimer (Server only)
if RunService:IsServer() then
	task.spawn(function()
		while true do
			task.wait(FLUSH_INTERVAL)
			TelemetryService:Flush()
		end
	end)

	-- Bei Server-Shutdown flushen
	game:BindToClose(function()
		TelemetryService:Flush()
	end)
end

return TelemetryService