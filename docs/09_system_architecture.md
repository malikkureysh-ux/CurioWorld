# 09 — System Architecture

## Zweck

Dieses Dokument definiert die technische Systemarchitektur von Curio World: Module, Datenmodelle, Schnittstellen, Performance-Strategien und Tech-Stack. Es ist die Grundlage für alle Engineering-Entscheidungen.

## Annahmen

- Roblox Studio + Luau ist die primäre Plattform.
- Multiplayer ist Standard; Skalierung auf 50–80 Spieler:innen pro Server ist das Ziel.
- Mobile (Smartphone, Tablet) ist die wichtigste Plattform, gefolgt von Desktop.
- Telemetrie ist datenschutzfreundlich (DSGVO/COPPA-konform).
- Modulare Systeme, klar definierte Schnittstellen.
- i18n für 9 Sprachen ist von Anfang an eingebaut.

## Quellen

- Roblox Creator Documentation (Stand 2026)
- Roblox LocalizationService
- Roblox DataStoreService, MemoryStoreService
- Roblox MessagingService, RemoteEvents
- Briefing-Modulliste

## Tech-Stack-Übersicht

| Bereich | Technologie | Anmerkung |
|---|---|---|
| Game Logic | Luau | Roblox-Standard |
| UI | Luau + Roact (oder vergleichbares) | Reaktives UI-Framework |
| Datenpersistenz | DataStoreService + ProfileService | Spieler:innen-Profile |
| Session-State | MemoryStoreService | Live-Spielzustand |
| Multi-Server-Komm. | MessagingService | Community-Events |
| Analytics | Roblox Analytics + Custom HTTP | Eigene Pipeline DSGVO-konform |
| i18n | Roblox LocalizationService | Externe Strings |
| Asset-Pipeline | Blender + FBX | siehe `08_asset_pipeline_blender_to_roblox.md` |
| Sound | Roblox Audio Assets | komponierte SFX/Musik |
| CI/CD | Roblox Open Cloud + Rojo + GitHub Actions | Versionskontrolle |

## Systemmodule

### M-01 Player Controller

**Zweck:** Steuerung von Bewegung, Parkour, Interaktion.

**Verantwortlichkeiten:**
- Laufen, Springen, Doppelsprung, Rutschen, Klettern, Gleiten.
- Bezirks-spezifische Bewegungsstile.
- Kontextsensitive Interaktion mit Welt-Objekten.

**Schnittstellen:**
- Input: Tastatur/Maus/Touchscreen/Gamepad.
- Output: Charakter-Animationen, Kamera-Steuerung.
- Telemetrie: Bewegungsmuster pro Spieler:in (anonymisiert).

**Wichtige Constraints:**
- Mobile-Tauglichkeit: alle Aktionen mit Touch-Bedienung möglich.
- Performance-Budget für Charakter: ≤ 8.000 Polygone.

---

### M-02 Quest System

**Zweck:** Verwaltung aller Missionen, Story-Kapitel, Bezirks-Ränge.

**Datenmodell:**
```
Quest {
  id: string
  title: localized
  description: localized
  type: enum (solo, duo, team, mini, exploration, event)
  district: string
  steps: QuestStep[]
  prerequisites: string[]
  rewards: Reward[]
  age_band_target: enum
  adaptive_range: { min, max }
}

QuestStep {
  id: string
  type: enum (objective, dialogue, puzzle, collect)
  target: string
  completion_condition: predicate
}
```

**Schnittstellen:**
- Eingabe: Trigger (NPC, Objekt, Event).
- Ausgabe: Belohnungen, Story-Fortschritt, Telemetrie-Events.
- Abhängig von: Adaptive Engine (M-08), Inventory (M-06), Dialogue (M-03).

---

### M-03 Dialogue System

**Zweck:** NPC-Dialoge mit Lokalisierung, optionalen Antworten, Story-Verzweigungen.

