# AGENTS.md — WISSENSWELTEN

> **Lies diese Datei ZUERST, bevor du irgendeine Aufgabe an diesem Projekt beginnst.**
> Sie ist nicht optional. Sie ist die Arbeitsweise.

---

## TL;DR (für eilige Agents)

**Was wir bauen:** Lern-Adventure auf Roblox für Kinder 9–16. Siehe `Wissenswelten-Konzept.md`.
**Wie wir arbeiten:** Zwei verschachtelte Loops (Working-Approach + Produkt) mit parallelen Heartbeats, harten Verifiern und Maker/Checker-Trennung.
**Niemals:** etwas „fertig" nennen, ohne dass ein Verifier es abgesegnet hat. Niemals ein Schulgefühl in Spiel-Content. Niemals Lern-Vorteile verkaufen.

---

## QUICK-START (deine ersten 5 Schritte)

```
1. Lies dieses AGENTS.md komplett.                              ← Du bist hier.
2. Lies Wissenswelten-Konzept.md (die Vision, was wir bauen).
3. Check /state/ (siehe §2.5) — was ist der aktuelle Stand?
4. Check /state/bug-triage.md + /state/content-backlog.md — was liegt an?
5. Mach /state/daily-plan.md — was sind DEINE 3 wichtigsten Dinge heute?
```

**Dann:** Eine Aufgabe auswählen → 4-Box-Test (§0.6) → Skill-Files checken (§2.2) → Sub-Agent-Rolle wählen (§7) → Loop-Spec nutzen (§4.5) → loslegen.

**Niemals ohne:** Verifier passieren (§2.6) + State updaten (§2.5) + Sub-Agent-Check (§2.3).

---

## 0. Das Projekt in einem Satz

**Curio World** ist ein Jump-&-Run-Adventure auf Roblox für Kinder 9–16, das Mathe, Physik, Chemie, Sprachen, Informatik, Logik und Planungs-Skills so vermittelt, dass es sich **nie nach Schule anfühlt**. Volle Spec: siehe `docs/00_product_vision.md` + `docs/05_game_design_document.md`.

**Qualitätsanspruch: Production-Ready · Premium · State of the Art.** Wir bauen kein "funktionierendes Spiel" — wir bauen ein Premium-Produkt, das mit kommerziellen Top-Titeln mithalten kann. Funktioniert allein reicht nicht; alles muss mit AAA-Polish-Niveau umgesetzt sein. Volle Definition in §11.

---

## 0.5 Leitplanken — Drei Sätze, die jede Entscheidung rahmen

> *"You should be designing loops that prompt your agents."*
> — **Peter Steinberger**, Engineer

> *"Loops do not crash — they bill you in silence."*
> — **Geoffrey Huntley**, über den "Ralph Wiggum Loop"

> *"A prompt hands the AI an instruction. A loop hands the AI a job, a way to know when the job is done, and a rule for when to give up."*
> — **Anatoli Kopadze**, "Loops explained" (Juni 2026)

Diese drei Sätze sind die Nordung. Wenn eine Entscheidung gegen sie geht, ist sie wahrscheinlich falsch.

---

## 0.6 Erst prüfen, ob überhaupt ein Loop nötig ist (4-Box-Test)

Bevor du einen Loop startest, beantworte **alle vier Fragen mit Ja**. Wenn auch nur eine Nein ist → bleib bei einem guten Prompt. Schlechte Loops kosten mehr als sie bringen.

```
☐ 1. TASK REPEATS
    Die Aufgabe wiederholt sich mindestens wöchentlich.
    Einmaliges bleibt besser ein Prompt.

☐ 2. AUTO-REJECT POSSIBLE
    Etwas kann schlechtes Output automatisch ablehnen.
    (Test, Lint, Build, Type-Check, harte Regel, Pädagogen-Rubrik)
    Ohne Gate dreht der Loop nur Däumchen.

☐ 3. AGENT CAN DO IT END-TO-END
    Der Agent kann die Aufgabe komplett selbst erledigen.
    Nicht "halb mir, halb dir".

☐ 4. "DONE" IS OBJECTIVE
    Fertig ist messbar, nicht Geschmackssache.
    Wenn Qualität eine Menschen-Frage ist, gewinnt der Mensch.
```

**Default für Wissenswelten:** Bei wöchentlichen Routine-Tasks (Daily Plan, Weekly Retro, Weekly Analytics, Bug-Triage, Content-Quality-Check) → Loop. Bei einmaligen Konzepten, neuen Stadt-Designs, World-Building-Entscheidungen → Prompt + Mensch.

---

## 0.7 OUT-OF-SCOPE — Was NICHT in einen Loop gehört

Diese Dinge sehen verlockend aus, gehören aber explizit **nicht** in einen automatischen Loop. Sie brauchen Mensch, Strategie oder Politik.

