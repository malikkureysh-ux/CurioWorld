# Curio World — Hamburg Harbor Phase 4 Playtest Plan

**Datum:** 2026-06-27
**Phase:** 4 (Concept-Tests + Beta)
**Vertical Slice:** Hamburg Harbor
**Stichprobe:** 90 Spieler:innen (30 pro Altersband: 9-11, 12-13, 14-16) + 30 Eltern + 15 Lehrkräfte

## Test-Phasen

### UT-1: Konzept-Tests (vor Phase 4 Code-Freeze)

**Zweck:** Validiere Hamburg-Harbor-Konzept, Art-Style, Quest-Design BEVOR Code komplett ist.

| # | Test | Stichprobe | Methode | Dauer |
|---|---|---|---|---|
| 1 | Art-Style-Approval | 30 Spieler:innen, je 10/Altersband | Side-by-side: 3 Art-Style-Varianten zeigen, beliebteste wählen | 15 min |
| 2 | Kran-Mechanik-Paper-Test | 15 Spieler:innen | Physisches Spielzeug-Setup; ohne Bildschirm | 20 min |
| 3 | Quest-Name-Komprehension | 30 Spieler:innen | „Was glaubst du, musst du bei 'Lift the Cargo' tun?" | 10 min |
| 4 | District-Sense-of-Place | 30 Spieler:innen | Free-Response: „Was gefällt dir am Hafen?" | 10 min |

**Erfolgskriterien:**
- ≥ 80 % der Spieler:innen erkennen Kran-Mechanik visuell
- ≥ 75 % verstehen Quest-Namen ohne Erklärung
- ≥ 70 % finden den Art-Style „freundlich und einladend"

### UT-2: Prototyp-Tests (Phase 4 Live)

**Zweck:** Validiere die echte Hamburg-Harbor-Spielbarkeit in Roblox Studio.

| # | Test | Stichprobe | Methode | Dauer |
|---|---|---|---|---|
| 5 | Onboarding-Test (HH_01) | 30 Spieler:innen | Beobachtete Spielsessions, Think-Aloud | 30 min |
| 6 | Kran-Use-Test (HH_02) | 30 Spieler:innen | Spieler:innen müssen Container mit Kran heben | 15 min |
| 7 | Werft-Teamwork-Test (HH_03) | 12 Teams à 3 Spieler:innen | Team-Quest beobachten | 45 min |
| 8 | Adaptive-Engine-Validierung | 30 Spieler:innen | Aufzeichnung: passt sich Schwierigkeit richtig an? | 30 min |
| 9 | Eltern-Befragung Lernwert | 30 Eltern | Fragebogen: „Siehst du Lernfortschritt?" | 20 min |

**Beobachtungs-Checkliste (für Beobachter):**
- [ ] Spieler:innen verstehen, WAS sie tun sollen
- [ ] Spieler:innen merken NICHT, dass sie lernen
- [ ] Frust-Momente (Schwierigkeit zu hoch oder zu niedrig)
- [ ] Aha-Momente (plötzliches Verstehen)
- [ ] Langeweile-Momente (zu einfach)
- [ ] Sensory-Overload (für neurodivergenz-Screening)
- [ ] Chat-Nutzung altersgerecht

**Erfolgskriterien:**
- ≥ 85 % der 9-11-Jährigen schaffen HH_01 ohne Hilfe
- ≥ 80 % der 12-13-Jährigen schaffen HH_02
- ≥ 75 % der Teams schaffen HH_03
- ≥ 90 % der Eltern sehen „Lernwert" (offene Frage)

### UT-3: Compliance-Tests (Phase 4 Final)

| # | Test | Methode | Erfolgskriterium |
|---|---|---|---|
| 10 | Robux-Kauf-Transparenz | 10 Spieler:innen lassen Eltern kaufen | Eltern verstehen, was gekauft wird |
| 11 | VIP-Pass-Erklärung | 15 Eltern bekommen VIP-Pass erklärt | 100 % verstehen „rein kosmetisch" |
| 12 | Anti-Frust-Test | 30 Spieler:innen spielen 1 Stunde frei | Keine „Warte-Timer"-Beschwerden |
| 13 | Chat-Sicherheit (9-11) | 20 Spieler:innen 9-11 | Können NICHT in Freitext-Chat schreiben |

