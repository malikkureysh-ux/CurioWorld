# D-012 — Asset-Pipeline: Blender → FBX → Roblox

**Status:** offen (Validierung in Phase 3)
**Datum:** 2026-06-27
**Owner:** Tech Lead + Art Director

## Problem

Welche 3D-Pipeline nutzen wir für Asset-Erstellung und -Import?

## Optionen

### Option A — Blender → FBX → Roblox

- Blender als DCC.
- FBX als Austauschformat.
- Trim Sheets und LODs für Performance.

### Option B — Direkt Roblox Studio-Tools

- Alles in Roblox Studio bauen.
- Eingeschränkte Modellierungs-Werkzeuge.

### Option C — Hybrid

- Blender für Charaktere und Landmarken, Studio für Props.

## Bewertungsmaßstab

- Künstler-Kontrolle
- Performance
- Pipeline-Wartbarkeit
- Asset-Qualität
- Kosten

## Entscheidung

**Option A — Blender → FBX → Roblox.**

## Begründung

- **Künstler-Kontrolle:** Blender bietet volle Kontrolle für hochqualitative stylisierte Assets.
- **Performance:** Über Trim Sheets und LODs erreichen wir Mobile-Tauglichkeit.
- **Pipeline-Wartbarkeit:** FBX ist ein robuster Industriestandard.
- **Asset-Qualität:** Charaktere, Companions und Landmarken brauchen die Detailtiefe, die Roblox-Studio-Tools nicht bieten.

## Erwartete Wirkung

- Hochqualitative Assets im Anime-Cute-Stil.
- Konsistente Performance durch Trim Sheets und LOD.
- Klare Pipeline mit Versionierung.

## Risiken

- **R-1:** Pipeline-Bruch bei Versionswechsel.
  - Mitigation: Version-Pinning, Regression-Tests.
- **R-2:** Performance-Budgets könnten nicht eingehalten werden.
  - Mitigation: automatische Validierung in CI.

## Validierungsplan

| Phase | Aktion |
|---|---|
| Phase 3 | Pipeline-Validierung mit erstem Test-Asset |
| Phase 3 | Performance-Benchmarks |
| Phase 4 | Vertical Slice Performance-Tests |

## Quellen

- `08_asset_pipeline_blender_to_roblox.md`
- `07_art_direction.md`

## Änderungsverlauf

| Datum | Version | Änderung | Autor |
|---|---|---|---|
| 2026-06-27 | 0.1 | Initial | Mavis (Agent) |