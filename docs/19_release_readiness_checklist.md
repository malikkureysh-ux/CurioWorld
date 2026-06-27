# 19 — Release Readiness Checklist

## Zweck

Dieses Dokument ist die finale Veröffentlichungs-Checkliste für Curio World. Es prüft alle kritischen Bereiche vor dem Launch und definiert Tag-0- und Tag-1-Aktivitäten.

## Annahmen

- Der Launch erfolgt auf Roblox mit der finalen Experience-Version.
- Compliance, Sicherheit, Performance und Qualität sind Gate-Kriterien.
- Tag-0-Überwachung ist intensiv.
- Eskalationspfade sind vorab definiert.

## Quellen

- Alle vorherigen Doku-Dokumente (`docs/00–18`)
- Roblox-Creator-Release-Prozess (Stand 2026)

## Gate-Kriterien

Folgende Kriterien müssen vor Launch alle erfüllt sein:

- [ ] Compliance-Review ohne offene S0/S1-Befunde
- [ ] Performance-Tests: Median FPS Mobile ≥ 30, Desktop ≥ 60
- [ ] Sicherheits-Audit bestanden (extern)
- [ ] Alle 9 Sprachen vollständig lokalisiert
- [ ] Alle Muttersprachler:innen-Reviews abgeschlossen
- [ ] Elterninformation und Roblox-Parental-Control-Hinweise im Spiel
- [ ] Telemetrie-Pipeline funktioniert
- [ ] Backup-Strategie für Daten getestet
- [ ] Notfall-Kommunikationsplan getestet
- [ ] 100 % aller Pflichtquests spielbar
- [ ] Adaptive Engine zeigt stabile Empfehlungen
- [ ] Alle Companion-Modelle und Hauptassets in Performance-Budget
- [ ] Beta-Test mit ≥ 80 % positiver Bewertung abgeschlossen
- [ ] Saison-Kalender für 6 Monate geplant
- [ ] Sicherheits-Team ist 24/7 erreichbar in der ersten Woche
- [ ] Support-Kanäle (E-Mail, in-game) sind eingerichtet
- [ ] Datenschutz-Folgenabschätzung (DSGVO) abgeschlossen
- [ ] Asset-Pipeline-Versionen sind gepinnt und dokumentiert

## Compliance-Checkliste

- [ ] **C-001:** Keine Inhalte für Erwachsene verifiziert.
- [ ] **C-002:** Verkauf nur Kosmetik/Komfort/Sammlerstücke.
- [ ] **C-003:** Keine Echtgeld-Lootboxen oder Glücksspiel-Mechaniken.
- [ ] **C-004:** Chat-Beschränkungen für jüngere Spieler:innen.
- [ ] **C-005:** Voice-Chat nur mit Berechtigung.
- [ ] **C-006:** Meldemechanismen funktionieren.
- [ ] **C-007:** Datenschutz-Folgenabschätzung.
- [ ] **C-008:** UGC-Beschränkungen.
- [ ] **C-009:** Naming-Filter aktiv.
- [ ] **C-010:** Keine ungeprüften Marken.
- [ ] **C-011:** Keine Werbe-Popups.
- [ ] **C-012:** Anti-Harassment funktioniert.
- [ ] **C-013:** Matchmaking-Buckets.
- [ ] **C-014:** Drei Reizprofile + Granular-Optionen.
- [ ] **C-015:** „Was kostet das?"-Anzeige vor jedem Kauf.
- [ ] **C-016:** Klare Lern-Transparenz im About-Bereich.
- [ ] **C-017:** Saisonpass ohne künstliche Verknappung.
- [ ] **C-018:** Mentoren-System nur über Emote-/Ping-Ebene.
- [ ] **C-019:** Roblox Parental Controls respektiert.
- [ ] **C-020:** Performance-Standards erfüllt.

## Sicherheits-Checkliste

- [ ] Externe Pen-Tests durchgeführt.
- [ ] Wortfilter in allen 9 Sprachen aktiv.
- [ ] Eskalationspfade dokumentiert und trainiert.
- [ ] Incident-Response-Team 24/7 für erste Woche.
- [ ] Backup-Strategie für Daten getestet.
- [ ] Rollback-Plan für kritische Bugs vorbereitet.
- [ ] Kommunikations-Vorlagen für schwere Vorfälle vorbereitet.

## Performance-Checkliste

- [ ] Median FPS Mobile (Low-End) ≥ 30.
- [ ] Median FPS Mobile (Mid-Range) ≥ 45.
- [ ] Median FPS Desktop ≥ 60.
- [ ] Median Latenz ≤ 100 ms.
- [ ] Speicherverbrauch im Budget pro Plattform.
- [ ] Server-Kapazität für Launch-Traffic getestet.
- [ ] Skalierungs-Plan für Traffic-Spitzen.

## Content-Checkliste

- [ ] 5 Pflichtbezirke spielbar.
- [ ] Mindestens 100 Quests über alle Bezirke.
- [ ] Vollständige Sammelbücher.
- [ ] Tutorial + Onboarding funktioniert.
- [ ] Alle Companion-Definitionen spielbar.
- [ ] Saisonale Inhalte der ersten Saison vorbereitet.
- [ ] Soundtrack in 9 Sprachen verfügbar.

## Lokalisierungs-Checkliste