| Thema | Warum raus |
|---|---|
| **Neue Stadt hinzufügen** | World-Building-Entscheidung. Braucht Creative-Direction + Pädagogik-Lead. Loop verfehlt die Vision. |
| **Lern-Framework ändern** (z.B. „vielleicht doch Vokabel-Tests") | Architektur-Entscheidung. Ein einziger schlechter Move verfehlt Skill S1 für immer. |
| **Monetarisierungs-Modell ändern** | Strategie + Ethik. Ethics-Guardian + Mensch entscheiden. |
| **Sicherheits-Policy ändern** | Compliance, Legal, Roblox-ToS. Niemand außer Strategy. |
| **Scope erweitern** (neue Zielgruppe, neue Altersstufe, neues Genre) | Produkt-Pivot. Monthly Strategy + Mensch. |
| **Team-/Rollen-Änderung** | Org-Design. Strategie-Lead. |
| **Plattform-Wechsel** (Roblox raus, was anderes rein) | Massive Auswirkung. Mensch-only. |
| **Brand-/Marketing-Aussagen** | Tone-of-Voice. Marketing-Lead + User. |
| **Daten an Dritte weitergeben** | Compliance. Ethics + Legal. |

**Default-Regel:** Wenn du unsicher bist, ob etwas in den Loop gehört → **Prompt + Mensch**. Lieber einmal zu viel fragen als einmal zu viel automatisieren.

---

## 1. Das Arbeitsprinzip: INCLUSIVE HEARTBEAT LOOPS

Wir arbeiten nicht „Aufgabe rein, Ergebnis raus". Wir arbeiten in **zwei verschachtelten Loops**, die parallel laufen und sich gegenseitig verbessern.

### Loop-Architektur

```
┌─────────────────────────────────────────────────────────────┐
│  LOOP A — WORKING APPROACH                                  │
│  „Wie werden WIR jeden Tag besser?"                         │
│  → Prozess, Tools, Kommunikation, Qualität der Arbeit       │
│                                                             │
│  ┌───────────────────────────────────────────────────────┐  │
│  │  LOOP B — PRODUKT                                     │  │
│  │  „Wie wird DAS SPIEL jeden Tag besser?"               │  │
│  │  → Lern-Mechanik, UX, Performance, Community         │  │
│  │                                                       │  │
│  │  Beide Loops haben einen Heartbeat, einen Verifier    │  │
│  │  und eine Stop-Bedingung. Loop A verbessert Loop B,  │  │
│  │  Loop B gibt Loop A Feedback.                         │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

**„Inclusive heartbeat"** heißt: **Mehrere automatische Trigger laufen parallel.** Nicht ein einzelner Cron, sondern ein Ökosystem aus Heartbeats auf unterschiedlichen Zeitskalen — und auf unterschiedlichen Ebenen (Prozess UND Produkt).

---

## 2. Die 5 Loop-Bausteine (verpflichtend für jede Aufgabe)

Jede substantielle Arbeit an diesem Projekt MUSS diese fünf Bausteine explizit machen. Wenn auch nur einer fehlt, ist die Arbeit unvollständig.

### 2.1 HEARTBEAT — Wann passiert es automatisch?

| Heartbeat | Frequenz | Loop | Owner-Rolle | Trigger | State-Pfad |
|---|---|---|---|---|---|
| **Daily Plan** | jeden Morgen 09:00 | A | Self-Plan | Cron: Agent beginnt den Tag mit Status-Check | `state/daily-plan.md` |
| **Daily Retro** | jeden Abend 18:00 | A | Self-Plan | Cron: Was lief, was nicht, was morgen | `state/daily-retro.md` |
| **Weekly Playtest** | jeden Freitag 16:00 | B | Community-Sentinel | Cron: echte Spieler testen aktuellen Build | `state/playtest-insights.md` |
| **Weekly Analytics Review** | jeden Sonntag 20:00 | B | Community-Sentinel | Cron: Engagement-, Lern-, Retention-Daten | `state/learning-outcomes.md` |
| **Bug-Heartbeat** | on-trigger | B | Triage-Agent | Spieler meldet Bug → sofortiger Investigate-Loop | `state/bug-triage.md` |
| **Content-Quality-Gate** | on-publish | B | Content-Writer | Jede neue Quest/Stadt geht durch Gate | `state/content-backlog.md` |
| **Monthly Strategy** | am 1. des Monats | A+B | Strategy-Lead | Großer Reset: Was funktioniert, was werfen wir raus | `state/decision-log.md` |
| **Sprint Boundary** | alle 3 Wochen | A | Strategy-Lead | Storyline-Sprint-Ende, Lessons Learned | `state/weekly-retro.md` |
| **Skill-Update-Loop** | monthly 1. | A | Strategy-Lead | Skill-Files gegen Erkenntnisse prüfen | `skills/`-Commits |
| **Decision-Log** | on-decision | A+B | Strategy-Lead | Substantielle Entscheidung trifft zu | `process/decisions/ADR-NNN.md` |

**Templates für alle State-Pfade:** siehe `state/*.template.md`. Beim ersten Befüllen kopieren, ab dann nicht mehr überschreiben (append-only wo möglich).

### 2.2 SKILL — Was sind die wiederverwendbaren Regeln?

Diese Regeln werden **jedes Mal** gelesen, **bevor** eine Arbeit anfängt. Sie sind die Substanz des Skill-Files.

> **Skill-Files einzeln:** siehe `skills/S1-lernprinzip.md`, `skills/S2-anime-aesthetik.md`, `skills/S3-neurodivergenz.md`, `skills/S4-luau-code.md`, `skills/S5-blender.md`, `skills/S6-ethik-moneta.md`. Diese sind die kanonische Quelle — Inline-Snippets hier sind nur Kurzform.

#### Skill S1 — Lernprinzip: Kein Schulgefühl (Kurzform, voll: skills/S1-lernprinzip.md)
```
WENN du Inhalt erstellst, DANN prüfe:
  ☑ Wird ein Spieler merken, dass er lernt?  → Falls ja, redesign.
  ☑ Ist die Wissens-Anwendung ein Werkzeug, nicht ein Test?  → Falls nein, redesign.
  ☑ Gibt es ein „Aha"-Erlebnis statt einem „Richtig/Falsch"-Moment?  → Falls nein, redesign.
```

#### Skill S2 — Anime-Ästhetik
```
WENN du Assets, Charaktere oder Welten baust, DANN:
  ☑ Chibi-Proportionen (großer Kopf, kleiner Körper)?
  ☑ Große Augen, kleine Nasen, rundliche Formen?
  ☑ Pastell-Palette mit kräftigen Akzenten?
  ☑ Cel-Shading mit weichen Outlines?
  ☑ Diversität (Ethnie, Körpertyp, Behinderung) sichtbar?
```

#### Skill S3 — Neurodivergenz-Standard
```
WENN du irgendetwas baust, DANN:
  ☑ Sensorik-Optionen (Helligkeit, Sound, Animationen) an/aus?
  ☑ Pacing-Kontrolle (Pause-Himmel, kein Time-Pressure)?
  ☑ Klare Quest-Texte, keine Mehrdeutigkeit?
  ☑ Optionale Hinweise (3 Stufen)?
  ☑ Keine Strafe für Verirren, Verlieren, Ausprobieren?
```

#### Skill S4 — Code-Standard Luau (Roblox)
```
  ☑ Module-Pattern: klare Trennung Combat / Lern / UI / Daten
  ☑ Server-Authoritative für Lern-Antworten (Anti-Cheat)
  ☑ ProfileService für Datenpersistenz
  ☑ MemoryStore für Live-Daten (Crews, Leaderboards)
  ☑ Performance: 60 FPS Ziel auf Mobile, Streaming-Enabled
```

#### Skill S5 — Blender-Standard
```
  ☑ Low-Poly-Charaktere (≤5000 Triangles)
  ☑ Saubere Topologie, sauberes UV
  ☑ LOD-Modelle (3 Stufen)
  ☑ Rigging humanoid (Hinge-Rigify oder Mixamo-Import)
  ☑ Outfits als separates Mesh (skinnable)
  ☑ FBX-Export mit korrekten Settings (Forward: -Z, Up: Y)
```

#### Skill S6 — Ethische Monetarisierung
```
WENN du überlegst, etwas kaufbar zu machen, DANN:
  ☑ Ist es NICHT pay-to-win?  → Falls nein: nicht kaufbar.
  ☑ Ist es NICHT Lern-relevant?  → Falls Lern-vorteil: gratis.
  ☑ Hat es KEIN FOMO?  → Falls ja, redesign.
  ☑ Ist die Kosten-Transparenz 100%?  → Falls nein, ergänzen.
```

### 2.3 SUB-AGENTS — Maker/Checker-Trennung (Pflicht!)

**Der Macher darf nie der Prüfer sein.** Das ist die wichtigste Anti-Failure-Regel.

| Agent-Paar | Wer macht | Wer prüft |
|---|---|---|
| Lern-Quest | Content-Writer | Pedagogical-Validator (anderer Agent/Person) |
| Code-Feature | Builder | Code-Reviewer |
| 3D-Asset | Modeler | Style-Guardian (Anime-Treue) |
| Stadt-Quest-Design | Designer | Player-Advocate („würde ich das spielen wollen?") |
| Monetarisierung | Product-Owner | Ethics-Guardian |
| Balance-Änderung | Designer | Community-Sentinel (Spieler-Daten) |

**Konsequenz:** Wenn du als Agent etwas baust, dann **musst du danach explizit einen anderen Pass darüber laufen lassen**, bevor du „fertig" sagst.

### 2.4 CONNECTORS — Wirken, nicht nur Vorschlagen

Ein Loop ist erst dann real, wenn seine Outputs **in der echten Welt** ankommen.

| Connector | Was es tut |
|---|---|
| **Roblox Studio CLI** | Deployt Builds, nicht nur lokal testen |
| **Blender-Pipeline** | Exportiert nach FBX, nicht nur modellieren |
| **DataStore-Sync** | Persistiert Spieler-Profile in Roblox-Cloud |
| **Playtest-Connector** | Lädt echte Spieler ein, sammelt Feedback |
| **Analytics-Connector** | Schickt Engagement-Daten ins Heartbeat-Dashboard |
| **Parent-Dashboard-Connector** | Liefert Eltern wöchentliche Lern-Reports |
| **Crash-Reporter** | Pusht Bugs sofort in den Bug-Heartbeat |

**Regel:** Kein „das wäre cool wenn" — nur „das ist live und läuft".

### 2.5 STATE — Was merkt sich der Loop zwischen den Runden?

> *"State is what makes the loop learn. Each pass, the AI has to remember what it already tried, or it repeats the same mistake forever."*
> — Anatoli Kopadze

Ohne State fängt der Loop jeden Morgen bei Null an und produziert denselben Mist auf Neue. **Jeder Loop führt deshalb eine schmale, versionierte State-Datei.**

#### State-Format für Wissenswelten

> **Templates:** siehe `state/*.template.md` (8 Stück). Beim ersten Anlegen kopieren, dann mit echtem Inhalt befüllen.

```
/state/
  daily-plan.md              # Heute-Ziele, geblockt von gestern
  daily-retro.md             # Was lief, was nicht, eine Lesson
  weekly-retro.md            # Velocity, Hindernisse, eine Aktion
  content-backlog.md         # Quests, Städte, Items — Status
  bug-triage.md              # Offene Bugs, wer macht was, wann close
  decision-log.md            # Architektur- & Design-Entscheidungen (ADR)
  playtest-insights.md       # Beobachtungen aus Kinder-Playtests
  learning-outcomes.md       # Welche Lern-Hypothesen haben gegriffen
```

#### Pflicht-Regeln für State
- **Schmal halten** — nur was die nächste Iteration braucht, nicht das ganze Wiki
- **Versioniert** (Git) — jeder Stand wiederherstellbar
- **Append-only wo möglich** — nie überschreiben, immer ergänzen + Datum
- **Eine Quelle der Wahrheit** pro Loop — nicht 3 Dokumente parallel
- **Vor jedem Heartbeat lesen, nach jedem Heartbeat schreiben** — sonst vergisst der Loop

#### Wo der State teuer wird (Cost-Warnung)
State wächst jeden Pass. Bei einem Loop, der alle 6 Stunden läuft, ist State nach einer Woche schnell 50 KB groß. Faustregel: **> 30 KB State = Loop redesignen, State zusammenfassen.**

---

### 2.6 VERIFIER — Was zählt als „fertig"?

Ohne Gate ist der Loop nur ein Agent, der sich selbst zustimmt. **Jede Arbeit** braucht eine messbare Pass-Bedingung.

#### Verifier V1 — „Lernt sich wie Spiel"-Test
```
PASS-BEDINGUNGEN (alle müssen erfüllt sein):
  ✓ Ein 10-Jähriger würde 15 Min spielen, ohne zu fragen „ist das Schule?"
  ✓ Eine Lehrkraft würde zustimmen: „da steckt echtes Lernen drin"
  ✓ Ein Kind mit ADHS würde nicht abschalten (Sensorik im Rahmen)
  ✓ Es gibt mindestens 3 alternative Lösungswege
```

#### Verifier V2 — Performance-Test
```
  ✓ 60 FPS auf Standard-Smartphone (Roblox-Spec-Device)
  ✓ < 100 MB Download pro Stadt
  ✓ Streaming lädt Assets on-demand
  ✓ Keine Memory-Leaks in 30-Min-Session
```

#### Verifier V3 — Lern-Outcome-Test
```
  ✓ Spieler kann 1 Tag später 1 Fakt aus dem Quest korrekt recallen
  ✓ Spieler kann das Konzept auf eine NEUE Situation anwenden
  ✓ Spieler erinnert sich an den Weg (Process), nicht nur das Ergebnis
```

#### Verifier V4 — Community-Safety-Gate
```
  ✓ Wortfilter aktiv und aktuell
  ✓ Anti-Mobbing-System getestet
  ✓ DSGVO/COPPA-konform für <13
  ✓ Eltern-Dashboard funktional
  ✓ Cringe-Content von Mitspielern wird gemeldet & eskaliert
```

#### Verifier V5 — Working-Approach-Gate (Loop A)
```
  ✓ Velocity über 4 Wochen stabil oder steigend
  ✓ Defect-Rate < 5%
  ✓ Stakeholder-Zufriedenheit > 7/10
  ✓ Retro-Aktionen werden tatsächlich umgesetzt (Close-Loop-Rate > 70%)
```

---

## 3. Die ZWEI LOOPS im Detail

### LOOP A — Working Approach

**Ziel:** Wir werden jeden Tag besser darin, das Projekt zu bauen.

**Heartbeats:** siehe zentrale Tabelle in §2.1 (Loop-A-relevant: Daily Plan, Daily Retro, Weekly Retro, Monthly Strategy, Sprint Boundary, Skill-Update-Loop).

**Discover → Plan → Execute → Verify → Iterate** auf Meta-Ebene:
1. **Discover:** Welche Reibung haben wir diese Woche gespürt?
2. **Plan:** Welche 1-2 Änderungen versuchen wir?
3. **Execute:** In den nächsten Sprint einbauen
4. **Verify:** Haben die Änderungen geholfen? (Daten oder Eindruck)
5. **Iterate:** Beibehalten, anpassen oder verwerfen

**Anti-Patterns in Loop A:**
- ❌ Retro-Aktionen aufschreiben und nie umsetzen
- ❌ Tools einführen ohne sie zu pilotieren
- ❌ „Wir haben schon immer so gearbeitet" als Argument
- ❌ Weekly ohne konkrete Owner für jede Aktion

### LOOP B — Produkt (Das Spiel)

**Ziel:** Das Spiel wird jeden Tag besser für die Kinder.

**Heartbeats:** siehe zentrale Tabelle in §2.1 (Loop-B-relevant: Bug-Heartbeat, Content-Quality-Gate, Weekly Playtest, Weekly Analytics Review).

**Discover → Plan → Execute → Verify → Iterate** auf Produkt-Ebene:
1. **Discover:** Wo haken Spieler? Welche Mechanik fühlt sich nach Schule an? Welche Stadt spielen sie nicht?
2. **Plan:** 1-2 konkrete Verbesserungen (gerne klein, gerne schnell testbar)
3. **Execute:** Im aktuellen Sprint umsetzen
4. **Verify:** A/B-Test oder Cohort-Vergleich, plus qualitative Playtest-Beobachtung
5. **Iterate:** Ausrollen, anpassen oder reverten

**Anti-Patterns in Loop B:**
- ❌ Features ohne Playtest launchen
- ❌ „Schönere Mechanik" statt „funktioniert sie für die Zielgruppe?"
- ❌ Lern-Content ohne Pädagogen-Check veröffentlichen
- ❌ Bugfixes ohne Re-Verify
- ❌ Iteration ohne klare Hypothese („vielleicht gefällt es dann besser")

### Wie Loop A und Loop B sich gegenseitig füttern

- **Loop B entdeckt Reibung** → Loop A fragt: „Warum? Ist es Tooling, Kommunikation, Skill-Lücke?"
- **Loop A entdeckt Workflow-Blocker** → Loop B fragt: „Brauchen wir andere Daten, andere Reports?"
- **Monthly Strategy reviewt BEIDE** zusammen — kein Silo-Denken.

---

## 4. STOP-BEDINGUNGEN — Wann hören wir auf zu iterieren?

Ein Loop ohne Exit frisst Geld und Zeit. **Jede Iteration hat ein Ende.**

### Iterations-Caps
- **Daily Retro:** 30 Min. Wenn nicht gelöst → eskaliere in Weekly Retro.
- **Weekly Playtest:** 5 Kinder, 30 Min. Mehr Sample-Größe = Monthly Strategy.
- **Bug-Heartbeat:** max. 8 Iterationen. Wenn nicht gelöst → eskalieren, nicht weiter versuchen.
- **Content-Iteration:** max. 3 Pässe durch V1/V3/V4. Danach Major-Redesign.
- **Loop A Retromüdigkeit:** Wenn Weekly Retro zur Pflichtübung wird → Format ändern.

### Akzeptanz-Schwelle
- **Cost per accepted change** muss > 50% sein. Wenn < 50% der Iterationen was bringen → Loop redesignen, nicht weiterlaufen lassen.

### „Ralph-Wiggum-Loop" vermeiden
Der Loop entscheidet nicht selbst, dass er fertig ist. **Immer** muss ein externes Gate (Verifier V1-V5, oder ein anderer Agent) das OK geben. Sonst läuft der Loop in Endlosschleife und produziert Bullshit.

### Cost-Disziplin (Anatolis wichtigste Warnung)
> *"Below a 50% accept rate, it costs more than it gives back."*

**Cost per accepted change** ist die einzige Metrik, die zählt. Nicht Tokens, nicht Iterationen.

| Loop-Typ | Erwartete Accept Rate | Wenn drunter → |
|---|---|---|
| Bug-Heartbeat | > 60% | Bug-Klasse analysieren, Loop pausieren |
| Content-Quality | > 50% | Skill-File updaten, Rubrik schärfen |
| Daily Retro | > 70% | Format ändern, kürzer, konkreter |
| Weekly Playtest | > 40% (Insight-Rate) | Methodik reviewen, Fragen anpassen |
| Analytics Review | > 50% (Actionable Insight) | Datenquellen prüfen |

**Cheap-Model-Strategie:** Routine-Pässe (Erst-Sortierung, Status-Check, Datensammlung) → kleines Modell. Tiefe Analyse, Pädagogik-Check, Style-Audit → großes Modell. So bleibt Cost per Iteration niedrig.

---

## 4.5 KONKRETE LOOP-BEISPIELE FÜR WISSENSWELTEN

Jedes Beispiel steht als **Loop-Spec** im Anatoli-Format da. Sie sind die Vorlagen, an denen sich neue Loops orientieren.

### Loop-Beispiel 1: Bug-Heartbeat (Loop B)

```
▸ LOOP SPEC
GOAL: Jeder gemeldete Bug ist innerhalb von 24h triagiert, priorisiert
      und entweder gefixt oder explizit eskaliert.

HEARTBEAT:  on-trigger (jeder neue Bug-Report im Tracker)

EACH ITERATION:
  1. PLAN   - Lese den Bug-Report + Repro-Schritte + Severity-Hinweise
  2. DO     - Reproduziere, klassifiziere (Severity 1-5), weise Owner zu
  3. VERIFY - "Ist die Klassifikation konsistent mit Skill S4 + V4?"
              "Gibt es einen klaren Fix-Path oder muss eskaliert werden?"
  4. DECIDE - Wenn reproduzierbar + klarer Fix → Bug in /state/bug-triage.md
              Wenn unklar → mehr Info vom Reporter holen
              Wenn Sicherheits-Vorfall → sofort Ethics-Guardian

STATE: /state/bug-triage.md (append-only, pro Bug ein Block)

STOP WHEN: Bug triagiert + Owner zugewiesen, ODER 8 Iterationen ohne
           Konsens → eskaliere an Strategy-Lead

SUB-AGENTS:
  - Maker: Triage-Agent (sortiert, klassifiziert, schlägt Fix vor)
  - Checker: Code-Reviewer (prüft Fix-Vorschlag gegen Architektur)

VERIFIER: V4 (Community-Safety), Skill S4 (Luau-Standard)
COST: erwartet ~150k Tokens/Bug, Accept-Rate-Ziel > 60%
```

### Loop-Beispiel 2: Lern-Quest Quality Gate (Loop B)

```
▸ LOOP SPEC
GOAL: Jede neue Lern-Quest fühlt sich wie Spiel an, nicht wie Schule,
      UND trainiert messbar ein Lern-Outcome.

HEARTBEAT:  on-publish (jede neue Quest geht live erst nach diesem Loop)

EACH ITERATION:
  1. PLAN   - Lies Quest-Skript + Story-Kontext + Ziel-Altersstufe
  2. DO     - Spiele die Quest selbst durch (mental simuliert + bei Bedarf Code-Run)
  3. VERIFY - V1 (Lernt-sich-wie-Spiel): ist die Lern-Anwendung versteckt?
              V3 (Lern-Outcome-Test): was genau nimmt der Spieler mit?
              Skill S1 (kein Schulgefühl): welche verbotenen Wörter?
              Skill S3 (Neurodivergenz): pacing, sensorik, klare texte?
  4. DECIDE - Wenn alle Gates passen → APPROVED + Sign-off-Datum
              Sonst: konkrete Änderungsliste, max 3 Pässe, dann Redesign

STATE: /state/content-backlog.md (Status: draft/in-review/approved/live)

STOP WHEN: APPROVED erreicht, ODER 3 Iterationen ohne Pass → Major Redesign

SUB-AGENTS:
  - Maker: Content-Writer
  - Checker 1: Pedagogical-Validator (Lern-Mechanik)
  - Checker 2: Player-Advocate (Spielgefühl)
  - Checker 3: Neurodivergenz-Auditor

COST: erwartet ~80k Tokens/Quest, Accept-Rate-Ziel > 50%
```

### Loop-Beispiel 3: Daily Retro (Loop A)

```
▸ LOOP SPEC
GOAL: Jeden Abend identifiziere ich die EINE Erkenntnis, die morgen
      anders macht, und schließe die Schleife.

HEARTBEAT:  daily 18:00 (Cron: mavis cron self)

EACH ITERATION:
  1. PLAN   - "Was war heute die größte Reibung? Was lief überraschend gut?"
  2. DO     - Schreibe /state/daily-retro.md (max 200 Wörter, eine Lesson)
  3. VERIFY - "Ist die Lesson ACTIONABLE? Kann ich morgen konkret was ändern?"
              "Ist sie ANGEWANDT auf einen Loop-A-Trigger?"
  4. DECIDE - Wenn actionable → Aktion für morgen in /state/daily-plan.md
              Sonst: verwerfen, nicht erzwingen

STATE: /state/daily-retro.md + /state/daily-plan.md

STOP WHEN: 1 Lesson identifiziert ODER ehrlich "nichts substanzielles heute"

SUB-AGENTS: keine — Solo-Loop, kein Maker/Checker nötig
            (außer alle 2 Wochen: Strategy-Lead reviewt die Lessons)

VERIFIER: V5 (Working-Approach-Gate) auf Wochen-Ebene
COST: ~5k Tokens/Tag, Accept-Rate-Ziel > 70%
```

### Loop-Beispiel 4: Weekly Playtest Insight Extraction (Loop B)

```
▸ LOOP SPEC
GOAL: Aus 5 Kinder-Playtests/Sprint extrahiere ich 3 umsetzbare
      Produkt-Verbesserungen mit klarer Hypothese.

HEARTBEAT:  weekly Friday 17:00 (nach Playtest-Slot)

EACH ITERATION:
  1. PLAN   - Lese Playtest-Notizen + Aufnahmen
  2. DO     - Clustere Beobachtungen (Frust-Momente, Aha-Momente, Langeweile)
  3. VERIFY - "Ist jede Verbesserung mit einer Beobachtung belegt?"
              "Ist die Hypothese testbar (A/B-Vergleich möglich)?"
              "Widerspricht sie Skill S1 (kein Schulgefühl)?"
  4. DECIDE - Top 3 in /state/content-backlog.md als nächste Sprints
              Verworfen-Begründungen dokumentieren (Anti-Bias)

STATE: /state/playtest-insights.md (wöchentlich, datiert)

STOP WHEN: 3 Insights extrahiert ODER Sample zu klein (< 3 valide Sessions)

SUB-AGENTS:
  - Maker: Community-Sentinel (liest Beobachtungen)
  - Checker: Player-Advocate (prüft Hypothesen-Qualität)

COST: ~30k Tokens/Woche, Insight-Rate-Ziel > 40%
```

### Loop-Beispiel 5: Skill-Update-Loop (Meta-Loop)

```
▸ LOOP SPEC
GOAL: Die Skill-Files in /skills/ spiegeln immer den aktuellen
      Stand der Erkenntnisse aus Loop A und Loop B.

HEARTBEAT:  monthly 1. (gekoppelt mit Monthly Strategy Review)

EACH ITERATION:
  1. PLAN   - Sammle alle "wir sollten XY anders machen"-Vorschläge
              aus /state/weekly-retro.md + /state/decisions/
  2. DO     - Entwirf Skill-Patch (max 5 Änderungen pro Zyklus)
  3. VERIFY - "Ist jede Änderung durch Daten/Erkenntnisse belegt?"
              "Widerspricht sie einer bestehenden Regel?"
              "Ist sie klein genug, um sie in 1 Sprint zu testen?"
  4. DECIDE - Wenn alle Checks passen → commit, alle Loops lesen neue Version

STATE: /skills/ (Git-versioniert, jeder Patch mit Begründung im Commit)

STOP WHEN: alle 5 Patches entschieden ODER 8 Iterationen ohne Konsens

SUB-AGENTS:
  - Maker: Strategy-Lead
  - Checker: Pedagogical-Validator + Code-Reviewer (paralleles Review)

COST: ~50k Tokens/Monat, Accept-Rate-Ziel > 70%
```

---

## 5. PROJEKT-SPEZIFISCHE REGELN (überschreiben generische Defaults)

| Bereich | Regel |
|---|---|
| **Story-Ton** | Warm, abenteuerlich, niemals belehrend. Spieler ist Held, nicht Schüler. |
| **NPC-Dialoge** | Max. 2 Sätze pro Sprechblase. Keine Erklär-Texte. |
| **Lern-Vokabular im Spiel** | VERBOTEN: „Lerne", „Test", „Quiz", „Aufgabe", „richtig", „falsch" als UI-Text. Erlaubt: „Finde", „Baue", „Mixe", „Erkunde", „Erinnere". |
| **Sanktionen** | Es gibt keine Strafe für Fehler, nur Hinweise („Lumi stupst an"). |
| **Tod im Spiel** | Maximal Rückkehr zum Checkpoint. Kein „Game Over". |
| **Energie-/Zeit-Limiter** | VERBOTEN (Pay-to-Wait-Door). |
| **Werbe-Tone** | Wirbt mit „Welt entdecken" und „Freunde finden", NICHT mit „wirst schlauer". |
| **Diversität** | Default. Nicht Feature, sondern Pflicht. |
| **Zahlungs-Modelle** | Eltern sehen vor Kindern, was es kostet. Keine Dark Patterns. |

---

## 6. STACK & TOOLS

### Entwicklung
- **Spiel-Engine:** Roblox Studio (Luau)
- **Asset-Produktion:** Blender (FBX → Roblox Importer)
- **Versionierung:** Git (Roblox Studio Git Plugin oder Rojo)
- **Dokumentation:** Markdown in diesem Repo
- **Lern-Content-Datenbank:** JSON/YAML, versioniert

### Loops-Werkzeuge (für die Agenten)
- **Cron / Heartbeat:** `mavis cron self` für periodische Self-Reminder
- **Memory:** `mavis memory append` für Loop-A-Erkenntnisse (Prozess)
- **Sub-Agent-Spawn:** `mavis communication send --command spawn` für Checker-Rolle
- **Memory-Layer:** Dieses `AGENTS.md` ist **Projekt-Memory** (siehe Pfad) — gilt nur für dieses Repo

### Daten-Layer (für Loop B)
- **Roblox DataStore:** Spieler-Profile, Fortschritt, Inventar
- **Roblox MemoryStore:** Live-Daten (Crews, Leaderboards, Sessions)
- **Analytics-Pipeline:** Roblox Analytics + Custom-Events (Lern-Outcomes)
- **Crash-Reports:** Roblox Auto-Reporting + Custom-Bug-Ingest

---

## 7. ROLLEN IM TEAM (für Sub-Agent-Routing)

| Rolle | Verantwortlich für | Spawn-Pattern |
|---|---|---|
| **Builder** | Code, Assets, Mechaniken umsetzen | Direkt |
| **Content-Writer** | Quests, NPC-Dialoge, Lore | Direkt |
| **Pedagogical-Validator** | Prüft Lern-Mechaniken gegen Skill S1, V1, V3 | Checker-Spawn |
| **Code-Reviewer** | Prüft Luau gegen Skill S4 | Checker-Spawn |
| **Style-Guardian** | Prüft Anime-Look gegen Skill S2 | Checker-Spawn |
| **Player-Advocate** | Spielt selbst, prüft „würde ich das spielen?" | Checker-Spawn |
| **Ethics-Guardian** | Prüft Monetarisierung, Safety, Inklusion | Checker-Spawn |
| **Community-Sentinel** | Liest Spieler-Feedback, Bug-Reports, Retention | Loop-B-Heartbeat |
| **Strategy-Lead** | Monthly Review, Roadmap | Loop-A-Heartbeat |

---

## 8. ERSTE SCHRITTE (Reihenfolge zählt!)

Folge dieser Reihenfolge. **Nicht überspringen.**

```
1. Lies dieses AGENTS.md komplett.                              ← Du bist hier.
2. Lies Wissenswelten-Konzept.md.                                ← Die Vision.
3. Mach EINE manuelle Iteration reliable (z.B. ein Mini-Quest).
4. Verifiziere mit V1 + V3 (Spielgefühl + Lern-Outcome).
5. Schreibe die Erkenntnisse ins Skill-File (hier updaten).
6. DANN: Automatisiere via Heartbeat.
7. DANN: Schedule via Cron.
```

Skipping = wie ein Loop, der läuft bevor er getestet ist. **Blows up while you sleep.**

---

## 9. ESCALATION — Wenn etwas schiefgeht

| Situation | Eskaliere an | Innerhalb von |
|---|---|---|
| Bug mit Datenverlust | Direkt an Strategie + Spieler-Pause | sofort |
| Sicherheits-Vorfall (Grooming, Daten-Leak) | Ethics-Guardian + Roblox Trust & Safety | sofort |
| Lern-Inhalt erzeugt Schulgefühl | Pedagogical-Validator + Redesign | < 24h |
| Performance unter 30 FPS | Builder + Style-Guardian | < 48h |
| Spieler-Beschwerden > 5% der DAU | Community-Sentinel → Strategy | < 1 Woche |
| Loop-A Retro-Aktion nicht umgesetzt | Strategy-Lead → Skill-Update | nächste Retro |

---

## 10. CLOSE-LOOP-DISZIPLIN

> **Die wichtigste Regel:** **Was nicht gemessen wird, wird nicht besser. Was nicht überprüft wird, wird nicht behoben. Was nicht dokumentiert wird, geht verloren.**

Jeder Heartbeat, jede Iteration, jede Verifier-Entscheidung wird in der passenden State-Datei dokumentiert:

```
state/                          # Loop-State (siehe §2.5 für Templates)
  daily-plan.md
  daily-retro.md
  weekly-retro.md
  content-backlog.md
  bug-triage.md
  decision-log.md
  playtest-insights.md
  learning-outcomes.md
process/
  decisions/                    # ADRs (siehe ADR-000-template.md)
    ADR-NNN-kurztitel.md
  retros/                       # Action-Items mit Owner & Datum
```

**Close-Loop-Rate** wird monatlich gemessen. Ziel: > 70%.

---

## 11. PREMIUM-QUALITÄTSSTANDARD

> **Nicht "funktioniert". Production-Ready · State of the Art · Premium.**

### 11.1 Was "Premium" konkret heißt

| Domäne | Minimal akzeptabel | **Premium-Standard** (verbindlich) |
|---|---|---|
| **Code-Qualität** | Läuft, keine Errors | Type-strict, getestet, dokumentiert, lint-pass, performance-optimiert, versioniert |
| **Performance** | 30 FPS auf Top-Device | **60 FPS konstant** auf Standard-Mid-Tier-Smartphone (Roblox-Spec) |
| **Ladezeit** | Spiel startet | **< 5 Sek bis erste spielbare Szene**, Streaming-Ready |
| **Lern-Mechanik** | Bringt Fakten bei | Pädagogisch fundiert, kinder-psychologisch validiert, A/B-testbar |
| **Ästhetik** | Sieht okay aus | AAA-Game-Studio-Polish, eigene Identität, kuratiert nicht "gut genug" |
| **Sound** | Hat Musik | Original-Komposition oder kuratierte Lizenz, **adaptive Musik**, Sound-Design auf Profi-Niveau |
| **UI** | Lesbar | HCI-Standards, **WCAG 2.2 AAA**, alle Interaktionen getestet |
| **Onboarding** | Spieler findet Knopf | **< 2 Min bis erstes Erfolgserlebnis**, ohne Tutorial-Text-Walls |
| **Retention** | Kommt wieder | Mechaniken ziehen über Monate, Live-Ops-Plan vorhanden |
| **Dokumentation** | Code hat Kommentare | Neuer Developer onboardet in **< 1 Tag** |
| **Testing** | Manuell gespielt | Coverage > 80%, automatisierte Playtests, A/B-Framework |
| **Accessibility** | Geht für alle | Exzellent für alle — Neurodivergenz, motorische Limitation, Sinnes-Einschränkungen |
| **Brand** | Hat Logo | Eigene Identität, eigene Schrift, eigene Farbpalette, eigener Sound |
| **Live-Ops** | Patch kommt | Saisonale Updates geplant, Monitoring-Dashboard, Incident-Response-Plan |

### 11.2 Premium-Verifier-Updates (V1–V5 verschärft)

Jeder bestehende Verifier bekommt eine **Premium-Schwelle**. Erfüllt eine Arbeit den Verifier nicht auf Premium-Niveau, ist sie **nicht fertig** — auch wenn sie funktional korrekt ist.

#### V1P — Lern-Mechanik Premium
```
Standard V1 + alle:
  ✓ Pädagogisches Konzept schriftlich (welcher Lern-Mechanismus, welche Forschung)
  ✓ A/B-Test-Plan vorhanden (oder Pilot mit N≥20 dokumentiert)
  ✓ Lern-Outcomes hypothesen-basiert formuliert (siehe state/learning-outcomes.md)
  ✓ Anti-Pattern-Audit (kein Schulgefühl, keine Quiz-Mentalität)
```

#### V2P — Performance Premium
```
Standard V2 + alle:
  ✓ 60 FPS auf Mid-Tier-Smartphone (Roblox-Spec), nicht nur High-End
  ✓ Memory < 200 MB nach 30 Min
  ✓ Keine GC-Pausen > 16 ms
  ✓ Lighthouse-Equivalent-Score > 90 für alle Szenen
```

#### V3P — Lern-Outcome Premium
```
Standard V3 + alle:
  ✓ Spaced-Recall-Test bestanden (1d, 7d, 30d Retention)
  ✓ Transfer-Test: Spieler wendet Wissen auf NEUE Situation an
  ✓ Eltern-/Lehrer-Validierung (mind. 3 Reviews dokumentiert)
```

#### V4P — Community-Safety Premium
```
Standard V4 + alle:
  ✓ Pen-Test durchgeführt (Roblox Trust & Safety Standards)
  ✓ Anti-Grooming-System auf AI-Best-Practice-Niveau
  ✓ DSGVO/COPPA-Audit bestanden
  ✓ Crisis-Response-Plan dokumentiert
```

#### V5P — Working-Approach Premium
```
Standard V5 + alle:
  ✓ Velocity steigend ODER stabil über 4 Wochen
  ✓ Close-Loop-Rate > 80% (Premium-Schwelle, höher als 70%)
  ✓ Stakeholder-Satisfaction > 8/10
  ✓ Code-Coverage > 80%
  ✓ Doku-Aktualität < 7 Tage alte Drift
```

### 11.3 Premium-Anti-Patterns (so NICHT)

| Anti-Pattern | Warum Anti-Premium |
|---|---|
| "TODO: später polishen" | Später = nie. Production-ready JETZT oder gar nicht. |
| "Funktioniert in unseren Tests" | Funktioniert auf Ziel-Device, oder es ist nicht production-ready. |
| "Können wir nochmal überarbeiten" | Wenn es in den Build geht, muss es Premium sein. |
| "Spieler werden das nicht merken" | Sie werden. Subtile Mängel zerstören Vertrauen. |
| "Reicht für MVP" | MVP ≠ Low-Quality. MVP = minimal viable premium. |
| Stock-Assets ohne Anpassung | Sieht nach Asset-Flip aus, nicht nach Marke. |
| Generische Lumi-/NPC-Sprüche | Marken-Ton statt KI-Standardtext. |
| UI ohne Micro-Interactions | Leblose UI wirkt billig. |
| Sound ohne adaptive Schicht | Musik, die nicht reagiert, fühlt sich wie Hintergrund-Geräusch an. |

### 11.4 Premium-Decision-Rule

Bevor du etwas "fertig" nennst, frag dich:

> *"Würde ein 14-jähriger Roblox-Spieler, der Genshin, Animal Crossing und Mario Odyssey gewohnt ist, das in den ersten 30 Sekunden als Premium-Produkt erkennen — oder als 'irgendein Schülerprojekt'?"*

Wenn die Antwort "Schülerprojekt" ist: nicht fertig. Zurück in den Loop.

---

*AGENTS.md v2.0 — Juni 2026*
*Gehört zu: Curio World — Premium Lern-Adventure auf Roblox*
*Basiert auf: Loop-Methodik nach Anatoli Kopadze ("Loops explained", Juni 2026), mit Referenzen auf Peter Steinberger und Geoffrey Huntley. Adaptiert für Educational Game Development mit inklusivem Heartbeat über zwei verschachtelte Loops (Working-Approach + Produkt) und verbindlichem Premium-Standard (§11).*