### UT-4: Performance-Tests

| # | Test | Methode | Budget |
|---|---|---|---|
| 14 | Mobile Low-End FPS | 5 Spieler:innen auf Low-End-Android | ≥ 30 FPS, ≤ 200 MB RAM |
| 15 | Server-Stabilität (50 Spieler) | Load-Test in Studio | ≥ 50 Spieler ohne Server-Crash |
| 16 | Save-Latenz | Auto-Save alle 60s messen | ≤ 200ms pro Save |

## Test-Persona-Auswahl

**Drei Altersbänder, drei Geräte-Typen:**

| Persona | Alter | Gerät | Online-Zeit |
|---|---|---|---|
| **Junge Entdeckerin (9-11)** | 9-11 | Tablet (iPad/Android) | 1-2 h/Tag |
| **Aktive Teen (12-13)** | 12-13 | Smartphone | 2-3 h/Tag |
| **Erfahrener Gamer (14-16)** | 14-16 | PC/Laptop | 3+ h/Tag |

Plus:
- 30 Eltern (gemischte Altersbänder, sowohl Online-affine als auch zurückhaltende)
- 15 Lehrkräfte (Mathematik, Physik, Sachkunde)

## Test-Durchführung

**Schritt 1:** Rekrutierung über Discord-Server (Roblox-Education-Community), Facebook-Gruppen (Eltern von Gamer-Kindern), und Schul-Kooperationen.

**Schritt 2:** Informed Consent (Eltern unterschreiben DSGVO-Consent für Datenverarbeitung + Recording).

**Schritt 3:** Test-Session (1-1,5 Stunden pro Spieler, mit 10 min Pause).

**Schritt 4:** Auswertung (Cluster Beobachtungen, 3 Verbesserungen mit Hypothese).

## Erwartete Erkenntnisse → Aktionen

| Erkenntnis-Muster | Wahrscheinliche Aktion |
|---|---|
| Spieler:innen merken NICHT, dass sie lernen | ✅ Bestätigt Anti-Schulgefühl-Design |
| Spieler:innen fühlen sich gestresst bei HH_02 | Adaptive Engine macht HH_02 leichter (HelpDepth = "subtle") |
| Spieler:innen langweilen sich bei HH_01 | Adaptive Engine macht HH_01 schwerer (Difficulty +0.2) |
| Eltern sagen „nur Spiel" | Educator-Modus muss prominenter in Marketing |
| Kran-Steuerung unklar | Tutorial-Video vor Quest, bessere visuelle Marker |
| Werft-Quest dauert zu lang | Material-Count von 4 auf 3 senken |

## Datenschutz & Compliance

- Aufzeichnungen nur mit Eltern-Consent
- Anonymisierung in allen Berichten
- DSGVO-konforme Speicherung (verschlüsselt, EU-Server)
- Spieler:innen-Pseudonyme (Curio_Test_001, etc.)
- Löschung nach 90 Tagen

## Erwartete Auswertung → Sprint-Plan

Nach Phase 4 (3 Wochen Test + 1 Woche Auswertung):

**Drei priorisierte Verbesserungen** mit Hypothese:
1. **HH_01 Tutorial verstärken** (Hypothese: Reduziert Drop-off um 30 %)
2. **Adaptive Engine Tuning für 9-11** (Hypothese: Verbessert Completion-Rate um 25 %)
3. **VIP-Pass-Marketing-Material** (Hypothese: Eltern-Akzeptanz steigt um 20 %)

Jede Verbesserung mit Owner + Sprint + Test-Design.

## Nächste Schritte

1. **Phase 4 Sponsor finden** (für Spielstunden-Budget)
2. **Test-Setup aufsetzen** (Discord-Server, Aufnahme-Tool, Fragebogen)
3. **Rekrutierung starten** (Phase 4 Woche 1)
4. **Tests durchführen** (Phase 4 Woche 2-3)
5. **Auswertung + Sprint-Plan** (Phase 4 Woche 4)
