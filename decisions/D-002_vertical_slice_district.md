# D-002 — Vertical-Slice-Bezirk: Hamburg Harbor (5-District-Plan)

**Status:** entschieden (Validierung in Phase 4)
**Datum:** 2026-06-27 (v0.1), 2026-06-27 14:18 (v1.0 — Refit nach Draft-Konzepten)
**Owner:** Lead Designer

## Problem

Curio World umfasst fünf Haupt-Districts (siehe Hub-Konzept-Bild). Welcher District wird zuerst vollständig prototypisiert? Die Wahl prägt die frühe Spielerfahrung, das erste öffentliche Bild und den Lern-Showcase.

## Options

### Option A — Hamburg Harbor als Vertical Slice, alle 5 parallel in Planung

Aus dem Hub-Bild (Draft 1) sind 5 Districts sichtbar:

| District | Inspiration | Topographie | Lernfokus | Visuelle Identität | Komplexität |
|---|---|---|---|---|---|
| SkyBridge Bay | San Francisco | Brücke, Hügel | Physik, Mathe | warm, sonnig | mittel-hoch |
| Liberty Blocks | New York (Liberty Island) | Insel, Skyline | Logik, Geschichte | urban, vertikal | mittel-hoch |
| Neo Sakura | Tokyo | Neon, vertikal | Informatik, Logik | dicht, lebhaft | hoch |
| Hamburg Harbor | Hamburg | Hafen, Kräne | Physik, Mathe | freundlich, maritim | mittel |
| Moon Bazaar | Istanbul | Basar, Gassen | Sprache, Chemie | warm, exotisch | mittel |

**Vertical Slice = Hamburg Harbor.**

### Option B — Harbor Forge als alleiniger Start-District (verworfen)

Würde das Hub-Konzept des Users ignorieren. Hub mit 5 Districts ist explizit als Visitenkarte gedacht.

### Option C — SkyBridge Bay als Vertical Slice

Auch möglich (großes Lern-Potenzial), aber Hamburg Harbor hat klarere Topographie für Pilot-Slice und kulturell sensiblere Umsetzung (siehe Risiken unten).

## Bewertungsmaßstab

- Lern-Potenzial (Anknüpfung an mehrere Domänen)
- Kulturelle Sensibilität (kein Klischee)
- Abgegrenzte Topographie (gut für Pilot-Slice)
- Asset-Komplexität (beherrschbar für Phase 3–4)
- Bewegungs-Vielfalt (Parkour + Lernen kombiniert)
- Performance-Budget (Mobile-tauglich)

## Entscheidung

**Option A — Hamburg Harbor als Vertical Slice, alle 5 Districts als Vollplan.**

## Begründung

- **Hub-Konzept:** Der User hat in Draft-Bild 1 explizit einen 5-District-Hub designt. Das ist die Vision. Vertical Slice darf nicht das Konzept einschränken, sondern muss exemplarisch für die anderen Bezirke funktionieren.
- **Topographie:** Hamburg Harbor bietet klare Anker (Hafenbecken, Kaimauern, Kräne, Speicherhäuser, Werft, Leuchtturm) — visuell sofort lesbar, gut für Orientierung, guter Pilot-Slice.
- **Lern-Potenzial:** Kran-Steuerung (Hebelgesetz, Koordinaten) + Material-Logistik (Mengen, Priorisierung) + Wetter-/Gezeiten-Rätsel (Physik, Mathe).
- **Kulturelle Sensibilität:** Hamburg als Hafenstadt bietet visuelle Inspiration (Kran-Silhouetten, Wasser, Lagerhäuser) ohne 1:1-Klischee-Risiko (anders als z.B. Liberty Island, wo Eiffelturm-Verschnitt schnell rassistisch wirken kann).
- **Asset-Komplexität:** Hafen-Architektur ist modular (Kräne, Speicher, Boote); mit wenigen Bausteinen viel Varianz.
- **Performance-Budget:** Wasser + Himmel über LOD und Textur-Streaming performant.

## Erwartete Wirkung

- Schneller Pilot-Slice mit klarer Identität, der die anderen 4 Districts informiert.
- Validierbare Mechaniken für die anderen Bezirke (Kran-Steuerung, Material-Logistik, Community-Bau).
- Hub-System als gemeinsamer Anker für alle 5.
- Guter Lern-Showcase für Mathematik und Physik.

## Risiken

- **R-1:** Hafen-Setting hat Wasser-Themen — visuell ansprechend, aber reale Schwimm-Mechaniken müssen vermieden werden.
  - Mitigation: Wasser ist rein visuell und dekorativ; Spieler:innen können nicht „ertrinken" oder schwimmen.
- **R-2:** Kran-Steuerung ist technisch anspruchsvoll.
  - Mitigation: Schrittweiser Tutorial-Aufbau, automatisches Sicherheitsnetz, vereinfachte Sekundär-Version (Greifarm statt Voll-Kran) als Fallback.
- **R-3:** Wasserthemen könnten bei jüngeren Spieler:innen unbehaglich wirken.
  - Mitigation: Wasser ist pastellig und freundlich, nicht bedrohlich; Testing in Phase 4.
- **R-4:** 5-District-Scope ist groß — Roadmap-Risiko.
  - Mitigation: Hamburg Harbor als vollständiger Slice Phase 4; die anderen 4 als Stubs/Previews im Hub, voll ausgebaut in Wellen Phase 5–6.
- **R-5:** Liberty Island wirkt politisch aufgeladen.
  - Mitigation: Inspiration ist New York Skyline + Hafen-Insel, nicht das Original-Denkmal; Architektur ahmt generische Skyline nach.
- **R-6:** Tokyo Neon wirkt klischeehaft (anime-trope).
  - Mitigation: Inspiration ist moderne Stadt, Neon-Akzente subtil, kein „Totentanz"-Klischee.

## Validierungsplan

| Phase | Aktion |
|---|---|
| Phase 2 | Skizzen-Test mit jungen Spieler:innen (Concept-Tests, alle 5) |
| Phase 4 | Hamburg-Harbor-Playtest mit 30 Spieler:innen pro Altersband |
| Phase 4 | Performance-Tests auf Low-End-Mobile |
| Phase 5 | SkyBridge Bay-Playtest (zweiter Slice) |
| Phase 6 | Neo Sakura + Liberty Blocks + Moon Bazaar in Wellen |

## Quellen

- `draft images/ChatGPT Image 27. Juni 2026, 13_48_24 (1).png` (Hub zeigt 5 Districts)
- `roblox_ai_briefing.md` (Pflichtbezirke)
- `06_world_bible.md` (alle 5 District-Details)

## Änderungsverlauf

| Datum | Version | Änderung | Autor |
|---|---|---|---|
| 2026-06-27 | 0.1 | Initial (nur Harbor Forge) | Mavis (Agent) |
| 2026-06-27 14:18 | 1.0 | Refit auf 5-District-Plan mit Hamburg Harbor als Vertical Slice | Mavis (Agent) |