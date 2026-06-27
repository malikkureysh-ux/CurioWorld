# Tooling — Roblox Studio + Blender Dev Stack

Dieser Ordner ist **getrennt vom restlichen Workspace**. Hier liegen nur die Roblox/Luau-Build-Tools. Das eigentliche Spiel-Konzept (docs/, decisions/, draft images/) bleibt im Workspace-Root unangetastet.

## Was hier ist

```
tooling/
├── aftman.toml             # Tool-Manager: definiert welche Versionen von Rojo/Wally/Selene
├── wally.toml              # Package-Manager: TestEZ + weitere Wally-Packages
├── wally.lock              # Lockfile (automatisch generiert)
├── selene.toml             # Linter-Konfiguration (Luau)
├── default.project.json    # Rojo: Mapping src/ → DataModel-Hierarchie
├── .gitignore              # Build-Artefakte ignorieren
├── .vscode/
│   └── settings.json       # VS Code: Roblox LSP + Rojo-Settings
├── src/                    # Deine Luau-Scripts (sync mit Roblox Studio)
│   ├── shared/             # → ReplicatedStorage.Shared
│   ├── server/             # → ServerScriptService
│   ├── client/             # → StarterPlayerScripts
│   └── tests/              # → TestEZ-Tests
├── Packages/               # Wally-installierte Libraries (TestEZ etc.)
└── blender-plugins/
    └── roblox-blender-plugin/   # Roblox Blender Plugin (offiziell)
```

## Installierte Tools (global)

| Tool | Version | Pfad |
|---|---|---|
| aftman | 0.3.0 | `C:\Users\malik_n9u\.aftman\bin\` |
| Rojo | 7.6.1 | über aftman (in `.aftman`) |
| Wally | 0.3.2 | über aftman |
| Selene | 0.31.0 | über aftman |
| TestEZ | 0.4.1 | via Wally in `Packages/` |
| VS Code | latest | `C:\Users\malik_n9u\AppData\Local\Programs\Microsoft VS Code\` |
| johnnymorganz.luau-lsp | 1.68.1 | VS Code Extension |
| evaera.vscode-rojo | 2.1.2 | VS Code Extension |

## Workflow

### Tägliche Entwicklung

1. **VS Code öffnen** mit `tooling/` als Workspace:
   ```powershell
   code "C:\Users\malik_n9u\Documents\Projekte\Roblox Studio - Blender - MCP\tooling"
   ```

2. **In Roblox Studio** das Rojo-Plugin installieren (einmalig):
   - Asset Manager → "Bulk Import" → oder Studio-Plugin-Manager
   - Oder: `rojo plugin install` (in `tooling/`-Ordner)
   - Im Explorer: Plugins → "Rojo" → "Connect" auf den Local-Server

3. **Sync starten**:
   ```powershell
   cd "C:\Users\malik_n9u\Documents\Projekte\Roblox Studio - Blender - MCP\tooling"
   rojo serve
   ```
   Roblox Studio verbindet sich automatisch (oder via Plugin → "Connect").

4. **In VS Code editieren** → Änderungen werden live in Studio sichtbar.

### Build (für Place-File-Generierung)

```powershell
cd "C:\Users\malik_n9u\Documents\Projekte\Roblox Studio - Blender - MCP\tooling"
rojo build --output ..\place.rbxl
```

→ `place.rbxl` im Workspace-Root, kann in Studio geöffnet oder veröffentlicht werden.

### Tests laufen lassen

In Roblox Studio Command Bar (im Play-Mode):
```lua
require(game:GetService("ReplicatedStorage").Packages.TestEZ).TestBootstrap:run(
    {game:GetService("ReplicatedStorage").src.tests}
)
```

Oder via TestEZ-Plugin falls vorhanden.

### Lint

```powershell
selene lint src
```

### Neues Package hinzufügen

```toml
# In wally.toml unter [dependencies]
Promise = "evaera/promise@4.0.0"
```

```powershell
wally install
```

→ Package landet in `Packages/Promise/` und ist via `require(game.ReplicatedStorage.Packages.Promise)` nutzbar.

### Tool-Versionen ändern

In `aftman.toml` die Version editieren, dann:
```powershell
aftman install
```

## Rojo Studio-Plugin installieren

**Methode 1 — via CLI:**
```powershell
cd "C:\Users\malik_n9u\Documents\Projekte\Roblox Studio - Blender - MCP\tooling"
rojo plugin install
```

**Methode 2 — manuell:**
1. Download: https://github.com/rojo-rbx/rojo/releases/latest (Rojo.rbxm)
2. Verschieben nach: `%LOCALAPPDATA%\Roblox\Plugins\`
3. Studio neu starten

**Methode 3 — Roblox Marketplace:**
1. Studio → Plugins → "Manage Plugins" → Reiter "Marketplace"
2. "Rojo" suchen → Install

## Blender-Plugin installieren

1. Blender öffnen (Version 5.0+ empfohlen wegen Plugin-Kompatibilität)
2. Edit → Preferences → Add-ons → "Install…"
3. Wähle: `tooling/blender-plugins/roblox-blender-plugin/` (oder den ZIP-Inhalt)
4. Aktivieren
5. Im 3D-View-Sidebar `N` → Tab "Roblox" → "Login" mit Roblox-Account

Workflow: Mesh in Blender bauen → "Upload to Roblox" → landet in deiner Roblox-Inventory → in Studio über Asset Manager einfügen.

## Pfade und Konventionen

- Luau-Scripts: `src/{shared,server,client,tests}/*.lua`
- ModuleScripts enden NICHT auf `.server.lua` oder `.client.lua`
- Server-Scripts: enden auf `.server.lua` (geht nach `ServerScriptService`)
- LocalScripts: enden auf `.client.lua` (geht nach `StarterPlayerScripts`)
- Test-Scripts: enden auf `.spec.lua`

## Troubleshooting

| Problem | Lösung |
|---|---|
| `aftman` nicht im PATH | Terminal neu starten |
| `rojo serve` startet nicht | Port 34872 belegt? Andere Rojo-Instanz beenden |
| VS Code zeigt rote Luau-Fehler in Wally-Packages | `luau-lsp` muss installiert sein + Workspace-Reload |
| Selene gibt komische Errors | `selene --version` checken; ggf. `selene.toml` exclude-Liste erweitern |
| Rojo-Plugin findet `default.project.json` nicht | Workspace-Pfad in VS Code muss `tooling/` sein, nicht das Parent |

## Updates

Tools aktualisieren:
```powershell
aftman update
wally update
```

Roblox Studio Plugin updaten:
```powershell
rojo plugin install --force
```