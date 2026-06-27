# 16 — Risk Register

## Zweck

Dieses Dokument sammelt, bewertet und priorisiert alle wesentlichen Risiken für Curio World. Es ist die lebendige Risiko-Landkarte und wird laufend aktualisiert.

## Annahmen

- Risiken werden mit Eintrittswahrscheinlichkeit, Schadenshöhe und Mitigation bewertet.
- Risiken werden mindestens monatlich reviewt.
- Jedes Risiko hat einen Owner.
- Eskalationspfade sind definiert.

## Quellen

- Alle bisherigen Dokumente (`docs/00–15`)
- Briefing-Risikoanforderungen

## Scoring-Skala

### Eintrittswahrscheinlichkeit

- **Niedrig (1):** < 10 % über 12 Monate.
- **Mittel (2):** 10–30 %.
- **Hoch (3):** 30–60 %.
- **Sehr hoch (4):** > 60 %.

### Schadenshöhe

- **Gering (1):** Wenig Impact, leicht zu beheben.
- **Mittel (2):** Spürbare Folgen, Recovery in Wochen.
- **Hoch (3):** Schwere Folgen, Recovery in Monaten.
- **Kritisch (4):** Existenzbedrohend oder dauerhafter Vertrauensverlust.

### Risiko-Score = Wahrscheinlichkeit × Schaden

## Aktive Risiken

### R-001: Sicherheits-Vorfall mit Minderjährigen

| Feld | Wert |
|---|---|
| Kategorie | Sicherheit / Compliance |
| Wahrscheinlichkeit | Mittel (2) |
| Schaden | Kritisch (4) |
| Score | 8 |
| Beschreibung | Trotz aller Vorkehrungen könnten Kontaktaufnahmen, Belästigungen oder Daten-Leaks auftreten. |
| Mitigation | Mehrschichtige Schutzmaßnahmen (siehe `11_community_and_safety.md`), schnelle Eskalation, externe Beratung. |
| Owner | Safety Lead |
| Status | aktiv, mitigation läuft |

### R-002: Eltern-Kritik an Monetarisierung

| Feld | Wert |
|---|---|
| Kategorie | Wirtschaft / Vertrauen |
| Wahrscheinlichkeit | Mittel (2) |
| Schaden | Hoch (3) |
| Score | 6 |
| Beschreibung | Eltern könnten Monetarisierung als zu aggressiv empfinden. |
| Mitigation | Strikte Kosmetik-only-Politik, Eltern-Transparenz, Empfehlung Roblox Parental Controls. |
| Owner | Economy Lead |
| Status | aktiv |

### R-003: Compliance-Verstoß wegen Regel-Änderung

| Feld | Wert |
|---|---|
| Kategorie | Compliance |
| Wahrscheinlichkeit | Niedrig (1) |
| Schaden | Hoch (3) |
| Score | 3 |
| Beschreibung | Roblox- oder nationale Regeländerungen könnten zur Höherstufung oder Sperrung führen. |
| Mitigation | Monatlicher Compliance-Review, enger Kontakt zu Roblox-Creator-Ressourcen, externe Beratung. |
| Owner | Compliance Lead |
| Status | aktiv |

### R-004: Performance-Probleme auf Mobile

| Feld | Wert |
|---|---|
| Kategorie | Technik |
| Wahrscheinlichkeit | Mittel (2) |
| Schaden | Hoch (3) |
| Score | 6 |
| Beschreibung | Mobile-Spielbarkeit ist kritisch; Performance-Probleme könnten Reichweite stark reduzieren. |
| Mitigation | Performance-Budgets, kontinuierliche Mobile-Tests, Auto-LOD. |
| Owner | Tech Lead |
| Status | aktiv |

### R-005: Adaptive Engine falsch kalibriert

| Feld | Wert |
|---|---|
| Kategorie | Lernen / UX |
| Wahrscheinlichkeit | Mittel (2) |
| Schaden | Mittel (2) |
| Score | 4 |
| Beschreibung | Adaptive Anpassung könnte über- oder unterfordern. |
| Mitigation | Pilot-Telemetrie, A/B-Tests, manuelle Reviews. |
| Owner | Learning Architect |
| Status | aktiv |

