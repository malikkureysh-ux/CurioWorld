# 13 — LiveOps Plan

## Zweck

Dieses Dokument definiert die Live-Operations-Strategie von Curio World: saisonale Zyklen, Events, Content-Drops, Community-Aktivitäten und operative Verantwortlichkeiten. Es ist die operative Roadmap nach dem Launch.

## Annahmen

- Nach Launch wird das Spiel kontinuierlich weiterentwickelt.
- Saisonale Inhalte sind kulturell sensibel und nicht ausbeuterisch.
- Community-Events sind kooperativ und inklusiv.
- LiveOps-Plan wird alle 8 Wochen aktualisiert.
- Alle Events folgen Compliance-Regeln (siehe `02_compliance_matrix.md`).

## Quellen

- `10_economy_design.md` (Saisonpass, Items)
- `06_world_bible.md` (Bezirke)
- `02_compliance_matrix.md` (C-017, C-018)

## Saisonale Struktur

- 6 Saisons pro Jahr (8 Wochen pro Saison).
- Saisonale Themes kulturell sorgfältig ausgewählt.
- Pro Saison: 1 Hauptthema + 2–3 Sub-Themen.

### Saison-Kalender (Beispiel-Jahr)

| Saison | Wochen | Hauptthema | Sub-Themen |
|---|---|---|---|
| S1 | 1–8 | Hafen-Eröffnung | Frühling im Hafen, Schiffs-Taufe |
| S2 | 9–16 | Liberty-Festival | Rooftop-Konzerte, Skyline-Beleuchtung |
| S3 | 17–24 | Sakura-Blüte | Kirschblüten, Tech-Festival |
| S4 | 25–32 | Mond-Basar | Laterne-Nächte, Gewürz-Festival |
| S5 | 33–40 | Sky-Plaza-Winter | Indoor-Märkte, Sternwarten |
| S6 | 41–48 | Neujahrs-Brücken | Brücken-Bau-Wettbewerb, neuer Bezirk (optional) |

## Event-Typen

### Saison-Hauptevent

- Dauer: 8 Wochen (parallel zur Saison).
- Inhalt: thematische Missionen, exklusive Items, globaler Baufortschritt.
- Beispiel: „Hafen-Eröffnung" — alle Spieler:innen bauen gemeinsam den ersten Speicher.

### Bezirks-Events (monatlich)

- Dauer: 1 Woche pro Bezirk.
- Inhalt: bezirks-spezifische Missionen, limitierte Items.
- Beispiel: „SkyBridge-Woche" — fokussierte Physik-Rätsel, Kabelbahn-Sprünge.

### Community-Events (wöchentlich)

- Dauer: 2–7 Tage.
- Inhalt: gemeinsame Bauziele, geteilte Belohnungen.
- Beispiel: „Eine Brücke für alle" — alle Spieler:innen tragen Materialien bei.

### Mini-Events (2–3 pro Woche)

- Dauer: 1–3 Tage.
- Inhalt: thematische Doppel-XP, kurze besondere Missionen.
- Beispiel: „Hafen-Kran-Marathon" — Speedrun auf Kran-Puzzles.

### Wiederkehrende saisonale Highlights

- Saisonwechsel-Event: kurze, freundliche Übergangs-Story.
- Jahrestreue-Event: Spieler:innen, die ein Jahr dabei sind, bekommen ein Jubiläums-Item.

## Content-Drop-Strategie

### Pro Saison

| Drop | Inhalt | Wann |
|---|---|---|
| Soft Launch | Saison-Themen, neue Missionen, neuer Saisonpass | Saison-Start |
| Mid-Season | 5–10 neue Items, 1 neues Community-Projekt | Saison-Halbzeit |
| End-Season | Saisonale Spezial-Items, Jubiläums-Story | Saison-Ende |

### Post-Launch-Erweiterungen

- 1 neuer Bezirk pro Saison (Phase 5/6, optional).
- 1 neues großes Feature pro Saison (z. B. neuer Begleiter, neues Bau-System).
- 1 neues Community-Event-Format pro Saison.

## LiveOps-Verantwortlichkeiten

### Operativer Rhythmus

| Cadence | Aktivität |
|---|---|
| Täglich | Server-Monitoring, Incident-Response |
| Wöchentlich | Telemetrie-Review, Community-Management |
| 2-wöchentlich | Mini-Event-Drops |
| 4-wöchentlich | Bezirks-Event |
| 8-wöchentlich | Saison-Wechsel |
| Quartalsweise | Strategie-Review, Elternfeedback |

### Rollen

| Rolle | Verantwortung |
|---|---|
| LiveOps Lead | Operative Planung, Event-Koordination |
| Content Designer | Saisonale Missionen und Items |
| Community Manager | Kommunikation, Feedback-Sammlung |
| Safety Lead | Vorfalls-Response, Plattform-Kontakt |
| Tech Lead | Performance, Verfügbarkeit, Patches |
| Economy Lead | Wirtschafts-Balance, Angebots-Kalender |

## Kommunikation an Spieler:innen

### Saison-Ankündigung

