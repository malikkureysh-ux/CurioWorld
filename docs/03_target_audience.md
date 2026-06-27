# 03 — Target Audience

## Zweck

Dieses Dokument definiert die Zielgruppen von Curio World entlang von Altersbändern, Verhaltensmustern und Bedürfnissen. Es ist Grundlage für jede Mechanik-, UI- und Lernarchitektur-Entscheidung.

## Annahmen

- Spieler:innen zwischen 9 und 16 Jahren sind keine homogene Gruppe.
- Spieler:innen können zusätzlich nach Kompetenzstand, Vorlieben und Spieltyp differenziert werden.
- Neurodivergenz ist Normalfall, nicht Ausnahme; das Design muss vielfältige Bedürfnisse abdecken.
- Eltern und Lehrkräfte sind sekundäre Zielgruppe für Vertrauen und Erreichbarkeit.

## Quellen

- `roblox_ai_briefing.md` (primäre Altersbänder)
- Lernforschung zu adaptiven Spielen (`01_research_log.md` T-04, T-08)
- Markt- und Wettbewerbsscan (Phase 2, in Vorbereitung)

## Primäre Altersbänder

### Band A — Junior Rangers (9–11 Jahre)

**Profil:**
- Neugierig, sammel- und belohnungsorientiert.
- Kürzere Aufmerksamkeitsspannen (~10–15 Minuten pro Loop).
- Klarheit und Vorhersagbarkeit wichtig.
- Eltern oft in der Nähe oder im selben Raum.
- Erstes Interesse an Selbstdarstellung (Skins, Emotes).

**Bevorzugte Spielmuster:**
- Visuelle Ursache-Wirkung.
- Klare Ziele mit sofortiger Belohnung.
- Einfache Mehrschrittaufgaben mit konkreten Hilfen.
- Sammeln und Sortieren.
- Co-op mit ähnlich alten Spielern.

**Lern- und Spieltiefe:**
- Konkret, visuell, kurz.
- Drei-Hilfe-Regel: Drei Hilfestellungen, dann einfache Lösung.
- Aufgaben mit 1–2 kognitiven Schritten.

**Anti-Pattern:**
- Lange Texte, komplexe Menüs, viele Zahlen.
- Lange Lade-Sessions ohne sofortige Action.
- Soziale Druck-Mechaniken (z. B. öffentliches Ranking).

---

### Band B — City Scouts (12–13 Jahre)

**Profil:**
- Mehr Autonomie und Eigeninitiative.
- Wunsch nach Zugehörigkeit und Identität.
- Teamspiel und gemeinsame Projekte werden attraktiv.
- Erste strategische Entscheidungen möglich.
- Online-Spielzeit regelmäßig, oft abends.

**Bevorzugte Spielmuster:**
- Verzahnte Systeme (Stadtbau + Quests + Sammeln).
- Teamquests mit klaren Rollen.
- Erkundung und Geheimnisse.
- Customizing von Avatar und persönlichem Bereich.
- Events mit Countdown, aber ohne Frust-Druck.

**Lern- und Spieltiefe:**
- Zwei bis drei verknüpfte Regeln pro Aufgabe.
- Weniger Hilfen, mehr Transfer.
- Erste Optimierungsentscheidungen.

**Anti-Pattern:**
- „Kinder-Spiel"-Anmutung (sie wollen als ernsthafte Spieler:innen respektiert werden).
- Überbehütete UI, die ihnen nichts zutraut.
- Belohnungen, die sich nach Konsum anfühlen statt nach Erreichung.

---

### Band C — Sky Architects (14–16 Jahre)

**Profil:**
- Höhere Systemkompetenz, mehr Geduld für komplexe Mechaniken.
- Soziale Identität wichtig (Cliquen, Builds, Status durch Können).
- Optimierung und Effizienz treiben Engagement.
- Bau- und Mastery-Motivation.

**Bevorzugte Spielmuster:**
- Tiefere Kombinatorik, mehrstufige Quests.
- Projektketten mit echtem Zeit- und Materialbudget.
- Optimierbare Builds, Werkzeuge, Routen.
- Wettbewerbs-Komponenten (Bestenliste ohne Pay-to-Win).
- Mentor-Rolle für jüngere Spieler (über Emote-/Ping-System).

**Lern- und Spieltiefe:**
- Mehrstufig, kombinatorisch, mit Optimierungs- und Teamkomponenten.
- Selbstständige Problemlösung über mehrere Sessions.
- Eigene Projekte, die im persistenten Stadtraum sichtbar bleiben.

**Anti-Pattern:**
- Reduktion auf „nur sammeln".
- Starre Pfade ohne Freiheit.
- Tutorial-Overload.

---

## Sekundäre Zielgruppen

### Eltern und Erziehungsberechtigte

