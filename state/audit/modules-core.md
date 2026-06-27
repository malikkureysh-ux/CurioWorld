# Feature-Audit: M-01 bis M-08 (Player / Quest / Dialogue / Adaptive / Puzzle / Inventory / Economy)

**Verfasser:** Verifier
**Datum:** 2026-06-27
**Zweck:** Production-Readiness-Review der zentralen Curio-World-Module.
**Methode:** Code-Lesung aller Module + Cross-Reference Docs/Decisions + identifizierte Lücken / Disconnects.

> **Hinweis zur Aufgabenstellung:** Die Aufgabenstellung verweist auf vier Querverweis-Dokumente, von denen zwei nicht unter dem angegebenen Dateinamen existieren. Was tatsächlich existiert und was stattdessen verwendet wurde, ist in §0 dokumentiert.

---

## 0. Aufgabenstellungs-Anomalien (vor dem eigentlichen Audit)

### 0.1 M-08 existiert nicht als separate Datei

**Behauptung der Aufgabenstellung:** „M08_AdaptiveDifficulty.lua (alias M-04)".

**Tatsache:** Es gibt im Verzeichnis `roblox-studio/src/shared/Modules/` **keine Datei mit dem Namen `M08_AdaptiveDifficulty.lua`**. Vorhanden sind ausschließlich: `M01_PlayerController.lua`, `M02_Quest.lua`, `M03_Dialogue.lua`, `M04_Adaptive.lua`, `M05_Puzzle.lua`, `M06_Inventory.lua`, `M07_Economy.lua` — plus M09-M11, M13, M15, MapBuilder.

Die Architektur-Spec `docs/09_system_architecture.md:222` sagt explizit: *„M-08 Adaptive Difficulty Engine — Siehe M-04 / `12_adaptive_difficulty_model.md`."* — d.h. **M-08 ist ein Alias auf M-04 und existiert konzeptuell, aber nicht als eigene Datei.**

**Konsequenz für diesen Audit:** M-08 wird als **Teilmenge von M-04** auditiert (siehe §4).

### 0.2 Querverweis-Dokumente teilweise nicht existent

**Behauptung der Aufgabenstellung:** Cross-Reference `docs/02_product_requirements.md`, `docs/03_user_personas.md`, `docs/06_world_bible.md`, `docs/09_system_architecture.md`.

**Tatsache (Auflistung `docs/`):**

