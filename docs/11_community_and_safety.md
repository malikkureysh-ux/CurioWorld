# 11 — Community and Safety

## Zweck

Dieses Dokument definiert das Community- und Sicherheitsdesign von Curio World: soziale Mechaniken, Kommunikationsarchitektur, Moderation, Meldemechanismen und Schutzregeln für jüngere Spieler:innen. Es ist verbindliche Grundlage für alle sozialen Features.

## Annahmen

- Community entsteht durch gemeinsame Aktivität, nicht durch unmoderierte Chats.
- Roblox-Plattformregeln zum Schutz jüngerer Nutzer:innen haben Vorrang.
- Sichere Kommunikation ist Standard; Freitext und Voice-Chat sind Ausnahmen mit klarer Berechtigung.
- Melde- und Eskalationsmechanismen sind Pflicht.
- Mentoren-/Ältere-Spieler:innen-Systeme sind nur dann erlaubt, wenn sie plattformkonform und missbrauchsresistent sind.

## Quellen

- `02_compliance_matrix.md` (C-004 bis C-013, C-018)
- Roblox Community Standards (Stand 2026)
- Roblox Chat- und Voice-Richtlinien

## Soziale Grundlogik

Curio World ist ein **Community-Spiel, aber keine ungefilterte Chat-Plattform**. Spieler:innen erleben Gemeinschaft durch:

- Gemeinsame Quests mit klaren Rollen.
- Kooperative Bezirks-Events.
- Bau-Projekte mit globalem Fortschrittsbalken.
- Sammelbücher, die Freunde vergleichen (ohne Noten).
- Housing-Einladungen.
- Emotes, Pings, vorgegebene Phrasen als Hauptsprache.

Freitext- und Voice-Chat sind **nicht der Standard**, sondern **Ausnahmen mit Berechtigung**.

## Kommunikationsarchitektur

### Primäre Sprache: Pings und Emotes

- **Pings:** Kontextmarker für „Hilfe hier", „Feind in der Nähe" (stilisiert), „Sammel-Item", „Quest-Trigger".
- **Emotes:** Mindestens 24 Basis-Emotes (Winken, Tanzen, Klatschen, Daumen hoch, Such-Geste, etc.).
- **Kontext-Phrasen:** Vorgegebene Sätze wie „Ich helfe dir!", „Geschafft!", „Wir schaffen das!", „Folge mir!".
- **Bezirks-Emotes:** Spezielle Emotes pro Bezirk (z. B. Hafen: „Salut", SkyBridge: „Schau die Aussicht!").

### Sekundäre Sprache: optionaler Text-Chat

| Altersband | Standard | Optional aktivierbar |
|---|---|---|
| 9–11 | Pings/Emotes/Phrasen | Nur mit Eltern-PIN + Roblox-Berechtigung |
| 12–13 | Pings/Emotes/Phrasen | Mit Roblox-Berechtigung |
| 14–16 | Pings/Emotes/Phrasen + Text | Standard gemäß Roblox-Settings |

**Wortfilter:**
- Roblox-Standard-Wortfilter.
- Zusätzlicher benutzerdefinierter Filter (Phase 3 zu definieren).
- Beleidigende oder grenzüberschreitende Inhalte werden blockiert und protokolliert.

### Tertiäre Sprache: Voice-Chat

| Altersband | Verfügbar |
|---|---|
| 9–11 | nein |
| 12–13 | nur mit aktivierter Roblox-Berechtigung |
| 14–16 | mit aktivierter Roblox-Berechtigung |

Voice-Chat wird durch Roblox-Plattformregeln verwaltet; Curio World erzwingt keine zusätzlichen Voice-Beschränkungen, nutzt aber die Standard-Sicherheits-Tools der Plattform.

## Soziale Mechaniken

### Kooperative Bezirks-Events

- Live-Events mit klaren Zielen.
- Beispiel: „Hafen-Fest" — alle Spieler:innen helfen, eine Brücke zu reparieren.
- Belohnung: gemeinsamer Baufortschritt + individuelle Event-Items.

### Teamquests mit Rollen

Rollen und ihre Eigenschaften:

| Rolle | Funktion | Anzeige |
|---|---|---|
| Builder | Konstruiert Bauwerke | Bauhelm-Icon |
| Scout | Erkundet Pfade | Fernglas-Icon |
| Solver | Löst Rätsel | Schlüssel-Icon |
| Collector | Sammelt Materialien | Taschen-Icon |
| Coordinator (optional) | Verteilt Rollen, gibt Pings | Stern-Icon |

### Community-Bauquests

- Globale Fortschrittsbalken für Bezirks-Bauwerke.
- Jede abgeschlossene Quest füllt den Balken.
- Nach Abschluss: Bauwerk wird sichtbar und persistent.

### Freundschafts-Boni ohne Ausschluss

- Freundschafts-Bonus: +5 % Materialien bei gemeinsamem Spiel.
- Keine Vorteile, die nicht-Freund:innen ausschließen.

### Mentor-System (eng begrenzt)

- Nur für Spieler:innen ab 14 Jahren mit aktiver Roblox-Berechtigung.
- Mentoring erfolgt über Emote-/Ping-Ebene, nicht über privaten Chat.
- Mentees können das Mentor-Verhältnis jederzeit beenden.
- Verstöße führen zu sofortigem Entzug der Mentor-Rolle.

## Sicherheitsarchitektur

### In-Game-Meldemechanismus

- Meldetaste im HUD, immer sichtbar.
- Meldeflow:
  1. Kategorie wählen (Verhalten, Name, Inhalt).
  2. Optional kurze Beschreibung.
  3. Anonyme Übermittlung an Roblox-Trust-and-Safety + interne Erfassung.

