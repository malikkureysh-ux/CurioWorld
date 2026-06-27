# 17 — Decision Log

## Zweck

Dieses Dokument ist das zentrale Register aller wesentlichen Entscheidungen für **Curio World**. Jede Entscheidung hat eine eindeutige ID, eine begründete Bewertung und Verweise auf Detail-Dateien.

## Annahmen

- Jede wesentliche Entscheidung wird hier protokolliert.
- Format folgt dem Briefing: ID, Datum, Problem, Optionen, Bewertungsmaßstab, Entscheidung, Begründung, erwartete Wirkung, Risiken, Validierungsplan.
- Detail-Begründungen werden in separaten Dateien in `decisions/` abgelegt.

## Quellen

- `roblox_ai_briefing.md` (Anforderung Decision Log)
- Alle bisherigen Dokumente (`docs/00–16`)

## Entscheidungen

### D-001 — Naming „Curio World"

| Feld | Wert |
|---|---|
| Datum | 2026-06-27 (v0.1, v1.0, v2.0) |
| Problem | Produkt benötigt einen klaren Namen, der zu Vision, Zielgruppe, Plattform und 9 Sprachen passt — und KEINE Naming-Kollision auf Roblox hat. |
| Optionen | (A) **Curio World** ✓, (B) MetroMinds Adventures, (C) Wonder World (Kollision), (D) Sub-Title-Varianten, (E) Curiosity Hub/Atlas Rangers/Wunderhub |
| Bewertungsmaßstab | Vision-Fit, Zielgruppenfit (9–16), Verständlichkeit, Internationalisierbarkeit (9 Sprachen), Einprägsamkeit, **Roblox-Such-Sicherheit**, Marken-Potenzial |
| Entscheidung | **A — Curio World** |
| Begründung | **Naming-Audit-Trail:** v0.1 „MetroMinds Adventures" (verworfen, widersprach User-Drafts), v1.0 „Wonder World" (verworfen — direkte Kollision mit existierendem Roblox-Pet-Game „Wonder World!" mit aktivem KOALA EVENT). v2.0 **Curio World** ist such-sicher (geprüft 2026-06-27 via `site:roblox.com`), funktioniert in allen 9 Sprachen, ist altersübergreifend ansprechend (9–16), trägt bewusst keinen Bildungsbezug (Lernen ist unsichtbar), hat starkes Mascot-Potenzial (Curio-Companion) und Lizenz-Potenzial (Stofftiere, Buchreihe, TV). |
| Erwartete Wirkung | Roblox-Such-Dominanz ohne Kollision, konsistente User-Vision, starke internationale Markenbasis, kein Rename-Risiko post-launch. |
| Risiken | „Curio" im Deutschen initial ungewohnt (Mitigation: Audio-First-Marketing). Kein Bildungsbezug im Namen (Mitigation: Educator-Modus, klares Marketing). Domain curio-world.com möglicherweise belegt (Mitigation: curioworld.de / .game Fallback). |
| Validierungsplan | Phase 2 ✅ Naming-Check (durchgeführt). Phase 2 Naming-Test mit Familien. Phase 5 Trademark + Domain-Kauf. |
| Detail | `decisions/D-001_naming.md` |

### D-002 — Vertical-Slice-Bezirk: Hamburg Harbor (5-District-Plan)

| Feld | Wert |
|---|---|
| Datum | 2026-06-27 (v0.1), 2026-06-27 14:18 (v1.0) |
| Problem | Welcher District wird zuerst vollständig prototypisiert, wenn das Hub-Konzept 5 Districts vorsieht? |
| Optionen | (A) Hamburg Harbor als Slice + 5-District-Plan, (B) Hamburg Harbor allein (würde Hub ignorieren), (C) SkyBridge Bay als Slice |
| Bewertungsmaßstab | Lern-Potenzial, kulturelle Sensibilität, Topographie, Asset-Komplexität, Performance, Konsistenz mit User-Vision |
| Entscheidung | **A — Hamburg Harbor als Vertical Slice, alle 5 Districts im Vollplan** |
| Begründung | Hub-Konzept zeigt 5 Districts (SkyBridge Bay, Liberty Blocks, Neo Sakura, Hamburg Harbor, Moon Bazaar). Hamburg Harbor bietet klare Topographie, starkes Physik-/Mathe-Potenzial, kulturell sensible Umsetzung (anders als Liberty Island, wo Klischee-Risiko besteht). Vertical Slice informiert die anderen 4 Bezirke. |
| Erwartete Wirkung | Schneller Pilot-Slice mit klarer Identität, validierbare Mechaniken für alle 5, Hub-System als gemeinsamer Anker. |
| Risiken | Scope zu groß (Mitigation: Hamburg Phase 4 voll, andere 4 als Stubs + Wellen Phase 5–6). Liberty Island politisch aufgeladen (Mitigation: Skyline-Inspiration, kein Original-Denkmal). Tokyo Neon klischeehaft (Mitigation: moderne Stadt, subtile Neon-Akzente). |
| Validierungsplan | Phase 2 Concept-Tests aller 5. Phase 4 Hamburg-Playtest. Phase 5–6 weitere Districts in Wellen. |
| Detail | `decisions/D-002_vertical_slice_district.md` |

### D-003 — Lernprinzip: Versteckt statt sichtbar

| Feld | Wert |
|---|---|
| Datum | 2026-06-27 |
| Problem | Wie wird Lernen im Spiel präsentiert? |
| Optionen | (A) Versteckte Mechaniken, (B) Sichtbarer Lernmodus, (C) Hybrid (sichtbar + versteckt) |
| Bewertungsmaßstab | Spielspaß, Anti-Schulgefühl, elterliche Akzeptanz, Nachvollziehbarkeit |
| Entscheidung | A — Versteckte Mechaniken |
| Begründung | Briefing-Prinzip „Spiel zuerst" + Anti-Schulgefühl. Sichtbarer Modus würde das Schulgefühl erzeugen. Hybrid würde Verwirrung stiften. Versteckte Mechaniken sind die ehrlichste Umsetzung des Lernversprechens. |
| Erwartete Wirkung | Spieler:innen erleben sich nicht als Lernende, sondern als Problemlöser:innen. Eltern sehen den Wert im Educator-Modus. |
| Risiken | Eltern könnten keinen Lernwert erkennen. Mitigation: Educator-Modus und About-Bereich. |
| Validierungsplan | Phase 4 Eltern-Befragung. |
| Detail | `decisions/D-003_learning_principle.md` |

### D-004 — Monetarisierung: Kosmetik-only + VIP-Komfort-Pass

| Feld | Wert |
|---|---|
| Datum | 2026-06-27 (v0.1), 2026-06-27 14:18 (v1.0) |
| Problem | Welche Verkaufskategorien werden angeboten? Draft-Konzept zeigt VIP-Badge — wie mit Pay-to-Win-Verbot vereinbaren? |
| Optionen | (A) Kosmetik + VIP-Komfort-Pass, (B) Power-Verkäufe, (C) Gemischt, (D) Kosmetik ohne VIP |
| Bewertungsmaßstab | Compliance (C-002, C-003), Ethik, Vertrauen Eltern, langfristige Bindung, Konsistenz mit User-Vision |
| Entscheidung | **A — Kosmetik-only + VIP-Komfort-Pass** |
| Begründung | Compliance verbietet Pay-to-Win für Kinderprodukte. VIP-Pass bietet nur kosmetische und komfortable Vorteile (Slots, Foto-Filter, früher Cosmetics-Zugang, kein Gameplay-Boost, kein XP-Boost, keine Stamina-Refill). User-Vision zeigt VIP-Badge im HUD. Roblox-Spieler:innen kennen VIP-Modelle (Adopt Me, Pet Simulator). |
| Erwartete Wirkung | Hohe elterliche Akzeptanz durch Transparenz, stabile Konversion 3–8 % (VIP) + 1–3 % (Einzelkäufe), langfristige Bindung. |
| Risiken | Compliance-Drift wenn VIP-Pass später Vorteile bietet (Mitigation: strikt getrennte Module, Compliance-Audits). Eltern-Verwirrung (Mitigation: Roblox-Parental-Controls + FAQ). |
| Validierungsplan | Phase 2 Marktanalyse VIP-Modelle. Phase 4 Beta-Test mit 500 Spieler:innen. Phase 5 Compliance-Audit. Phase 6 Live-Daten. |
| Detail | `decisions/D-004_monetization.md` |

### D-005 — Adaptive Engine: diskret und unsichtbar

| Feld | Wert |
|---|---|
| Datum | 2026-06-27 |
| Problem | Wie wird die adaptive Schwierigkeit sichtbar? |
| Optionen | (A) Vollständig unsichtbar, (B) Teilweise sichtbar (Level-Anzeige), (C) Voll sichtbar (Wahl-Menü) |
| Bewertungsmaßstab | Anti-Schulgefühl, Anti-Shame, Wirksamkeit der Anpassung |
| Entscheidung | A — Vollständig unsichtbar mit optionalem Sammelbuch-Modus |
| Begründung | Lernforschung zu Anti-Shame + Briefing-Anforderung. Sammelbuch-Modus ermöglicht interessierten Spieler:innen einen Blick ohne Bewertung. |
| Erwartete Wirkung | Keine Stigmatisierung, Spieler:innen erleben das Spiel als fließend. |
| Risiken | Spieler:innen merken Anpassung nicht. Mitigation: Belohnungen kommunizieren Wechsel. |
| Validierungsplan | Phase 4 qualitative Tests. |
| Detail | `decisions/D-005_adaptive_visibility.md` |

### D-006 — Anti-Shame-Prinzip

| Feld | Wert |
|---|---|
| Datum | 2026-06-27 |
| Problem | Wie verhindern wir Stigmatisierung durch Anpassung? |
| Optionen | (A) Strenge Anti-Shame-Regeln, (B) Light-Touch, (C) keine spezielle Politik |
| Bewertungsmaßstab | Inklusivität, neurodivergenz-freundlich, langfristige Bindung |
| Entscheidung | A — Strenge Anti-Shame-Regeln |
| Begründung | Briefing-Pflicht, Forschung zu Neurodivergenz und adaptiven Spielen. |
| Erwartete Wirkung | Inklusives Spielerlebnis für alle Altersbänder und Profile. |
| Risiken | Anti-Shame könnte Erfolge weniger sichtbar machen. Mitigation: Belohnungen klar kommunizieren. |
| Validierungsplan | Phase 4 Beobachtung, Phase 6 Feedback. |
| Detail | `decisions/D-006_anti_shame.md` |

### D-007 — Memory-Design mit Retrieval

| Feld | Wert |
|---|---|
| Datum | 2026-06-27 |
| Problem | Wie fördern wir aktives Erinnern ohne Test-Charakter? |
| Optionen | (A) Retrieval-Mechaniken, (B) Recognition (Wiedererkennung), (C) Gemischt |
| Bewertungsmaßstab | Lernwirksamkeit, Spielspaß |
| Entscheidung | A — Retrieval-Mechaniken |
| Begründung | Forschung zu Retrieval Practice zeigt Überlegenheit gegenüber Recognition. |
| Erwartete Wirkung | Stärkeres Behalten, ohne Test-Charakter. |
| Risiken | Retrieval kann Frust erzeugen. Mitigation: Adaptive Hilfe, freundliches UI. |
| Validierungsplan | Phase 4 Lern-Tests. |
| Detail | `decisions/D-007_memory_design.md` |

### D-008 — Sprachstrategie: 9 Sprachen von Anfang an

| Feld | Wert |
|---|---|
| Datum | 2026-06-27 |
| Problem | Welche Sprachen unterstützen wir zum Launch? |
| Optionen | (A) 9 Sprachen (DE, TR, EN, HI, ES, FR, ZH, JA, AR), (B) 5 Sprachen initial, später erweitern, (C) nur EN |
| Bewertungsmaßstab | Zielgruppen-Erreichung, technische Komplexität, Kosten |
| Entscheidung | A — 9 Sprachen von Anfang an |
| Begründung | Briefing-Pflicht. Frühzeitige Lokalisierung günstiger als späteres Refactoring. Großer Zielgruppenfit. |
| Erwartete Wirkung | Breite Zielgruppen-Adressierung, kulturelle Sichtbarkeit. |
| Risiken | Hoher Übersetzungs- und Audio-Aufwand. Mitigation: starke Lokalisierungs-Pipeline, parallele Übersetzung. |
| Validierungsplan | Phase 6 Lokalisierungs-Audit. |
| Detail | `decisions/D-008_i18n.md` |

### D-009 — Chat-Architektur altersabhängig

| Feld | Wert |
|---|---|
| Datum | 2026-06-27 |
| Problem | Wie kommunizieren Spieler:innen miteinander? |
| Optionen | (A) Streng altersabhängig (Pings/Emotes für 9–11, Text optional), (B) Einheitlich, (C) Komplett offen |
| Bewertungsmaßstab | Sicherheit, Kommunikationsqualität, soziales Erlebnis |
| Entscheidung | A — Streng altersabhängig |
| Begründung | Compliance (C-004, C-005), Briefing-Prinzip „Community, aber sicher". |
| Erwartete Wirkung | Hohe Sicherheit, funktionale Kommunikation. |
| Risiken | 14–16 könnten sich eingeschränkt fühlen. Mitigation: volle Kommunikation in dieser Altersgruppe. |
| Validierungsplan | Phase 4 Tests in allen Altersbändern. |
| Detail | `decisions/D-009_chat.md` |

### D-010 — Währungsdesign: Gold + Gems + Robux (KEIN Stamina)

| Feld | Wert |
|---|---|
| Datum | 2026-06-27 (v0.1), 2026-06-27 14:18 (v1.0) |
| Problem | Welche Währungen verwenden wir? Draft-HUD zeigt 3 Slots inkl. Energy/Stamina — wie mit Anti-Frust vereinbaren? |
| Optionen | (A) Gold + Gems + Robux, KEIN Stamina, (B) Spark + Robux, (C) Eigene Premium-Currency, (D) 3 Währungen MIT Stamina |
| Bewertungsmaßstab | Konsistenz mit User-Vision, Anti-Frust, Compliance, Spieler:innen-Erfahrung, Wirtschafts-Balance |
| Entscheidung | **A — Gold + Gems + Robux, KEIN Stamina** |
| Begründung | User-Vision zeigt 3-Slot-HUD. Stamina widerspricht dem Anti-Frust-Prinzip (Briefing-Pflicht). Lösung: 3. Slot wird zu „Daily-Bonus-Status" uminterpretiert (Belohnungs-Boost, kein Verbrauchs-Resource). Gold (Massen, Gameplay), Gems (Selten, Gameplay), Robux (Echtgeld-Premium). Keine eigene Premium-Currency außer Robux → keine zusätzlichen Compliance-Anforderungen. |
| Erwartete Wirkung | Klare 3-Stufen-Wirtschaft, Anti-Frust (niemand muss warten), Elternfreundlich (kein Pay-to-skip-wait), Conversion durch Gems + Robux. |
| Risiken | Gems als „Pay-to-skip" missinterpretiert (Mitigation: Gems NUR für Kosmetik, Compliance-Audit). 3-Währungs-Verwirrung bei 9–11 (Mitigation: Tutorial, Hover-Tooltips, erste 30 Min nur Gold). Gold-Inflation (Mitigation: Sink-Mechaniken, Balance-Simulation). Daily-Bonus-Status als „Energy" missverstanden (Mitigation: UI-Text + Icon ändern). |
| Validierungsplan | Phase 2 Marktanalyse 3-Währungs-Modelle. Phase 4 Spieler:innen-Befragung. Phase 5 Wirtschafts-Simulation + Compliance-Audit. Phase 6 Live-Monitoring. |
| Detail | `decisions/D-010_currency.md` |

### D-011 — Community-Schutzarchitektur

| Feld | Wert |
|---|---|
| Datum | 2026-06-27 |
| Problem | Wie schützen wir Spieler:innen in sozialen Situationen? |
| Optionen | (A) Mehrschichtig (Filter + Reporting + Eskalation), (B) Nur Roblox-Standard, (C) Light-Touch |
| Bewertungsmaßstab | Sicherheit, Akzeptanz |
| Entscheidung | A — Mehrschichtige Schutzarchitektur |
| Begründung | Compliance (C-006, C-012, C-013), Briefing-Pflicht. |
| Erwartete Wirkung | Hohe Sicherheit, klar definierte Eskalation. |
| Risiken | Komplexität der Implementierung. Mitigation: schrittweise Einführung. |
| Validierungsplan | Phase 5 Sicherheits-Audit. |
| Detail | `decisions/D-011_community_protection.md` |

### D-012 — Asset-Pipeline: Blender → FBX → Roblox

| Feld | Wert |
|---|---|
| Datum | 2026-06-27 |
| Problem | Welche 3D-Pipeline nutzen wir? |
| Optionen | (A) Blender → FBX → Roblox, (B) Direkt Roblox Studio-Tools, (C) Hybrid |
| Bewertungsmaßstab | Künstler-Kontrolle, Performance, Pipeline-Wartbarkeit |
| Entscheidung | A — Blender → FBX → Roblox |
| Begründung | Blender ermöglicht hochqualitative stylisierte Assets. FBX ist Roblox-Standard-Import. Performance-Budgets werden über Trim Sheets und LOD kontrolliert. |
| Erwartete Wirkung | Hochqualitative Assets, konsistente Performance. |
| Risiken | Pipeline-Bruch bei Versionswechsel. Mitigation: Version-Pinning, Tests. |
| Validierungsplan | Phase 3 Pipeline-Validierung. |
| Detail | `decisions/D-012_asset_pipeline.md` |

### D-013 — Accessibility-Optionen

| Feld | Wert |
|---|---|
| Datum | 2026-06-27 |
| Problem | Welche Accessibility-Optionen bieten wir an? |
| Optionen | (A) Drei Profile + Granular-Optionen, (B) Nur Granular, (C) Nur Standard |
| Bewertungsmaßstab | Inklusivität, Komplexität, neurodivergenz-freundlich |
| Entscheidung | A — Drei Profile + Granular-Optionen |
| Begründung | Forschung zu Neurodivergenz + Briefing-Pflicht. Profile machen es einfach, Granular-Optionen ermöglichen Feintuning. |
| Erwartete Wirkung | Breite Inklusivität. |
| Risiken | UI-Komplexität. Mitigation: klare Kategorisierung. |
| Validierungsplan | Phase 4 Tests mit neurodivergenz-erfahrenen Tester:innen. |
| Detail | `decisions/D-013_accessibility.md` |

### D-014 — Vertical-Slice-Bewegung: Schwingen mit Kranen (Hamburg Harbor)

| Feld | Wert |
|---|---|
| Datum | 2026-06-27 (v0.1), 2026-06-27 14:18 (v1.0 Naming-Refit) |
| Problem | Welche bezirks-spezifische Bewegung wird in Hamburg Harbor erprobt? |
| Optionen | (A) Kran-Schwingen, (B) Boot-Gleitbahnen, (C) Standard-Springen, (D) Mehrere kombiniert |
| Bewertungsmaßstab | Spielspaß, Lernanbindung (Physik), Performance |
| Entscheidung | D — Mehrere kombiniert (Kran-Schwingen als Highlight) |
| Begründung | Vielfalt erhöht Wiederspielbarkeit, Kran-Schwingen ist einzigartig und physikalisch lehrreich. |
| Erwartete Wirkung | Starke Mechanik-Identität für den Bezirk. |
| Risiken | Komplexität der Steuerung. Mitigation: schrittweiser Tutorial-Aufbau. |
| Validierungsplan | Phase 4 Playtest. |
| Detail | `decisions/D-014_harbor_movement.md` |

### D-015 — Lore-Modell: ambient, nicht frontal

| Feld | Wert |
|---|---|
| Datum | 2026-06-27 |
| Problem | Wie wird Lore im Spiel vermittelt? |
| Optionen | (A) Ambient durch NPCs und Items, (B) Frontal durch Cutscenes, (C) Hybrid |
| Bewertungsmaßstab | Spielfluss, Langzeitmotivation |
| Entscheidung | A — Ambient |
| Begründung | Erhält das „Spiel zuerst"-Prinzip; Lore wird entdeckt, nicht aufgedrängt. |
| Erwartete Wirkung | Neugier-getriebene Erkundung. |
| Risiken | Manche Spieler:innen wünschen mehr Story. Mitigation: NPC-Dialoge vertiefen punktuell. |
| Validierungsplan | Phase 4 qualitative Tests. |
| Detail | `decisions/D-015_lore.md` |

## Decision-Statistik

- **Entscheidungen total:** 15
- **Davon mit offenem Validierungsplan:** 15
- **Davon abgeschlossen:** 0
- **Detail-Dateien erstellt:** parallel zu `docs/`

## Pflegehinweise

- Jede neue Entscheidung wird mit eindeutiger ID, Datum und vollständigem Schema eingetragen.
- Validierungspläne werden nach Abschluss aktualisiert (Status: offen / abgeschlossen / erneut offen).
- Veraltete Entscheidungen werden mit Begründung beibehalten (Audit Trail).

## Offene Fragen

- Welche Entscheidungen werden in Phase 2 zusätzlich getroffen? (Liste folgt.)
- Welche Entscheidungen benötigen externe Validierung? (Phase 6.)

## Nächste Schritte

1. Detail-Dateien für D-001 bis D-015 in `decisions/` erstellen.
2. Phase 2-Entscheidungen einarbeiten.
3. Regelmäßiger Decision-Review mit Stakeholdern.

## Änderungsverlauf

| Datum | Version | Änderung | Autor |
|---|---|---|---|
| 2026-06-27 | 0.1 | Initialer Decision Log | Mavis (Agent) |
| 2026-06-27 14:18 | 0.2 | D-001 (Naming → Curio World), D-002 (5-District-Plan), D-004 (VIP-Pass), D-010 (Gold+Gems+Robux) refitted | Mavis (Agent) |
| 2026-06-27 14:50 | 0.3 | D-001 Refit: Wonder World → Curio World (Naming-Kollision mit existierendem Roblox-Pet-Game aufgedeckt) | Mavis (Agent) |