| Aufgabenstellung verlangt | Existiert? | Stattdessen verwendet |
|---|---|---|
| `docs/02_product_requirements.md` | **NEIN** | `docs/00_product_vision.md` + `docs/03_target_audience.md` + `docs/05_game_design_document.md` |
| `docs/03_user_personas.md` | **NEIN** | `docs/03_target_audience.md` (Personas sind in §„Cross-Cutting Personas" enthalten) |
| `docs/06_world_bible.md` | JA | wie angegeben |
| `docs/09_system_architecture.md` | JA | wie angegeben |

Zusätzlich für Spec-Kontext herangezogen: `docs/10_economy_design.md`, `docs/12_adaptive_difficulty_model.md`, `docs/04_learning_architecture.md`.

### 0.3 Testabdeckung (vorab)

Von 8 angefragten Modulen haben **genau 1** eine Test-Suite: M-07 (via `M07_Economy.spec.lua`, 239 Zeilen, ~20 Specs). Eine zweite Spec existiert für M-15 (außerhalb dieses Audit-Scopes). **M-01, M-02, M-03, M-04, M-05, M-06 haben null Testabdeckung.**

Zusätzlich: Das `TestRunner.server.lua` (Zeile 45) verwendet das Pattern `string.match(child.Name, "%.spec$")` — das matcht nur Dateinamen, die mit `.spec` enden. Die vorhandenen Test-Dateien heißen `M07_Economy.spec.lua` und enden auf `.lua`. **=> Die existierenden Tests werden vom Auto-Discovery NICHT gefunden.** Die scheinbare Testabdeckung von M-07 ist also auch noch faktisch tot.

---

## Modul-Status-Übersicht

| Modul | Feature-Status | Test-Status | Production-Ready? |
|---|---|---|---|
| **M-01 PlayerController** | SKELETON | KEINE | NEIN |
| **M-02 Quest** | SKELETON (Datamodel + trivial-API) | KEINE | NEIN |
| **M-03 Dialogue** | SKELETON (nur Typen) | KEINE | NEIN |
| **M-04 Adaptive (inkl. M-08-Alias)** | PARTIAL (Bayes-Update funktional, kein Trend-Window, kein Save) | KEINE | NEIN |
| **M-05 Puzzle** | SKELETON (nur Typen) | KEINE | NEIN |
| **M-06 Inventory** | SKELETON (nur Typen) | KEINE | NEIN |
| **M-07 Economy** | DONE (Client-Modul) + DONE (EconomyService Server) | 20 Specs (funktional, aber Auto-Discovery kaputt) | TEILWEISE |
| **M-08 Adaptive Difficulty** | IDENTISCH MIT M-04 | KEINE separate Spec | NEIN |

**Gesamtbild:** Das Spiel hat **ein** produktionsnahes Modul (M-07 + EconomyService) und **sieben** Skeletons/Stubs. Selbst M-02 Quest — das **zentrale Gameplay-Modul** — kann faktisch keine Quest-Schritte auswerten (alle `completion_condition` returnen hartcodiert `true`).

---

## M-01 PlayerController

**Datei:** `roblox-studio/src/shared/Modules/M01_PlayerController.lua` (49 Zeilen)
**Doc-Referenz:** `docs/09_system_architecture.md:41-58`
**Decision-Referenz:** D-014 (Kran-Schwingen als Highlight)

### Feature: Movement-Context-Anwendung

**User Story:** Als Spieler:in möchte ich mich in verschiedenen Bezirken mit passenden Bewegungs-Parametern bewegen, damit ich in Hamburg Harbor anders steuerbar bin als in SkyBridge Bay.

**Erwartetes Verhalten (Spec §9 M-01):** WalkSpeed/JumpPower/Sprint setzen; Touch-Input für Mobile; Spezial-Bewegungen wie Kran-Schwingen auslösen.

**Tatsächliches Verhalten (`M01_PlayerController.lua:30-40`):**
```lua
humanoid.WalkSpeed = context.WalkSpeed or 16
humanoid.JumpPower = context.JumpPower or 50
humanoid.JumpHeight = (context.JumpPower or 50) / 10
```
Setzt WalkSpeed + JumpPower + JumpHeight — **dabei sind JumpPower und JumpHeight in Roblox Humanoid-State-API gegenseitig exklusiv** (Roblox-Doku: das Setzen der einen Property setzt die andere auf 0). Der Code setzt **beide**, was zu undefiniertem Verhalten führt. Das ist ein Logikfehler.

**Status:** SKELETON
**Blocker / Fehler:**
- Konflikt `JumpPower` vs. `JumpHeight` (Roblox-API-Verhalten).
- Touch-Input komplett unimplementiert (`-- Sprint via UserInputService in Phase 3`).
- Sprint-Multiplier aus dem Context wird **nirgends angewendet** (Typ `MovementContext.SprintMultiplier` deklariert, aber keine Verwendung).

### Feature: Kran-Schwingen (Bezirks-Spezialbewegung)

**User Story:** Als Spieler:in in Hamburg Harbor möchte ich an einem Kran schwingen können, damit ich Physik (Hebelgesetz) spielerisch erlebe.

**Erwartetes Verhalten (D-014 Option D, Spec §9):** Schwing-Mechanik mit Physik-Simulation, Seil-Snap, Schwung-Phase.

**Tatsächliches Verhalten (`M01_PlayerController.lua:43-47`):**
```lua
function M01_PlayerController:TrySwingFromCrane(_character: Model, _crane: Model): boolean
    -- TODO Phase 3: Physik-Simulation, Seil-Snap, Schwung-Phase
    return false
end
```
Stub gibt hartcodiert `false` zurück. Keine Physik, keine Animation, keine Sound-Kopplung. Die Parameter werden mit Underscore-Prefix versehen, um Selene-Warnungen zu unterdrücken — ehrlich, aber funktional inexistent.

**Status:** SKELETON
**Blocker / Fehler:**
- Keine Schwing-Mechanik vorhanden (Phase 3 laut Kommentar).
- Highlight-Feature für Vertical Slice fehlt komplett.
- Keine Tests.

---

## M-02 Quest

**Datei:** `roblox-studio/src/shared/Modules/M02_Quest.lua` (224 Zeilen)
**Doc-Referenz:** `docs/09_system_architecture.md:61-93`
**Decision-Referenz:** D-002 (Vertical Slice Hamburg Harbor), D-003 (Lernen versteckt)

### Feature: Quest-Datenmodell

**User Story:** Als Game-Designer möchte ich Quests deklarativ definieren (Typ, Schritte, Belohnungen, Prerequisites), damit das System sie typsicher verarbeiten kann.

**Erwartetes Verhalten (Spec §9 M-02):** Vollständige Typen `Quest`, `QuestStep`, `QuestProgress`, `Reward`.

**Tatsächliches Verhalten (`M02_Quest.lua:22-51`):** Typen vollständig definiert, inkl. `QuestStepType`, `QuestProgress`. ✓

**Status:** DONE (Datenmodell)

### Feature: Sample-Quests für Hamburg Harbor

**User Story:** Als Spieler:in möchte ich eine Einstiegsquest in Hamburg Harbor erleben, damit ich die Kran-Mechanik lerne.

**Erwartetes Verhalten:** Mindestens 1–2 lauffähige Quest-Definitionen mit echten `completion_condition`-Funktionen.

**Tatsächliches Verhalten (`M02_Quest.lua:73-87`, sowie 116, 122, 130, 165, 171, 177, 183):**
```lua
completion_condition = function(_, _) return true end,
```
**Alle 14 Sample-Quest-Schritte verwenden eine hartcodierte Completion-Condition, die immer `true` zurückgibt.** Drei Sample-Quests (HH_01, HH_02, HH_03) sind als vollständige Bäume vorhanden, aber jeder einzelne Schritt akzeptiert sich selbst sofort. Es gibt keine echte Auswertung.

**Status:** PARTIAL (Daten ja, Logik nein)
**Blocker / Fehler:**
- Keine echte Completion-Logik — Spieler kann nicht „scheitern".
- Keine Verbindung zu Puzzle- oder Objective-Systemen (die anderen Module haben auch keine).
- `required_count = 4` in HH_03 step_1 wird nirgends ausgewertet (kein Code liest das Feld).

### Feature: Quest-Start-API

**User Story:** Als Server möchte ich für eine Spieler:in eine Quest starten, damit sie Fortschritt machen kann.

**Erwartetes Verhalten:** Validiert `prerequisites`, legt `QuestProgress` an, gibt sie zurück.

**Tatsächliches Verhalten (`M02_Quest.lua:202-213`):**
```lua
function M02_Quest:StartQuest(player: Player, questId: string, state: { [string]: any }): QuestProgress?
    local quest = self.SampleQuests[questId]
    if not quest then return nil end
    return {
        pid = tostring(player.UserId),
        quest_id = questId,
        current_step = 1,
        state = state or {},
        started_at = os.time(),
    }
end
```
- Keine Prüfung von `prerequisites` (jede Quest ist für jeden startbar, auch ohne Vorbedingungen).
- Keine Server-seitige Validierung, dass die Quest für die Altersklasse passt (`age_band_target` wird ignoriert).
- Kein Server-only-Schutz (kein `if RunService:IsServer() then` Guard).
- Kein Persistieren des Fortschritts.

**Status:** SKELETON
**Blocker / Fehler:**
- Prerequisites ungenutzt → Spieler:innen können die Story überspringen.
- Kein Server-Authoritative-Schutz (S4 Anti-Cheat verlangt dies).
- Kein Schreiben in SaveService.

### Feature: Quest-Step-Advance

**User Story:** Als Quest-System möchte ich den aktuellen Schritt weiterschalten, wenn die Completion-Condition erfüllt ist.

**Tatsächliches Verhalten (`M02_Quest.lua:215-218`):**
```lua
function M02_Quest:AdvanceStep(progress: QuestProgress): boolean
    progress.current_step += 1
    return true
end
```
- Erhöht `current_step` ohne Bound-Check. Wenn der Spieler am Ende der Steps ist, läuft der Index über das Array hinaus.
- Ruft die `completion_condition` **nicht auf** — der Caller muss das extern machen (was aber nirgends im Code passiert).

**Status:** SKELETON
**Blocker / Fehler:**
- Keine Bound-Prüfung.
- Keine Trigger-Logik.

### Feature: Quest-Complete + Reward-Vergabe

**Erwartetes Verhalten:** Beim Quest-Abschluss werden Rewards vergeben (Gold, Gems, Companions, Photo-Filter).

**Tatsächliches Verhalten (`M02_Quest.lua:220-222`):**
```lua
function M02_Quest:Complete(progress: QuestProgress)
    progress.completed_at = os.time()
end
```
Setzt nur den Timestamp. **Keine Reward-Vergabe** trotz explizit deklarierter Reward-Strukturen in den Sample-Quests (`type = "Gold", amount = 50` etc.). Keine Aufrufe an `EconomyService:AddGold` / `AddGems`. Keine Aufrufe an `M06_Inventory` für Items/Companions.

**Status:** SKELETON
**Blocker / Fehler:**
- Reward-System ist die zentrale Wirtschaftsschnittstelle — nicht implementiert.
- Companion-Rewards (`item = "Curio_Seagull"`) werden nie persistiert.

---

## M-03 Dialogue

**Datei:** `roblox-studio/src/shared/Modules/M03_Dialogue.lua` (35 Zeilen)
**Doc-Referenz:** `docs/09_system_architecture.md:94-126`

### Feature: Dialogue-Datenmodell

**User Story:** Als Game-Designer möchte ich NPC-Dialoge mit Lokalisierungs-Keys, Audio-Asset-IDs und optionalen Antworten definieren.

**Erwartetes Verhalten:** Vollständige Typen + Funktionen zum Start, Advance und Beenden eines Dialogs.

**Tatsächliches Verhalten:** Datei enthält **ausschließlich Typdeklarationen** und `return M03_Dialogue` (35 Zeilen total). Keine einzige Funktion, kein Sample-Dialog.

**Status:** SKELETON
**Blocker / Fehler:**
- Keine Logik vorhanden.
- Keine Sample-Dialoge für Hamburg-Harbor-NPCs (Hafenwirtin Lina, Markt-Händlerin Yuki, Bootsbauerin Maja, Leuchtturmwächter Nils — alle 4 NPCs aus `docs/06_world_bible.md:181-184` wären hier zu modellieren).
- Kein Trigger-Mechanismus (Quest-Step „type = dialogue" verweist auf `target = "Hafenwirtin"`, aber kein Code resolved das).
- Kein Audio-Sync (laut Spec für Phase 3 — eigentlich schon OK, aber kein Sample).
- Keine Verbindung zu M-13 Moderation (laut Spec: Trigger bei bestimmten Inhalten).

---

## M-04 Adaptive Learning Engine

**Datei:** `roblox-studio/src/shared/Modules/M04_Adaptive.lua` (166 Zeilen)
**Doc-Referenz:** `docs/12_adaptive_difficulty_model.md`, `docs/09_system_architecture.md:128-153` (M-04)
**Decision-Referenz:** D-005 (Unsichtbar), D-006 (Anti-Shame), D-007 (Retrieval), D-003 (Versteckt)

### Feature: CompetencyProfile-Datenmodell

**User Story:** Als Adaptive Engine möchte ich pro Spieler:in und pro Domäne (Math, Physics, Logic, Language, Memory, Planning, Chemistry, Coding) einen Kompetenzwert speichern, damit ich Empfehlungen ableiten kann.

**Tatsächliches Verhalten (`M04_Adaptive.lua:15-71`):**
- Typen `Domain`, `DomainScore`, `CompetencyProfile`, `AdaptiveRecommendation` vollständig.
- `newProfile(pid)` initialisiert 8 Domänen mit level=0.5, confidence=0.0, trend=unknown, samples=0. ✓
- Die Domänen-Liste enthält „Coding" — **aber** `docs/12_adaptive_difficulty_model.md:57-67` listet **9 Domänen** inkl. „english" und „informatics". „Coding" vs. „informatics" — Naming-Inkonsistenz.

**Status:** PARTIAL (Typen OK, aber Domänen-Naming weicht von Spec ab)

### Feature: Signal-Aufzeichnung (Bayesian Update)

**User Story:** Als Quest/Puzzle-System möchte ich Erfolgs-Signale an die Adaptive Engine melden, damit das Kompetenzprofil aktualisiert wird.

**Tatsächliches Verhalten (`M04_Adaptive.lua:83-114`):**
```lua
local delta = signal.success and 0.04 or -0.03
if signal.hint_used then delta *= 0.5 end
if signal.attempts > 3 then delta *= 0.5 end
d.level = math.max(0.0, math.min(1.0, d.level + delta))
d.confidence = math.min(1.0, d.samples / 20.0)
```
- Update-Logik funktional — positiv/negativ Bayesian-ähnlicher Sprung mit Dämpfung.
- **Aber:** `signal.latency_ms` (deklarierter Parameter) wird **nirgends verwendet** — toter Input.
- **Trend-Bug:** `d.recent_trend = delta > 0 and "rising" or (delta < 0 and "falling" or "stable")` — das wird **bei jedem Signal überschrieben**, basierend nur auf dem letzten Signal. Der Kommentar sagt „Trend: basiert auf letzte 5 Signals. (Phase 3: rolling window)" — das ist nicht implementiert. Der Trend ist faktisch immer „rising" oder „falling", nie „stable" über mehrere Signale.

**Status:** PARTIAL
**Blocker / Fehler:**
- Trend-Logik ist deterministisch abhängig vom letzten Signal — kein echtes „rolling window".
- `latency_ms` Parameter dead code.
- 9 Domänen in Spec vs. 8 in Code.

### Feature: Adaptions-Empfehlung

**User Story:** Als Quest-System möchte ich für eine Domäne eine Empfehlung (Difficulty, HelpDepth, Language, Pacing) bekommen, damit ich Aufgaben passend wählen kann.

**Tatsächliches Verhalten (`M04_Adaptive.lua:120-164`):**
- `SuggestDifficulty = level - 0.05` (Flow-Channel unter dem Level).
- `HelpDepth` abhängig von Confidence.
- `LanguageComplexity` abhängig von Level (0.3/0.7 Schwellen).
- `Pacing` abhängig von Trend.

**Status:** PARTIAL
**Blocker / Fehler:**
- **Disconnect zum Quest-System:** `M02_Quest.lua` ruft `M04_Adaptive:Recommend` **nirgends auf**. Die zwei Module sind komplett unverbunden. Die Empfehlung existiert, aber wird nie benutzt.
- **Altersband-Initialwerte ignoriert:** `docs/12_adaptive_difficulty_model.md:91-98` sieht vor, dass das `base_age_band_level` mit 30 % ins `estimated_level` einfließt. Im Code ist `newDomainScore()` hartcodiert auf `level=0.5` für alle. Keine Altersband-Initialisierung.
- `age_band` ist im `CompetencyProfile`-Typ gar nicht enthalten (Spec sieht das vor).

### Feature: Unsichtbarkeit / Anti-Shame

**Erwartetes Verhalten (D-005 + D-006):** Engine läuft im Hintergrund; kein öffentliches Ranking; Sammelbuch-Modus optional.

**Tatsächliches Verhalten:** Keine UI-Anbindung existiert. Da kein Quest-Step die Engine konsumiert, gibt es auch keine sichtbaren Outputs — die Unsichtbarkeit ist eine **Konsequenz davon, dass das Modul unbenutzt ist**, nicht eine Design-Entscheidung im Code.

**Status:** MISSING (im Sinne einer echten, integrierten Anti-Shame-Implementation)

### Feature: Profile-Persistierung

**Erwartetes Verhalten (D-005 + `docs/12_adaptive_difficulty_model.md:191-192`):** „Profil wird alle 5 Minuten im DataStore gespeichert."

**Tatsächliches Verhalten:** `SaveService.lua` hat nur `LoadWallet` / `SaveWallet`. **Keine Methoden für CompetencyProfile.** Die Adaptive Engine hat keine Persistenz.

**Status:** MISSING
**Blocker / Fehler:** Datenverlust bei jedem Logout. Spec verlangt 5-Min-Save.

---

## M-05 Puzzle Framework

**Datei:** `roblox-studio/src/shared/Modules/M05_Puzzle.lua` (32 Zeilen)
**Doc-Referenz:** `docs/09_system_architecture.md:157-170`, `docs/04_learning_architecture.md:62-88`

### Feature: Puzzle-Datenmodell

**User Story:** Als Puzzle-Designer möchte ich Sortier-/Bau-/Memory-/Logik-Puzzles mit Domänen-Tag und Difficulty-Range definieren.

**Tatsächliches Verhalten:** Datei enthält ausschließlich Typ-Deklarationen und `return M05_Puzzle`. 32 Zeilen total.

**Status:** SKELETON
**Blocker / Fehler:**
- Keine einzige Funktion.
- Keine Puzzle-Instanzen — Spec sagt explizit: „Phase 3: Puzzle-Instanzen für Hamburg-Harbor-Erstausbau (5 Stück)."
- `solution_check` ist als Function-Type deklariert (`((input: any) -> (boolean, number))`), aber keine einzige konkrete Puzzle-Instanz nutzt das.
- Kein Drag-and-Drop, keine Memory-Karten, kein Switch-Board — alles unimplementiert.
- **Quest-Integration fehlt:** HH_01 step_2 hat `type = "puzzle", target = "CraneTutorial"` — keine Implementierung, die das resolven könnte.

---

## M-06 Inventory & Collection

**Datei:** `roblox-studio/src/shared/Modules/M06_Inventory.lua` (34 Zeilen)
**Doc-Referenz:** `docs/09_system_architecture.md:172-205`

### Feature: Inventar/Sammlung-Datenmodell

**User Story:** Als Spieler:in möchte ich Items sammeln und in einem Inventar verwalten, damit ich sie für Bauquests einsetzen kann.

**Tatsächliches Verhalten:** Datei enthält ausschließlich Typ-Deklarationen. 34 Zeilen total. Keine Funktion.

**Status:** SKELETON
**Blocker / Fehler:**
- Keine Add/Remove/Get-Funktionen.
- Keine Material-Slots für Bauquests (HH_03 Werft benötigt `required_count = 4` für „Materials" — keine Logik dahinter).
- Keine Persistenz.
- **Disconnect zu M-02 Quest:** Quest-Rewards enthalten Items und Companions (`type = "Companion", item = "Curio_Seagull"`) — nichts davon landet im Inventar, weil weder M-02 noch M-06 Methoden haben.

---

## M-07 Economy & Shop System

**Datei:** `roblox-studio/src/shared/Modules/M07_Economy.lua` (146 Zeilen) + `server/Services/EconomyService.lua` (336 Zeilen)
**Doc-Referenz:** `docs/09_system_architecture.md:208-220`, `docs/10_economy_design.md`
**Decision-Referenz:** D-004, D-010 (KEIN Stamina, C-007)
**Test-Datei:** `src/tests/M07_Economy.spec.lua` (239 Zeilen, 20+ Specs)

### Feature: Währungs-Typen + Limits

**User Story:** Als Spieler:in möchte ich Gold und Gems als getrennte Währungen mit klaren Obergrenzen haben, damit die Wirtschaft balanciert ist.

**Tatsächliches Verhalten (`M07_Economy.lua:32-40`):**
- Typen `Wallet`, `CurrencyKind`, `CurrencyLimits` definiert.
- Limits: Gold SoftCap 999.999, Gems SoftCap 9.999. ✓

**Status:** DONE

### Feature: Compliance-Audit (kein Pay-to-Win)

**User Story:** Als Compliance-Owner möchte ich, dass jedes Shop-Item gegen die Whitelist `{Cosmetic, Comfort, Event, VIP}` geprüft wird, damit nichts versehentlich Power-Verkäufe sind.

**Tatsächliches Verhalten (`M07_Economy.lua:123-144`):**
- `AuditItem` prüft Kategorie gegen `AllowedCategories`, lehnt negative Preise ab.
- Tests (`M07_Economy.spec.lua:46-89`) verifizieren Reject von „Power" Category, negativen Preisen, leerer Kategorie. ✓

**Status:** DONE (mit Test-Abdeckung)

### Feature: VIP-Komfort-Pass (kosmetisch, kein Power-Boost)

**User Story:** Als Spieler:in möchte ich einen monatlichen VIP-Pass kaufen, der mir kosmetische Vorteile (Slots, Foto-Filter) bringt, aber KEINE Gameplay-Boosts.

**Tatsächliches Verhalten (`M07_Economy.lua:78-98`):**
- `VIP.Benefits` listet erlaubte Vorteile.
- `VIP.ForbiddenBenefits` listet explizit verbotene (`XPBoost`, `GoldBoost`, `GemsBoost`, `GameplayBoost`, `StaminaRefill`, `StorySkip`, `LearningTaskSkip`).
- Tests prüfen, dass die verbotenen Felder `nil` sind. ✓

**Status:** DONE (Modul-Definition). Server-Logik für echten Robux-Kauf ist in EconomyService.lua (siehe unten).

### Feature: Daily-Bonus (Anti-Frust, KEIN Stamina)

**User Story:** Als Spieler:in möchte ich einen täglichen Bonus auf Quest-Belohnungen, aber KEINE künstliche Wartezeit.

**Tatsächliches Verhalten (`M07_Economy.lua:68-72`):**
- `DailyBonus = { MaxCharges = 3, RechargeSeconds = 600, GoldMultiplier = 1.2 }`.
- Test (`M07_Economy.spec.lua:202-219`) verifiziert, dass kein Stamina/Energy-Feld existiert und Multiplier 1.2 ist. ✓

**Status:** DONE (Modul), aber siehe Server-Audit unten für die Integration.

### Feature: Wallet-Logik Server (EconomyService)

**Tatsächliches Verhalten (`EconomyService.lua`):**
- `:GetBalance`, `:AddGold`, `:AddGems`, `:SpendGold`, `:SpendGems`, `:TryPurchase`, `:GrantVip`, `:GetDailyBonus`.
- Auto-Save alle 60 Sek via `task.spawn`.
- MarketplaceService.ProcessReceipt mit Idempotency (`processedReceipts`) verhindert Replay-Double-Grants.
- C-019 explizite Logging-Statements für Eltern-Streitfälle.
- Atomic Deduct (vermeidet die C-3 Race-Bedigung, die im TestRunner-Kommentar dokumentiert ist).

**Status:** DONE (Server-Seite)
**Restrisiken / Bemerkungen:**
- **Race in `CanAfford`:** Bei einem Item mit BEIDE `PriceGold` UND `PriceGems` prüft `CanAfford` (Zeile 109-120) jede Währung unabhängig — `if PriceGold and Gold < PriceGold`, dann `if PriceGems and Gems < PriceGems`. **Wenn beide Preise verlangt werden und nur eine Währung reicht, schlägt CanAfford fehl** mit `not_enough_gold` oder `not_enough_gems`, ohne den jeweils anderen Pfad zu prüfen. Das ist im aktuellen Datenmodell OK (Items haben jeweils nur einen Preis), aber künftige Items mit Gold+Gems-Pflicht-Preis hätten einen Bug. Aktuell kein Item im Code, also latent.
- **`os.time()` vs `DateTime.now()`:** EconomyService verwendet `os.time()` durchgängig (Zeilen 82, 86, 105, 115, 203, 209, 224, 230, 234, 236). Roblox `os.time()` ist DST-anfällig und liefert nur Sekunden-Präzision. `DateTime.now().UnixTimestamp` wäre robuster.
- **Doppelte Service-Requires:** `EconomyService.lua:16, 19` — `local ReplicatedStorage = game:GetService("ReplicatedStorage")` wird zweimal deklariert. Lua erlaubt das, aber es ist Code-Smell.
- **`wallet.Gold -= item.PriceGold` ohne Bound-Check:** Zeile 170 — wenn `CanAfford` true zurückgab, ist die Subtraktion OK, aber bei zukünftigen Refactorings muss darauf geachtet werden.

### Feature: Daily-Bonus-Anwendung

**Tatsächliches Verhalten (`EconomyService.lua:79-84`):**
```lua
local db = dailyBonus[player]
if db and db.Charges > 0 and amount > 0 then
    amount = math.floor(amount * M07_Economy.DailyBonus.GoldMultiplier)
    db.Charges -= 1
end
```
Funktional. ✓ Aber **kein UI-Signal an Client** — der Spieler merkt nichts vom Bonus. „Unsichtbar" ist OK (D-005), aber eine Telemetrie-Auswertung muss später zeigen, ob Spieler den +20%-Bonus überhaupt wahrnehmen.

### Feature: Telemetry-Integration

**Tatsächliches Verhalten:** `TelemetryService:Track(player, "economy.gold.added", {...})` etc. durchgängig.
**TelemetryService selbst:** In-Memory-Buffer (Phase 2 Stub), `HashPlayerId` mit trivialem Hash (Zeile 31-39) — kein SHA256/salt; **nicht kryptographisch**, aber OK für Anonymisierung.
**Auto-Flush alle 30s via `task.spawn`** und `game:BindToClose` für Server-Shutdown. ✓

**Status:** DONE

### Feature: SaveService

**Tatsächliches Verhalten (`SaveService.lua`):**
- `LoadWallet` / `SaveWallet` mit DataStore-Wrapper.
- Verschlüsselungs-Stub: `encryptField` setzt nur ein `"ENC:"` Prefix (Zeile 62). **Keine echte Verschlüsselung.**
- Auto-Save alle 60 Sek via EconomyService.

**Status:** PARTIAL
**Blocker / Fehler:**
- **Verschlüsselung ist Theater.** `ENC:<plaintext>` ist lesbar. Kommentar sagt selbst „KEINE echte Sicherheit; nur Markierung" — die `docs/09_system_architecture.md:330` aber sagt „Verschlüsselung sensibler Felder" und `02_compliance_matrix.md` C-019 verlangt das für DSGVO/COPPA. **Compliance-Lücke.**
- `SAVE_VERSION = 1` — keine Migration-Strategie dokumentiert.

### Feature: Auto-Discovery-Test-Bug (global, betrifft auch M-07)

**Tatsache (`TestRunner.server.lua:45`):**
```lua
if child:IsA("ModuleScript") and string.match(child.Name, "%.spec$") then
```
**Das Pattern `%.spec$` matcht Dateinamen, die mit `.spec` enden.** Die vorhandenen Test-Dateien heißen `M07_Economy.spec.lua` und `M15_Localization.spec.lua` — sie enden mit `.lua`, nicht mit `.spec`. **=> Der TestRunner findet keine einzige Spec und führt keine Tests aus.**

Das wurde mit dem Bash-Output verifiziert: bei `Tests` Folder-Mapping (default.project.json zeigt `"Tests": "$path": "src/tests"`), enthält das Folder diese Dateien mit der Endung `.spec.lua`. Der TestRunner wird also beim Start "[TestRunner] No test specs found at ReplicatedStorage.Shared.Tests" loggen — was im Code-Pfad Zeile 55 als `warn` steht, aber wegen `Log:Debug`-Gating der Telemetrie möglicherweise nie sichtbar wird.

**Konsequenz:** Selbst die vorhandenen M-07-Tests laufen faktisch nicht. **Die ganze „Test-Abdeckung" ist tot.**

---

## M-08 Adaptive Difficulty (Alias auf M-04)

**Spec-Referenz:** `docs/09_system_architecture.md:222-225` — „M-08 Adaptive Difficulty Engine — Siehe M-04 / `12_adaptive_difficulty_model.md`."

Da M-08 ein dokumentarischer Alias auf M-04 ist und keine eigene Datei existiert, ist der Audit für M-08 identisch mit M-04 (siehe oben).

**Status:** IDENTISCH MIT M-04

**Zusatz-Befund:** Die in `docs/12_adaptive_difficulty_model.md:115-127` beschriebenen **Anpassungshebel** (Tiefenstufe, Aufgabenkomplexität, Hilfetiefe, Sprachkomplexität, Tempo, Wiederholungsfrequenz, Abstraktionsgrad) sind im Modul **nicht alle abgedeckt** — z.B. „Aufgabenkomplexität" und „Abstraktionsgrad" fehlen komplett in der `AdaptiveRecommendation`-Typ-Definition.

---

## Cross-Cutting-Befunde (modulübergreifend)

### Befund A: Modul-Disconnect Quest ↔ Adaptive ↔ Inventory

**Was:** `M02_Quest.lua` (StartQuest / AdvanceStep / Complete) ruft weder `M04_Adaptive:Recommend` noch `M06_Inventory:Add` auf. Die drei Module kennen sich gegenseitig nicht.

**Spec:** `docs/09_system_architecture.md:443-458` zeigt explizit die Pfeile `M-02 → M-04`, `M-02 → M-06`.

**Konsequenz:** Wenn das Spiel morgen live ginge, könnte eine Quest gestartet, abgeschlossen und mit Rewards „belohnt" werden, aber: das Kompetenzprofil würde sich nie anpassen, das Inventar würde leer bleiben, der adaptive Schwierigkeitshebel würde nicht greifen. **Kein einziges Cross-Module-Feature funktioniert.**

### Befund B: Kein Server-Authoritative-Schutz in den Modul-APIs

**Was:** `M02_Quest:StartQuest`, `M04_Adaptive:RecordSignal`, `M04_Adaptive:Recommend` haben kein `if RunService:IsServer()`-Guard. Theoretisch könnte ein Client-Modul sie aufrufen und Werte setzen.

**Spec:** Skill S4 in `AGENTS.md` §2.2: „Server-Authoritative für Lern-Antworten (Anti-Cheat)".

**Konsequenz:** Aktuell existiert kein Server-Wrapper für M02/M04. `EconomyService.lua` ist server-only, weil es über Bootstrap geladen wird — aber Quest/Adaptive haben keinen Server-Wrapper.

### Befund C: Telemetry-Buffer flush verliert Events

**Was:** `TelemetryService.lua:68-86` — `Flush()` leert den Buffer mit `table.clear(buffer)`, **ohne ihn vorher an einen Backend-Endpoint zu schicken**. Der Kommentar sagt `TODO Phase 3: HttpService:PostAsync(...)`. Events gehen also verloren.

**Spec:** `docs/14_telemetry_plan.md` (vermutlich, nicht in Audit-Scope eingelesen).

**Konsequenz:** Alle Telemetrie-Events aus EconomyService, SaveService etc. werden **nie persistiert**. Compliance-Audit-Trail (C-019) ist damit faktisch inexistent.

### Befund D: Client-Bootstrap ohne UI

**Was:** `Bootstrap.client.lua:42-48`:
```lua
local wallet = economy:GetBalance(player)
if wallet then Log:Info("Wallet loaded:", wallet) end
-- TODO Phase 3: roact-based HUD widgets
```
Es gibt **keine UI-Controller**. Der Ordner `src/client/Controllers` ist leer. Spieler sehen nichts.

**Konsequenz:** Es gibt kein Spiel-UI. Kein HUD, kein Quest-Tracker, kein Inventar.

### Befund E: MapBuilder ohne Tests

**Was:** `Bootstrap.server.lua:36-43` ruft `MapBuilder:Validate(HamburgHarborData)` auf und **bricht den Build ab**, wenn die Validierung fehlschlägt. Aber es gibt keine Test-Spec für `MapBuilder.Validate` — ein zukünftiger Refactor könnte die Validierung subtil kaputtmachen, ohne dass es ein CI fängt.

### Befund F: Doc-Code-Drift bei Domänen

**Was:** `docs/12_adaptive_difficulty_model.md:57-67` listet Domänen „math, physics, chemistry, english, informatics, logic, language, memory, planning" (9 Domänen). `M04_Adaptive.lua:21` deklariert `Domain = "Math" | "Physics" | "Logic" | "Language" | "Memory" | "Planning" | "Chemistry" | "Coding"` (8 Domänen, mit „Coding" statt „informatics" und ohne „english").

**Konsequenz:** Domänen-Mismatch zwischen Pädagogik-Doc und Implementierung. Telemetrie-Events mit `domain = "english"` (aus dem pädagogischen Spec) würden von der Engine abgelehnt (`if not d then return end`).

### Befund G: Kein Altersband-Filter trotz Persona-Spec

**Was:** `M02_Quest.lua:202-213` `StartQuest` prüft `quest.age_band_target` nicht. Alle Spieler können alle Quests starten.

**Spec:** `docs/03_target_audience.md:20-102` — strikte Altersbänder A/B/C; Quest `age_band_target` ist im Quest-Typ dokumentiert (`M02_Quest.lua:40`).

**Konsequenz:** 9-Jährige könnten Quests starten, die für 14–16-Jährige gedacht sind. Pädagogisch und compliance-mäßig problematisch.

### Befund H: Kein lokalisierter String vorhanden (außerhalb Scope, aber kontextuell)

**Was:** M02/M03 verwenden `title_key`, `description_key`, `text_key` für Lokalisierung. Aber `M15_Localization.lua` ist außerhalb dieses Audit-Scopes. Es ist unklar, ob die Keys (`quest.hh_01.title` etc.) überhaupt aufgelöst werden.

**Status:** Nicht in diesem Audit geprüft. Vermerk für nächsten Audit-Pass.

---

## Production-Readiness-Verdict pro Modul

| Modul | Production-Ready? | Begründung |
|---|---|---|
| M-01 PlayerController | NEIN | Kran-Schwingen fehlt komplett; JumpPower/JumpHeight-Konflikt; Touch-Input fehlt; keine Tests |
| M-02 Quest | NEIN | completion_condition ist hartcodiert; Prerequisites ignoriert; Rewards nie vergeben; keine Server-Authority; keine Tests |
| M-03 Dialogue | NEIN | Nur Typen; keine Funktion; keine Sample-Dialoge; keine Tests |
| M-04 Adaptive | NEIN | Keine Persistenz; kein Trend-Window; Trend-Bug; Domänen-Mismatch; keine Quest-Integration; keine Tests |
| M-05 Puzzle | NEIN | Nur Typen; keine Puzzle-Instanzen; keine Drag-and-Drop-Logik; keine Tests |
| M-06 Inventory | NEIN | Nur Typen; keine Add/Remove-Logik; keine Persistenz; keine Quest-Integration; keine Tests |
| M-07 Economy | TEILWEISE | Modul-Definition + EconomyService + SaveService sind solide; **Aber:** Test-Auto-Discovery ist kaputt (Tests laufen nicht); Verschlüsselung ist Theater; Telemetrie-Buffer verliert Events |
| M-08 (Alias M-04) | NEIN | identisch mit M-04 |

**Gesamtfazit:** Für Production-Release (Premium-Standard gem. AGENTS.md §11) ist **keines** der 7 Kernmodule bereit. Das Projekt ist im **Skeleton-/Stub-Stadium** mit einem produktionsnahen Wirtschafts-Sub-System.

---

## Empfohlene nächste Schritte (priorisiert)

1. **Fix `TestRunner.server.lua`** Pattern: `%.spec$` → `%.spec%.lua$` (oder `%.lua$` mit EndsWith-Filter), damit die vorhandenen M-07/M-15-Tests überhaupt laufen.
2. **Implementiere `M02_Quest` Completion-Logik** mit echten Conditions (Mindestens: Server-seitige Trigger-API, an die Puzzles/Objectives andocken können).
3. **Implementiere `M02_Quest → EconomyService`-Verdrahtung** für Reward-Vergabe (StartQuest → leer, Complete → `EconomyService:AddGold/AddGems`).
4. **Implementiere `M02_Quest → M06_Inventory`-Verdrahtung** für Item-/Companion-Rewards.
5. **Implementiere `M02_Quest → M04_Adaptive`-Verdrahtung** für Difficulty-Empfehlung pro Quest-Step.
6. **Schreibe Profile-Persistierung** in SaveService + 5-Min-Auto-Save.
7. **Ersetze Verschlüsselungs-Stub** durch echte Verschlüsselung sensibler Felder.
8. **Implementiere Puzzles** für Hamburg-Harbor-Vertical-Slice (5 Stück laut Spec).
9. **Ersetze Telemetrie-Buffer-Stub** durch echtes Backend-POST.
10. **Altersband-Filter** in StartQuest einbauen.
11. **Test-Coverage** auf 80 % (Premium-Schwelle) bringen — Module ohne Tests: M-01, M-02, M-03, M-04, M-05, M-06 + MapBuilder.

---

*Ende des Audits. Für Fragen oder Erläuterungen: Verifier-Session `mvs_cd70008bca9a4cf19bb0350290ddd2fd`.*
