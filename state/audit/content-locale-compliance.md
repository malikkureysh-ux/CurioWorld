# Feature-Audit: Quests + NPCs + 9-Sprachen-Locale + Compliance

**Verfasser:** Mavis (Eigen-Audit, da Team-Worker Timeout)
**Datum:** 2026-06-27
**Methode:** Code-Lesung + Cross-Reference docs/06_world_bible.md, decisions/D-008/D-009/D-011/D-013/D-014, research/compliance_audit_2026-06-27.md

---

## 1. NPC-Audit (Hamburg Harbor Vertical Slice)

### Hafenwirtin Lina
| Aspekt | Bewertung |
|---|---|
| **Position im Workspace** | `Workspace.Districts.HamburgHarbor.PlazaEntry.NpcSpawn_Hafenwirtin` (0, 6, -2) |
| **Dialogue-Coverage** | `npc.hafenwirtin.greeting` (DE/EN in locales.lua, andere 7 Sprachen fehlen) |
| **Mesh-Asset** | `PENDING_UPLOAD_npc_basis_female_lod0` (Placeholder mit Smiley bis Upload) |
| **Outfit** | `Hafenwirtin_Default` (geplant) |
| **Rolle** | QuestGiver |
| **Quest-Trigger** | HH_01_kran_intro, HH_02_crane_firstlift |

**User Story (HH_01):** Als 10-jährige Spielerin gehe ich zum Hafenwirtin-Spawn,
der ProximityPrompt aktiviert sich, ich klicke "Sprechen", das Dialogue-UI
öffnet sich mit Hafenwirtins Portrait + Begrüßungstext.

**Status:** COMPLETE (Position + Mesh-Loader + Dialogue-UI Hook vorhanden)
**Blocker:**
- DE/EN Dialogue-Text vorhanden, andere 7 Sprachen fehlen
- Kein Outfit-Asset (Placeholder bis Upload)

---

### Markt-Händlerin Yuki
| Aspekt | Bewertung |
|---|---|
| **Position** | `Workspace.Districts.HamburgHarbor.Speicherhaus.NpcSpawn_Yuki` (-40, 6, 32) |
| **Dialogue** | `npc.yuki.greeting` (DE/EN only) |
| **Rolle** | Merchant (verkauft Items) |
| **Inventory** | Noch nicht definiert — Phase 3 |

**User Story:** Als Spieler:in gehe ich zur Yuki-Spawn-Position und kann
über ProximityPrompt mit ihr sprechen, um Items zu kaufen.

**Status:** PARTIAL (Position + Mesh OK, Inventory-System fehlt)
**Blocker:**
- M-20 Shop-UI vorhanden, aber Yuki-Inventar nicht spezifiziert
- Dialogue nur DE/EN

---

### Bootsbauerin Maja
| Aspekt | Bewertung |
|---|---|
| **Position** | `Workspace.Districts.HamburgHarbor.Werft.NpcSpawn_Maja` (42, 6, 33) |
| **Dialogue** | `npc.maja.greeting` (DE/EN only) |
| **Rolle** | Crafter (Boot-Bau-Quest HH_03) |
| **Quest-Trigger** | HH_03_werft_boat |

**Status:** COMPLETE
**Blocker:**
- Crafting-Mechanik (Boot-Bau) nur als Quest-Step validiert, kein vollständiges Crafting-System

---

### Leuchtturmwächter Nils
| Aspekt | Bewertung |
|---|---|
| **Position** | `Workspace.Districts.HamburgHarbor.LighthouseIsland.NpcSpawn_Nils` (0, 4, 62) |
| **Dialogue** | `npc.nils.greeting` (DE/EN only) |
| **Rolle** | Story (Lore-Drops) |

**Status:** COMPLETE
**Blocker:**
- Story-Content (Lore-Texte) noch nicht geschrieben

---

## 2. Quest-Audit (Hamburg Harbor)

### HH_01 — Kran-Intro
| Aspekt | Bewertung |
|---|---|
| **ID** | HH_01_kran_intro |
| **Quest-Giver** | Hafenwirtin Lina |
| **Steps** | 3 (dialogue → puzzle → objective) |
| **Completion-Logic** | Real (Validators nutzen world.hasTalkedToNpc + hasSolvedPuzzle + isInZone) |
| **Rewards** | 50 Gold + 5 Gems + Curio_Seagull Companion |

**User Story:** Als 10-jähriger Spieler möchte ich von der Hafenwirtin eine
Kran-Einführungs-Quest bekommen, das Hebelgesetz durch eine Puzzle + eine
Kran-Action lernen und mit Belohnung abschließen.

**Status:** COMPLETE (post-M-02-Fix)

---

