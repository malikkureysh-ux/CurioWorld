# D-003 — Lernprinzip: Versteckt statt sichtbar

**Status:** offen (Validierung in Phase 4 und Phase 6)
**Datum:** 2026-06-27
**Owner:** Learning Architect

## Problem

Wie wird Lernen im Spiel präsentiert? Die Wahl prägt das gesamte Spielgefühl, die elterliche Akzeptanz und den langfristigen Erfolg.

## Optionen

### Option A — Versteckte Mechaniken

- Lernimpulse sind vollständig in Spielaktionen eingebettet.
- Keine sichtbaren Quizfragen, keine „Lerne jetzt"-Aufforderungen.
- Lernfortschritt nur über sichtbare Belohnungen kommuniziert.
- Optionaler Educator-Modus für Eltern/Lehrkräfte zeigt Lernbezüge explizit.

### Option B — Sichtbarer Lernmodus

- Eigener Lern-Tab im Hauptmenü.
- Quizze, Erklärtexte, Tests.
- Spieler:innen können zwischen „Spiel" und „Lernen" wechseln.

### Option C — Hybrid (sichtbar + versteckt)

- Hauptsächlich versteckt, aber gelegentliche sichtbare Quizze als Belohnung.
- Risiko: Verwirrung und Schulgefühl.

## Bewertungsmaßstab

- Spielspaß („Spiel zuerst"-Prinzip)
- Anti-Schulgefühl (Briefing-Pflicht)
- Eltern-Akzeptanz
- Nachvollziehbarkeit für Eltern und Lehrkräfte
- Lernwirksamkeit (laut Forschung)
- Plattform-Compliance

## Entscheidung

**Option A — Versteckte Mechaniken.**

## Begründung

Die Forschung zu adaptiven Lernspielen zeigt klar, dass Lernen am wirksamsten ist, wenn es in sinnvolle Handlungen eingebettet ist, nicht in separate Lernphasen. Das Briefing-Prinzip „Spiel zuerst" + „Lernen ohne Schulgefühl" verlangt diese Lösung explizit.

Option B (sichtbarer Lernmodus) widerspricht dem Briefing und würde das Produkt in Richtung „Lernspiel" drängen, was die Zielgruppe der 14–16-Jährigen abschrecken könnte.

Option C (Hybrid) klingt ausgewogen, schafft aber in der Praxis Verwirrung: Spieler:innen wissen nie, wann sie „spielen" und wann sie „lernen", was den Flow bricht.

Der Educator-Modus in Option A löst das Eltern-Bedürfnis, ohne die Spieler:innen-Erfahrung zu beeinträchtigen.

## Erwartete Wirkung

- Spieler:innen erleben sich als Problemlöser:innen, nicht als Lernende.
- Hohe intrinsische Motivation.
- Eltern können den Lernwert im Educator-Modus nachvollziehen.
- Lehrkräfte können das Spiel begleitend einsetzen.

## Risiken

- **R-1:** Eltern könnten keinen Lernwert erkennen.
  - Mitigation: Educator-Modus, About-Bereich, Elterninformation.
- **R-2:** Lernwirkung könnte weniger sichtbar sein als bei Quiz-Formaten.
  - Mitigation: Phase-4-Tests mit qualitativen Lerneffekt-Indikatoren.
- **R-3:** Marketing-Kommunikation muss das Lernversprechen trotzdem klar machen.
  - Mitigation: klare Botschaft „Lernen durch Spielen" statt „Lernspiel".

## Validierungsplan

| Phase | Aktion |
|---|---|
| Phase 4 | Eltern-Befragung zur Wahrnehmung des Lernwerts |
| Phase 4 | Spieler:innen-Befragung zum Spielerlebnis (keine Schulgefühle) |
| Phase 6 | Langzeit-Eltern-Studie: Berichten Kinder von neuen Fähigkeiten? |

## Quellen

- `roblox_ai_briefing.md` (Lernprinzip)
- `04_learning_architecture.md` (LP-1 bis LP-6)
- `01_research_log.md` T-04, T-05, T-06

## Änderungsverlauf

| Datum | Version | Änderung | Autor |
|---|---|---|---|
| 2026-06-27 | 0.1 | Initial | Mavis (Agent) |