# BOOTSTRAP — Curio World Setup-Prompt für neue Sessions

> **Zweck:** Wenn du eine neue Agent-Session startest und sie soll das Wonder-World-Projekt eigenständig einrichten, kopiere den passenden Prompt unten in den Chat. Die Session übernimmt alles.
>
> **Qualitätsanspruch:** Production-Ready · Premium · State of the Art. Nicht "funktioniert", sondern **muss mit kommerziellen Top-Titeln mithalten können**. Volle Definition: siehe `AGENTS.md §11`.

---

## Wie benutzen

1. Neuen Chat öffnen
2. Prompt aus diesem File kopieren (zwischen den beiden ```-Blöcken)
3. Einfügen + abschicken
4. Session richtet sich ein und meldet sich mit Bestätigung + substantieller Beobachtung zurück

**Optional:** Vor dem Abschicken einen kurzen Kontext ergänzen, was du als Nächstes vorhast (z.B. "Wir starten mit Vertical Slice Hamburg Harbor"). Dann kann die Session direkt darauf einzahlen.

---

## Der Prompt

```
Du startest in einem neuen Wonder-World-Setup-Modus.

PROJEKT-KONTEXT
===============
Curio World ist ein Lern-Adventure auf Roblox für Kinder 9–16 Jahre.
Verstecktes Lernen in Jump-&-Run + Adventure (siehe decisions/D-003).
Ethik-konforme Monetarisierung (siehe decisions/D-004).
Inklusiv & neurodivergenz-freundlich (siehe decisions/D-013).
Workspace: C:\Users\malik_n9u\Documents\Projekte\Roblox Studio - Blender - MCP
Sprache mit User: Deutsch. Code/Identifiers: Englisch.

DEINE AUFGABE
=============
Lies dich ein, räume Doppelungen auf, richte State & Heartbeats ein,
melde dich beim User mit Bestätigung + einer substantiellen Beobachtung.

PFLICHT-REIHENFOLGE (nicht überspringen)
=========================================

SCHRITT 1 — LIES (jeweils komplett, nicht überfliegen)
  a) AGENTS.md (im Workspace-Root) — Loop-Methodik, Verifier, Heartbeats
  b) docs/00_product_vision.md
  c) docs/05_game_design_document.md
  d) docs/04_learning_architecture.md
  e) decisions/D-003_learning_principle.md
  f) decisions/D-004_monetization.md
  g) decisions/D-013_accessibility.md
  h) skills/S1-lernprinzip.md bis S6-ethik-moneta.md (6 Files)
  i) roblox-studio/src/shared/Modules/M02_Quest.lua (Beispiel-Code, gibt Stil vor)

SCHRITT 2 — RÄUME AUF (bestehende Doppelungen)
  - Falls Wissenswelten-Konzept.md im Workspace-Root existiert: löschen
    (Duplikat zu docs/).
  - Falls process/decisions/ existiert: Inhalt von ADR-000-template.md nach
    decisions/D-template.md migrieren, dann process/decisions/ löschen.

SCHRITT 3 — RICHE STATE EIN (kopiere Templates, fülle erste Einträge)
  - state/daily-plan.md           ← state/daily-plan.template.md
  - state/daily-retro.md          ← state/daily-retro.template.md
  - state/content-backlog.md      ← state/content-backlog.template.md
  - state/bug-triage.md           ← state/bug-triage.template.md
  - state/decision-log.md         ← state/decision-log.template.md
                                   (INDEX-Datei, nicht decisions/ überschreiben!)
  - state/learning-outcomes.md    ← state/learning-outcomes.template.md
  - state/playtest-insights.md    ← state/playtest-insights.template.md
  - state/weekly-retro.md         ← state/weekly-retro.template.md

  Hinweis: nur Template-Struktur kopieren, dann mit echtem Inhalt befüllen
  wo sinnvoll (z.B. daily-plan.md mit heutigem Datum und 3 Goals).