**Datenmodell:**
```
Dialogue {
  id: string
  npc_id: string
  lines: DialogueLine[]
  options: DialogueOption[] | null
}

DialogueLine {
  speaker: string
  text: localized
  audio: string
  duration_estimate: number
}

DialogueOption {
  text: localized
  next_dialogue: string | null
  triggers: string[]
}
```

**Schnittstellen:**
- Eingabe: Quest-Trigger, Spieler:innen-Interaktion.
- Ausgabe: UI-Text, Audio-Wiedergabe, Story-Flag.
- Lokalisierung: alle Texte extern.

---

### M-04 Adaptive Learning Engine

**Zweck:** Diskretes Kompetenzmodell und Aufgaben-Anpassung.

**Siehe `12_adaptive_difficulty_model.md` für Details.**

**Datenmodell:**
```
CompetencyProfile {
  player_id: hash
  domains: { domain_name: DomainScore }
  signals: rolling_window
  last_updated: timestamp
}

DomainScore {
  level: number
  confidence: number
  recent_trend: enum
}
```

**Schnittstellen:**
- Eingabe: Telemetrie-Events aus Quest, Puzzles, Minispiele.
- Ausgabe: Empfohlene Schwierigkeit, Hilfetiefe, Sprachkomplexität.

---

### M-05 Puzzle Framework

**Zweck:** Wiederverwendbares Rätsel-System mit eingebetteten Lernaufgaben.

**Puzzle-Typen:**
- Sortier-Puzzle (Drag-and-Drop, Reihenfolge, Auswahl).
- Bau-Puzzle (Maschinen, Schalter, Sequenzen).
- Erinnerungs-Puzzle (Karten aufdecken, Sequenzen merken).
- Logik-Puzzle (Bedingungen, Aussagen, Beweise).

**Schnittstellen:**
- Eingabe: Quest-Step löst Puzzle aus.
- Ausgabe: Erfolgs- oder Hinweis-Antwort an Quest-System.

---

### M-06 Inventory and Collection System

**Zweck:** Spieler:innen-Inventar, Sammelbücher, Materialien.

**Datenmodell:**
```
Inventory {
  player_id: hash
  slots: ItemStack[]
  max_slots: number
}

ItemStack {
  item_id: string
  quantity: number
  metadata: table
}

CollectionBook {
  player_id: hash
  categories: { category: CollectionEntry[] }
}

CollectionEntry {
  item_id: string
  discovered: boolean
  recalled_count: number
}
```

**Schnittstellen:**
- Eingabe: Belohnungen aus Quests, Materialien aus Welterkundung.
- Ausgabe: UI-Inventar, Sammelbuch-Anzeige, Bau-Slots.

---

### M-07 Economy and Shop System

**Siehe `10_economy_design.md` für vollständige Spezifikation.**

**Verantwortlichkeiten:**
- Soft-Currency-Management.
- Robux-Käufe (Developer Products / Game Passes).
- Saisonpass-Logik.
- Tausch zwischen Spielwährungen.
- Limits und Eltern-Kontrollen.

---

### M-08 Adaptive Difficulty Engine

Siehe M-04 / `12_adaptive_difficulty_model.md`.

---

### M-09 Event Framework

**Zweck:** Saisonale Events, Community-Events, Live-Drops.

**Event-Typen:**
- Saisonale Festivals (mehrwöchige Themen-Events).
- Community-Events (globale Ziele).
- Live-Events (zeitlich begrenzte Herausforderungen).

**Schnittstellen:**
- Eingabe: Konfiguration (Backend-Admin oder LiveOps-Plan).
- Ausgabe: Quest-Trigger, City-Deko-Wechsel, globale Fortschrittsbalken.

---

### M-10 Housing and Personal Space

**Zweck:** Persönliches Studio oder Wohnung pro Spieler:in.

**Datenmodell:**
```
House {
  owner_id: hash
  room_layout: RoomLayout
  decorations: DecorationPlacement[]
  visitor_settings: enum (private, friends, public)
}

DecorationPlacement {
  decoration_id: string
  position: Vector3
  rotation: Vector3
}
```

