# 14 — Telemetry Plan

## Zweck

Dieses Dokument definiert die Telemetrie- und Analytics-Strategie von Curio World: erfasste Events, KPIs, Datenschutz, Dashboards und A/B-Test-Framework. Es ist die Grundlage für datengetriebene Entscheidungen.

## Annahmen

- Telemetrie ist DSGVO/COPPA-konform; nur notwendige Daten.
- Personenbezugsdaten werden pseudonymisiert; Identifikation nur über Roblox-User-ID (an uns gehasht).
- Elterninformation über Datenumfang ist Pflicht.
- Telemetrie wird sowohl für Produktentscheidungen als auch für Sicherheit und Wirtschaftsbalance genutzt.

## Quellen

- `02_compliance_matrix.md` (C-007 Datenminimierung)
- Roblox Analytics Service (Stand 2026)
- Roblox Open Cloud API für eigene Datensammlung

## Datenmodell

### Erfasste Daten (anonymisiert/pseudonymisiert)

| Kategorie | Beispiele | Speicherung |
|---|---|---|
| Account-Hash | SHA-256 von Roblox-User-ID | DataStore + eigene Pipeline |
| Altersband-Schätzung | Junior/Scout/Architect | Profil-Feld |
| Locale | Sprache | Profil-Feld |
| Event-Logs | Quest-Starts, Puzzle-Abschluss, Item-Erhalt | Telemetrie-Stream |
| Performance-Metriken | FPS, Latenz, Crash-Reports | Roblox Analytics |
| Wirtschafts-Events | Käufe, Belohnungen, Inventar-Änderungen | DataStore |
| Sicherheits-Events | Reports, Verbote, Wortfilter-Treffer | Sicherheits-DB |

### Nicht erfasste Daten

- Personenbezogene Daten (Namen, Adressen, E-Mails) — diese liegen bei Roblox, nicht bei uns.
- Freitext-Chat-Inhalte (außer bei Sicherheits-Vorfällen, wo Wortfilter-Treffer anonym protokolliert werden).
- Biometrische Daten.
- Standort über IP (außer für grobe Regions-Bestimmung, falls überhaupt nötig).

## Event-Katalog

### Funktionale Events

| Event | Felder | Zweck |
|---|---|---|
| `session_start` | timestamp, locale | Sitzungs-Analyse |
| `session_end` | timestamp, duration_seconds | Sitzungs-Länge |
| `district_entered` | district_id, source | Bewegungs-Analyse |
| `district_left` | district_id, duration_seconds | Verweildauer |
| `quest_started` | quest_id, mode (solo/duo/team) | Quest-Popularität |
| `quest_completed` | quest_id, duration_seconds, success | Quest-Erfolg |
| `quest_abandoned` | quest_id, time_in_quest_seconds | Abbruch-Analyse |
| `puzzle_completed` | puzzle_id, domain, success, time, hints_used | Adaptive Engine |
| `puzzle_failed` | puzzle_id, domain, attempts | Fehlermuster |
| `item_acquired` | item_id, source | Belohnungs-Analyse |
| `item_purchased` | item_id, currency, robux_amount | Wirtschafts-Analyse |
| `companion_unlocked` | companion_id, source | Companion-Analyse |
| `housing_decorated` | decoration_id | Housing-Analyse |
| `event_participated` | event_id, contribution | Event-Analyse |

### Sicherheits-Events

| Event | Felder | Zweck |
|---|---|---|
| `report_filed` | category, target_hash | Vorfalls-Analyse |
| `word_filter_triggered` | category, locale | Filter-Wirksamkeit |
| `user_muted` | reason, duration | Disziplinar-Analyse |
| `user_banned` | reason, severity | Plattform-Kontakt |
| `parental_action` | action_type | Eltern-Kontrollen-Wirksamkeit |

### Performance-Events

| Event | Felder | Zweck |
|---|---|---|
| `client_fps_sample` | fps, device_class | Performance-Analyse |
| `client_crash` | stack, device_class | Stabilität |
| `server_load_sample` | player_count, sim_time | Server-Kapazität |
| `network_latency_sample` | rtt, packet_loss | Netzwerk-Analyse |

## KPIs

### Engagement-KPIs

| KPI | Definition | Zielwert |
|---|---|---|
| DAU | Daily Active Users | saisonal steigend |
| MAU | Monthly Active Users | saisonal steigend |
| DAU/MAU | Sticky Ratio | ≥ 25 % |
| Avg Session Length | Durchschnittliche Sitzungsdauer | 20–40 Min |
| Sessions per User per Week | Häufigkeit | 3–5 |
| Day-1 Retention | Spieler:innen, die Tag 2 wiederkommen | ≥ 50 % |
| Day-7 Retention | Spieler:innen, die Tag 8 wiederkommen | ≥ 25 % |
| Day-30 Retention | Spieler:innen, die Tag 31 wiederkommen | ≥ 15 % |

### Lern-KPIs (anonymisiert)

| KPI | Definition | Zielwert |
|---|---|---|
| Puzzle Success Rate | Erfolgsquote pro Domäne | 60–80 % |
| Avg Hints per Puzzle | Hilfenutzung | ≤ 1.5 |
| Avg Time per Puzzle | Bearbeitungszeit | im Plan pro Bezirk |
| Adaptive Spread | Verteilung der Schwierigkeitsstufen | ausgewogen |

### Wirtschafts-KPIs

| KPI | Definition | Zielwert |
|---|---|---|
| Conversion Rate | Anteil zahlender Spieler:innen | 3–8 % |
| ARPU | Average Revenue per User | im Plan |
| ARPPU | Average Revenue per Paying User | im Plan |
| Item Popularity | Items pro Kategorie | ausgewogen |
| Inflation Index | Gold-Menge pro aktivem Spieler | stabil |

