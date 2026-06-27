# D-011 — Community-Schutzarchitektur

**Status:** offen (Validierung in Phase 5)
**Datum:** 2026-06-27
**Owner:** Safety Lead

## Problem

Wie schützen wir Spieler:innen in sozialen Situationen?

## Optionen

### Option A — Mehrschichtig (Filter + Reporting + Eskalation)

- Wortfilter in 9 Sprachen.
- In-Game-Meldemechanismus.
- Mehrstufige Eskalation.
- Roblox-Plattform-Integration.

### Option B — Nur Roblox-Standard

- Roblox-eigene Sicherheitstools ohne eigene Schicht.

### Option C — Light-Touch

- Wenig eigene Schutzmaßnahmen.

## Bewertungsmaßstab

- Sicherheit
- Compliance
- Implementierungskomplexität

## Entscheidung

**Option A — Mehrschichtige Schutzarchitektur.**

## Begründung

- **Compliance:** Briefing und Compliance-Matrix verlangen mehrschichtige Schutzmaßnahmen.
- **Sicherheit:** Mehrere Verteidigungslinien reduzieren Risiken.
- **Roblox-Integration:** Roblox-Standard-Report-System ist Basis, ergänzt um eigene Schichten.

## Erwartete Wirkung

- Hohe Sicherheit.
- Klar definierte Eskalation.
- Nachvollziehbarkeit für Eltern und Plattform.

## Risiken

- **R-1:** Komplexität der Implementierung.
  - Mitigation: schrittweise Einführung, priorisierte Rollouts.
- **R-2:** Wortfilter in 9 Sprachen benötigt linguistische Expertise.
  - Mitigation: externe Berater:innen, kontinuierliche Updates.

## Validierungsplan

| Phase | Aktion |
|---|---|
| Phase 4 | Pen-Tests |
| Phase 5 | Externe Sicherheits-Audits |
| Phase 6 | Live-Incident-Tracking |

## Quellen

- `11_community_and_safety.md`
- `02_compliance_matrix.md` (C-006, C-012, C-013)

## Änderungsverlauf

| Datum | Version | Änderung | Autor |
|---|---|---|---|
| 2026-06-27 | 0.1 | Initial | Mavis (Agent) |