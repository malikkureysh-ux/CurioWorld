--!strict
--[[
	M01_PlayerController.lua — Spieler-Bewegung (Skeleton)
	======================================================

	Vollständige Spec: docs/09_system_architecture.md (M-01)

	Verantwortlichkeiten:
	- Laufen, Springen, Doppelsprung, Rutschen, Klettern, Gleiten.
	- Bezirks-spezifische Bewegungsstile (z.B. Kran-Schwingen in Hamburg Harbor).
	- Touch-Input für Mobile (primäre Plattform).

	Phase 2: Skeleton mit öffentlicher API.
	Phase 3: vollständige Implementierung mit HumanoidStateAPI.
]]

local M01_PlayerController = {}

-- ============================================================
-- Public API
-- ============================================================

export type MovementContext = {
	WalkSpeed: number,
	JumpPower: number,
	SprintMultiplier: number,
	District: string?, -- z.B. "HamburgHarbor" — triggert Spezial-Bewegungen
}

function M01_PlayerController:ApplyContext(character: Model, context: MovementContext)
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	humanoid.WalkSpeed = context.WalkSpeed or 16
	humanoid.JumpPower = context.JumpPower or 50
	humanoid.JumpHeight = (context.JumpPower or 50) / 10

	-- Sprint via UserInputService in Phase 3
	-- District-Spezialbewegungen (Kran-Schwingen) via Animation-Trigger
end

-- Kran-Schwingen für Hamburg Harbor (D-014 Highlight)
function M01_PlayerController:TrySwingFromCrane(character: Model, crane: Model): boolean
	-- TODO Phase 3: Physik-Simulation, Seil-Snap, Schwung-Phase
	return false
end

return M01_PlayerController