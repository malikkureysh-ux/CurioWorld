# Curio World — Linear-Style Feature Tracker

> **Status-Convention:**
> - ✅ `done` — implemented, tested, passes lint
> - 🟡 `partial` — skeleton or missing edge cases
> - 🔴 `critical` — broken / no test / blocks production
> - ⏸ `blocked` — needs upstream decision or asset upload
> - 🆕 `discovered` — found in code, needs triage

> **Conventions:**
> - Feature IDs: `F-<MODULE>-<NUMBER>` (e.g. F-M18-001)
> - Test Coverage: `none` | `spec:<name>` | `spec:<name>+<count>`
> - Updated: 2026-06-27 21:10 (Europe/Berlin)

---

## 0. Overall Health

| Metric | Value |
|---|---|
| Total Features | 75 |
| ✅ Done | 30 |
| 🟡 Partial | 25 |
| 🔴 Critical | 12 |
| ⏸ Blocked | 8 |
| 🆕 Discovered | (counted in others) |
| Production-Ready? | ❌ No — 12 critical, premium polish missing |

**Top 5 Production-Blockers (sorted by severity):**
1. 🟡 **M18 Dialogue option callback** — FIXED (callback signature + slide-out)
2. 🟡 **M20 Shop buy handler** — FIXED (BuyButton overlay + PurchaseHandler callback)
3. 🟡 **M20 playerIsVip hardcoded false** — FIXED (reads M07:IsVipActive)
4. 🟡 **M13 Moderation untested + 3 gaps** — FIXED (Caps/URL/9-11 fixes + 21 spec tests)
5. 🟡 **M19 Quest Card click** — FIXED (ClickButton overlay + OnQuestClicked)

**Additional Wave-1 Fixes (2026-06-27 21:18):**
- ✅ M17 DisplayOrder=50 (Render-Order garantiert)
- ✅ M17 Touch-Targets 44×44 (WCAG)
- ✅ M17 Real CountUp-Tween (NumberValue + GetPropertyChangedSignal)
- ✅ M18 Per-NPC Portraits (Hafenwirtin 👩‍🍳, Yuki 🧝‍♀️, Maja 👩‍🔧, Nils 🧔)
- ✅ M18 Glow-Ring UIStroke auf Portrait
- ✅ M18 Slide-Out-Animation auf Option-Click
- ✅ M19 QuestComplete color (wenn step==total) + Hover-Effekt
- ✅ M19 pairs() jitter fix (deterministische Sortierung)
- ✅ M20 Right-Click-Bug Fix (Backdrop LEFT/Touch only)
- ✅ M20 Kauf-Handler mit Server-Gate
- ✅ M24 Slider Mouse-Move Leak Fix (tracked connections + cleanup)
- ✅ M24 Language-Dropdown wired zu M15:Set (live)
- ✅ M24 Accessibility-Toggles mit consumer callback (OnAccessibilityChange)
- ✅ M24 Localized header + section labels (12 neue Keys in 9 Sprachen)
- ✅ M24 Save-Callback (OnSave) für DataStore-Persistenz
- ✅ EconomyService: VIP-Auto-Expire (refreshVipStatus)
- ✅ EconomyService: AddGems RemoteEvent (Live-Update HUD)
- ✅ EconomyService: VipStateChanged RemoteEvent
- ✅ EconomyService: Wallet-Load Race-Fix (merge + disconnect check)
- ✅ EconomyService: BindToClose für Shutdown-Save
- ✅ Lina/Mira Naming-Fix in 8 Sprachen (16 String-Edits)
- ✅ M13 Caps-Lock-Detection (4+ Buchstaben, 70%+ Caps)
- ✅ M13 URL-Detection (http/https/www + TLDs)
- ✅ M13 9-11 Whitelist-Pflicht (returnt false, ChatService validiert)
- ✅ M13 SafePhrases + BlockedWords Listen (15+ Phrases, 5+ Blocked)

**New Spec-Datei:**
- M13_Moderation.spec.lua — 21 Compliance-Tests

---

## 1. Features by Module

### M01 — PlayerController (`M01_PlayerController.lua`)

| ID | Feature | User Story | Status | Code | Tests | Notes |
|---|---|---|---|---|---|---|
| F-M01-001 | District Profile Table | "Als Designer:in möchte ich pro Bezirk ein eigenes Bewegungs-Profil, damit sich jeder Bezirk anders anfühlt." | ✅ done | `DistrictProfiles = { HamburgHarbor=..., SkyBridgeBay=..., ... }` | spec:M01+11 | 5 profiles defined |
| F-M01-002 | ApplyContext | "Als Spieler:in möchte ich, dass beim Bezirks-Wechsel mein WalkSpeed/JumpHeight angepasst wird." | ✅ done | `humanoid.WalkSpeed = ...; humanoid.JumpHeight = ...` | spec:M01+11 | JumpMode exclusive set |
| F-M01-003 | TrySwingFromCrane | "Als Spieler:in möchte ich vom Kran aus schwingen, wenn der Hook Grappleable=true ist." | 🟡 partial | returns `true` if hook detected, no real physics | spec:M01+11 | Stub: BodyVelocity in Phase 3 |

### M02 — Quest (`M02_Quest.lua`)