### R-006: Kulturelle Fehltritte in Bezirken

| Feld | Wert |
|---|---|
| Kategorie | Inhalt / Kultur |
| Wahrscheinlichkeit | Mittel (2) |
| Schaden | Hoch (3) |
| Score | 6 |
| Beschreibung | Kulturelle Bezüge könnten als klischeehaft oder beleidigend empfunden werden. |
| Mitigation | Kulturelle Berater:innen pro Region, Sensibilitäts-Reviews, Community-Feedback. |
| Owner | Lead Designer |
| Status | aktiv |

### R-007: Lokalisierungs-Fehler

| Feld | Wert |
|---|---|
| Kategorie | Lokalisierung |
| Wahrscheinlichkeit | Mittel (2) |
| Schaden | Mittel (2) |
| Score | 4 |
| Beschreibung | Übersetzungsfehler oder kulturell unpassende Inhalte in 9 Sprachen. |
| Mitigation | Muttersprachler:innen-Review pro Sprache, automatisierte Tests für String-Vollständigkeit. |
| Owner | Localization Lead |
| Status | aktiv |

### R-008: Story-Drift oder Lore-Inkonsistenz

| Feld | Wert |
|---|---|
| Kategorie | Inhalt |
| Wahrscheinlichkeit | Niedrig (1) |
| Schaden | Mittel (2) |
| Score | 2 |
| Beschreibung | Inkonsistente Lore über mehrere Bezirke. |
| Mitigation | World Bible als Single Source of Truth, Lore-Reviews. |
| Owner | Narrative Designer |
| Status | aktiv |

### R-009: Wirtschafts-Inflation

| Feld | Wert |
|---|---|
| Kategorie | Wirtschaft |
| Wahrscheinlichkeit | Mittel (2) |
| Schaden | Mittel (2) |
| Score | 4 |
| Beschreibung | Gold-Inflation könnte Wirtschafts-Balance zerstören. |
| Mitigation | Sink-Mechaniken, Balance-Simulationen pro Saison. |
| Owner | Economy Lead |
| Status | aktiv |

### R-010: Spieler:innen-Burnout durch falsche Retention-Loops

| Feld | Wert |
|---|---|
| Kategorie | UX / Ethik |
| Wahrscheinlichkeit | Niedrig (1) |
| Schaden | Hoch (3) |
| Score | 3 |
| Beschreibung | Selbst mit Anti-Dark-Pattern-Regeln könnten Loops Burnout erzeugen. |
| Mitigation | Pausen-Empfehlungen, klare Session-Indikatoren, qualitative Spieler:innen-Feedback. |
| Owner | Lead Designer |
| Status | aktiv |

### R-011: Datenverlust oder Datenleck

| Feld | Wert |
|---|---|
| Kategorie | Sicherheit / Compliance |
| Wahrscheinlichkeit | Niedrig (1) |
| Schaden | Kritisch (4) |
| Score | 4 |
| Beschreibung | Trotz Verschlüsselung Risiko durch Bugs oder Angriffe. |
| Mitigation | Roblox-Standard-Persistenz, Backups, strenge Zugriffskontrollen. |
| Owner | Tech Lead + Compliance Lead |
| Status | aktiv |

### R-012: Konkurrenzprodukt mit ähnlichem Konzept

| Feld | Wert |
|---|---|
| Kategorie | Markt |
| Wahrscheinlichkeit | Mittel (2) |
| Schaden | Mittel (2) |
| Score | 4 |
| Beschreibung | Andere Studios könnten ähnliche Konzepte umsetzen. |
| Mitigation | Fokus auf Qualität, Community-Bindung und einzigartige Mechaniken statt Wettrennen. |
| Owner | Product Lead |
| Status | aktiv |

### R-013: Team-Schlüsselperson fällt aus

| Feld | Wert |
|---|---|
| Kategorie | Personal |
| Wahrscheinlichkeit | Niedrig (1) |
| Schaden | Hoch (3) |
| Score | 3 |
| Beschreibung | Verlust einer Schlüsselrolle könnte Projekt verzögern. |
| Mitigation | Wissen teilen, Doppelspurigkeiten, Dokumentations-Disziplin. |
| Owner | Operations Lead |
| Status | aktiv |

