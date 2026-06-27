# Skill S4 — Code-Standard Luau (Roblox)

## Zweck
Stellt sicher, dass Luau-Code **lesbar, sicher, performant und teamfähig** ist. Verhindert die häufigsten Bugs und macht Reviews effizient.

**Premium-Anspruch:** Code ist **production-ready auf Anhieb**. Type-strict, getestet (>80% Coverage), dokumentiert, lint-pass, performance-optimiert. Kein "geht erstmal". Volle Definition: AGENTS.md §11.

## Wann anwenden
- **Bei:** jedem Commit, jedem Modul, jedem Skript
- **Loop:** A (Working-Approach) für Prozess + B für Funktionalität
- **Sub-Agent-Rolle:** Code-Reviewer prüft gegen dieses Skill

## Architektur-Regeln

### Modul-Pattern (Pflicht)
```
src/
├── shared/                  # Module, beide Seiten können sie nutzen
│   ├── Config/              # Konstanten, Tuning-Werte
│   ├── Types/               # Type-Definitionen (Luau-Types)
│   └── Utilities/           # Helper, keine Game-Logic
├── server/                  # ServerScriptService
│   ├── Services/            # Singletons (DataService, QuestService, ...)
│   ├── Handlers/            # RemoteEvent-Handler
│   └── Controllers/         # Game-Logic (Boss, NPC, ...)
├── client/                  # StarterPlayerScripts
│   ├── Controllers/         # UI, Input, Camera
│   └── Views/               # UI-Components
└── data/                    # Statische Daten (JSON/Luau-Tables)
    ├── quests/
    ├── cities/
    └── dialogue/
```

### Pflicht-Checkliste pro Skript

```
☐ HEADER-KOMMENTAR: Zweck, Owner, Letzte Review, Abhängigkeiten
☐ TYPE-ANNOTATIONEN überall (function foo(x: number): boolean)
☐ NUR lokale Variablen wo möglich (kein _G-Missbrauch)
☐ Module-Verwendung statt "von Hand" kopieren
☐ Error-Handling: pcall + klare Fehlermeldungen
☐ Logging: bei wichtigen Events (Quest-Start, Boss-Kill, Daten-Load)
☐ Magic Numbers → Config aus /shared/Config/
```

## Sicherheits-Regeln (KRITISCH)

```
☐ SERVER-AUTHORITATIVE für LERN-ANTWORTEN
  → Spieler-Eingaben NIE client-seitig auswerten
  → Server prüft, Server vergibt XP, Server speichert
  → Anti-Cheat: Eingabe-Muster, Timing, alternative Lösungswege

☐ DATASTORE mit ProfileService (NICHT DataStore2-Fork)
  → Versionierte Profile (Migration-Pfad dokumentiert)
  → Auto-Save mit Session-Locking
  → Backups für kritische Daten (Inventar, Progress)

☐ REMOTE-EVENTS validiert
  → Jeder Client→Server-Call: Argument-Typen geprüft
  → Range-Checks (Geld > 0, Level < 100, etc.)
  → Rate-Limits (max X Calls/Sekunde)

☐ KEINE SECRETS im Client
  → API-Keys, Service-Tokens nur server-seitig
  → Niemals in ReplicatedStorage, auch nicht "verschlüsselt"

☐ KEIN user-provided Content ohne Filter
  → Chat, Custom-Namen, Avatar-Customization
  → Wortfilter + Pädagogen-Sanity-Check
```

## Performance-Ziele

```
☐ 60 FPS auf Standard-Smartphone (Roblox-Spec-Device)
☐ < 100 MB Download pro Stadt (Streaming-Enabled)
☐ Erste Szene in < 5 Sekunden sichtbar
☐ Keine Memory-Leaks in 30-Min-Session
☐ GC-Pausen < 16ms (eine Frame)
☐ Server: < 50 Spieler pro Server (für Lern-Engine-Rechenzeit)
```

## Performance-Patterns

```lua
-- ✅ Gut: lokal statt self.Tabelle.foo.bar
local Config = require(script.Parent.Config)
local foo = Config.QuestPoints -- einmal laden

-- ✅ Gut: Pre-allocated tables
local results = table.create(100)

-- ✅ Gut: Tasks statt yield
task.spawn(function() ... end)

-- ✅ Gut: Cached Lookups statt Instance-Find alle Frames
local playerGui = player:WaitForChild("PlayerGui")
-- Statt player.PlayerGui jedes Mal

-- ❌ Schlecht: Game:GetService("...") jeden Frame
-- ❌ Schlecht: FindFirstChild in Hot-Loops
-- ❌ Schlecht: Große Tables in ReplicatedStorage
```

## Naming-Konventionen

| Element | Stil | Beispiel |
|---|---|---|
| Module (PascalCase) | PascalCase | `QuestService`, `DataController` |
| Funktionen | camelCase | `startQuest`, `getPlayerXP` |
| Lokale Variablen | camelCase | `currentLevel`, `playerName` |
| Konstanten | UPPER_SNAKE | `MAX_PLAYERS = 50` |
| Remotes (PascalCase) | PascalCase + Suffix | `QuestRemote`, `ChatRemoteFunction` |
| Datatypes | PascalCase + "T" | `QuestT`, `PlayerT` |

## Git-Workflow

```
main (immer spielbar)
  └─ feature/quest-system-v2
       └─ PR mit:
           - Tests (falls Logik komplex genug)
           - Code-Reviewer-Sign-off
           - Lint-Pass
           - Performance-Profiler-Snapshot
```

## Lint-Empfehlung

`selene` oder `stylua` mit Repo-Config in `.luau.toml` oder `.selene.toml` — verhindert Stil-Drift.

## Verbindlich mit anderen Skills
- **Skill S5** (Blender) — Assets müssen zu Code passen (LOD-Naming, etc.)
- **Skill S6** (Ethische Monetarisierung) — Code darf keine Pay-to-Win-Pfade öffnen

## Version
v1.0 — Juni 2026 — Initial definiert