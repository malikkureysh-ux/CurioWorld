--!strict
--[[
	M04_Adaptive.lua — Adaptive Learning Engine (Skeleton)
	======================================================

	Vollständige Spec: docs/12_adaptive_difficulty_model.md
	Dieses Modul definiert das Datenmodell + Server-API.

	Prinzipien:
	- Unsichtbar für Spieler:innen (D-005)
	- Anti-Shame (D-006): keine öffentliche Performance-Anzeige
	- Retrieval-Mechaniken (D-007)
]]

local M04_Adaptive = {}

-- ============================================================
-- Typen
-- ============================================================

export type Domain = "Math" | "Physics" | "Logic" | "Language" | "Memory" | "Planning" | "Chemistry" | "Coding"

export type DomainScore = {
	level: number,        -- 0.0–1.0, normalisiert
	confidence: number,   -- 0.0–1.0, Vertrauen ins Level
	recent_trend: "rising" | "stable" | "falling" | "unknown",
	samples: number,
}

export type CompetencyProfile = {
	pid: string, -- gehashte Spieler-ID
	domains: { [Domain]: DomainScore },
	updated_at: number,
}

export type AdaptiveRecommendation = {
	SuggestedDifficulty: number,        -- 0.0–1.0
	HelpDepth: "none" | "subtle" | "gentle" | "clear",
	LanguageComplexity: "simple" | "standard" | "advanced",
	PacingHint: "slower" | "normal" | "faster",
}

-- ============================================================
-- Default-Score
-- ============================================================

local function newDomainScore(): DomainScore
	return {
		level = 0.5,
		confidence = 0.0,
		recent_trend = "unknown",
		samples = 0,
	}
end

local function newProfile(pid: string): CompetencyProfile
	return {
		pid = pid,
		domains = {
			Math     = newDomainScore(),
			Physics  = newDomainScore(),
			Logic    = newDomainScore(),
			Language = newDomainScore(),
			Memory   = newDomainScore(),
			Planning = newDomainScore(),
			Chemistry= newDomainScore(),
			Coding   = newDomainScore(),
		},
		updated_at = os.time(),
	}
end

M04_Adaptive.newProfile = newProfile

-- ============================================================
-- Update nach Signal (Erfolg/Misserfolg, Antwortzeit)
-- ============================================================

--[[
	RecordSignal(profile, domain, signal)
	signal: { success: bool, latency_ms: number, hint_used: bool, attempts: number }
]]
function M04_Adaptive:RecordSignal(profile: CompetencyProfile, domain: Domain, signal: {
	success: boolean,
	latency_ms: number,
	hint_used: boolean,
	attempts: number,
})
	local d = profile.domains[domain]
	if not d then return end

	d.samples += 1

	-- Bayesian-Update (vereinfacht): +level wenn Erfolg, -level wenn Misserfolg.
	-- Hint-Nutzung und hohe Attempts dämpfen den Sprung.
	local delta = signal.success and 0.04 or -0.03
	if signal.hint_used then delta *= 0.5 end
	if signal.attempts > 3 then delta *= 0.5 end

	d.level = math.max(0.0, math.min(1.0, d.level + delta))

	-- Confidence wächst mit Samples.
	d.confidence = math.min(1.0, d.samples / 20.0)

	-- Trend: basiert auf letzte 5 Signals.
	-- (Phase 3: rolling window)
	d.recent_trend = delta > 0 and "rising" or (delta < 0 and "falling" or "stable")

	profile.updated_at = os.time()
end

-- ============================================================
-- Empfehlung ableiten (für Quest-System)
-- ============================================================

function M04_Adaptive:Recommend(profile: CompetencyProfile, domain: Domain): AdaptiveRecommendation
	local d = profile.domains[domain] or newDomainScore()

	-- Difficulty passt zum Level, leicht darunter für Flow (Csikszentmihalyi).
	local suggestedDifficulty = math.max(0.1, math.min(0.9, d.level - 0.05))

	-- HelpDepth: mehr Hilfe bei niedrigem Confidence.
	local helpDepth: AdaptiveRecommendation.HelpDepth
	if d.confidence < 0.2 then
		helpDepth = "clear"
	elseif d.confidence < 0.5 then
		helpDepth = "gentle"
	elseif d.confidence < 0.8 then
		helpDepth = "subtle"
	else
		helpDepth = "none"
	end

	-- Language: passt zur Alters-Schätzung (Phase 3: aus Input-Mustern ableiten).
	local languageComplexity: AdaptiveRecommendation.LanguageComplexity
	if d.level < 0.3 then
		languageComplexity = "simple"
	elseif d.level < 0.7 then
		languageComplexity = "standard"
	else
		languageComplexity = "advanced"
	end

	-- Pacing: bei steigender Tendenz etwas schneller, sonst normal.
	local pacing: AdaptiveRecommendation.PacingHint
	if d.recent_trend == "rising" then
		pacing = "faster"
	elseif d.recent_trend == "falling" then
		pacing = "slower"
	else
		pacing = "normal"
	end

	return {
		SuggestedDifficulty = suggestedDifficulty,
		HelpDepth = helpDepth,
		LanguageComplexity = languageComplexity,
		PacingHint = pacing,
	}
end

return M04_Adaptive