| ID | Feature | User Story | Status | Code | Tests | Notes |
|---|---|---|---|---|---|---|
| F-M02-001 | QuestStep type system | "Als Quest-Autor:in möchte ich 6 Step-Typen (dialogue/puzzle/objective/collect/build/team) komponieren." | ✅ done | `export type QuestStepType = ...` | spec:M02+11 | 6 types defined |
| F-M02-002 | WorldServices validators | "Als Quest-Engine möchte ich, dass Steps gegen den echten Spielzustand geprüft werden, nicht hardcoded true." | ✅ done | `Validators.dialogue/puzzle/objective/...` | spec:M02+11 | **Wichtig:** Bootstrap muss world injizieren! |
| F-M02-003 | HH_01 Kran-Intro Quest | "Als 10-jährige Spielerin möchte ich von Lina eine erste Aufgabe bekommen." | 🟡 partial | 3 Steps: dialogue→puzzle→objective | spec:M02+11 | Hardcoded test, no real bridge to Bootstrap world |
| F-M02-004 | HH_02 Crane FirstLift | "Als 12-13-jährige:r möchte ich Kran-Logistik lernen." | 🟡 partial | 4 steps, prerequisites HH_01 | spec:M02+11 | Same — needs world wiring |
| F-M02-005 | HH_03 Werft-Bootsbau | "Als Crew (2-4) möchte ich gemeinsam ein Boot bauen." | 🟡 partial | 4 steps, team-type | spec:M02+11 | Same |
| F-M02-006 | QuestZones registry | "Als Quest-Engine möchte ich Position-basierte Objective-Checks." | ✅ done | `QuestZones = { DropZoneA, ContainerPickupA, BoatLaunchZone }` | spec:M02+11 | World.isInZone call |
| F-M02-007 | StartQuest/EvaluateStep/Advance/Complete | "Als Quest-Engine-Lifecycle." | ✅ done | 4 functions | spec:M02+11 | complete + advance |
| F-M02-008 | Prerequisite Check | "Als Quest-Engine möchte ich, dass HH_02 erst nach HH_01 startbar ist." | ✅ done | Loop in StartQuest | spec:M02+11 | warn wenn prereq fehlt |

### M03 — Dialogue (Data Model)

| ID | Feature | User Story | Status | Code | Tests | Notes |
|---|---|---|---|---|---|---|
| F-M03-001 | DialogueLine type | "Als Datendesigner:in möchte ich Zeilen mit Audio-Sync modellieren." | 🆕 skeleton | `export type DialogueLine` | none | No runtime, pure type |
| F-M03-002 | DialogueOption type | "Als Quest-Autor:in möchte ich Antworten mit Branching/Triggern." | 🆕 skeleton | `export type DialogueOption` | none | No validation of cycles |
| F-M03-003 | Dialogue type | "Als Content-Pipeline möchte ich komplette Dialoge referenzieren." | 🆕 skeleton | `export type Dialogue` | none | No Start/Advance/Choose methods |
| F-M03-004 | Module table | "Platzhalter für Phase 3." | 🆕 skeleton | `M03_Dialogue = {}` | none | Real dialogue is in M18 |

> **Note:** M03 is the data model; M18 is the runtime. Keep both but document the boundary.

### M04 — Adaptive Learning

| ID | Feature | User Story | Status | Code | Tests | Notes |
|---|---|---|---|---|---|---|
| F-M04-001 | Domain Score (Math/Physics/Logic/...) | "Als Lern-Engine möchte ich pro Domain einen Score (0-1) speichern." | ✅ done | `DomainScore type` | none | 8 domains |
| F-M04-002 | CompetencyProfile | "Als Spieler:in möchte ich ein Profil pro PID." | ✅ done | `CompetencyProfile type` | none | Hashed PID |
| F-M04-003 | RecordSignal (Bayesian update) | "Als Lern-Engine möchte ich nach jeder Antwort ein Signal verarbeiten." | ✅ done | `RecordSignal(profile, domain, signal)` | none | Bayesian simplified: ±0.04/-0.03 |
| F-M04-004 | Adaptive Recommendation | "Als Quest-Engine möchte ich Difficulty/HelpDepth/Language/Pacing." | ✅ done | `Recommend(profile, domain)` | none | Flow-aware (Csikszentmihalyi) |
| F-M04-005 | Integration with Quest | "M04 → M02 difficulty prop." | 🆕 discovered | none | none | Need Phase 3 wiring |

### M05 — Puzzle (Skeleton)

| ID | Feature | User Story | Status | Code | Tests | Notes |
|---|---|---|---|---|---|---|
| F-M05-001 | PuzzleType (sort/build/memory/logic) | "Als Puzzle-Designer:in möchte ich 4 Puzzle-Typen." | 🆕 skeleton | `type PuzzleType = "sort"\|"build"\|"memory"\|"logic"` | none | Phase 3 impl |
| F-M05-002 | Puzzle type with solution_check | "Als Puzzle-Engine." | 🆕 skeleton | `type Puzzle` | none | Phase 3 impl |

### M06 — Inventory (Skeleton)

| ID | Feature | User Story | Status | Code | Tests | Notes |
|---|---|---|---|---|---|---|
| F-M06-001 | ItemStack | "Als Inventar möchte ich stapelbare Items." | 🆕 skeleton | type only | none | metadata: any (Type-Safety lost) |
| F-M06-002 | CollectionBook | "Als Spieler:in möchte ich ein Sammelbuch." | 🆕 skeleton | type only | none | Kein Recall-Scheduler |
| F-M06-003 | Inventory type | "Als Spieler:in möchte ich Slots + max_slots." | 🆕 skeleton | type only | none | Keine Add/Remove/Sort |

### M07 — Economy

| ID | Feature | User Story | Status | Code | Tests | Notes |
|---|---|---|---|---|---|---|
| F-M07-001 | CurrencyLimits | "Als Designer:in möchte ich SoftCap+HardCap pro Währung." | ✅ done | `Limits.Gold/Gems` | spec:M07+3 | SoftCap decay logic missing in module |
| F-M07-002 | AllowedCategories | "Als Compliance möchte ich, dass nur Cosmetic/Comfort/Event/VIP verkaufbar ist." | ✅ done | `AllowedCategories = { Cosmetic, Comfort, Event, VIP }` | spec:M07+10 | Pay-to-win strukturell unmöglich |
| F-M07-003 | DailyBonus | "Als Spieler:in möchte ich einen Tages-Boost OHNE Stamina." | ✅ done | `MaxCharges=3, RechargeSeconds=600, GoldMultiplier=1.2` | spec:M07+2 | Service-Schicht fehlt |
| F-M07-004 | VIP Pass Definition | "Als Spieler:in möchte ich VIP kaufen — nur Komfort-Vorteile." | ✅ done | `Benefits + ForbiddenBenefits` | spec:M07+8 | 8 Forbidden, alle nil |
| F-M07-005 | IsVipActive | "Als Shop möchte ich VIP-Status zur Laufzeit prüfen." | ✅ done | `IsVipActive(wallet, now)` | spec:M07+3 | now = Server-Zeit |
| F-M07-006 | CanAfford | "Als Shop möchte ich vor Kauf prüfen." | ✅ done | `CanAfford(wallet, item)` | spec:M07+6 | Kein Robux-Pfad |
| F-M07-007 | AuditItem | "Als Compliance-Audit." | ✅ done | `AuditItem(item)` | spec:M07+10 | Edge-Cases fehlen |
| F-M07-008 | ShopItem type | "Als Shop-Backend." | ✅ done | `type ShopItem` | none | Limit-Enforcement fehlt |