SCHRITT 4 — RICHE HEARTBEATS EIN
  Daily Retro (Pflicht):
    mavis cron self daily-retro-wonder-world \
      --every "0 18 * * *" \
      --timezone "Europe/Berlin" \
      --prompt "Daily Retro Heartbeat für Curio World: 1) Lies
        state/daily-plan.md (heute) und prüfe was geschafft wurde. 2) Schreibe
        state/daily-retro.md mit: was lief gut, was lief nicht, eine actionable
        Lesson + Aktion für morgen. 3) Wenn etwas in state/bug-triage.md oder
        state/content-backlog.md blockiert ist, das in den Daily-Plan für morgen
        übernehmen. 4) Max. 30 Min, eine echte Lesson pro Tag ist genug." \
      --ttl 30d

  Weekly Playtest (optional, nur wenn Vertical Slice existiert):
    mavis cron self weekly-playtest-wonder-world \
      --every "0 16 * * 5" \
      --timezone "Europe/Berlin" \
      --prompt "Weekly Playtest Heartbeat: Falls diese Woche Playtest stattfand,
        lies state/playtest-insights.md, clustere Beobachtungen, schreibe 3
        umsetzbare Verbesserungen mit Hypothese. Falls kein Playtest: dokumentiere
        Lücke + plane nächsten Termin." \
      --ttl 30d

SCHRITT 5 — MELDE DICH BEIM USER
  Format:
    ✓ Setup komplett.
    ✓ Cron aktiv: daily-retro-wonder-world (täglich 18:00, Europe/Berlin)
    ✓ State-Files angelegt: [Liste]
    ✓ Cleanup: [was aufgeräumt wurde]
    → Beobachtung/Frage an User: [eine substantielle Sache]

TONE & UMGANG
=============
- Antworte auf Deutsch (User-Sprache).
- Locker, direkt, kein Bullshit.
- Wenn was fehlt oder kaputt ist, sag es offen statt zu überspielen.
- Frage nicht alles — mach und berichte.
- Respektiere bestehende Struktur: docs/, decisions/, roblox-studio/src/ sind
  kanonisch und dürfen nicht durch eigene parallele Strukturen ersetzt werden.
- Verboten: "Wissenswelten"-Naming (Projekt heißt Curio World), eigene
  ADR-Schemata, eigene Konzept-Docs.

