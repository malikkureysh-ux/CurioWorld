# 02 — Compliance Matrix

## Zweck

Dieses Dokument definiert die für Curio World relevanten Plattform-, Sicherheits- und Jugendschutzregeln und übersetzt sie in konkrete Umsetzungsanforderungen. Es ist verbindliche Grundlage für alle Designentscheidungen.

## Annahmen

- Die Plattform Roblox setzt verbindliche Mindeststandards für alle Experiences.
- Bestimmte Features haben altersabhängige Einschränkungen.
- Eltern und Erziehungsberechtigte müssen über die Art der Interaktion informiert sein.
- Compliance ist nicht „nachgereicht", sondern wird vor dem Feature-Design geprüft.

## Quellen

- Roblox Community Standards (offizielle Creator-Doku, Stand 2026)
- Roblox Content Maturity Policy (offizielle Creator-Doku, Stand 2026)
- Roblox Terms of Use
- Roblox Chat und Voice-Chat-Richtlinien
- COPPA / DSGVO-Kinderrechte (siehe `research/safety/`)

## Compliance-Matrix

| ID | Regel / Quelle | Risiko | Pflicht-Umsetzung | Owner | Status |
|---|---|---|---|---|---|
| C-001 | Keine Inhalte für Erwachsene | Mittelfristige Sichtbarkeitsverlust-Risiken | Keine Gewalt über stylisierten Slapstick hinaus; keine sexualisierten Inhalte; keine Drogen-/Alkohol-Positivdarstellung | Compliance Lead | offen |
| C-002 | Keine Pay-to-Win-Mechaniken | Hohes Vertrauensrisiko für Kinderprodukte | Verkauf nur Kosmetik, Komfort, Sammlerstücke; keine spielmechanischen Vorteile gegen Echtgeld | Economy Lead | offen |
| C-003 | Keine Glücksspiel-Mechaniken (Echtgeld) | Hohes Compliance-Risiko | Keine Lootboxen mit Echtgeld-Käufen; keine zufallsbasierten Käufe mit Echtgeld; Belohnungen deterministisch oder mit reiner Soft-Currency | Economy Lead | offen |
| C-004 | Chat-Einschränkungen für jüngere Nutzer | Hohes Sicherheitsrisiko | Spieler unter 13: kein uneingeschränkter Freitext-Chat; Pings/Emotes/vorgegebene Phrasen als Standard; Optionaler Text-Chat nur mit aktivierter Roblox-Berechtigung | Safety Lead | offen |
| C-005 | Voice-Chat-Altersgrenze | Hohes Sicherheitsrisiko | Voice-Chat nur für Nutzer mit aktivierter Roblox-Berechtigung; kein Voice für 9–11-Spieler; klare In-Game-Hinweise | Safety Lead | offen |
| C-006 | Meldemechanismen | Plattform-Pflicht | Roblox-eigenes Report-System vollständig nutzen; ergänzendes In-Game-Reporting; Eskalationspfade dokumentiert | Safety Lead | offen |
| C-007 | Datenminimierung für Minderjährige | DSGVO/COPPA | Nur notwendige Telemetrie; keine Profilbildung zu Werbezwecken; Elterninformation über Datenumfang | Compliance Lead | offen |
| C-008 | UGC-Beschränkungen | Sicherheitsrisiko | Keine nutzergenerierten 3D-Inhalte im Spiel ohne Moderation; nutzergenerierte Outfits nur aus genehmigtem Asset-Pool | Safety Lead | offen |
| C-009 | Naming-Regeln für Spieler | Sicherheitsrisiko | Respektvolle Vorschläge in der Charaktererstellung; Filter gegen Beleidigungen | Safety Lead | offen |
| C-010 | Werbe- und Sponsoring-Regeln | Markenvertrauen | Keine ungeprüften Marken in Erfahrung; Sponsoring nur nach Compliance-Freigabe | Product Lead | offen |
| C-011 | Werbe-Trigger im Spiel | Compliance | Keine Werbe-Popups, kein Ad-Inject zwischen Spielmomenten | Product Lead | offen |
| C-012 | Anti-Harassment | Plattform-Standard | Klare Verhaltensregeln beim Beitritt; Emote-Block bei Reports; Wiederholungstätern Zugang entziehen | Safety Lead | offen |
| C-013 | Matchmaking-Mindeststandards | Schutz Minderjähriger | Standardmäßig gleichaltrige Matchmaking-Buckets; Solo-Modus für Spieler, die nicht in öffentliche Lobbys wollen | Safety Lead | offen |
| C-014 | Accessibility-Mindeststandards | Ethische Pflicht | Drei Reizprofile (Standard, Reduziert, Fokus); Untertitel für alle Audio-Hinweise; anpassbare Textgröße | UX Lead | offen |
| C-015 | Transparenz über Monetarisierung | Vertrauen Eltern | Klare „Was kostet das?"-Anzeige vor jedem Kauf; Elterninformation im Spielmenü | Economy Lead | offen |
| C-016 | Transparenz über Lernanspruch | Vertrauen Eltern/Lehrer | Klare Beschreibung im About-Bereich, welche Kompetenzen spielerisch angeregt werden; keine Versprechen, die nicht haltbar sind | Learning Architect | offen |
| C-017 | Saisonale LiveOps und Kaufdruck | Ethische Pflicht | Saisonpass ohne künstliche Verknappung des Kerninhalts; klare Daten statt „noch X Stunden"; keine Frust-Verkäufe | LiveOps Lead | offen |
| C-018 | Mentoren-/Ältere-Spieler-Systeme | Hohes Risiko bei Minderjährigen | Nur mit klarer Roblox-Berechtigung und ohne direkten privaten Kommunikationskanal; Mentoring auf Emote-/Ping-Ebene | Safety Lead | offen |
| C-019 | Robux-Kauf und Altersverifikation | Plattform-Logik | Roblox-eigene Parental Controls respektieren; keine Umgehung von Robux-Limits; klare Hinweise für Eltern | Economy Lead | offen |
| C-020 | Performance- und Verfügbarkeitsstandards | Plattform-Erwartung | Roblox-Crash-Reporting nutzen; keine absichtlichen Timeouts für jüngere Nutzer | Tech Lead | offen |