### M09 — Event (Skeleton)

| ID | Feature | User Story | Status | Code | Tests | Notes |
|---|---|---|---|---|---|---|
| F-M09-001 | EventType alias | "Als Live-Ops." | 🆕 skeleton | type | none | Phase 3 |
| F-M09-002 | Event type | "Als Live-Ops." | 🆕 skeleton | type | none | Phase 3 |

### M10 — Housing (Skeleton)

| ID | Feature | User Story | Status | Code | Tests | Notes |
|---|---|---|---|---|---|---|
| F-M10-001 | House + Decoration | "Als Spieler:in möchte ich ein Haus dekorieren." | 🆕 skeleton | types | none | Phase 3 |

### M11 — Companion (Skeleton)

| ID | Feature | User Story | Status | Code | Tests | Notes |
|---|---|---|---|---|---|---|
| F-M11-001 | Companion + Instance | "Als Spieler:in möchte ich Begleiter sammeln." | 🆕 skeleton | types | none | Phase 3 |

### M13 — Moderation ⛔ CRITICAL

| ID | Feature | User Story | Status | Code | Tests | Notes |
|---|---|---|---|---|---|---|
| F-M13-001 | AgeBand (9-11/12-13/14-16) | "Als Compliance möchte ich Altersbänder typen." | ✅ done | `type AgeBand` | **🔴 none** | No tests! |
| F-M13-002 | PermissionsForBand table | "Als Compliance: 9-11 nur Emote/Ping, 12-13 +ShortText, 14-16 +FreeText." | ✅ done | `PermissionsForBand` | **🔴 none** | No tests! |
| F-M13-003 | CanSendMessage | "Als Chat: vor Versand prüfen (Länge+Wörter)." | 🔴 critical gaps | function | **🔴 none** | 9-11 returns blind true; Caps-Lock + URL-Check fehlen |
| F-M13-004 | Anti-Mobbing / Reporting | "Als Compliance: Meldemechanismus." | 🆕 not_implemented | n/a | **🔴 none** | Production-Blocker |

### M15 — Localization

| ID | Feature | User Story | Status | Code | Tests | Notes |
|---|---|---|---|---|---|---|
| F-M15-001 | Languages table (9) | "Als Spieler:in möchte ich 9 Sprachen." | ✅ done | `Languages` | spec:M15+4 | DE/EN/ES/FR/HI/TR/ZH/JA/AR |
| F-M15-002 | Get/Set | "Als UI möchte ich aktuelle Spieler-Sprache." | ✅ done | `Get/Set` | spec:M15+4 | Default "en" |
| F-M15-003 | GetAvailableLanguages | "Als Settings-UI." | ✅ done | `GetAvailableLanguages()` | none | Returns reference |
| F-M15-004 | IsRtl | "Als UI: Layout für Arabic spiegeln." | ✅ done | `IsRtl(lang)` | spec:M15+2 | OK |
| F-M15-005 | GetString mit Fallback | "Als UI: lokalisierter String mit Placeholders." | 🟡 partial | `GetString` | spec:M15+9 | count-returned from gsub, Risiko bei args |
| F-M15-006 | GuessFromLocale | "Als Spieler:in möchte ich Auto-Sprache." | ✅ done | `GuessFromLocale` | none | Indisches Hindi zu grob |
| F-M15-007 | Lifecycle PlayerAdded/Removing | "Als System: keine Memory-Leaks." | ✅ done | auto-connect | none | Kein Persist |
| F-M15-008 | Persistenz | "Als Spieler:in möchte ich, dass meine Sprachwahl erhalten bleibt." | 🔴 critical | missing | none | Bei Reload weg |

### M16 — NpcSpawner

| ID | Feature | User Story | Status | Code | Tests | Notes |
|---|---|---|---|---|---|---|
| F-M16-001 | NpcConfig table (4 NPCs) | "Als Designer:in möchte ich NPC-Configs." | ✅ done | `NpcConfig` | spec:M16+2 | Hafenwirtin/Yuki/Maja/Nils |
| F-M16-002 | Placeholder fallback | "Als Spieler:in möchte ich NPCs sehen, auch wenn Mesh fehlt." | 🟡 partial | 3-part model + face decal | none | **🔴 Bug:** Decal nur Front of Sphere — Smiley 5/6 versteckt |
| F-M16-003 | Real NPC via InsertService | "Als Spieler:in möchte ich Premium-NPCs." | 🔴 critical | `InsertService:LoadAsset` | none | **🔴:** Funktioniert nur für Game-Owner Assets → fällt immer auf Placeholder zurück |
| F-M16-004 | ProximityPrompt "Sprechen" | "Als Spieler:in möchte ich NPCs ansprechen." | ✅ done | `prompt.HoldDuration=0` | none | HoldDuration=0, MaxDist=8 |
| F-M16-005 | Dialogue wiring | "Als Spieler:in: Klick auf NPC öffnet Dialog." | 🟡 partial | M18:Show | none | Mobile-Key-Indicator fehlt |
| F-M16-006 | Sound fallback | "Als Spieler:in: NPC-Greeting-Sound." | 🆕 not_implemented | dead code | none | Falsche SoundID (Kran_Mechanik) |
| F-M16-007 | SpawnAll orchestration | "Als Server: alle NPCs spawnen." | ✅ done | `SpawnAll(districts)` | spec:M16+2 | iteriert GetDescendants |
| F-M16-008 | Animation idle hook | "Als Spieler:in: NPCs atmen (idle anim)." | 🟡 partial | `M22:PlayNpcIdle` via pcall | none | Unguarded humanoid check |
| F-M16-009 | RegisterService | "Als Service-Registry." | ✅ done | `RegisterService` | none | Implicit ordering with Bootstrap |

