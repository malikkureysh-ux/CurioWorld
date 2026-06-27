# 18 — User Testing Reports

## Zweck

Dieses Dokument sammelt alle User-Testing-Aktivitäten für Curio World: Methodik, Protokolle, Berichte und Erkenntnisse. Es ist die lebendige Forschungs-Quelle der Wahrheit.

## Annahmen

- User-Testing beginnt ab Phase 2 und intensiviert sich in Phase 4.
- Tests sind geordnet in: Konzept-Tests, Prototyp-Tests, Beta-Tests, Live-Tests.
- Junge Tester:innen werden nur mit Eltern-Einwilligung einbezogen.
- DSGVO/COPPA-konforme Datenpraxis ist Pflicht.
- Qualitative Erkenntnisse haben Vorrang vor rein quantitativen Metriken.

## Quellen

- `03_target_audience.md` (Altersbänder, Personas)
- `15_qa_test_plan.md` (Test-Methodik)
- `16_risk_register.md` (R-016 Junge Tester:innen)

## Testphasen

### UT-Phase-1: Konzept-Tests (Phase 2)

**Zweck:** Validierung von Vision, Lore, Bezirks-Konzepten.

**Methoden:**
- Fokusgruppen mit Eltern und Kindern (alle drei Altersbänder).
- Concept-Tests mit Skizzen, Stilreferenzen, Story-Snippets.
- Naming-Tests (Logo- und Namensvarianten).

**Stichprobe:** 6–10 Familien pro Region (DE, US, TR, IN, BR, JP, CN, EG, FR) — also 54–90 Familien insgesamt.

### UT-Phase-2: Prototyp-Tests (Phase 4)

**Zweck:** Validierung von Vertical Slice Hamburg Harbor.

**Methoden:**
- Beobachtete Spielsessions (1 Spieler:in + 1 Beobachter:in).
- Aufgaben: Quest-Strecken, Sammel-Mechaniken, Bau-Mechaniken.
- Think-Aloud-Protokoll.
- Fragebogen nach der Session (lokalisiert).

**Stichprobe:** 30 Spieler:innen pro Altersband (insgesamt 90).

### UT-Phase-3: Beta-Tests (Phase 5)

**Zweck:** Validierung des vollständigen Spiels vor Launch.

**Methoden:**
- Geschlossener Beta-Server (max. 500 Spieler:innen).
- Eingebettete Telemetrie + qualitative Befragungen.
- Sicherheits-Tests in geschützter Umgebung.

**Stichprobe:** 500 Beta-Tester:innen mit Eltern-Einwilligung.

### UT-Phase-4: LiveOps-Tests (Phase 6+)

**Zweck:** Validierung von saisonalen Events und kontinuierlichen Verbesserungen.

**Methoden:**
- In-Game-Umfragen.
- Social-Media-Listening (Community-Feedback).
- A/B-Tests für neue Features.

**Stichprobe:** Alle aktiven Spieler:innen.

## Testprotokoll-Vorlage

Jeder Testbericht folgt dieser Struktur:

```
Test Report
============
Test-ID: UT-XXX
Datum: YYYY-MM-DD
Phase: UT-Phase-X
Methodik: ...
Stichprobe: ...
Test-Dauer: ...
Setting: ...

Ziele:
- ...

Methode:
- ...

Ergebnisse:
- ...

Beobachtungen:
- ...

Probleme und Empfehlungen:
- ...

Follow-up:
- ...

Anhänge:
- ...
```

## Geplante Testberichte

| ID | Titel | Phase | Status |
|---|---|---|---|
| UT-001 | Naming-Test „Curio World" | 1 | geplant |
| UT-002 | Bezirks-Identifikation (Skizzen) | 1 | geplant |
| UT-003 | Farbpalette-Test (jüngere vs. ältere Spieler:innen) | 1 | geplant |
| UT-004 | Onboarding-Test (Vertical Slice) | 2 | geplant |
| UT-005 | Kran-Schwing-Mechanik (Vertical Slice) | 2 | geplant |
| UT-006 | Werft-Bau-Teamquest (Vertical Slice) | 2 | geplant |
| UT-007 | Adaptive Engine — Sichtbarkeit | 2 | geplant |
| UT-008 | Erinnerungs-Mechaniken | 2 | geplant |
| UT-009 | Eltern-Befragung zur Monetarisierung | 3 | geplant |
| UT-010 | Sicherheits- und Moderation-Test | 3 | geplant |
| UT-011 | Vollständiger Beta-Test | 3 | geplant |
| UT-012 | Saison-Event-Test | 4 | geplant |

