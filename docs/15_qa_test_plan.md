# 15 — QA Test Plan

## Zweck

Dieses Dokument definiert den vollständigen QA-Prozess für Curio World: Testkategorien, Testfälle, Methoden, Tools und Verantwortlichkeiten. Es ist die operative Grundlage für Qualitätssicherung.

## Annahmen

- QA ist von Anfang an Teil des Prozesses, nicht erst kurz vor Release.
- Mehrere Testkategorien sind nötig: funktional, Performance, Sicherheit, UX, Lernen.
- Tests in mehreren Sprachen sind Pflicht.
- Junge Tester:innen werden mit Eltern-Einwilligung einbezogen.
- Bugs werden mit Priorität und Severity kategorisiert.

## Quellen

- `02_compliance_matrix.md` (Compliance-Tests)
- `14_telemetry_plan.md` (Performance-Metriken)
- `11_community_and_safety.md` (Sicherheits-Tests)
- `04_learning_architecture.md` (Lern-Tests)

## Testkategorien

### T-Kat-1: Funktionale Tests

**Zweck:** Sicherstellen, dass alle Features wie spezifiziert funktionieren.

**Beispiele:**
- Quest startet und schließt korrekt ab.
- Puzzle akzeptiert korrekte Lösung, lehnt falsche ab.
- Inventar zeigt richtige Items.
- Shop-Kauf reduziert korrekt Robux und fügt Item hinzu.
- Adaptive Engine schlägt passende nächste Quest vor.
- Speichern und Laden funktioniert nach Trennung.

**Methoden:**
- Unit-Tests (Luau-Test-Framework).
- Integration-Tests pro System.
- Manuelle End-to-End-Tests pro Quest.

### T-Kat-2: Performance-Tests

**Zweck:** Sicherstellen, dass Spielbarkeit auf Mobile, Desktop und Konsole den Zielen entspricht.

**Methoden:**
- FPS-Profiling auf Mobile (Android, iOS), Desktop (Win/Mac), Konsole.
- Netzwerk-Latenz-Tests in verschiedenen Regionen.
- Speicher-Tests auf Low-End-Geräten.
- Server-Lasttests mit 50–80 Spieler:innen.

**Akzeptanzkriterien:**
- Median FPS Mobile ≥ 30.
- Median FPS Desktop ≥ 60.
- Median Latenz ≤ 100 ms.
- Speicherverbrauch ≤ Zielwert pro Plattform.

### T-Kat-3: Sicherheits-Tests

**Zweck:** Sicherstellen, dass alle Sicherheitsfeatures funktionieren.

**Testfälle:**
- Meldetaste funktioniert end-to-end.
- Wortfilter blockiert unangemessene Inhalte in allen 9 Sprachen.
- Anti-Harassment: Wiederholungstäter werden gemutet.
- Chat-Beschränkungen für 9–11 funktionieren.
- Voice-Chat-Beschränkungen für 9–11 funktionieren.
- Housing-Sichtbarkeit respektiert Visitor-Settings.
- Mentoren-Verhältnis kann von Mentee beendet werden.

**Methoden:**
- Penetration-Test-Sessions (intern + extern).
- Red-Team-Übungen mit geschulten Tester:innen.
- Wortfilter-Test-Samples in 9 Sprachen.

### T-Kat-4: UX-Tests

**Zweck:** Sicherstellen, dass die Spielerfahrung angenehm, klar und motivierend ist.

**Methoden:**
- Usability-Tests mit Spieler:innen aus allen drei Altersbändern.
- Beobachtung von Onboarding-Sessions.
- A/B-Tests für UI-Varianten.
- Qualitative Interviews nach Test-Sessions.

**Akzeptanzkriterien:**
- 80 % der Tester:innen erreichen erstes Erfolgserlebnis in ≤ 5 Minuten.
- 70 % verstehen Quest-Ziel nach einmaligem Lesen.
- 85 % finden die UI „freundlich" oder „sehr freundlich".

### T-Kat-5: Lern-Tests

**Zweck:** Sicherstellen, dass Lernmechaniken funktionieren und keine Schulgefühle entstehen.

**Testfälle:**
- Eingebettete Aufgaben lösen Lernimpulse aus.
- Adaptive Anpassung funktioniert (Spieler:in sieht leichtere/schwierigere Varianten).
- Hilfen sind hilfreich, nicht bevormundend.
- Erinnerungs-Mechaniken fördern aktives Abrufen.
- Anti-Shame: keine öffentliche Bewertung sichtbar.

**Methoden:**
- Beobachtete Test-Sessions mit Fokus auf Lerneffekt.
- Fragebögen (lokalisiert) zu Spielerlebnis und Lernwahrnehmung.
- Vergleich Test-Gruppe (mit aktivierter Lernmechanik) vs. Kontroll-Gruppe (mit Placebo-Mechanik) — wo DSGVO-konform möglich.

### T-Kat-6: Lokalisierungs-Tests

**Zweck:** Sicherstellen, dass alle 9 Sprachen korrekt funktionieren.

**Testfälle:**
- Alle UI-Texte in 9 Sprachen vorhanden.
- Arabisch: RTL-Layout korrekt.
- Schriften haben alle Glyphen für 9 Sprachen.
- NPC-Dialoge vollständig lokalisiert.
- Audio-Vertonung in 9 Sprachen vorhanden und synchron.
- Keine kulturell unangemessenen Inhalte.