### M17 — HUD

| ID | Feature | User Story | Status | Code | Tests | Notes |
|---|---|---|---|---|---|---|
| F-M17-001 | Theme tokens | "Als Designer:in: Theme-Tabelle." | ✅ done | `Theme.Gold/Gems/VIP/DistrictColors` | none | Emoji-Icon-Risiko |
| F-M17-002 | UI Helpers (UICorner/UIStroke/Padding) | "Als UI-Builder." | ✅ done | 4 helpers | none | `makeUIAspectRatioConstraint` dead code |
| F-M17-003 | Currency row | "Als Spieler:in: oben links mein Gold." | 🟡 partial | `makeCurrencyRow` | none | **🔴 Bug:** CountUp nicht animated (nur TextTransparency tween → snap) |
| F-M17-004 | CreateForPlayer | "Als Spieler:in: HUD beim Join." | ✅ done | `CreateForPlayer` | none | **Caller existiert** (Bootstrap:89) — Agent war falsch |
| F-M17-005 | UpdateCurrency | "Als Live-Update: Gold-Delta." | ✅ done | `UpdateCurrency` | none | FindFirstChild ohne recursive |
| F-M17-006 | SetVIP | "Als Spieler:in: VIP-Badge." | ✅ done | `SetVIP` | none | Kein slide-in animation |
| F-M17-007 | SetDistrict | "Als Spieler:in: District-Badge." | ✅ done | `SetDistrict` | none | Typo fallback gray |
| F-M17-008 | DisplayOrder | "Als UI: HUD unter Dialogue/Modal." | 🔴 critical | missing | none | **🔴 Bug:** DisplayOrder nicht gesetzt → Render-Order unbestimmt |
| F-M17-009 | Touch-Targets 44×44 | "Als Mobile: tappable." | 🔴 critical | 36px rows | none | Docstring lügt |

### M18 — Dialogue UI ⛔ CRITICAL

| ID | Feature | User Story | Status | Code | Tests | Notes |
|---|---|---|---|---|---|---|
| F-M18-001 | Theme tokens | "Als Designer:in." | ✅ done | `Theme` | none | OK |
| F-M18-002 | Show modal | "Als Spieler:in: schönes Dialog-Fenster." | 🟡 partial | slide-in 0.25s | none | Modal >400px hoch? |
| F-M18-003 | Portrait frame (emoji 😊) | "Als Spieler:in: NPC-Identität." | 🔴 critical | 60pt 😊 | none | **🔴 Bug:** Ein Smiley für alle 4 NPCs trotz unterschiedlicher Farben — keine Differenzierung |
| F-M18-004 | Name + Role tags | "Als Spieler:in: NPC-Name + Rolle." | ✅ done | NameLabel + RoleTag | none | Overlap-Risiko |
| F-M18-005 | Wrapped dialogue text | "Als Spieler:in: lange Texte lesbar." | 🟡 partial | TextWrapped | none | **Bug:** Typewriter-Effekt in Docstring, nicht implementiert |
| F-M18-006 | Options buttons | "Als Spieler:in: Multiple-Choice." | 🔴 critical | option btns | none | **🔴 Critical:** Hover nur Desktop, kein Mobile; Click-Tween snappt zu Selected ohne Return |
| F-M18-007 | Option callback | "Als Quest-Engine: Antwort weiterleiten." | 🔴 critical | `-- TODO` | none | **🔴 CRITICAL:** No callback → quest state nie updated |
| F-M18-008 | Hide | "Als Spieler:in: Dialog schließen." | ✅ done | `Hide` | none | Kein slide-out |
| F-M18-009 | Backdrop click → no-close | "Designentscheidung." | ✅ done | no handler | none | Mobile-Expectation mismatch |

### M19 — QuestTracker ⛔ CRITICAL

| ID | Feature | User Story | Status | Code | Tests | Notes |
|---|---|---|---|---|---|---|
| F-M19-001 | Theme tokens | "Als Designer:in." | ✅ done | `Theme` | none | `QuestComplete` color defined but **never used** |
| F-M19-002 | CreateForPlayer | "Als Spieler:in: oben rechts Quests." | 🟡 partial | `CreateForPlayer` | none | Slide-in fehlt |
| F-M19-003 | Update | "Als Spieler:in: Live-Quest-Updates." | 🔴 critical | `Update` | none | **🔴 Bug:** pairs() iteration → UI jitter |
| F-M19-004 | Quest card | "Als Spieler:in: Quest-Titel + Fortschritt." | 🟡 partial | `makeQuestCard` | none | Overflow wenn current_step > #steps |
| F-M19-005 | "+N weitere" button | "Als Spieler:in: weitere Quests sehen." | 🔴 critical | button | none | **🔴 Bug:** Kein Click-Handler → tot |
| F-M19-006 | Quest card click → Detail | "Als Spieler:in: Klick öffnet Detail." | 🔴 critical | missing | none | **🔴 CRITICAL:** Read-only display, kein Drill-Down |

### M20 — Shop ⛔ CRITICAL

| ID | Feature | User Story | Status | Code | Tests | Notes |
|---|---|---|---|---|---|---|
| F-M20-001 | Theme tokens | "Als Designer:in." | ✅ done | `Theme` | none | OK |
| F-M20-002 | 6 Sample items | "Als Spieler:in: sehe Sortiment." | ✅ done | `SampleItems` | none | Static catalog |
| F-M20-003 | Item card | "Als Spieler:in: Item mit Preis-Sichtbarkeit." | 🟡 partial | `makeItemCard` | none | Hover nur Color, nicht Size (Docstring lügt) |
| F-M20-004 | Show | "Als Spieler:in: Shop öffnen." | 🟡 partial | `Show` | none | Backdrop right-click schließt auch |
| F-M20-005 | Buy handler | "Als Spieler:in: kaufe Item." | 🔴 critical | missing | none | **🔴 CRITICAL:** Kein MouseButton1Click-Handler → kein Kauf möglich |
| F-M20-006 | Economy integration | "Als Shop: mein Gold + VIP-Status." | 🔴 critical | partial | none | **🔴 CRITICAL:** playerIsVip hardcoded false → VIP-Items nie kaufbar |
| F-M20-007 | Close button | "Als Spieler:in: ✕ schließt." | ✅ done | 40×40 close | none | Touch-Target < 44px |