### R-014: Asset-Pipeline-Bruch

| Feld | Wert |
|---|---|
| Kategorie | Technik |
| Wahrscheinlichkeit | Niedrig (1) |
| Schaden | Mittel (2) |
| Score | 2 |
| Beschreibung | Versionswechsel in Blender oder Roblox Studio könnte Pipeline zerschießen. |
| Mitigation | Version-Pinning, Regression-Tests. |
| Owner | Tech Lead |
| Status | aktiv |

### R-015: Saisonale Event-Schwäche

| Feld | Wert |
|---|---|
| Kategorie | Inhalt / LiveOps |
| Wahrscheinlichkeit | Mittel (2) |
| Schaden | Mittel (2) |
| Score | 4 |
| Beschreibung | Saisonale Events könnten Spieler:innen nicht begeistern. |
| Mitigation | Spieler:innen-Feedback einholen, Event-Templates testen. |
| Owner | LiveOps Lead |
| Status | aktiv |

### R-016: Mangel an jungen Tester:innen

| Feld | Wert |
|---|---|
| Kategorie | QA / Forschung |
| Wahrscheinlichkeit | Mittel (2) |
| Schaden | Mittel (2) |
| Score | 4 |
| Beschreibung | Junge Tester:innen könnten schwer zu rekrutieren sein (Eltern-Einwilligung). |
| Mitigation | Frühe Pilot-Gruppen aufbauen, Community-Tests nach Soft Launch. |
| Owner | User Research Lead |
| Status | aktiv |

### R-017: Regulatorische Änderungen (DSGVO, COPPA, regional)

| Feld | Wert |
|---|---|
| Kategorie | Compliance |
| Wahrscheinlichkeit | Niedrig (1) |
| Schaden | Hoch (3) |
| Score | 3 |
| Beschreibung | Datenschutz- oder Jugendschutzgesetze könnten sich verschärfen. |
| Mitigation | Konservativster Standard global, externe Beratung. |
| Owner | Compliance Lead |
| Status | aktiv |

## Risiko-Matrix-Übersicht

| Score | Anzahl |
|---|---|
| 8 (kritisch) | 1 |
| 6 (hoch) | 3 |
| 4 (mittel-hoch) | 6 |
| 3 (mittel) | 5 |
| 2 (niedrig) | 2 |

## Top-5-Risiken (priorisiert)

1. **R-001 Sicherheits-Vorfall** — Score 8
2. **R-002 Eltern-Kritik Monetarisierung** — Score 6
3. **R-004 Performance Mobile** — Score 6
4. **R-006 Kulturelle Fehltritte** — Score 6
5. **R-005 Adaptive Engine Kalibrierung** — Score 4

## Eskalationspfade

- **Score 6+:** Sofort an Product Lead und Compliance Lead.
- **Score 4–5:** Wöchentlicher Review.
- **Score 2–3:** Monatlicher Review.

## Review-Cadence

- Wöchentlich: Top-Risiken (R-001 bis R-005).
- Monatlich: Alle aktiven Risiken.
- Quartalsweise: Strategische Risikobewertung.

## Offene Fragen

- Welche externen Kindersicherheits-Expert:innen für R-001? (Phase 6.)
- Welche Performance-Targets sind realistisch auf Low-End-Mobile? (Phase 4.)

## Nächste Schritte

1. Externe Sicherheits-Beratung anfragen (Phase 6).
2. Performance-Benchmarks für Low-End-Mobile aufsetzen (Phase 4).
3. Kulturelle Berater:innen pro Region rekrutieren (Phase 2).

## Änderungsverlauf

| Datum | Version | Änderung | Autor |
|---|---|---|---|
| 2026-06-27 | 0.1 | Initialer Risk Register | Mavis (Agent) |
| 2026-06-27 14:25 | 0.2 | Refit: Curio World + 5-District-Plan + Gold/Gems/Robux (kein Stamina) + VIP-Komfort-Pass | Mavis (Agent) |
| 2026-06-27 14:50 | 0.3 | Refit: Wonder World → Curio World (Naming-Kollision mit existierendem Roblox-Pet-Game aufgedeckt) | Mavis (Agent) |
| 2026-06-27 | 0.1 | Initialer Risk Register | Mavis (Agent) |