- 2 Wochen vor Saisonstart: Vorschau-Video und Item-Liste.
- Saisonstart: kurzes Intro-Video mit neuen Features.
- Saisonhalbzeit: Highlight-Video der bisherigen Community-Leistungen.

### In-Game-Event-Benachrichtigung

- HUD-Bereich zeigt aktive Events.
- Stadt-Deko wechselt sichtbar.
- NPCs themenbezogen.

## Saisonale Themenwahl — Sensibilität

### Vermeidungs-Liste

- Kulturelle oder religiöse Feste, die wir nicht zugehörig sind.
- Politisch aufgeladene Themen.
- Reale Marken oder Personen.
- Kommerzielle Feiertage ohne kulturelle Verankerung.

### Bevorzugungs-Liste

- Jahreszeiten (Frühling, Sommer, Herbst, Winter).
- Naturphänomene (Blüte, Ernte, Polarlichter).
- Architektur- und Kulturfeste, die wirken wie „die Stadt feiert sich selbst".
- Mathematisch-naturwissenschaftliche Themen (Tag der Mathematik, Erfindungs-Festival).

## Anti-Dark-Pattern-Regeln

- Keine künstliche Verknappung („letzte Chance!").
- Keine „überspringe Wartezeit"-Käufe.
- Keine Lootboxen.
- Klare Daten statt „noch X Stunden".
- Saisonale Inhalte sind auch ohne Pass erreichbar (siehe `10_economy_design.md`).

## Metriken pro Saison

| Metrik | Zielwert | Trigger für Anpassung |
|---|---|---|
| DAU/MAU Ratio | ≥ 25 % | Wenn < 20 %: Content-Anpassung |
| Durchschnittliche Session-Länge | 20–40 Min | Wenn < 15 Min: Onboarding prüfen |
| Tägliche Quests-Abschlussrate | ≥ 60 % der Spieler:innen | Wenn < 50 %: Schwierigkeit prüfen |
| Community-Event-Teilnahme | ≥ 40 % der aktiven Spieler:innen | Wenn < 30 %: Event-Design prüfen |
| Saisonpass-Kauf-Rate | 5–15 % der aktiven Spieler:innen | Wenn > 25 %: möglicherweise zu aufdringlich |
| Sicherheitsvorfälle | 0 schwere | Jeder schwere Vorfall: sofortige Review |

## Operative Risiken

| Risiko | Mitigation |
|---|---|
| Event-Bug | Rollback-Plan, Stage-Environment |
| Sicherheits-Vorfall | Sofort-Eskalation, Kommunikations-Plan |
| Wirtschafts-Inflation | Balance-Simulation pro Saison |
| Content-Erschöpfung | Content-Pipeline mit 8 Wochen Vorlauf |
| Kulturelle Fehltritte | Kulturelle Berater:innen pro Region |

## Tools

- Roblox Open Cloud für Asset- und Config-Deploys.
- Eigene Telemetrie-Pipeline für KPIs.
- Interne Operations-Dashboards.
- Notfall-Kommunikations-Plan (Telegram/Discord intern).

## Notfall-Kommunikations-Plan

### Stufen

| Stufe | Beispiel | Reaktion |
|---|---|---|
| Niedrig | Mini-Bug | Patch in 24h |
| Mittel | Event-Fail | Patch in 6h, Community-Post |
| Hoch | Sicherheits-Vorfall | Sofortige Sperrung, Plattform-Kontakt, Elterninfo |
| Kritisch | Datenleck | Plattform-Kontakt, Compliance-Meldung, externe PR |

## Saisonale Erfolgsdefinition

Eine Saison ist erfolgreich, wenn:

- Geplante Inhalte pünktlich und in Qualität ausgeliefert wurden.
- Mindestens 60 % der Spieler:innen haben das Hauptevent erlebt.
- Wirtschaftlich im Plan (keine Inflation, faire Konversion).
- Keine schweren Sicherheitsvorfälle.
- Spieler:innen-Feedback überwiegend positiv.
- Begleitende Telemetrie zeigt gesunde Verteilung der Personas.

## Offene Fragen

- Welche Events sind in den ersten 8 Wochen realistisch umsetzbar? (Phase 3.)
- Wie messen wir Spieler:innen-Feedback effizient? (Phase 3-5.)
- Welche externen Berater:innen für kulturelle Sensibilität? (Phase 6.)

## Nächste Schritte

1. Saison-Kalender für das erste Jahr finalisieren.
2. Erste Events im Studio prototypen.
3. KPI-Dashboards in Phase 3.
4. Sicherheits-Notfallplan für Launch.

## Änderungsverlauf

| Datum | Version | Änderung | Autor |
|---|---|---|---|
| 2026-06-27 | 0.1 | Initialer LiveOps-Plan | Mavis (Agent) |
| 2026-06-27 14:25 | 0.2 | Refit: Curio World + 5-District-Plan + Gold/Gems/Robux (kein Stamina) + VIP-Komfort-Pass | Mavis (Agent) |
| 2026-06-27 14:50 | 0.3 | Refit: Wonder World → Curio World (Naming-Kollision mit existierendem Roblox-Pet-Game aufgedeckt) | Mavis (Agent) |
| 2026-06-27 | 0.1 | Initialer LiveOps-Plan | Mavis (Agent) |