**Bedürfnisse:**
- Wissen, was das Kind spielt und lernt.
- Sicherheit, dass Monetarisierung fair und transparent ist.
- Möglichkeit, Käufe zu kontrollieren.
- Verlässliche Bildschirmzeit-Mechanismen (keine Endlos-Loops).

**Wie wir sie adressieren:**
- Klarer About-Bereich mit Lernzielen, Sicherheitsstandards und Monetarisierungs-Übersicht.
- In-Game-Kaufvorschau, die das Kind den Eltern zeigen kann.
- Aktivitäts-Zusammenfassung (welche Bezirke, welche Art von Aufgaben, welche Fähigkeiten geübt) — ohne Noten.
- Klare Hinweise auf Roblox Parental Controls und deren Empfehlungen.

### Lehrkräfte und Pädagog:innen (optionale sekundäre Zielgruppe)

**Bedürfnisse:**
- Anknüpfungspunkte an Lehrplan-Themen.
- Verlässliche Informationen über Lernanspruch.
- Empfehlungen für begleitende Aktivitäten offline.

**Wie wir sie adressieren:**
- Optionaler „Educator Modus" mit Lernzusammenhängen pro Mission.
- Downloads: Hintergrund-Informationen pro Bezirk (Phase 6).

## Cross-Cutting Personas

Neben Altersbändern unterscheiden wir Verhaltens- und Interessen-Personas:

| Persona | Charakteristik | Was sie liebt | Was sie frustriert |
|---|---|---|---|
| Der Sammler | liebt Checklisten, Alben, 100%-Completion | Sticker, Erinnerungsstücke, seltene Items | Zufall statt Können |
| Der Builder | liebt es, Welten zu formen | Bezirks-Bau, Housing, Deko-Slots | Enges Inventar, unfaire Materialkosten |
| Der Explorer | liebt unbekannte Ecken | Geheimnisse, versteckte Missionen | Lineare Story |
| Der Solver | liebt Logik und Muster | Rätsel, Planungsquests, Teamquests | Glücks-Mechaniken |
| Der Social Player | liebt Gesellschaft | Emotes, Teams, saisonale Events | Solo-Zwang, Isolation |
| Der Speedrunner | liebt Effizienz | Optimale Routen, Sprint-Challenges | Lange Zwischensequenzen |

Das Spiel muss alle Personas bedienen, ohne eine zu bevorzugen. Tägliche Rotation der Hauptattraktion hilft, mehrere Personas anzusprechen.

## Anpassungsdimensionen

Das adaptive System (`12_adaptive_difficulty_model.md`) berücksichtigt:

- **Erfolgsquote** pro Missionstyp
- **Bearbeitungszeit**
- **Hilfenutzung**
- **Fehlermuster**
- **Abbruchverhalten**
- **Wiederholungsbedarf**
- **Präferenz für Spieltyp** (Sammler/Builder/Explorer/…)
- **Kooperationsverhalten**
- **Altersband** (Startfilter)

## Risiken

- **Stereotype Bedienung:** Gefahr, Altersbänder zu klischeehaft zu bedienen. Mitigation: Cross-Band-Test, junge Tester:innen aus allen Bändern.
- **Eltern-Bedenken:** Eltern könnten das Spiel als zu komplex oder zu wenig „lehrreich" empfinden. Mitigation: klare About-Seite, Elterninformation.
- **Unter- oder Überforderung:** Adaptive Engine muss sehr fein justieren. Mitigation: ausführliche Telemetrie und qualitative Tests.

## Offene Fragen

- Wie messen wir ohne klassische Tests, ob die Lernziele erreicht werden? (Phase 2.)
- Welche Kommunikationskanäle zu Eltern sind effektiv, ohne aufdringlich zu wirken? (Phase 6.)
- Wie integrieren wir junge Tester:innen in die Designphase, ohne Datenschutz zu verletzen? (Phase 2.)

## Nächste Schritte

1. Persona-Steckbriefe mit echten Spieler:innen-Daten validieren (Phase 2).
2. Elternbefragung zur Monetarisierungs-Transparenz (Phase 6 vorbereiten).
3. Persona-Mix pro Bezirk definieren (welche Persona wird dort bevorzugt angesprochen).

## Änderungsverlauf

| Datum | Version | Änderung | Autor |
|---|---|---|---|
| 2026-06-27 | 0.1 | Initiale Zielgruppen-Definition | Mavis (Agent) |
| 2026-06-27 14:25 | 0.2 | Refit: Curio World + 5-District-Plan + Gold/Gems/Robux (kein Stamina) + VIP-Komfort-Pass | Mavis (Agent) |
| 2026-06-27 14:50 | 0.3 | Refit: Wonder World → Curio World (Naming-Kollision mit existierendem Roblox-Pet-Game aufgedeckt) | Mavis (Agent) |
| 2026-06-27 | 0.1 | Initiale Zielgruppen-Definition | Mavis (Agent) |