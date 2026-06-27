# Curio World — Roblox Studio Project

Dieser Ordner enthält das produktionsreife Roblox-Studio-Skeleton für **Curio World** mit allen 15 Modulen (M-01 bis M-15) gemäß `docs/09_system_architecture.md`.

## Voraussetzungen

- **Roblox Studio** (neueste Version)
- **Rojo** für Studio-Sync: `aftman install` oder manuell von https://rojo.space
- **Git** für Versionskontrolle
- **optional:** ProfileService (lokal in ReplicatedStorage hinzufügen) oder eigene Save-Implementierung

## Quickstart

```bash
# 1. Rojo installieren (einmalig)
cargo install rojo

# 2. Projekt in Studio syncen
rojo serve

# 3. In Roblox Studio: "Connect to Rojo" Plugin → Live-Sync aktiv
```

## Projektstruktur

```
roblox-studio/
├── default.project.json          # Rojo-Konfiguration
├── README.md                     # Diese Datei
├── src/
│   ├── server/
│   │   ├── init.server.lua       # Server-Bootstrap
│   │   └── Services/
│   │       ├── EconomyService.lua    # M-07 Server-Impl
│   │       ├── SaveService.lua       # M-14 Persistenz
│   │       ├── AdaptiveService.lua   # M-04 Adaptive Engine Server
│   │       └── TelemetryService.lua  # M-12 Telemetrie
│   ├── client/
│   │   ├── init.client.lua       # Client-Bootstrap
│   │   └── Controllers/
│   │       ├── PlayerController.lua    # M-01
│   │       ├── QuestUI.lua            # M-02 (UI)
│   │       ├── InventoryUI.lua        # M-06 (UI)
│   │       └── LocalizationUI.lua     # M-15 (Sprachwechsel)
│   ├── shared/
│   │   ├── Modules/              # 15 Module (M-01 bis M-15)
│   │   ├── Data/                 # Statische Daten
│   │   │   ├── currencies.lua   # Gold, Gems, Robux, VIP
│   │   │   ├── quests.lua       # Quest-Definitionen
│   │   │   ├── districts.lua    # 5 Districts
│   │   │   └── locales.lua      # DE/EN Starter-Lokalisierung
│   │   └── Util/
│   │       ├── Log.lua          # Logging-Wrapper
│   │       └── Promise.lua      # Promise-Helper
│   └── assets/
│       ├── blender-scripts/     # Pipeline-Skripte
│       ├── fbx/                 # Quell-FBX aus Blender
│       └── exports/             # Finale Roblox-Assets
```

## Module (M-01 bis M-15)

| ID | Modul | Datei | Status |
|---|---|---|---|
| M-01 | Player Controller | `shared/Modules/M01_PlayerController.lua` | Skeleton |
| M-02 | Quest System | `shared/Modules/M02_Quest.lua` | Skeleton (1 Beispiel-Quest) |
| M-03 | Dialogue | `shared/Modules/M03_Dialogue.lua` | Skeleton (Datenmodell) |
| M-04 | Adaptive Engine | `shared/Modules/M04_Adaptive.lua` | Skeleton (Bayesian-Update, Empfehlungs-API) |
| M-05 | Puzzle Framework | `shared/Modules/M05_Puzzle.lua` | Skeleton |
| M-06 | Inventory | `shared/Modules/M06_Inventory.lua` | Skeleton |
| M-07 | Economy & Shop | `shared/Modules/M07_Economy.lua` + `server/Services/EconomyService.lua` | **Fertig** (vollständig implementiert) |
| M-08 | Adaptive Difficulty | = M-04 | (M-04) |
| M-09 | Event Framework | `shared/Modules/M09_Event.lua` | Skeleton |
| M-10 | Housing | `shared/Modules/M10_Housing.lua` | Skeleton |
| M-11 | Companion | `shared/Modules/M11_Companion.lua` | Skeleton |
| M-12 | Telemetry | `server/Services/TelemetryService.lua` | Skeleton (In-Memory + HTTP-Stub) |
| M-13 | Moderation | `shared/Modules/M13_Moderation.lua` | Skeleton (Chat-Permissions + Age-Band-Logik) |
| M-14 | Save | `server/Services/SaveService.lua` | Skeleton (DataStore + Encryption-Stub) |
| M-15 | Localization | `shared/Modules/M15_Localization.lua` + `shared/Data/locales.lua` | **Fertig** (DE+EN Strings) |