### Sicherheits-KPIs

| KPI | Definition | Zielwert |
|---|---|---|
| Reports per 1k Sessions | Meldungen | ≤ 5 |
| Severe Incidents | Schwere Vorfälle | 0 |
| Avg Response Time | Durchschnittliche Antwortzeit auf Reports | < 24h |
| Filter Hit Rate | Wortfilter-Treffer | Monitor |

### Performance-KPIs

| KPI | Definition | Zielwert |
|---|---|---|
| Median FPS Mobile | Median-Bildrate auf Mobile | ≥ 30 fps |
| Median FPS Desktop | Median-Bildrate auf Desktop | ≥ 60 fps |
| Crash Rate | Crashes pro 1k Sessions | ≤ 1 |
| Median Latency | Mittlere Latenz | ≤ 100 ms |

## A/B-Test-Framework

### Test-Struktur

- Hypothese → Variante A (Kontrolle) vs. Variante B (Veränderung) → Metrik → Signifikanz.
- Tests laufen über mindestens 7 Tage oder 1.000 Spieler:innen pro Variante.
- Tests werden im Backend-Admin-Tool konfiguriert.

### Beispiel-Tests (Post-Launch)

- Saisonpass-Preis-Varianten (250 vs. 400 vs. 600 Robux).
- Onboarding-Länge (kurz vs. ausführlich).
- Hilfen-Sichtbarkeit (Hilfe-Button immer sichtbar vs. erst nach 10 Sekunden).

### Stop-Kriterien

- Statistische Signifikanz (p < 0.05) und praktische Relevanz.
- Negative Effekte auf andere Metriken.
- Sicherheits- oder Compliance-Bedenken.

## Datenschutz und Einwilligung

### DSGVO/COPPA-Compliance

- Datenminimierung: nur notwendige Events.
- Pseudonymisierung: alle personenbezogenen Daten werden gehasht.
- Aufbewahrungsdauer: 90 Tage für detaillierte Logs, 1 Jahr für aggregierte Metriken.
- Löschung auf Anfrage: bei Account-Löschung werden alle Daten innerhalb von 30 Tagen gelöscht.

### Elterninformation

- About-Bereich erklärt, welche Daten erhoben werden.
- Hinweis auf Roblox Parental Controls und dortige Datenschutz-Optionen.
- Kontaktadresse für Datenschutz-Fragen.

### Roblox-Analytics-Service

Wir nutzen Roblox Analytics für Performance- und Aggregat-Metriken, eigene Pipeline für detaillierte Event-Logs.

## Dashboards

### Operative Dashboards

- Live-Spieler:innen-Zahl
- Aktuelle Events
- Performance-Metriken
- Aktuelle Vorfälle

### Strategische Dashboards

- Trends über Saisons
- Persona-Verteilung
- Wirtschafts-Balance
- Lern-Domänen-Verteilung
- Sicherheits-Trends

## Datenspeicherung und -verarbeitung

### Speicher

| Datentyp | Speicher | Aufbewahrung |
|---|---|---|
| Spieler:innen-Profil | DataStore (Roblox) | bis Account-Löschung |
| Event-Logs (detailliert) | Eigene Pipeline (Cloud) | 90 Tage |
| Aggregierte Metriken | Eigene Data Warehouse | 1 Jahr |
| Sicherheits-Vorfälle | Interne DB (anonymisiert) | 1 Jahr |

### Verarbeitung

- Batch-Aggregation täglich.
- Live-Dashboards aktualisieren alle 5 Minuten.
- Alerts bei Schwellwert-Überschreitung.

## Risiken

- **Datenleck:** Trotz Verschlüsselung Risiko. Mitigation: strenge Zugriffskontrollen, regelmäßige Audits.
- **Fehlinterpretation:** Korrelation ≠ Kausalität. Mitigation: Hypothesen-getriebene Tests, qualitative Validierung.
- **Datenschutz-Verstoß:** Neue Events könnten personenbezogene Daten enthalten. Mitigation: Compliance-Review jedes neuen Events.
- **Performance-Hit durch Telemetrie:** Zu viele Events können das Spiel verlangsamen. Mitigation: Throttling, Sampling für hochfrequente Events.

## Offene Fragen

- Welche konkreten Daten sind über die Roblox Open Cloud API zugänglich? (Phase 3.)
- Wie integrieren wir eigene Telemetrie DSGVO-konform? (Phase 3 mit Compliance Lead.)
- Welche Alerts sollen automatisch ausgelöst werden? (Phase 3.)

## Nächste Schritte

1. Event-Katalog in Luau implementieren (Phase 3).
2. Backend-Pipeline für eigene Event-Sammlung (Phase 3).
3. Dashboard-Prototypen (Phase 3).
4. Erste A/B-Tests nach Launch vorbereiten.

## Änderungsverlauf

| Datum | Version | Änderung | Autor |
|---|---|---|---|
| 2026-06-27 | 0.1 | Initialer Telemetrie-Plan | Mavis (Agent) |
| 2026-06-27 14:25 | 0.2 | Refit: Curio World + 5-District-Plan + Gold/Gems/Robux (kein Stamina) + VIP-Komfort-Pass | Mavis (Agent) |
| 2026-06-27 14:50 | 0.3 | Refit: Wonder World → Curio World (Naming-Kollision mit existierendem Roblox-Pet-Game aufgedeckt) | Mavis (Agent) |
| 2026-06-27 | 0.1 | Initialer Telemetrie-Plan | Mavis (Agent) |