### Roblox-Trust-and-Safety-Integration

- Roblox-Standard-Report-System nutzen.
- Wiederholungstätern wird der Zugang zur Experience entzogen.
- Schwere Verstöße: zusätzliche Plattform-Meldung.

### Wort- und Verhaltensfilter

- Roblox-Standardfilter aktiv.
- Zusätzliche Listen für Spieler:innen-Namen (respektvolle Vorschläge in der Charaktererstellung).
- Anti-Harassment: Spieler:innen, die wiederholt gemeldet werden, werden temporär oder dauerhaft gemutet.

### Matchmaking-Regeln

- Standard: gleichaltrige Buckets (basierend auf Roblox-Profilalter).
- Solo-Modus für Spieler:innen, die nicht in öffentliche Lobbys wollen.
- Freundschaftslisten-Lobby für private Spielsitzungen.
- Eltern können Matchmaking-Typ konfigurieren.

### UGC-Beschränkungen

- Keine nutzergenerierten 3D-Inhalte im Spiel ohne Moderation.
- Charakter-Namen: Vorschläge + Filter.
- Housing-Deko: nur aus genehmigtem Asset-Pool (kein freier Upload).
- Avatar-Customizing: aus genehmigtem Item-Set.

### Naming-Schutz

- Bei Charaktererstellung: Vorschläge auf Basis von Wortlisten (Tiernamen, Naturphänomene, freundliche Adjektive).
- Filter gegen Beleidigungen, Markennamen, personenbezogene Daten.
- Optionale Namensänderung einmal pro Saison kostenlos.

## Eskalationspfade

### Stufen

| Stufe | Trigger | Reaktion |
|---|---|---|
| 1 | Einzelne Meldung | Intern registrieren, keine sofortige Aktion |
| 2 | Mehrere Meldungen in kurzer Zeit | Temporäre Emote-/Chat-Beschränkung |
| 3 | Wiederholte Verstöße | Plattform-Report an Roblox |
| 4 | Schwere Verstöße (z. B. Grooming-Versuche, personenbezogene Daten) | Sofortige Sperrung + Plattform-Report |
| 5 | Systematische oder gewerbliche Verstöße | Plattform-Trust-and-Safety-Kontakt |

### Interne Dokumentation

- Alle Vorfälle werden anonymisiert protokolliert.
- Trend-Analyse wöchentlich durch Safety Lead.
- Quartalsweise Review mit kindersicherheits-erfahrenem Berater.

## Kommunikation an Eltern und Spieler:innen

### Beim ersten Beitritt

- Kurzes Community-Video (lokalisiert) erklärt Verhaltensregeln.
- Klare Sprache: „Wir wollen, dass alle Spaß haben. Wer andere stört, fliegt raus."

### Im About-Bereich

- Detaillierte Erklärung der Kommunikationsarchitektur.
- Hinweise auf Roblox Parental Controls.
- Empfehlungen für Bildschirmzeit und Pausen.

## Sicherheits-Tests

Jedes Community-Feature wird vor Release getestet auf:

- Funktion der Meldefunktion (end-to-end).
- Wortfilter (mit Test-Samples in allen 9 Sprachen).
- Rollen-Verteilung und Anzeige.
- Privatsphäre-Einstellungen für Housing.
- Anti-Harassment-Verhalten bei wiederholten Verstößen.

## Risiken

- **Grooming und Kontaktaufnahme:** Auch bei beschränktem Chat können Risiken bestehen. Mitigation: zusätzliche Filter, schnelle Eskalation, Monitoring.
- **Cybermobbing:** Wiederholtes negatives Verhalten kann schaden. Mitigation: Meldefunktion, automatische Beschränkungen, Plattform-Report.
- **Mehrsprachige Filter:** Beleidigungen in anderen Sprachen sind schwer zu erkennen. Mitigation: lokalisierte Wortfilter-Listen, kulturelle Berater:innen.
- **Toxic Behavior in Events:** Wettbewerbs-Events können Konflikte auslösen. Mitigation: kooperative statt kompetitive Haupt-Events.

## Offene Fragen

- Welche zusätzlichen Wortfilter-Listen sind in Hindi, Arabisch, Japanisch kritisch? (Phase 3 Recherche.)
- Wie genau funktioniert die Roblox Parental Control API? (Phase 2.)
- Welche Eskalationswege sind außerhalb der Plattform sinnvoll (z. B. bei Verdacht auf Straftat)? (Phase 6.)

## Nächste Schritte

1. Konkrete Wortfilter-Listen pro Sprache recherchieren.
2. Melde-Flow im Studio prototypisch implementieren.
3. Mentor-System-Regeln in Phase 3 spezifizieren.
4. Externe Beratung durch Kindersicherheits-Expert:innen für Phase 6.

## Änderungsverlauf

| Datum | Version | Änderung | Autor |
|---|---|---|---|
| 2026-06-27 | 0.1 | Initiales Community- und Sicherheitsdesign | Mavis (Agent) |
| 2026-06-27 14:25 | 0.2 | Refit: Curio World + 5-District-Plan + Gold/Gems/Robux (kein Stamina) + VIP-Komfort-Pass | Mavis (Agent) |
| 2026-06-27 14:50 | 0.3 | Refit: Wonder World → Curio World (Naming-Kollision mit existierendem Roblox-Pet-Game aufgedeckt) | Mavis (Agent) |
| 2026-06-27 | 0.1 | Initiales Community- und Sicherheitsdesign | Mavis (Agent) |