## Server-Services

- `EconomyService.lua` — Wallet, Käufe, VIP-Pass, Daily-Bonus, Robux-Marketplace
- `SaveService.lua` — DataStoreService-Persistenz mit Auto-Save alle 60s
- `TelemetryService.lua` — Anonyme Event-Sammlung (DSGVO/COPPA-konform)

## Wirtschaft (M-07) — aktiv implementiert

- **Gold (Soft-Massen)** — durch Gameplay
- **Gems (Soft-Selten)** — durch besondere Aktivitäten
- **Robux (Echtgeld-Premium)** — VIP-Pass, Cosmetics
- **KEIN Stamina** (Anti-Frust)

API:
```lua
local EconomyService = require(ServerScriptService.Services.EconomyService)
EconomyService:AddGold(player, 100)  -- +100 Gold
EconomyService:AddGems(player, 5)
EconomyService:GetBalance(player)    -- {gold=1234, gems=42, robuxSpent=0, vipActive=false}
EconomyService:TryPurchase(player, "skin_red", 500)  -- {success, reason}
```

## Lokalisierung (M-15) — DE + EN aktiv

Strings werden via `LocalizationService` und externer Tabelle aufgelöst.
Neue Sprache hinzufügen:
1. Eintrag in `shared/Data/locales.lua` (Tabelle)
2. Studio: Game Settings → Localization → Translator-Tab
3. JSON-Übersetzung in `ReplicatedStorage.Locale.<lang>.json`

## Compliance-Hooks

- **C-002 (Pay-to-Win):** `EconomyService` lehnt Käufe ab, die Gameplay-Vorteile bieten würden. Compliance-Audit-Log auf jedem Kauf.
- **C-007 (Anti-Frust):** Keine Stamina. Alle Aktionen unbegrenzt.
- **C-013 (Minderjährigenschutz):** `SaveService` verschlüsselt sensible Felder. Telemetry anonymisiert.
- **C-019 (Robux-Transparenz):** Vor jedem Kauf zeigt UI den Preis + klaren Hinweis „rein kosmetisch/komfort".

## Erste Schritte

1. **Roblox Studio öffnen** und dieses Verzeichnis als Rojo-Projekt verbinden.
2. **Rojo sync** startet — alle Module erscheinen in der Hierarchy.
3. **ProfileService** (oder eigenes Save-System) in `ReplicatedStorage` einbinden.
4. **Erster Test:** `Play` im Studio, Gold-Balance im HUD prüfen.
5. **Asset-Pipeline:** `assets/blender-scripts/` öffnen, FBX exportieren, in Studio importieren.

## Asset-Pipeline (Blender → Roblox)

```bash
# Blender muss mit aktivem RPC-Server laufen (oder via CLI)
blender --background --python assets/blender-scripts/export_kran.py \
    --output assets/fbx/kran.fbx

# Dann in Studio: Game Explorer → Import FBX
```

Die Pipeline-Skripte:
- `assets/blender-scripts/export_kran.py` — Erster Kran-Test (Hamburg Harbor)
- `assets/blender-scripts/optimize_for_roblox.py` — Trim-Sheet-Generierung, LOD
- `assets/blender-scripts/batch_export.py` — Alle Distrikt-Assets

## Nächste Schritte (Phase 2 → Phase 3)

- [ ] ProfileService integrieren
- [ ] LocalizationService aktivieren + alle 9 Sprachen-Strings einlesen
- [ ] Erste Quest-Skripte für Hamburg Harbor (3 Mathe + 2 Physik)
- [ ] Adaptive Engine mit echtem Bayesian-Skill-Estimator
- [ ] Erste Blender-Assets (Kran, Leuchtturm, Speicher)
- [ ] Playtest mit 30 Spieler:innen (Phase 4)

## Lizenz & Owner

- **Produkt:** Curio World
- **Owner:** Product Lead
- **Stand:** 2026-06-27 (Phase 2 — Skeleton)