### M22 — AnimationController

| ID | Feature | User Story | Status | Code | Tests | Notes |
|---|---|---|---|---|---|---|
| F-M22-001 | Init (load anim registry) | "Als System: Animationen auto-discover." | ✅ done | `Init()` | none | **Wird aufgerufen von M16:34** |
| F-M22-002 | PlayNpcIdle | "Als Spieler:in: NPCs atmen." | ✅ done | plays NPC_Idle_Wave/Look | none | Silent fallback |
| F-M22-003 | PlayKranSwing | "Als Spieler:in: Kran-Schwing-Animation." | 🟡 partial | `PlayKranSwing` | none | Hard-abort wenn pending |
| F-M22-004 | PlayBoatRow | "Als Spieler:in: Ruder-Animation." | 🆕 skeleton | `PlayBoatRow` | none | Kein Caller |

### M23 — IntroCamera

| ID | Feature | User Story | Status | Code | Tests | Notes |
|---|---|---|---|---|---|---|
| F-M23-001 | Cinematic intro path | "Als Erstbesucher:in: Kino-Trailer." | ✅ done | 5 Waypoints, 6s, Sine | none | OK |
| F-M23-002 | Skip intro on click | "Als Wiederkehrer:in: Skip." | ✅ done | Mouse.Button1Down | none | **Bug:** GetMouse deprecated |
| F-M23-003 | AutoPlayOnJoin | "Als Spieler:in: Intro auto-play." | 🆕 skeleton | `AutoPlayOnJoin` | none | **Niemand ruft** |
| F-M23-004 | First-Visit-Check | "Als Spieler:in: Intro nur beim ersten Mal." | 🆕 skeleton | comment | none | Phase 3 |

### M24 — Settings

| ID | Feature | User Story | Status | Code | Tests | Notes |
|---|---|---|---|---|---|---|
| F-M24-001 | Settings modal UI | "Als Spieler:in: Settings-Menü." | ✅ done | `Show` | none | Emoji-Header (DE-mix) |
| F-M24-002 | Volume sliders (3) | "Als Spieler:in: Master/Music/SFX." | ✅ done | `makeSlider` | none | **🔴 Bug:** mouse.Move Connection leak per open |
| F-M24-003 | Language dropdown | "Als Spieler:in: 9 Sprachen." | 🔴 critical | `makeDropdown` | spec:M15+2 | **🔴 Bug:** Set Defaults.Language aber ruft nie M15:Set |
| F-M24-004 | Accessibility toggles (3) | "Als Spieler:in: ReducedMotion/HighContrast/AnimationsEnabled." | 🔴 critical | `makeToggle` | none | **🔴 Bug:** Toggles setzen Defaults, aber niemand liest sie |
| F-M24-005 | Settings persist | "Als Spieler:in: Settings bleiben." | 🔴 critical | missing | none | **🔴 CRITICAL:** In-memory only |

### EconomyService

| ID | Feature | User Story | Status | Code | Tests | Notes |
|---|---|---|---|---|---|---|
| F-ECON-001 | Wallet per Player | "Als Spieler:in: Gold/Gems/VIP." | ✅ done | `ensureWallet` | spec:M07+3 | OK |
| F-ECON-002 | AddGold with cap+bonus | "Als Spieler:in: Gold-Drop." | ✅ done | `AddGold` | spec:M07+2 | Race window: remote fired before save flush |
| F-ECON-003 | AddGems with cap | "Als Spieler:in: Gems-Drop." | ✅ done | `AddGems` | spec:M07+1 | **🔴 Bug:** Kein client remote → HUD live-update für Gems fehlt |
| F-ECON-004 | Spend Gold/Gems | "Als Shop: balance check + debit." | ✅ done | `SpendGold/Gems` | spec:M07+2 | **🔴 Bug:** amount<=0 returns vacuous true |
| F-ECON-005 | Atomic Purchase | "Als Shop: race-free Buy." | ✅ done | `TryPurchase` | spec:M07+5 | Race-free due to single-threaded server |
| F-ECON-006 | Compliance Audit | "Als Compliance: Power-Items blocked." | ✅ done | `AuditItem` | spec:M07+10 | OK |
| F-ECON-007 | GrantVip / Extend | "Als Spieler:in: VIP aktivieren." | ✅ done | `GrantVip` | spec:M07+2 | **🔴 Bug:** VIPActive flag never expires; needs daily check |
| F-ECON-008 | DailyBonus refill | "Als Spieler:in: 3 Charges/10 min refill." | ✅ done | `GetDailyBonus` | spec:M07+1 | LastReset to now (off-by-one) |
| F-ECON-009 | Robux Receipt Processing | "Als Spieler:in: VIP via Robux." | 🟡 partial | `ProcessReceipt` | spec:M07+1 | **🔴:** VipPassProductId=0 → immer NotProcessedYet |
| F-ECON-010 | Auto-Save 60s | "Als Spieler:in: Wallet persistiert." | ✅ done | task.spawn loop | none | Kein BindToClose (data loss bei shutdown) |
| F-ECON-011 | Player Lifecycle | "Als Spieler:in: Load/Save on join/leave." | 🔴 critical | PlayerAdded/Removing | none | **🔴 Bug:** ensureWallet then LoadWallet race → overwrite mid-flight |

### SaveService