ERFOLGS-KRITERIEN (alle müssen erfüllt sein)
============================================
☐ Alle 9 Pflicht-Files gelesen
☐ Cleanup durchgeführt (Wissenswelten-Konzept weg, process/decisions migriert)
☐ Mindestens 8 State-Files aus Templates angelegt
☐ Daily-Retro-Cron aktiv (Bestätigung in der Antwort)
☐ User hat substantielle Antwort mit Beobachtung/Frage erhalten
```

---

## Was diese Session danach getan haben sollte (für dich prüfbar)

| Check | Wie verifizieren |
|---|---|
| AGENTS.md gelesen | Frage: "Was sind die 5 Loop-Bausteine?" → muss Antwort geben können |
| Vision verstanden | Frage: "Was sind die 6 Creative Pillars?" |
| Bestehende ADRs respektiert | state/decision-log.md zeigt nur INDEX auf decisions/, nichts überschrieben |
| Cron läuft | `mavis cron ls` zeigt `daily-retro-wonder-world` |
| State-Files da | `Get-ChildItem state/*.md` zeigt 8 Files ohne .template-Suffix |
| Cleanup gemacht | `Wissenswelten-Konzept.md` existiert nicht mehr im Root, `process/decisions/` ist leer/gelöscht |
| Substantielle Antwort | Die Session gibt eine echte Beobachtung oder Frage, kein leeres "Fertig" |

---

## Optionale Erweiterungen

### Variante A — Mit konkretem Sprint-Fokus
Vorne im Prompt ergänzen:
```
AKTUELLER SPRINT: Vertical Slice Hamburg Harbor
NÄCHSTER FOKUS: [konkret, z.B. "Kran-Tutorial-Quest (HH_01_kran_intro) implementieren"]
```

### Variante B — Mit explizitem Cleanup-Auftrag
Falls vorherige Sessions Müll hinterlassen haben, ergänzen in SCHRITT 2:
```
- Lösche auch [konkretes File/Ordner].
- Erzwinge Selene-Lint über src/ und liste alle Fehler auf.
```

### Variante C — Mit Pair-Programming-Partner
Falls du willst, dass die Session dir gleichzeitig Fragen stellt:
```
NACH SCHRITT 5: Stelle 3 Rückfragen, die dir beim Lesen aufgekommen sind
                  und die du ohne User-Antwort nicht entscheiden kannst.
```

---

## Use-Case-Matrix — Welcher Bootstrap-Prompt für welche Aufgabe?

Ein einzelner Full-Prompt passt nicht für alles. Wähle den Use Case, der zur Aufgabe passt:

| # | Use Case | Pflicht-Reads | Setup-Aufwand | Output |
|---|---|---|---|---|
| 1 | **Full Bootstrap** (Projekt kalt starten) | AGENTS + alle docs + decisions + skills + Beispiel-Code | hoch | komplettes Setup, Cron aktiv |
| 2 | **Continue** (in laufende Arbeit zurück) | daily-plan + daily-retro + letzte 3 commits | minimal | weiterarbeiten am Stand |
| 3 | **Quick Task** (eine kleine Sache) | AGENTS TL;DR + 1-2 relevante docs | minimal | nur die Aufgabe |
| 4 | **Code Review** | AGENTS + Skill S4 + relevante Module | mittel | Review-Report mit Premium-Checkliste |
| 5 | **Bug Fix** | bug-triage + Skill S4 + betroffene Module | mittel | Fix + Re-Verify |
| 6 | **Asset (Blender)** | Skill S2 + S5 + docs/07 + docs/08 | mittel | Blender-File mit Export-Smoke-Test |
| 7 | **Lern-Content** | AGENTS + Skill S1 + S3 + D-003 + city-spezifische docs | mittel | Quest-Skript mit Pädagogik-Begründung |
| 8 | **ADR schreiben** | state/decision-log + letzte 3 ADRs + D-template | niedrig | neue ADR mit Begründung |
| 9 | **Playtest-Auswertung** | playtest-insights + Skill S1 + Skill S3 | niedrig | Insights + 3 Verbesserungen mit Hypothese |
| 10 | **Pair / Consult** | AGENTS TL;DR + 1-2 relevante docs | minimal | Antwort auf Frage, kein Output-File |
| 11 | **Sprint Planning** | content-backlog + weekly-retro + bug-triage | mittel | priorisierter Sprint-Backlog |
| 12 | **Skill Update** | skills/ + letzte 2 Retros + Monthly-Strategy-Notizen | niedrig | Skill-Patch mit Begründung |
| 13 | **Architecture-Question** | system-architektur + relevante ADRs + Skill S4 | mittel | Diskussion + Empfehlung + ggf. ADR-Vorschlag |

### Mini-Prompts pro Use Case

Jeder Mini-Prompt ist **copy-paste-bar** und enthält nur das, was die Session wirklich braucht. Setup-Aufwand, Pflicht-Reads und Verifier sind jeweils vorgegeben.

---

#### USE CASE 1 — Full Bootstrap (komplett einrichten)

```
Du startest in Wonder-World-Setup-Modus. Ziel: komplettes Premium-Setup
in einer Session. Production-Ready · State of the Art · Premium.

PFLICHT (nicht überspringen):
1. LIES komplett: AGENTS.md, docs/00-19/, decisions/D-001 bis D-015,
   skills/S1-S6, roblox-studio/src/shared/Modules/M02_Quest.lua.
2. Cleanup: lösche Wissenswelten-Konzept.md und process/decisions/.
3. State: kopiere 8 Templates nach state/*.md (ohne .template).
4. Cron: `mavis cron self daily-retro-wonder-world --every "0 18 * * *"
   --timezone "Europe/Berlin" --prompt "[Daily-Retro-Prompt]" --ttl 30d`
5. Melde dich mit: Setup-Status, Cron-Liste, State-Files, Cleanup,
   einer substantiellen Premium-Beobachtung.

Premium-Disziplin: Wenn dir beim Lesen auffällt, dass etwas nicht
Premium-Niveau hat (siehe AGENTS.md §11), sag es offen statt zu
überspielen. Antworte auf Deutsch, locker, direkt.
```

---

#### USE CASE 2 — Continue (weiterarbeiten)

```
Du übernimmst eine laufende Wonder-World-Session. Production-Ready-Standard.

PFLICHT:
1. LIES: state/daily-plan.md + state/daily-retro.md + letzte 3 Git-Commits.
2. Verstehe: was war der letzte Stand, was steht heute an.
3. Setze exakt da fort, wo die letzte Session aufgehört hat.
4. Update am Ende: state/daily-plan.md + ggf. neue Issues in bug-triage.md.

Antworte auf Deutsch. Wenn was unklar ist, frag bevor du loslegst.
```

---

#### USE CASE 3 — Quick Task (eine kleine Sache)

```
Curio World, eine konkrete Aufgabe: [HIER DEINE AUFGABE].

PFLICHT (minimal):
1. Lies AGENTS.md TL;DR + QUICK-START.
2. Falls Aufgabe Code: lies Skill S4 (skills/S4-luau-code.md).
   Falls Lern-Content: Skill S1 + S3.
   Falls Blender: Skill S2 + S5.
3. Mach die Aufgabe. Premium-Standard (AGENTS.md §11).
4. Wenn du fertig bist: zeige Output + welche Verifier (V1-V5) du geprüft hast.

Antworte auf Deutsch. Kein Setup, keine großen Reads — nur die Aufgabe.
```

---

#### USE CASE 4 — Code Review

```
Curio World, Code-Review für: [FILE-PFAD oder MODUL].

PFLICHT:
1. LIES: AGENTS.md + skills/S4-luau-code.md + docs/09_system_architecture.md.
2. Review gegen Premium-Standard (AGENTS.md §11):
   - Type-strict? (--!strict, alle Annotations)
   - Selene-Lint clean?
   - Module-Pattern (kein Spaghetti-Code)?
   - Security (Server-Authoritative für Lern-Antworten)?
   - Performance (60 FPS, Memory)?
   - Dokumentation (Header, Magic-Numbers → Config)?
3. Output-Format:
   - ✅ Was gut ist (3-5 konkrete Stärken)
   - ⚠️ Was zu fixen ist (3-7 konkrete Punkte mit Datei:Zeile)
   - 🚫 Was blockiert (kritische Issues, sofort fixen)
   - Premium-Score: X/10 (was fehlt für 10/10?)
4. Empfehlung: approve / approve-mit-fix / reject.

Antworte auf Deutsch. Sei direkt, kein Bullshit.
```

---

#### USE CASE 5 — Bug Fix

```
Curio World, Bug Fix für: [BUG-ID oder BESCHREIBUNG].

PFLICHT:
1. LIES: state/bug-triage.md (falls vorhanden) + Skill S4 + betroffenes Modul.
2. Reproduziere den Bug. Verstehe Root Cause (nicht Symptom fixen).
3. Fix mit kleinster möglicher Änderung.
4. Re-Verify: Bug-Triage-Sektion in state/bug-triage.md updaten
   (Status: open → in-progress → fixed → verified).
5. Wenn Fix Side-Effects hat: dokumentiere in derselben Sektion.

Premium-Standard: Fix muss mit Tests abgesichert sein, nicht nur "geht jetzt".
Wenn Bug zu groß für eine Session → eskaliere, sag klar was offen ist.
```

---

#### USE CASE 6 — Asset (Blender)

```
Curio World, neues 3D-Asset: [BESCHREIBE WAS].

PFLICHT:
1. LIES: skills/S2-anime-aesthetik.md + skills/S5-blender.md
   + docs/07_art_direction.md + docs/08_asset_pipeline_blender_to_roblox.md.
2. Baue in Blender mit den Triangle-Budgets aus Skill S5.
3. Anime-Treue gegen Skill S2 prüfen (Cel-Shading, Chibi-Proportionen, Palette).
4. Export nach FBX (siehe Skill S5 Export-Pipeline).
5. Smoke-Test: in Roblox Studio importieren, platzieren, screenshotten.
6. Output: Blender-File-Pfad + FBX-Datei + Roblox-Screenshot.

Premium-Check: sieht es aus wie Genshin/Ghibli, oder wie Asset-Flip?
Wenn Asset-Flip → nicht fertig, redesign.
```

---

#### USE CASE 7 — Lern-Content (Quest, Dialog, Schriftrolle)

```
Curio World, neuer Lern-Content: [STADT, QUESTS, LEVEL, LERN-DOMÄNE].

PFLICHT:
1. LIES: AGENTS.md + skills/S1-lernprinzip.md + skills/S3-neurodivergenz.md
   + decisions/D-003_learning_principle.md + city-spezifische docs.
2. Entwirf Content mit Anti-Schulgefühl-Audit:
   - Merkt Spieler dass er lernt? → Redesign wenn ja.
   - Ist Wissen Werkzeug, nicht Test?
   - Aha-Erlebnis statt Richtig/Falsch?
   - Verbotene UI-Wörter: "Lerne", "Test", "Quiz", "Aufgabe" → umformulieren.
3. Pädagogisches Konzept schriftlich (welche Forschung stützt das?).
4. Altersstufen-Variante (Junior 9-11 / Cadet 12-13 / Master 14-16).
5. Liefere: Quest-Skript + Pädagogik-Begründung + A/B-Test-Hypothese.

Premium-Standard: Eltern und Lehrkraft müssen zustimmen können, dass
echtes Lernen drin steckt — auch wenn sie das Spiel nicht mögen.
```

---

#### USE CASE 8 — ADR schreiben (Architektur-Entscheidung)

```
Curio World, neue ADR für: [ENTSCHEIDUNG].

PFLICHT:
1. LIES: state/decision-log.md (Index) + letzte 3 ADRs in decisions/
   + decisions/D-template.md (Format-Vorlage).
2. Folge dem Schema (D-NNN_kurztitel.md): Problem, Optionen mit Pro/Contra,
   Entscheidung mit Begründung, Konsequenzen, Validierungsplan.
3. Mindestens 2 Optionen mit echtem Trade-off (nicht Strohpuppen).
4. Verifier-Check am Ende (4-Box-Test, Skills-Check, etc.).
5. Update state/decision-log.md (Index-Eintrag).

Premium-Standard: Eine ADR ist erst fertig, wenn ein:e Reviewer:in
sie gegenzeichnen würde ohne zu fragen "warum so?".
```

---

#### USE CASE 9 — Playtest-Auswertung

```
Curio World, Playtest-Auswertung für [DATUM/SPRINT].

PFLICHT:
1. LIES: state/playtest-insights.md (Template) + Skill S1 + Skill S3.
2. Clustere rohe Beobachtungen: Frust / Aha / Langeweile / Sensory.
3. Formuliere 3 umsetzbare Verbesserungen mit Hypothese
   (Wenn X geändert wird, dann Y, weil Z).
4. Pro Verbesserung: Owner + Sprint + Test-Design (A/B oder Cohort).
5. Verworfen-Begründungen dokumentieren (Anti-Bias).
6. Update state/playtest-insights.md.

Premium-Standard: Insights sind erst fertig, wenn jemand auf Basis davon
einen klaren Sprint planen kann — ohne zurückzufragen.
```

---

#### USE CASE 10 — Pair / Consult (User fragt, Agent antwortet)

```
Curio World, Beratung zu: [FRAGE].

PFLICHT:
1. LIES: AGENTS.md TL;DR + relevante docs (1-2 Files).
2. Antworte direkt, kurz, mit Begründung.
3. Wenn Frage eine Entscheidung verlangt: liste Optionen mit Empfehlung.
4. Wenn Frage Architektur berührt: empfehle ADR (Use Case 8).
5. KEIN Output-File erstellen. KEIN Setup.

Premium-Standard: Antwort ist auf Augenhöhe mit einem erfahrenen
Game-Designer, nicht auf Wikipedia-Niveau.
```

---

#### USE CASE 11 — Sprint Planning

```
Curio World, Sprint-Planung für die nächsten 3 Wochen.

PFLICHT:
1. LIES: state/content-backlog.md + state/weekly-retro.md
   + state/bug-triage.md + state/playtest-insights.md.
2. Inventar: was ist offen, was ist ready, was blockiert.
3. Kapazität realistisch schätzen (nicht überladen).
4. Sprint-Goals: 3-5 konkrete Deliverables, jede mit Owner + Verifier.
5. Anti-Scope-Creep: was kommt NICHT in diesen Sprint (mit Begründung).
6. Update state/content-backlog.md (Sprint-Zuordnung).

Premium-Standard: Sprint-Plan ist erst fertig, wenn alle Owners
zustimmen und kein Item unklar verantwortet ist.
```

---

#### USE CASE 12 — Skill Update (skill-Files pflegen)

```
Curio World, Skill-Update für: [S1-S6 oder neuer Skill].

PFLICHT:
1. LIES: skills/ (alle 6) + letzte 2 Retros + Monthly-Strategy-Notizen.
2. Datengetrieben: jede Änderung mit Beobachtung/Erkenntnis belegen.
3. Maximal 5 Änderungen pro Patch (sonst zu groß).
4. Jede Änderung gegen bestehende Regeln prüfen (Widerspruch?).
5. Patch-Notiz: was ändert sich + warum + wie getestet.
6. State: entscheidung in state/decision-log.md erwähnen.

Premium-Standard: Skill-Update ist erst fertig, wenn nächste Loop-Pass
das neue Skill automatisch nutzt ohne zu fragen.
```

---

#### USE CASE 13 — Architecture-Question

```
Curio World, Architektur-Diskussion zu: [FRAGE].

PFLICHT:
1. LIES: docs/09_system_architecture.md + relevante ADRs + Skill S4.
2. Pro Option: Vor-/Nachteile mit konkreten Code-/Architektur-Beispielen.
3. Empfehlung mit Begründung (nicht "beides geht").
4. Trade-offs explizit machen (was opfern wir für was?).
5. Wenn wichtig genug: ADR-Vorschlag machen (Use Case 8).

Premium-Standard: Diskussion ist auf Game-Architecture-Conference-Niveau,
nicht "vielleicht könnten wir...".
```

---

## Wann KEINEN Bootstrap-Prompt benutzen

- **Triviale Einzelfragen** → direkt fragen, kein Setup
- **Laufende Session ergänzen** → in der laufenden Session bleiben
- **Komplett anderes Thema** (z.B. "schreib mir ein Python-Script") → kein Wonder-World-Setup nötig
- **Session macht etwas Gefährliches** (Lösch-Orgien auf Root) → lieber manuell machen

---

*BOOTSTRAP.md v2.0 — Juni 2026*
*Gehört zu: Curio World — Production-Ready · Premium · State of the Art, siehe AGENTS.md*