- [ ] Alle UI-Texte in 9 Sprachen.
- [ ] Alle NPC-Dialoge in 9 Sprachen.
- [ ] Audio-Vertonung in 9 Sprachen.
- [ ] Schriftarten mit voller Glyphen-Abdeckung.
- [ ] RTL-Layout für Arabisch getestet.
- [ ] Kulturelle Sensibilitäts-Reviews abgeschlossen.

## Telemetrie-Checkliste

- [ ] Alle Events aus `14_telemetry_plan.md` aktiv.
- [ ] Dashboards für operative und strategische KPIs.
- [ ] Alerts für Sicherheits- und Performance-Schwellwerte.
- [ ] Datenschutz-konforme Speicherung und Aufbewahrung.
- [ ] A/B-Test-Framework funktioniert.

## Tag-0-Aktivitäten

| Zeit | Aktivität | Owner |
|---|---|---|
| 06:00 | Go-Live-Check (Build, Datenbanken, Telemetrie) | Tech Lead |
| 07:00 | Compliance-Spotcheck | Compliance Lead |
| 08:00 | Launch-Kommunikation | Marketing |
| 09:00 | Live-Monitoring (Player Count, Performance) | Tech Lead |
| 10:00 | Sicherheits-Monitoring | Safety Lead |
| 12:00 | Mittags-Review | Product Lead |
| 14:00 | Erste Community-Posts beantworten | Community Manager |
| 18:00 | Abend-Review mit KPI-Check | LiveOps Lead |
| 22:00 | Nacht-Schicht-Übergabe | Tech Lead |

## Tag-1-Aktivitäten

| Zeit | Aktivität | Owner |
|---|---|---|
| 08:00 | Tages-Review aller KPIs | Product Lead |
| 09:00 | Sicherheits-Bericht | Safety Lead |
| 10:00 | Performance-Bericht | Tech Lead |
| 11:00 | Wirtschafts-Bericht | Economy Lead |
| 14:00 | Community-Feedback-Sammlung | Community Manager |
| 16:00 | Hotfix-Release-Plan | Tech Lead |
| 18:00 | Update-Kommunikation | Marketing |

## Erste-Woche-Aktivitäten

- Tägliche Reviews aller KPIs.
- Tägliche Sicherheits-Checks.
- Erste Community-Umfrage.
- Erste Performance-Optimierungen.
- Erste Sicherheits-Vorfalls-Analyse.
- Erste Wirtschafts-Balance-Analyse.
- Tägliche Eltern-Feedback-Sammlung.

## Launch-Kommunikation

### Vor Launch

- 2 Wochen: Save-the-Date für Eltern und Community.
- 1 Woche: Feature-Videos.
- 1 Tag: Countdown-Posts.

### Launch-Tag

- Launch-Post mit Überblick, Sicherheits-Hinweisen, Elterninformation.
- Live-Streams (Community Manager + Designer).

### Nach Launch

- Wöchentliche Update-Posts.
- Elterninformation alle 2 Wochen.
- Saison-Highlights alle 8 Wochen.

## Notfall-Plan

### Schwere Vorfälle

1. Sofortige Sperrung der betroffenen Funktion.
2. Plattform-Kontakt (Roblox Trust and Safety).
3. Interne Eskalation an Product Lead und Safety Lead.
4. Externe Beratung (Kindersicherheits-Expert:innen) bei Bedarf.
5. Elterninformation via in-game-Nachricht und E-Mail.
6. Post-Mortem innerhalb von 7 Tagen.

### Performance-Probleme

1. Skalierung hochfahren.
2. Notfall-Patch innerhalb von 6 Stunden.
3. Kommunikation an Community.

### Compliance-Verstoß

1. Sofortige Sperrung.
2. Plattform-Kontakt.
3. Compliance-Review.
4. Post-Mortem.

## Erfolgsdefinition Launch

Der Launch gilt als erfolgreich, wenn:

- Tag-1-Stabilität: keine S0-Vorfälle.
- Tag-7-Stabilität: keine wiederkehrenden S1-Vorfälle.
- Tag-30: KPIs im Plan (Retention, Wirtschaft, Sicherheit).
- Tag-30: erste Community-Feedback-Welle überwiegend positiv.
- Tag-30: keine Compliance-Verstöße.

## Offene Fragen

- Welche externe Sicherheits-Firma für Pen-Test? (Phase 6.)
- Welche finalen Performance-Targets? (Phase 4.)
- Welche finalen Marketing-Kanäle? (Phase 5.)

## Nächste Schritte

1. Launch-Team formieren (Phase 5).
2. Externe Audits terminieren (Phase 5-6).
3. Notfall-Pläne testen (Phase 6).
4. Launch-Kommunikationsplan finalisieren (Phase 6).

## Änderungsverlauf

| Datum | Version | Änderung | Autor |
|---|---|---|---|
| 2026-06-27 | 0.1 | Initiale Release-Readiness-Checkliste | Mavis (Agent) |
| 2026-06-27 14:25 | 0.2 | Refit: Curio World + 5-District-Plan + Gold/Gems/Robux (kein Stamina) + VIP-Komfort-Pass | Mavis (Agent) |
| 2026-06-27 14:50 | 0.3 | Refit: Wonder World → Curio World (Naming-Kollision mit existierendem Roblox-Pet-Game aufgedeckt) | Mavis (Agent) |
| 2026-06-27 | 0.1 | Initiale Release-Readiness-Checkliste | Mavis (Agent) |