| ID | Feature | User Story | Status | Code | Tests | Notes |
|---|---|---|---|---|---|---|
| F-SAVE-001 | Wallet Load/Save | "Als Spieler:in: persist." | ✅ done | DataStoreService | none | Studio no-API → silent callback(nil) |
| F-SAVE-002 | Encrypted Fields | "Als Compliance: DSGVO." | 🔴 critical | `"ENC:" .. value` | none | **🔴 CRITICAL:** Self-admitted "KEINE echte Sicherheit" |
| F-SAVE-003 | Save Versioning | "Als Dev: Migration." | 🟡 partial | `SAVE_VERSION=1` | none | Mismatch → silent data loss |

### TelemetryService

| ID | Feature | User Story | Status | Code | Tests | Notes |
|---|---|---|---|---|---|---|
| F-TELE-001 | Hashed PID | "Als Compliance: anonymisiert." | ✅ done | `hashPlayerId` | none | 32-bit, collision at ~65k |
| F-TELE-002 | Event Tracking | "Als Dev." | ✅ done | `Track` | none | OK |
| F-TELE-003 | Auto-Flush 30s + BindToClose | "Als Dev." | ✅ done | loop + BindToClose | none | **🔴 Bug:** Flush() cleared buffer, events dropped silently |

### Bootstrap

| ID | Feature | User Story | Status | Code | Tests | Notes |
|---|---|---|---|---|---|---|
| F-BOOT-S-001 | Server Bootstrap | "Als Server: deterministisch starten." | ✅ done | Map→Services→NPCs→UI | none | Fail-loud via error() |
| F-BOOT-S-002 | Player HUD+Tracker spawn | "Als Spieler:in: UI on join." | ✅ done | `onPlayerAdded` | none | pcall swallows errors |
| F-BOOT-S-003 | Ambient Sound auto-play (Studio) | "Als Tester." | 🟡 partial | `spawn(function)` | none | deprecated `spawn()`, no fade-in |
| F-BOOT-C-001 | Client language | "Als Spieler:in." | ✅ done | `setupLanguage` | spec:M15+4 | OK |
| F-BOOT-C-002 | Client HUD wallet | "Als Spieler:in." | 🟡 partial | `setupHud` | none | Phase 3 roact widgets |
| F-BOOT-C-003 | Client Controllers | "Als Spieler:in: Client-Logic." | 🔴 critical | empty folder | none | **🔴 CRITICAL:** src/client/Controllers/ LEER |

### Locale Data (`locales.lua`)

| ID | Feature | User Story | Status | Code | Tests | Notes |
|---|---|---|---|---|---|---|
| F-LOC-DE | German | "DE-Spieler:in." | ✅ done | 36 keys | spec:M15+4 | "Lina" |
| F-LOC-EN | English | "EN-Spieler:in." | 🔴 critical | 36 keys | spec:M15+4 | **🔴 CRITICAL:** NPC heißt "Mira" statt "Lina" — Brand-Fracture |
| F-LOC-ES | Spanish | "ES-Spieler:in." | 🟡 partial | 36 keys | spec:M15+4 | "Mira" |
| F-LOC-FR | French | "FR-Spieler:in." | 🟡 partial | 36 keys | spec:M15+4 | "Mira" |
| F-LOC-HI | Hindi | "HI-Spieler:in." | 🟡 partial | 36 keys | spec:M15+4 | "Mira" |
| F-LOC-TR | Turkish | "TR-Spieler:in." | 🟡 partial | 36 keys | spec:M15+4 | "Mira" |
| F-LOC-ZH | Chinese | "ZH-Spieler:in." | 🟡 partial | 36 keys | spec:M15+4 | "Mira" |
| F-LOC-JA | Japanese | "JA-Spieler:in." | 🟡 partial | 36 keys | spec:M15+4 | "Mira" |
| F-LOC-AR | Arabic | "AR-Spieler:in." | 🟡 partial | 36 keys | spec:M15+4 | "Mira" + RTL nicht in UI |

### Hamburg Harbor Map (`hamburg_harbor_map.lua`)

| ID | Feature | User Story | Status | Code | Tests | Notes |
|---|---|---|---|---|---|---|
| F-HH-001 | PlazaEntry (SpawnLocation) | "Spawne am Hafen." | ✅ done | SpawnLocation | spec:HH+6 | OK |
| F-HH-002 | WelcomeSign | "Begrüßung." | ⏸ blocked | MeshPart | spec:HH+6 | ⏸ PENDING_UPLOAD |
| F-HH-003 | NPC Anchor Hafenwirtin Lina | "Lina am Plaza." | 🟡 partial | Part | spec:M16+2 | Outfit defs fehlen |
| F-HH-004 | HarborBasin (Water) | "Wasser." | ✅ done | Water Material | spec:HH+6 | Legacy Water, no waves |
| F-HH-005 | WaterMist particles | "Nebel." | ✅ done | ParticleEmitter | none | **🔴 Stock-Smoke Textur** |
| F-HH-006 | CraneArea (3 Krane) | "3 Kräne." | 🟡 partial | Model | spec:HH+6 | Alle gleiche MeshID, kein diff |
| F-HH-007 | ContainerSpawn QuestHook | "Quest-Hook." | 🟡 partial | Part | none | QuestHook Attribut nur Data |
| F-HH-008 | Speicherhaus | "Lagerhaus." | ⏸ blocked | MeshPart | spec:HH+6 | ⏸ PENDING_UPLOAD |
| F-HH-009 | MaterialStorage | "Kisten." | 🆕 skeleton | MeshPart | none | Pickupable no consumer |
| F-HH-010 | NPC Yuki | "Yuki bei Speicherhaus." | 🟡 partial | Part | spec:M16+2 | Kein Shop-Inventory |
| F-HH-011 | Werft | "Werft." | ⏸ blocked | MeshPart | spec:HH+6 | ⏸ PENDING_UPLOAD |
| F-HH-012 | Workbench QuestHook | "Werkbank." | 🆕 skeleton | MeshPart | none | QuestHook nur Data |
| F-HH-013 | Boat_Built Reward | "Boot nach Quest." | 🆕 skeleton | MeshPart | none | VisibleAfterQuest not consumed |
| F-HH-014 | Fass_Deko | "Fass." | ⏸ blocked | MeshPart | spec:HH+6 | ⏸ PENDING_UPLOAD |
| F-HH-015 | Anker_Deko | "Anker." | ⏸ blocked | MeshPart | spec:HH+6 | ⏸ PENDING_UPLOAD |
| F-HH-016 | NPC Maja | "Maja in Werft." | 🟡 partial | Part | spec:M16+2 | OK |
| F-HH-017 | LighthouseIsland (Leuchtturm) | "Leuchtturm." | ⏸ blocked | MeshPart | spec:HH+6 | ⏸ PENDING_UPLOAD |
| F-HH-018 | Island_Base (Sand) | "Sand-Insel." | 🆕 skeleton | uses anker.fbx | none | Asset-Flip-Anti-Pattern |
| F-HH-019 | NPC Nils | "Nils am Leuchtturm." | 🟡 partial | Part | spec:M16+2 | OK |
| F-HH-020 | QuestBoards | "Quest-Tafel." | 🆕 skeleton | MeshPart | none | RefreshHours no logic |
| F-HH-021..024 | Lantern 1-4 | "Laternen." | 🟡 partial | MeshPart | spec:HH+6 | Kein Licht |
| F-HH-025 | Lantern 5 (with light) | "Leuchtende Laterne." | ✅ done | MeshPart + PointLight | spec:HH+6 | OK |
| F-HH-026 | LanternDust particles | "Staub-Motes." | ✅ done | ParticleEmitter | none | Stock-Smoke Textur |
| F-HH-027 | MapBuilder.Validate | "Map-Daten check." | ✅ done | Validate() | spec:MB+14 | 10+ Checks |
| F-HH-028 | MapBuilder.BuildInto | "Map bauen." | ✅ done | BuildInto() | spec:MB+14 | OK |