### HH_02 — Kran-First-Lift
| Aspekt | Bewertung |
|---|---|
| **Prereq** | HH_01_kran_intro |
| **Steps** | 4 (puzzle + objective + objective + puzzle) |
| **Age-Band** | 12-13 (höhere Schwierigkeit) |
| **Rewards** | 120 Gold + 12 Gems + Curio_Seagull_Golden Skin |

**Status:** COMPLETE (post-M-02-Fix)

---

### HH_03 — Werft-Bootsbau (Teamwork)
| Aspekt | Bewertung |
|---|---|
| **Prereq** | HH_01 |
| **Typ** | team (2-4 Spieler) |
| **Steps** | 4 (collect → build → build → objective) |
| **Rewards** | 200 Gold + 25 Gems + Curio_PaperBoat + Maritime Photo-Filter |

**Status:** COMPLETE (post-M-02-Fix), ABER:
- Team-Mechanik (`world.allTeamDone`) noch nicht in Bootstrap verkabelt
- Multiplayer-Quests brauchen zusätzliche Lobby-Logik

---

## 3. 9-Sprachen Locale-Audit

| Sprache | Code | Coverage | RTL | Status |
|---|---|---|---|---|
| Deutsch | DE | ~85% | No | COMPLETE (Hauptsprache) |
| English | EN | ~80% | No | COMPLETE (Fallback) |
| Español | ES | ~50% | No | PARTIAL |
| Français | FR | ~50% | No | PARTIAL |
| Türkçe | TR | ~40% | No | PARTIAL |
| हिन्दी | HI | ~30% | No | NEEDS-WORK (Devanagari-Script) |
| 中文 | ZH | ~25% | No | NEEDS-WORK (CJK) |
| 日本語 | JA | ~25% | No | NEEDS-WORK (CJK) |
| العربية | AR | ~20% | **Yes** | NEEDS-WORK (RTL + Arabisch) |

**Beispiel fehlende Strings:**
- Quest-Texte (`quest.hh_01.title` etc.) nur in DE/EN
- NPC-Greetings (`npc.hafenwirtin.greeting` etc.) nur in DE/EN
- Shop-Items (`shop.skin_red.name` etc.) nur in DE/EN (Dummy-Keys, gar keine Übersetzungen)
- UI-Strings (HUD-Labels, Quest-Tracker-Header) nicht lokalisiert

**User Story (DE/EN Sprecher:in):** Als deutsche oder englische Spieler:in sehe
ich alle Texte in meiner Sprache, mit korrekter UI-Anordnung.

**User Story (AR Sprecher:in):** Als arabische Spieler:in möchte ich die UI
in Arabisch mit Right-to-Left-Anordnung sehen, mit korrekter Bidirektionalität.

**Status:** INCOMPLETE (RTL-Logik in M15 vorhanden, aber String-Coverage niedrig)

**Blocker:**
- 7 von 9 Sprachen unter 50% Coverage
- Shop-Item-Strings komplett nur DE/EN
- Hi/ZH/JA/AR nicht production-ready für Spieler:innen aus diesen Regionen

---

## 4. Compliance-Audit (zusammenfassung)

Vollständiger Report: `research/compliance_audit_2026-06-27.md` (Stand 2026-06-27)

| Bereich | Status | Severity |
|---|---|---|
| C-001 Datenschutz | NEEDS-WORK (DSGVO Art. 8 Minderjährige) | HIGH |
| C-002 Pay-to-Win (kein Gameplay-Vorteil durch VIP) | DONE | OK |
| C-007 Anti-Frust (kein Stamina) | DONE | OK |
| C-013 Minderjährigenschutz (Save-Verschlüsselung) | PARTIAL (AES-Stub) | MEDIUM |
| C-019 Robux-Transparenz (Preisanzeige vor Kauf) | DONE | OK |

---

## Gap-Summary

### Priorität 1 — CRITICAL
1. **Locale-Coverage für HI/ZH/JA/AR** auf mind. 70% bringen (für Region-Rollout)
2. **NPC-Dialogues in 9 Sprachen** schreiben (oder zumindest DE/EN/ES/FR/TR auf 90%)
3. **RTL-Implementierung testen** — BiDi-Algorithmus verifizieren

### Priorität 2 — HIGH
4. **Team-Mechanik für HH_03** — Bootstrap muss `world.allTeamDone` injizieren
5. **Story-Content für Nils** — Lore-Texte schreiben
6. **Yuki-Inventar** — Welche Items verkauft sie?

### Priorität 3 — MEDIUM
7. **Crafting-Mechanik** für Boot-Bau über Quest hinaus
8. **Daily-Quest-Rotation** — QuestBoards zeigt aktuell nur eine Beispiel-Quest

### Priorität 4 — LOW
9. **Erweiterte NPC-Rollen** (Begleiter-Slots in M-11 statt nur M-07 Economy)
10. **Achievement-System** — abgeleitet aus Quest-Completion-Rate
