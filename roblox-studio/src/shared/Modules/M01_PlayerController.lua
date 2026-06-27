--!strict
--[[
	M01_PlayerController.lua — Spieler-Bewegung
	============================================

	Vollständige Spec: docs/09_system_architecture.md (M-01)

	Verantwortlichkeiten:
	- Laufen, Springen, Doppelsprung, Rutschen, Klettern, Gleiten.
	- Bezirks-spezifische Bewegungsstile (z.B. Kran-Schwingen in Hamburg Harbor).
	- Touch-Input für Mobile (primäre Plattform).

	Roblox-API-Hinweis: JumpPower und JumpHeight sind gegenseitig exklusiv.
	Das Setzen der einen Property setzt die andere auf 0 (Roblox-Doku).
	Dieser Controller verwendet bevorzugt JumpHeight (mobiler-freundlicher,
	neuer API), mit optionalem JumpPower-Fallback für klassische Setups.

	Phase 2: Skeleton mit öffentlicher API.
	Phase 3: vollständige Implementierung mit HumanoidStateAPI.
]]

local M01_PlayerController = {}

-- ============================================================
-- Public API
-- ============================================================

export type JumpMode = "Height" | "Power"

export type MovementContext = {
	WalkSpeed: number,
	-- Entweder JumpHeight (modern, mobile-friendly, in Studs)
	-- ODER JumpPower (classic, in studs/frame for legacy).
	JumpHeight: number?,
	JumpPower: number?,
	JumpMode: JumpMode?,        -- default: "Height"
	SprintMultiplier: number,   -- default: 1.5
	District: string?,          -- z.B. "HamburgHarbor" — triggert Spezial-Bewegungen
}

-- Default-Profile pro Bezirk (siehe docs/06_world_bible.md)
M01_PlayerController.DistrictProfiles = {
	HamburgHarbor = { WalkSpeed = 14, JumpHeight = 7, SprintMultiplier = 1.5 },
	SkyBridgeBay  = { WalkSpeed = 16, JumpHeight = 8, SprintMultiplier = 1.6 },
	LibertyBlocks = { WalkSpeed = 16, JumpHeight = 8, SprintMultiplier = 1.6 },
	NeoSakura    = { WalkSpeed = 18, JumpHeight = 9, SprintMultiplier = 1.7 },
	MoonBazaar   = { WalkSpeed = 15, JumpHeight = 7, SprintMultiplier = 1.5 },
}

function M01_PlayerController:ApplyContext(character: Model, context: MovementContext)
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	-- WalkSpeed (immer setzen)
	humanoid.WalkSpeed = context.WalkSpeed or 16

	-- Jump-Mode: Height bevorzugt (Roblox-API-Standard für neue Projekte).
	-- Wir setzen NUR EINE Property — Roblox-API setzt die andere automatisch auf 0.
	local mode: JumpMode = context.JumpMode or "Height"
	if mode == "Height" then
		-- JumpHeight (Studs, frame-rate-unabhängig, mobile-bevorzugt)
		humanoid.JumpHeight = context.JumpHeight or 7.2
		-- JumpPower auf 0 setzen, damit nicht beide konkurrieren
		humanoid.UseJumpPower = false
	else
		-- JumpPower (classic API, in studs/frame)
		humanoid.JumpPower = context.JumpPower or 50
		humanoid.UseJumpPower = true
	end

	-- Sprint-Multiplier wird im Sprint-Service (Phase 3) angewendet;
	-- hier nur dokumentiert, damit Validate() den Wert prüfen kann.
	if context.SprintMultiplier and context.SprintMultiplier <= 0 then
		warn("[M01] SprintMultiplier muss > 0 sein")
	end

	-- District-Spezialbewegungen (Kran-Schwingen) via Animation-Trigger
	-- werden in Phase 3 via AnimationController ausgelöst.
end

-- Kran-Schwingen für Hamburg Harbor (D-014 Highlight)
-- Voraussetzungen:
-- - Spieler:in steht unter CraneA/B/C (siehe hamburg_harbor_map.lua)
-- - Crane hat Hook-Part mit Attribut "Grappleable = true"
-- - Spieler:in interagiert via ProximityPrompt (in Phase 3)
-- Rückgabe: true wenn Schwing-Mechanik ausgelöst wurde.
function M01_PlayerController:TrySwingFromCrane(character: Model, crane: Model): boolean
	-- Phase 2 Stub: nur Hook-Detection, keine echte Physik.
	-- TODO Phase 3: Seil-Snap + Schwung-Phase + Release.
	if not character or not crane then return false end

	local hook = crane:FindFirstChild("Hook", true)
	if not hook or not hook:IsA("BasePart") then return false end
	if not hook:GetAttribute("Grappleable") then return false end

	-- Stub: in Phase 3 löst dies eine BodyVelocity/LinearVelocity aus,
	-- die den Spieler an den Hook heftet und schwingen lässt.
	return true
end

return M01_PlayerController
