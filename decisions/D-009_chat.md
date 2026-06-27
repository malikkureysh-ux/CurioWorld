# D-009 — Chat-Architektur altersabhängig

**Status:** offen (Validierung in Phase 4)
**Datum:** 2026-06-27
**Owner:** Safety Lead

## Problem

Wie kommunizieren Spieler:innen miteinander? Die Wahl prägt Sicherheit, soziales Erlebnis und Compliance.

## Optionen

### Option A — Streng altersabhängig

- 9–11: nur Pings, Emotes, vorgegebene Phrasen.
- 12–13: Standard wie 9–11, optionaler Text mit Roblox-Berechtigung.
- 14–16: volle Chat-Funktion gemäß Roblox-Settings.

### Option B — Einheitlich für alle Altersbänder

- Gleicher Text-Chat für alle, mit Wortfilter.

### Option C — Komplett offen

- Freier Text-Chat, freier Voice-Chat für alle.

## Bewertungsmaßstab

- Sicherheit
- Compliance (C-004, C-005, C-013)
- Soziales Erlebnis
- Plattform-Reputation

## Entscheidung

**Option A — Streng altersabhängig.**

## Begründung

- **Compliance:** Roblox-Regeln und Briefing verlangen altersabhängige Chat-Beschränkungen.
- **Sicherheit:** Jüngere Spieler:innen sind besonders gefährdet durch unmoderierten Kontakt.
- **Soziales Erleben:** Pings, Emotes und Phrasen bieten bereits ein reichhaltiges Kommunikationsrepertoire.

## Erwartete Wirkung

- Hohe Sicherheit für alle Altersbänder.
- Funktionale Kommunikation auch ohne Text.
- Compliance mit Plattform und internationalem Jugendschutz.

## Risiken

- **R-1:** 14–16 könnten sich eingeschränkt fühlen.
  - Mitigation: volle Kommunikation in dieser Altersgruppe gemäß Roblox.
- **R-2:** Spieler:innen zwischen Altersbändern könnten sich missverstehen.
  - Mitigation: Pings und Emotes sind universal verständlich.

## Validierungsplan

| Phase | Aktion |
|---|---|
| Phase 4 | Tests in allen drei Altersbändern |
| Phase 4 | Sicherheits-Pen-Tests |
| Phase 6 | Live-Daten: Vorfälle pro Altersband |

## Quellen

- `11_community_and_safety.md`
- `02_compliance_matrix.md` (C-004, C-005, C-013)

## Änderungsverlauf

| Datum | Version | Änderung | Autor |
|---|---|---|---|
| 2026-06-27 | 0.1 | Initial | Mavis (Agent) |