## Operationale Konsequenzen

### C-002 + C-003: Monetarisierungs-Compliance

Wir verkaufen ausschließlich:
- Kosmetische Skins, Haare, Accessoires
- Bezirks- und Zimmer-Dekoration
- Emotes und VFX
- Companion-Skins
- Saisonpass-Inhalte (kosmetisch/sammlerisch)
- Komfortfunktionen (zusätzliche Slots, Deko-Speicher)
- Event-Tickets (wenn Kerninhalt frei zugänglich bleibt)

Niemals:
- Spielmechanische Vorteile
- Echtgeld-Wheel-of-Fortune oder Lootboxen
- Energie-Booster oder Frustbremsen
- Direktes Überspringen von Story-Inhalten

### C-004 + C-005: Chat- und Voice-Architektur

| Altersband | Text-Chat | Voice-Chat | Standard-Kommunikation |
|---|---|---|---|
| 9–11 | nur mit aktiver Roblox-Berechtigung | nicht verfügbar | Pings, Emotes, vorgegebene Phrasen |
| 12–13 | aktivierbar durch Eltern/Spieler | aktivierbar | Pings, Emotes, vorgegebene Phrasen, optionaler Text |
| 14–16 | freigegeben | freigegeben | volle Chat-Funktion gemäß Roblox-Settings |

### C-006 + C-012: Eskalationspfade

1. Spieler meldet Verhalten → Roblox-Standard-Report-System
2. Wiederholungstäter → Sofortige Emote-/Chat-Beschränkung in der Experience
3. Schwere Verstöße → Plattform-Report an Roblox Trust & Safety
4. Interne Dokumentation jedes Vorfalls (anonymisiert) für Trend-Analyse

## Compliance-Review-Cadence

- **Vor jedem Release:** Vollständige Compliance-Review durch Compliance Lead.
- **Monatlich:** Update-Check der Roblox-Regelwerke.
- **Quartalsweise:** Stakeholder-Review mit kindersicherheits-erfahrenem Berater (sofern verfügbar).

## Offene Fragen

- Wie genau funktionieren die Roblox Parental Controls technisch, und welche APIs sind für Drittanbieter verfügbar? (Phase 2-Recherche.)
- Welche aktuellen Sanktionen gibt es bei Verstößen gegen Content-Maturity-Regeln? (Phase 2.)
- Welche Telemetrie-Events sind DSGVO-konform für Spieler unter 13? (Phase 2-Recherche, Abstimmung mit Compliance Lead.)

## Risiken

- **Regel-Änderungen:** Roblox kann Regeln kurzfristig anpassen. Mitigation: monatlicher Review.
- **Kulturelle Compliance:** Verschiedene Regionen haben unterschiedliche Jugendschutzgesetze. Mitigation: konservativster Standard gilt global.
- **Sicherheitsvorfall:** Auch bei guter Prävention können Vorfälle passieren. Mitigation: Eskalationsplan und Notfall-Kommunikation vorbereitet.

## Nächste Schritte

1. Detail-Recherche zu Roblox Parental Controls (Phase 2).
2. Schriftliche Verpflichtungserklärung für alle Entwickler:innen, Compliance-Regeln zu lesen und zu befolgen.
3. Externe Beratung durch Kindersicherheits-Expert:innen für die Markteinführung.
4. Pseudonymisiertes Incident-Reporting-System einrichten (Phase 3).

## Änderungsverlauf

| Datum | Version | Änderung | Autor |
|---|---|---|---|
| 2026-06-27 | 0.1 | Initiale Compliance-Matrix auf Basis Briefing + Roblox-Standardrecherche | Mavis (Agent) |
| 2026-06-27 14:25 | 0.2 | Refit: Curio World + 5-District-Plan + Gold/Gems/Robux (kein Stamina) + VIP-Komfort-Pass | Mavis (Agent) |
| 2026-06-27 14:50 | 0.3 | Refit: Wonder World → Curio World (Naming-Kollision mit existierendem Roblox-Pet-Game aufgedeckt) | Mavis (Agent) |
| 2026-06-27 | 0.1 | Initiale Compliance-Matrix auf Basis Briefing + Roblox-Standardrecherche | Mavis (Agent) |