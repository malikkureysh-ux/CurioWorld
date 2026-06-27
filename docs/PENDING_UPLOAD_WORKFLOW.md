# PENDING UPLOAD Workflow — Roblox Asset-Upload Anleitung

## Übersicht

Die Map-Daten referenzieren `rbxassetid://PENDING_UPLOAD_*` Platzhalter. Diese müssen durch echte Roblox-AssetIds ersetzt werden, nachdem die FBX-Dateien zu Roblox hochgeladen wurden.

## Schritt-für-Schritt Anleitung

### 1. Roblox Studio öffnen
- **Datei → Öffnen…**
- Navigiere zu: `C:\Users\malik_n9u\Documents\Projekte\Roblox Studio - Blender - MCP\roblox-studio\builds\CurioWorld_HamburgHarbor.rbxl`
- Studio lädt das Projekt-Skeleton

### 2. Asset Manager öffnen
- Menü **View → Asset Manager** (oder Ctrl+I)
- Klicke auf **Bulk Import** (oben rechts)

### 3. FBX-Dateien hochladen
Navigiere zu `C:\Users\malik_n9u\Documents\Projekte\Roblox Studio - Blender - MCP\roblox-studio\assets\fbx\`

Wähle folgende FBX-Dateien (in dieser Reihenfolge für saubere AssetIds):

| # | FBX-Datei | Größe | Platzhalter | Zweck |
|---|---|---:|---|---|
| 1 | `kran_premium_lod0.fbx` | 1.0 MB | `PENDING_UPLOAD_kran_lod0` | Kran mit PBR |
| 2 | `leuchtturm_premium_lod0.fbx` | 1.9 MB | `PENDING_UPLOAD_leuchtturm_lod0` | Leuchtturm mit Emissive |
| 3 | `speicherhaus_lod0.fbx` | 142 KB | `PENDING_UPLOAD_speicherhaus_lod0` | Speicherhaus |
| 4 | `boot_lod0.fbx` | 47 KB | `PENDING_UPLOAD_boot_lod0` | Boot |
| 5 | `fass_lod0.fbx` | 68 KB | `PENDING_UPLOAD_fass_lod0` | Fass |
| 6 | `kiste_lod0.fbx` | 46 KB | `PENDING_UPLOAD_kiste_lod0` | Kiste |
| 7 | `dock_planke_lod0.fbx` | 21 KB | `PENDING_UPLOAD_dock_planke_lod0` | Dock |
| 8 | `laterne_lod0.fbx` | 31 KB | `PENDING_UPLOAD_laterne_lod0` | Laterne |
| 9 | `anker_lod0.fbx` | 36 KB | `PENDING_UPLOAD_anker_lod0` | Anker |
| 10 | `willkommen_schild_lod0.fbx` | 42 KB | `PENDING_UPLOAD_willkommen_schild_lod0` | Welcome-Sign |
| 11 | `quest_tafel_lod0.fbx` | 46 KB | `PENDING_UPLOAD_quest_tafel_lod0` | Quest-Brett |
| 12 | `npc_basis_female_lod0.fbx` | 124 KB | `PENDING_UPLOAD_npc_basis_female_lod0` | NPC-Basis weiblich |
| 13 | `npc_basis_male_lod0.fbx` | 124 KB | `PENDING_UPLOAD_npc_basis_male_lod0` | NPC-Basis männlich |

### 4. AssetIds notieren
Nach jedem Upload zeigt der Asset Manager die neue AssetId an. Notiere sie in folgender Tabelle:

```
KranA/B/C:          rbxassetid://_____________
Leuchtturm:         rbxassetid://_____________
Speicherhaus:       rbxassetid://_____________
Boot:               rbxassetid://_____________
Fass:               rbxassetid://_____________
Kiste:              rbxassetid://_____________
Dock_Planke:        rbxassetid://_____________
Laterne:            rbxassetid://_____________
Anker:              rbxassetid://_____________
Welcome_Schild:     rbxassetid://_____________
Quest_Tafel:        rbxassetid://_____________
NPC_Female:         rbxassetid://_____________
NPC_Male:           rbxassetid://_____________
```

### 5. Platzhalter ersetzen
- **Datei → Edit in Notepad** für `C:\Users\malik_n9u\Documents\Projekte\Roblox Studio - Blender - MCP\roblox-studio\src\shared\Data\hamburg_harbor_map.lua`
- Search & Replace: `PENDING_UPLOAD_kran_lod0` → deine echte Kran-AssetId (für alle 3 Kräne)
- Wiederhole für jeden Asset-Typ
- **Speichern**

### 6. Neu bauen
```powershell
cd "C:\Users\malik_n9u\Documents\Projekte\Roblox Studio - Blender - MCP"
rojo build roblox-studio --output roblox-studio\builds\CurioWorld_HamburgHarbor.rbxl
```

### 7. Studio-Reload
- In Studio: **Datei → Schließen** (alte Place)
- **Datei → Öffnen…** → neue .rbxl

## Was passiert automatisch beim Bauen

- `MapBuilder` baut die Map mit den neuen MeshRefs
- `M16_NpcSpawner` lädt NPC-Meshes (oder fällt auf Smiley-Placeholder zurück wenn LoadAsset fehlschlägt)
- `Bootstrap` registriert alle Services + startet das Server-Bootstrap
- `TestRunner` versucht Tests zu laden (wird ohne TestEZ-Paket mit Warnung abbrechen)

## Sound-Assets (separater Workflow)

CC0 Sound-Quellen sind in `state/audit/cc0-sound-recommendations.md` dokumentiert. Nach User-Upload der WAV/OGG-Dateien zu Roblox (max 7 Sekunden pro Clip), werden sie in `SoundService`-Children verlinkt:

```
SoundService
├── Ambient_Hafen (Loop, ~30 sec, Lautstärke 0.3)
├── Kran_Mechanik (One-Shot, 1.5 sec)
├── Möwen_Abend (Loop, ~15 sec)
├── Wasserplätschern (Loop, ~20 sec)
└── UI_Click (One-Shot, 0.3 sec)
```

## Optionale Schritte für Premium-Standard

- [ ] **SurfaceAppearance** mit Emission-Maps für Leuchtturm-Laterne setzen (in Studio, nicht in JSON)
- [ ] **NPC-Outfit-Skins** (Hafenwirtin-Default, Yuki-Merchant, Maja-Crafter, Nils-Watchman) als separate Assets hochladen
- [ ] **Trim-Sheets** für Werft-Floor und Hafenbecken-Boden (siehe `docs/07_art_direction.md` §5)
- [ ] **Sound-Ambiente** in SoundService einbauen
- [ ] **TestEZ** über Wally installieren für automatische Test-Ausführung

## Troubleshooting

**Upload schlägt fehl mit "Mesh too large"**
→ LOD 1 oder 2 verwenden (kran_lod1.fbx ist 71 KB statt 1 MB)

**Mesh wird grau dargestellt**
→ Studio rendert unbekannte rbxassetid als graue Box; AssetId korrekt einsetzen

**NPC-Mesh lädt nicht**
→ M16 fällt automatisch auf Placeholder (Smiley) zurück; Log: "[M16] Asset-Load fehlgeschlagen"

**Build-Fehler "Lighting.Technology expects string"**
→ Sicherstellen, dass in `default.project.json` `"Technology": "Future"` (String, nicht 3)