**Schnittstellen:**
- Eingabe: Spieler:innen-Aktionen, Markt-Käufe.
- Ausgabe: Persistente Stadtteil-Sichtbarkeit (nur für Besucher:innen).

---

### M-11 Companion / Pet System

**Zweck:** Sammelbare Begleiter, kosmetisch, mit Story-Verbindungen.

**Datenmodell:**
```
Companion {
  id: string
  name: localized
  model: asset_id
  rarity: enum
  unlock_condition: string
  stats_cosmetic: CosmeticProfile
}

CompanionInstance {
  companion_id: string
  player_id: hash
  nickname: string | null
  affection: number  # kosmetisch
}
```

**Schnittstellen:**
- Eingabe: Erkundung, Quests, Events.
- Ausgabe: Companions sichtbar im Spiel, keine Gameplay-Vorteile.

---

### M-12 Analytics and Telemetry

**Siehe `14_telemetry_plan.md` für Details.**

**Verantwortlichkeiten:**
- Event-Sammlung (anonymisiert).
- Performance-Metriken.
- KPI-Dashboards.
- A/B-Test-Framework.

---

### M-13 Moderation and Safety Interfaces

**Siehe `11_community_and_safety.md` für Details.**

**Verantwortlichkeiten:**
- In-Game-Reporting.
- Roblox-Report-Schnittstelle.
- Wort-/Verhaltens-Filter.
- Anti-Harassment-Mechaniken.

---

### M-14 Save and Progress

**Zweck:** Persistenz von Spieler:innen-Profil, Fortschritt, Inventar, Housing.

**Implementation:**
- DataStoreService mit ProfileService (oder vergleichbarer Wrapper).
- Auto-Save alle 60 Sekunden und bei Quest-Abschluss.
- Backup-Strategie bei Datenverlust.
- Verschlüsselung sensibler Felder.

---

### M-15 Localization (i18n)

**Zweck:** 9 Sprachen von Anfang an.

**Unterstützte Sprachen:**
| Code | Sprache | Schrift |
|---|---|---|
| de | Deutsch | Lateinisch |
| en | Englisch | Lateinisch |
| es | Spanisch | Lateinisch |
| fr | Französisch | Lateinisch |
| hi | Hindi | Devanagari |
| tr | Türkisch | Lateinisch |
| zh | Chinesisch (vereinfacht) | Han (CN) |
| ja | Japanisch | Kanji/Hiragana/Katakana |
| ar | Arabisch | Arabisch (RTL) |

**Implementation:**
- Alle Spieler:innen-Texte in `LocalizationTable` oder externen JSON-Dateien.
- Schriftarten mit allen Glyphen für 9 Sprachen.
- UI-Spiegelung für Arabisch (RTL-Layout).
- Cultural-Review für alle Story- und NPC-Inhalte.

---

## Datenmodell-Übersicht

```
PlayerProfile
├── id (hash)
├── locale
├── age_band (initial estimate, refine via usage)
├── persona_signals
├── competency_profile
├── inventory
├── collections
├── housing
├── companions
├── quests_progress
├── achievements
├── settings (audio, accessibility, etc.)
└── parent_link (optional)

District
├── id
├── name (localized)
├── ranks
├── story_chapters
├── quests
├── npcs
├── ambient_audio
└── seasonal_decorations

Item
├── id
├── name (localized)
├── description (localized)
├── type (material, decoration, consumable, cosmetic)
├── rarity
└── source

Quest
├── id
├── title (localized)
├── steps
├── rewards
├── prerequisites
└── adaptive_range

Event
├── id
├── type
├── start_time
├── end_time
├── global_progress
└── contributions
```

## Performance-Strategien

### Streaming

- Workspace Streaming aktiv.
- Bezirke als separate Streaming-Regionen.
- NPC-Population und Decorations stream-basiert.

### Caching

- Statische Daten (Items, NPCs, Distrikt-Konfiguration) in `ReplicatedStorage`.
- Dynamische Daten (Spieler:innen-spezifisch) in `ServerStorage` + DataStore.
- Telemetrie-Buffer für Network-Efficiency.

