--!strict
--[[
	M05_Puzzle.lua — Puzzle-Framework (Skeleton)
	============================================

	Vollständige Spec: docs/09_system_architecture.md (M-05).

	Puzzle-Typen:
	- Sortier-Puzzle (Drag-and-Drop, Reihenfolge)
	- Bau-Puzzle (Maschinen, Schalter, Sequenzen)
	- Erinnerungs-Puzzle (Karten aufdecken, Sequenzen merken)
	- Logik-Puzzle (Bedingungen, Aussagen)

	Phase 2: Skeleton mit Typen.
	Phase 3: Puzzle-Instanzen für Hamburg-Harbor-Erstausbau (5 Stück).
]]

local M05_Puzzle = {}

export type PuzzleType = "sort" | "build" | "memory" | "logic"

export type Puzzle = {
	id: string,
	type: PuzzleType,
	domain: "Math" | "Physics" | "Logic" | "Language" | "Memory" | "Planning",
	difficulty_range: { min: number, max: number },
	prompt_key: string,
	solution_check: ((input: any) -> (boolean, number)), -- success, score 0–1
	hint_keys: { string },
}

return M05_Puzzle