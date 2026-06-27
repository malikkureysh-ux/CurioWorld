# D-005 — Adaptive Engine: vollständig unsichtbar

**Status:** offen (Validierung in Phase 4)
**Datum:** 2026-06-27
**Owner:** Learning Architect + Tech Lead

## Problem

Wie wird die adaptive Schwierigkeits-Anpassung für Spieler:innen sichtbar?

## Optionen

### Option A — Vollständig unsichtbar

- Anpassung passiert im Hintergrund.
- Spieler:innen merken nichts von der Engine.
- Optionaler Sammelbuch-Modus zeigt grobe Zusammenfassung auf Wunsch.

### Option B — Teilweise sichtbar

- Sichtbares „Spieler-Level" oder „Skill-Punkte".
- Spieler:innen sehen, dass sie „weitergekommen" sind.

### Option C — Voll sichtbar

- Spieler:innen wählen Schwierigkeitsstufen selbst.
- Klare Skill-Anzeige.

## Bewertungsmaßstab

- Anti-Schulgefühl
- Anti-Shame
- Wirksamkeit der Anpassung
- Spieler:innen-Motivation
- Compliance mit Briefing

## Entscheidung

**Option A — Vollständig unsichtbar mit optionalem Sammelbuch-Modus.**

## Begründung

- **Anti-Schulgefühl:** Sichtbare Skill-Anzeige erzeugt Schulgefühl.
- **Anti-Shame:** Sichtbares Ranking stigmatisiert schwächere Spieler:innen.
- **Briefing-Konformität:** Pflicht „unsichtbare Anpassung".
- **Motivation:** Sichtbare Belohnungen (Items, Deko, Companions) liefern bereits Feedback.

Der optionale Sammelbuch-Modus ermöglicht es interessierten Spieler:innen, ihre Reise Revue passieren zu lassen, ohne dass es bewertend wirkt.

## Erwartete Wirkung

- Keine Stigmatisierung.
- Spieler:innen erleben das Spiel als fließend und konsistent.
- Anpassung geschieht, ohne dass sie Aufmerksamkeit erfordert.

## Risiken

- **R-1:** Spieler:innen merken Anpassung nicht.
  - Mitigation: Belohnungen kommunizieren Fortschritt; Sammelbuch-Modus bei Bedarf.
- **R-2:** Eltern könnten Anpassungs-Funktion nicht erkennen.
  - Mitigation: Educator-Modus erklärt das Prinzip.

## Validierungsplan

| Phase | Aktion |
|---|---|
| Phase 4 | Qualitative Tests: merken Spieler:innen die Anpassung? |
| Phase 4 | Eltern-Befragung: bewerten sie die Unsichtbarkeit positiv? |
| Phase 6 | Langzeit-Daten: Retention vs. Anpassungs-Häufigkeit |

## Quellen

- `12_adaptive_difficulty_model.md`
- `04_learning_architecture.md` (LP-5)
- `01_research_log.md` T-04, T-08

## Änderungsverlauf

| Datum | Version | Änderung | Autor |
|---|---|---|---|
| 2026-06-27 | 0.1 | Initial | Mavis (Agent) |