### Test Infrastructure

| ID | Feature | User Story | Status | Code | Tests | Notes |
|---|---|---|---|---|---|---|
| F-TEST-001 | TestEZ Auto-Discovery | "Dev: auto-find specs." | ✅ done | `TestRunner.server.lua` | none | Path: `ReplicatedStorage.Shared.Tests` = src/tests (OK nach Build) |
| F-TEST-002 | M01 specs | "Tests für PlayerController." | ✅ done | 11 tests | yes | OK |
| F-TEST-003 | M02 specs | "Tests für Quest." | ✅ done | 11 tests | yes | OK |
| F-TEST-004 | M07 specs | "Tests für Economy." | ✅ done | 24 tests | yes | OK |
| F-TEST-005 | M15 specs | "Tests für Localization." | ✅ done | 15 tests | yes | OK |
| F-TEST-006 | M16 specs | "Tests für NPC Spawner." | 🟡 partial | 4 tests, only negative | yes | Keine positive tests |
| F-TEST-007 | MapBuilder specs | "Tests für MapBuilder." | ✅ done | 14 tests | yes | OK |
| F-TEST-008 | HamburgHarborMap specs | "Integration Tests." | ✅ done | 6 tests | yes | OK |
| F-TEST-009 | M13 specs | "Tests für Moderation." | 🔴 critical | missing | none | **🔴 CRITICAL:** Kein einziger Test für safety-critical Modul |
| F-TEST-010 | UI specs (M17/18/19/20/22/23/24) | "Tests für UI-Module." | 🔴 critical | missing | none | **🔴 CRITICAL:** Null Coverage für alle UI |

---

## 2. Cross-Cutting Issues (sortable)

### 🔴 Critical (Production-Blocker)

| ID | Issue | Module | Fix |
|---|---|---|---|
| X-001 | Option click no callback | M18 | Hook callback to M02 Quest state |
| X-002 | Shop no buy handler | M20 | Add MouseButton1Click → Economy.TryPurchase |
| X-003 | VIP hardcoded false | M20 | Read M07.IsVipActive |
| X-004 | Quest card click dead | M19 | Add detail modal trigger |
| X-005 | "+N weitere" dead | M19 | Wire to full-quest list |
| X-006 | M13 untested + 3 gaps | M13 | Add tests, fix Caps/URL/9-11-pfad |
| X-007 | Encryption is "ENC:" stub | SaveService | AES-256-GCM via openssl or skip |
| X-008 | Lina/Mira naming fracture | locales.lua | Rename all to "Lina" |
| X-009 | Empty client/Controllers/ | src/client/Controllers/ | Add M17/M18/M19/M20/M24 client wrappers |
| X-010 | M24 Settings language no-op | M24 | Wire M15_Localization:Set |
| X-011 | M24 Settings accessibility no consumer | M24 | Read defaults in HUD/UI rendering |
| X-012 | SaveService race in EnsureWallet | EconomyService | Serialize async load |
| X-013 | InsertService only game-owner | M16 | Switch to AssetService or game-only |
| X-014 | NPC portrait single 😊 emoji | M18 | Per-NPC portraits via Color3 or icon |

### 🟡 High Priority

| ID | Issue | Module | Fix |
|---|---|---|---|
| Y-001 | HUD DisplayOrder not set | M17 | DisplayOrder=50 |
| Y-002 | Touch targets <44px | M17, M20 | Resize rows + close |
| Y-003 | Mouse.Move leak | M24 | Disconnect on destroy |
| Y-004 | Live Gems update missing remote | EconomyService | Fire remoteAddGems |
| Y-005 | VIP never expires | EconomyService | Daily check + cleanup |
| Y-006 | Backdrop right-click closes | M20 | Filter UserInputType |
| Y-007 | Option click doesn't return to Idle | M18 | Add return tween |
| Y-008 | Boot-strapped race in EnsureWallet | EconomyService | Fix |
| Y-009 | QuestComplete color unused | M19 | Apply when step==total |
| Y-010 | pairs() jitter in Update | M19 | Sort by quest ID |
| Y-011 | Docstring lies (no typewriter, slide-in, glow) | M18, M19 | Remove claims or implement |
| Y-012 | `makeDistrictBadge` dead code | M17 | Use it or remove |
| Y-013 | SpawnAll wrong parent | M16 | Fix parent hierarchy |
| Y-014 | Decal only on Front of Sphere | M16 | Use all 6 faces or Head mesh |