### Network

- RemoteEvents und RemoteFunctions nur für nötige Kommunikation.
- Komprimierte Payloads.
- Throttling für nicht-kritische Updates.

### Mobile

- Performance-Budgets (siehe `07_art_direction.md`).
- Optional: vereinfachte Partikel und Post-Processing auf Mobile.

## Telemetrie-Hooks

Jedes System hat definierte Telemetrie-Events (siehe `14_telemetry_plan.md`).

## Schnittstellen-Übersicht

```
M-01 Player Controller ─→ M-02 Quest, M-05 Puzzle, M-06 Inventory
M-02 Quest ─→ M-03 Dialogue, M-04 Adaptive, M-05 Puzzle, M-06 Inventory, M-09 Event
M-03 Dialogue ─→ M-13 Moderation (Trigger bei bestimmten Inhalten)
M-04 Adaptive ─→ M-02 Quest, M-05 Puzzle
M-05 Puzzle ─→ M-02 Quest, M-04 Adaptive
M-06 Inventory ─→ M-07 Economy, M-10 Housing, M-11 Companion
M-07 Economy ─→ M-06 Inventory, M-13 Moderation (Kauf-Limits)
M-09 Event ─→ M-02 Quest, M-06 Inventory
M-10 Housing ─→ M-06 Inventory, M-13 Moderation (Visitor-Settings)
M-11 Companion ─→ M-06 Inventory
M-12 Telemetry ─→ alle Systeme
M-13 Moderation ─→ alle Systeme
M-14 Save ─→ alle Systeme (persistenter Zustand)
M-15 Localization ─→ alle Systeme mit Textausgabe
```

## Deployment und Versionierung

- Git-basiertes Quellcode-Management.
- Rojo für Studio-Sync.
- GitHub Actions für Tests.
- Roblox Open Cloud für Asset- und Config-Deploys.
- Feature-Flags für gestaffelte Rollouts.

## Risiken

- **Komplexität:** 15+ Systeme erfordern diszipliniertes Schnittstellenmanagement. Mitigation: strikte API-Verträge, Dokumentation, Tests.
- **Performance:** Mobile-Spielbarkeit kann durch zu viele Systeme gefährdet werden. Mitigation: Budget-Tests pro System.
- **Daten-Persistenz:** Datenverlust bei Spieler:innen ist ein Reputationsrisiko. Mitigation: redundante Saves, Recovery-Strategien.
- **i18n-Spätkosten:** Späte Lokalisierung ist teuer. Mitigation: Lokalisierungs-Schicht von Anfang an.

## Offene Fragen

- Welche konkreten Datenstrukturen setzen wir für ProfileService-Profile ein? (Phase 3.)
- Wie granular sind Telemetrie-Events? (Phase 3 mit Telemetrie-Plan.)
- Wie genau funktioniert Roblox Parental Control API-Integration? (Phase 2-Recherche.)

## Nächste Schritte

1. Modul-Skeletons in Studio anlegen (Ordner, ModuleScripts, leere Funktionen).
2. LocalizationService einrichten und String-Tabelle aufbauen.
3. ProfileService-Integration planen.
4. Performance-Benchmark-Test mit erstem Hafen-Asset.

## Änderungsverlauf

| Datum | Version | Änderung | Autor |
|---|---|---|---|
| 2026-06-27 | 0.1 | Initiale System-Architektur | Mavis (Agent) |
| 2026-06-27 14:25 | 0.2 | Refit: Curio World + 5-District-Plan + Gold/Gems/Robux (kein Stamina) + VIP-Komfort-Pass | Mavis (Agent) |
| 2026-06-27 14:50 | 0.3 | Refit: Wonder World → Curio World (Naming-Kollision mit existierendem Roblox-Pet-Game aufgedeckt) | Mavis (Agent) |
| 2026-06-27 | 0.1 | Initiale System-Architektur | Mavis (Agent) |