## Ethische Leitlinien

- **Einverständnis:** Schriftliche Eltern-Einwilligung vor jeder Spieler:innen-Studie.
- **Datenminimierung:** Keine Aufnahme von Gesichtern oder Namen; nur pseudonymisierte Notizen.
- **Freiwilligkeit:** Kinder können jederzeit ohne Konsequenzen abbrechen.
- **Sicherheit:** Tests nur in kontrollierter Umgebung mit geschulten Erwachsenen.
- **Belohnung:** Kleine, altersgerechte Dankeschöns (z. B. digitaler Sticker) — kein Druck.

## Rekrutierung

- Pilot-Phase: lokale Schulen, Roblox-Community-Kanäle, interne Mitarbeiter:innen-Familien.
- Spätere Phasen: spezialisierte Marktforschungs-Partner für jüngere Zielgruppen.
- Diversität über Regionen, Geschlechter und sozioökonomische Hintergründe sicherstellen.

## Berichts-Ablage

- Testberichte in `research/ut/UT-XXX_<kurzname>.md`.
- Rohdaten (anonymisiert) in `research/ut/raw/`.
- Aggregierte Erkenntnisse fließen in `00_product_vision.md`, `03_target_audience.md`, `04_learning_architecture.md` zurück.

## Aktuelle Test-Reports

*(Bisher keine durchgeführten Tests — geplant ab Phase 2.)*

## Erkenntnis-Aggregation

Nach Abschluss einer Testphase werden zentrale Erkenntnisse gesammelt und in die entsprechenden Doku-Dokumente zurückgespielt:

- Vision → `00_product_vision.md`
- Zielgruppe → `03_target_audience.md`
- Lernen → `04_learning_architecture.md`
- Game Design → `05_game_design_document.md`
- Welt → `06_world_bible.md`
- Art → `07_art_direction.md`

## Risiken

- **Rekrutierungsschwierigkeiten:** Junge Tester:innen mit Eltern-Einwilligung schwer zu finden. Mitigation: Pilot-Gruppen früh aufbauen.
- **Test-Verzerrung:** Kinder verhalten sich in Tests anders als zu Hause. Mitigation: Mixed-Methods, längere Beobachtungen.
- **Datenschutz:** Strenge Anforderungen für Minderjährige. Mitigation: Compliance-Lead prüft jedes Protokoll.

## Offene Fragen

- Welche Marktforschungspartner für globale Tests? (Phase 2.)
- Welche internen Pilot-Gruppen können wir früh aufbauen? (Phase 2.)
- Welche Belohnungen sind ethisch vertretbar? (Phase 2.)

## Nächste Schritte

1. Testprotokoll-Vorlagen finalisieren (Phase 2).
2. Pilot-Rekrutierung starten (Phase 2).
3. Erste Naming- und Bezirks-Tests vorbereiten (Phase 2).
4. Datenschutz-Review der Testprotokolle (Phase 2).

## Änderungsverlauf

| Datum | Version | Änderung | Autor |
|---|---|---|---|
| 2026-06-27 | 0.1 | Initiale User-Testing-Struktur | Mavis (Agent) |
| 2026-06-27 14:25 | 0.2 | Refit: Naming-Test auf „Curio World", Vertical Slice auf Hamburg Harbor | Mavis (Agent) |
| 2026-06-27 14:50 | 0.3 | Refit: Wonder World → Curio World (Naming-Kollision mit existierendem Roblox-Pet-Game aufgedeckt) | Mavis (Agent) |
| 2026-06-27 14:25 | 0.2 | Refit: Naming-Test auf „Curio World", Vertical Slice auf Hamburg Harbor | Mavis (Agent) |