**Methoden:**
- Muttersprachler:innen-Review pro Sprache.
- RTL-Layout-Test mit arabischen Tester:innen.
- Audio-Synchronitätstest pro Sprache.

### T-Kat-7: Compliance-Tests

**Zweck:** Sicherstellen, dass Plattform- und Sicherheitsregeln eingehalten werden.

**Testfälle:**
- Keine Pay-to-Win-Mechaniken.
- Keine Lootboxen mit Echtgeld.
- Chat-Beschränkungen für jüngere Nutzer:innen.
- Meldemechanismen funktionieren.
- Elterninformationen sind im Spiel zugänglich.

**Methoden:**
- Interne Audits gegen Compliance-Matrix.
- Externe Reviews durch Kindersicherheits-Expert:innen.

## Test-Pyramide

```
        /\
       /  \           Explorationstests mit echten Spieler:innen
      / E2E\          (kontinuierlich, mit Eltern-Einwilligung)
     /______\
    /        \        UX-Tests, Sicherheits-Tests, Lern-Tests
   / Integ.   \       (Phase 2-5, mit dedizierten Tester:innen)
  /____________\
 /              \     System-Integration-Tests
/  Unit-Tests    \    (Phase 2-5, automatisiert in CI)
/__________________\
```

## Test-Tools

| Tool | Zweck |
|---|---|
| Luau-Test-Framework | Unit-Tests |
| Roblox Studio Test-Suite | Studio-Tests |
| Eigene Telemetrie | Live-Tests |
| Performance-Profiler (Studio) | FPS, Speicher |
| Externe Pen-Test-Firma | Sicherheits-Audit |
| Usability-Testing-Plattform | UX-Tests mit Spieler:innen |

## Test-Schedule

| Phase | Tests |
|---|---|
| Phase 2 (Konzept) | Konzept-Reviews, Concept-Tests mit Stakeholdern |
| Phase 3 (Systemdesign) | Architektur-Reviews, Mock-Test-Sessions |
| Phase 4 (Prototype) | Funktionale Tests Vertical Slice, Performance-Baseline, erste UX-Tests |
| Phase 5 (Production) | Volle Test-Suite pro Feature, Lasttests, Sicherheits-Audit |
| Phase 6 (Launch) | Compliance-Review, Release-Readiness-Check |
| LiveOps | Kontinuierliche Tests bei jedem Drop |

## Bug-Management

### Bug-Kategorien

| Severity | Beschreibung | Reaktion |
|---|---|---|
| S0 | Crash, Datenverlust, Sicherheits-Vorfall | Sofort |
| S1 | Feature komplett kaputt, viele Spieler:innen betroffen | 24h |
| S2 | Feature beeinträchtigt, Workaround vorhanden | 1 Woche |
| S3 | Kleiner Bug, UX-Einschränkung | Nächster Sprint |
| S4 | Kosmetik, Minor Polish | Backlog |

### Bug-Lifecycle

1. Erkennung (Tester:in oder Spieler:in via Report).
2. Triage (Severity, Priorität, Owner).
3. Behebung.
4. Regressionstest.
5. Verifikation.
6. Schließen.

## Test-Dokumentation

- Testpläne pro Feature (Phase 3+).
- Test-Reports nach jeder Test-Session.
- Bug-Reports mit Reproduktions-Schritten.
- Test-Coverage-Bericht pro System.

## Junge Tester:innen — Schutz

- Einverständniserklärung der Eltern.
- Tests in kontrollierter Umgebung (geschlossener Test-Server).
- Beobachtung durch geschulte Erwachsene.
- Datenschutzkonforme Erfassung (kein Foto, kein Name).
- Klare Abbruch-Möglichkeit für Kinder.

## Risiken

- **Untertestung:** Komplexe Systeme können untergetestet sein. Mitigation: Test-Coverage-Ziele pro Modul.
- **Übertestung:** Endlose Testzyklen verzögern Launch. Mitigation: klare Akzeptanzkriterien.
- **Test-Müdigkeit:** Junge Tester:innen verlieren Interesse. Mitigation: kurze, spielerische Tests, Belohnungen.
- **Kulturelle Fehlinterpretationen:** Tester:innen aus einem Kulturkreis übersehen Probleme für andere. Mitigation: Tests in allen 9 Sprachen mit Muttersprachler:innen.

## Offene Fragen

- Welche externe Pen-Test-Firma? (Phase 6.)
- Welche Performance-Targets für Low-End-Mobile? (Phase 4.)
- Wie viele junge Tester:innen werden für Phase 4/5 benötigt? (Phase 4 planen.)

## Nächste Schritte

1. Test-Tools im Studio aufsetzen (Phase 3).
2. Erste Testpläne für Vertical Slice (Phase 4).
3. Performance-Benchmark-Suite (Phase 4).
4. Externe Sicherheits-Audit-Vorbereitung (Phase 6).

## Änderungsverlauf

| Datum | Version | Änderung | Autor |
|---|---|---|---|
| 2026-06-27 | 0.1 | Initialer QA-Plan | Mavis (Agent) |
| 2026-06-27 14:25 | 0.2 | Refit: Curio World + 5-District-Plan + Gold/Gems/Robux (kein Stamina) + VIP-Komfort-Pass | Mavis (Agent) |
| 2026-06-27 14:50 | 0.3 | Refit: Wonder World → Curio World (Naming-Kollision mit existierendem Roblox-Pet-Game aufgedeckt) | Mavis (Agent) |
| 2026-06-27 | 0.1 | Initialer QA-Plan | Mavis (Agent) |