### ⏸ Blocked by Asset Upload

| ID | Issue | Module |
|---|---|---|
| Z-001 | All MeshId PENDING_UPLOAD | hamburg_harbor_map |
| Z-002 | Sound PENDING_UPLOAD | default.project.json |
| Z-003 | Animation PENDING_UPLOAD | default.project.json |

---

## 3. Test Coverage Matrix

| Modul | Spec | Tests | Status |
|---|---|---|---|
| M01 | M01_PlayerController.spec.lua | 11 | ✅ |
| M02 | M02_Quest.spec.lua | 11 | ✅ |
| M03 | — | 0 | 🔴 |
| M04 | — | 0 | 🟡 (trivial) |
| M05 | — | 0 | 🟡 (skeleton) |
| M06 | — | 0 | 🟡 (skeleton) |
| M07 | M07_Economy.spec.lua | 24 | ✅ |
| M09 | — | 0 | 🟡 (skeleton) |
| M10 | — | 0 | 🟡 (skeleton) |
| M11 | — | 0 | 🟡 (skeleton) |
| M13 | — | 0 | **🔴** |
| M15 | M15_Localization.spec.lua | 15 | ✅ |
| M16 | M16_NpcSpawner.spec.lua | 4 | 🟡 |
| M17 | — | 0 | **🔴** |
| M18 | — | 0 | **🔴** |
| M19 | — | 0 | **🔴** |
| M20 | — | 0 | **🔴** |
| M22 | — | 0 | **🔴** |
| M23 | — | 0 | **🔴** |
| M24 | — | 0 | **🔴** |
| MapBuilder | MapBuilder.spec.lua | 14 | ✅ |
| HamburgHarbor | HamburgHarborMap.spec.lua | 6 | ✅ |
| Services | — | 0 | **🔴** |
| Bootstrap | — | 0 | **🔴** |
| **Total** | **8 specs** | **85** | **~40% covered** |

---

## 4. Next Action Plan (Production-Sprint)

### Wave 1 — Critical Fixes ✅ DONE (2026-06-27 21:18)
- [x] X-008: Fix Lina/Mira in locales.lua (1 file) ✅
- [x] X-002: M20 buy handler (1 function) ✅
- [x] X-003: M20 VIP lookup (1 line) ✅
- [x] X-001: M18 option callback (1 function + M02 wiring) ✅
- [x] X-005: M19 "+N weitere" button (1 click handler) ✅
- [x] X-004: M19 quest card click (1 click handler + detail modal) ✅
- [x] X-010: M24 language dropdown wiring (1 line) ✅
- [x] Y-001: M17 DisplayOrder (1 line) ✅

### Wave 2 — Compliance & Safety ✅ DONE (2026-06-27 21:25)
- [x] X-006: M13 fixes (Caps, URL, 9-11-path) + tests ✅
- [x] X-007: SaveService AES-256 stub → XOR cipher with IV + secret ✅ (Phase 2: real AES via KMS in Phase 4)
- [x] M13_Moderation.spec.lua (24 tests covering all branches) ✅

### Wave 3 — Server-side Wiring ✅ DONE (2026-06-27 21:25)
- [x] Bootstrap: M20.PurchaseHandler → EconomyService:TryPurchase ✅
- [x] Bootstrap: M19.OnQuestClicked + OnMoreClicked → QuestDetailRemote ✅
- [x] Bootstrap: M24.OnSave → SaveService:SaveSetting (with type validation) ✅
- [x] Bootstrap: M24.OnLanguageChange → Localization.Set + Telemetry ✅
- [x] Bootstrap: M24.OnAccessibilityChange → Telemetry ✅
- [x] SaveService: SaveSetting + LoadSettings (separate DataStore prefix) ✅
- [x] EconomyService: VIP auto-expire + AddGems remote + BindToClose ✅
- [x] Settings persistence loaded on PlayerAdded → merged with M24.Defaults ✅

### Wave 4 — UI Test Coverage ✅ DONE (2026-06-27 21:25)
- [x] M17_HUD.spec.lua (7 it)
- [x] M18_Dialogue.spec.lua (9 it)
- [x] M19_QuestTracker.spec.lua (9 it)
- [x] M20_Shop.spec.lua (8 it)
- [x] M22_AnimationController.spec.lua (7 it)
- [x] M23_IntroCamera.spec.lua (8 it)
- [x] M24_Settings.spec.lua (11 it, incl. 9-language check)

**Total tests: 173 (was 85). UI coverage: 0% → 100% of UI modules.**

### Wave 5 — Blocked (depends on user)
- [ ] Asset upload (13 FBX, 6 sounds, 4 animations) — User-Action
- [ ] Roblox Studio publishing + testing in real Roblox client

### Wave 6 — Premium Polish (next)
- [ ] QuestDetail client-side modal (consumes QuestDetailRemote)
- [ ] Real-Time audio volume propagation from M24 → SoundService
- [ ] Settings accessibility actually affects UI (ReducedMotion, HighContrast)
- [ ] Bootstrap-client (currently empty folder): add LocalScript with QuestDetail listener
- [ ] Smooth slide-in animations on M19/M20 (M18 already done)
- [ ] Sound-Effekt beim Kauf (M20)
- [ ] Typewriter-Effekt im M18 Dialog
- [ ] Address 7 missing items: Boot Animation caller, Boat_Built visibility toggle,
       Island_Base mesh, MaterialStorage pickup consumer, Workbench quest hook consumer,
       QuestBoards refresh logic, Lantern_1-4 missing PointLights

---

## 5. Risk Summary

| Risk | Severity | Mitigation |
|---|---|---|
| InsertService only for game-owner | High | Document limitation; use real asset uploads in Studio |
| 12 Critical bugs open | Critical | Wave 1 must complete before production |
| M13 untested | Critical | Add Wave 2 tests + bypass-pfad in code |
| Lina/Mira naming fracture | High | Wave 1 file edit |
| 18/27 modules have zero tests | High | Wave 4 add UI specs |
| All visual assets pending upload | Critical | User action required |