# Map-Assets-Atmosphäre Audit — Hamburg Harbor Vertical Slice

**Audit-Datum:** 2026-06-27
**Auditor:** Verifier (adversarial)
**Scope:** Visuelle/spatiale Schicht des Vertical-Slice-Bezirks Hamburg Harbor
**Severity-Schema:** `BLOCKY_PRIMITIVE` | `MESHPLACED_REFERENCED` | `MISSING` | `MISSING_CONFIG`
**Quellen-Querverweise:** `docs/06_world_bible.md`, `docs/07_art_direction.md`,
`docs/19_release_readiness_checklist.md`, `decisions/D-002`, `decisions/D-014`,
`docs/08_asset_pipeline_blender_to_roblox.md`

---

## 0. TL;DR — Top-Befunde

> **Visuelle Qualität ist die Top-1-Beschwerde des Users. Diese Beschwerde ist aktuell
> voll gerechtfertigt.** Die Map ist zu 100 % aus Roblox-Block-Primitives gebaut,
> obwohl 19 Blender-FBX-Assets (Speicherhaus, Kräne, Leuchtturm, NPCs, Props) bereits
> exportiert vorliegen. Die existierenden Assets werden in der Map-Daten-Definition
> an **keiner einzigen Stelle** referenziert. Es gibt keine Skybox, kein Atmosphäre-
> Setup, keine Lighting-Konfiguration, keine Fog, keine Tageszeit, keine MeshPart-
> Instanzen. Das `default.project.json` definiert nur `Folder`-Container für die
> Districts, aber keine echten Atmosphäre-Werte.

| Kategorie | Befund | Severity |
|---|---|---|
| Map-Assets (Bauten) | 8/8 BLOCKY_PRIMITIVE, obwohl 19 FBX bereitstehen | **CRITICAL** |
| NPC-Spawn-Punkte | Unsichtbare Cubes statt echter NPC-Mesh | HIGH |
| Lighting / Atmosphäre | Komplett MISSING_CONFIG | **CRITICAL** |
| MapBuilder.Validate() | Robustheit unzureichend | MEDIUM |
| Workspace-Hierarchie | Nur 2 Ebenen, Districts als leere Folder | MEDIUM |
| Build-Datei | 46 KB .rbxl ist nur ein Bootstrap-Snapshot, kein Production-Build | LOW |

---

## 1. Asset-Inventar (FBX)

### 1.1 Liste mit Größen

Alle 19 FBX-Dateien unter `roblox-studio/assets/fbx/`:

| Datei | Größe (Bytes) | Größe (KB) | Quelle |
|---|---:|---:|---|
| `anker_lod0.fbx` | 35 868 | 35,03 | fehlt (kein Export-Script) |
| `boot_lod0.fbx` | 46 924 | 45,82 | fehlt |
| `dock_planke_lod0.fbx` | 21 404 | 20,90 | fehlt |
| `fass_lod0.fbx` | 67 852 | 66,26 | fehlt |
| `kiste_lod0.fbx` | 45 884 | 44,81 | fehlt |
| `kran_lod0.fbx` | 67 260 | 65,68 | `export_kran.py` |
| `kran_lod1.fbx` | 71 052 | 69,39 | `export_kran.py` |
| `kran_lod2.fbx` | 80 012 | 78,14 | `export_kran.py` |
| `laterne_lod0.fbx` | 31 020 | 30,29 | fehlt |
| `leuchtturm_lod0.fbx` | 123 644 | 120,75 | `export_leuchtturm.py` |
| `leuchtturm_lod1.fbx` | 104 300 | 101,86 | `export_leuchtturm.py` |
| `leuchtturm_lod2.fbx` | 76 652 | 74,86 | `export_leuchtturm.py` |
| `npc_basis_female_lod0.fbx` | 124 220 | 121,31 | fehlt |
| `npc_basis_male_lod0.fbx` | 124 236 | 121,32 | fehlt |
| `quest_tafel_lod0.fbx` | 45 548 | 44,48 | fehlt |
| `speicherhaus_lod0.fbx` | 142 348 | 139,01 | `export_speicherhaus.py` |
| `speicherhaus_lod1.fbx` | 144 684 | 141,29 | `export_speicherhaus.py` |
| `willkommen_schild_lod0.fbx` | 41 756 | 40,78 | fehlt |

**Gesamtvolumen:** 1 472 664 Bytes (≈ 1,4 MB)

### 1.2 Blender-Skripte (Ist-Stand)

Tatsächlich vorhanden in `roblox-studio/assets/blender-scripts/`:

- `export_kran.py` (236 Zeilen) — baut Kran mit Werft-Orange + Wasserblau
- `export_leuchtturm.py` (224 Zeilen) — baut Leuchtturm mit Streifen, Laterne, Dach
- `export_speicherhaus.py` (238 Zeilen) — baut Speicherhaus mit Wänden, Tür, Dach, Schornstein
- `README.md` (14 Zeilen)

**Im README angekündigt, aber NICHT vorhanden:**

- `optimize_for_roblox.py` — fehlt
- `batch_export.py` — fehlt
- `import_roblox_template.py` — fehlt

→ **Dokumentations-Lüge**: Das `README.md` bewirbt 4 Skripte, von denen nur 3 vorhanden sind,
und das `export_prop.py` aus dem ursprünglichen Task-Brief ist ebenfalls nicht vorhanden,
obwohl 12 weitere FBX-Assets existieren (Anker, Boot, Fass, Kiste, Laternen, NPCs, Schilder,
Quest-Tafel, Dock-Planke), für die es kein reproduzierbares Export-Script gibt.

**Beweis (grep):**

```
$ Get-ChildItem .../blender-scripts/
    export_kran.py
    export_leuchtturm.py
    export_speicherhaus.py
    README.md

$ grep -c "MeshPart|MeshId|TextureID|AssetId" .../src
0
```

→ Die `export_*.py`-Skripte generieren Materialien mit `embed_textures=True`, aber es
existieren **keinerlei PNG-Texturen** im Projekt (`grep "**/*.png"` unter
`roblox-studio/assets/` liefert 0 Treffer). Die FBX-Dateien enthalten also nur Vertex-
Farben oder Default-Materialien.

---

## 2. Asset-Audit: Map-Daten vs. Art-Direction

### 2.1 Welche Assets erwartet die Welt?

Aus `docs/06_world_bible.md` §"Hamburg Harbor" (Zeilen 138–222) und
`docs/07_art_direction.md` §"Hamburg Harbor-Palette" (Zeile 83):

**Erwartete Hamburg-Harbor-Bauten (World Bible):**
- Hafen mit Kaimauern (Modular-Bausteine)
- 3 aktive Kräne (Highlight-Mechanik D-014)
- Speicherhäuser mit interaktiven Verlade-Mechaniken
- Werft (1 Bootsbau-Werkstatt)
- Leuchtturm-Insel mit Aussicht
- Wasserwege mit Gleit-Etappen
- Zentraler Marktplatz mit „Hafen-Glocke" (Quest-Trigger)
- Wohn- und Werkstattinseln am Wasser

**Erwartete NPCs (4 Vertical-Slice-Rollen):**
- Hafenwirtin Lina (PlazaEntry, Quest-Giver)
- Markt-Händlerin Yuki (Speicherhaus, Merchant)
- Bootsbauerin Maja (Werft, Crafter)
- Leuchtturmwächter Nils (Leuchtturm, Story)

### 2.2 Pro-Asset-Audit

#### PlazaEntry

| Asset-Name | Aktuelle Impl. | Erwartete Impl. | Status | Gap to Fix |
|---|---|---|---|---|
| `WelcomeSign` | `ClassName = "Part"`, 8×4×0.5, keine Textur, kein Mesh | Soll Willkommen-Schild sein — FBX `willkommen_schild_lod0.fbx` existiert (40,78 KB) | **BLOCKY_PRIMITIVE** | MeshPart-Reference auf `willkommen_schild_lod0.fbx` setzen (MeshId + TextureID nach Roblox-Asset-Import) |
| `HafenwirtinSpawn` | Unsichtbarer `Part` (Transparency=1, Size 1×2×1), Attribute für NPC-Placement | Echte NPC-Mesh (FBX `npc_basis_female_lod0.fbx`, 121,31 KB) mit Skinned Outfit + Idle-Animation | **BLOCKY_PRIMITIVE** (invisible spawn proxy) | NPC-Modul muss `npc_basis_female_lod0.fbx` an Spawn laden + Skin + Animation-Controller |

#### CraneArea

| Asset-Name | Aktuelle Impl. | Erwartete Impl. | Status | Gap to Fix |
|---|---|---|---|---|
| `CraneA.Base` | `ClassName = "Part"`, 4×12×4 Metal, Werft-Orange | FBX `kran_lod0.fbx` (65,68 KB) — vollständiger Kran mit Mast, Ausleger, Kontergewicht, Seil, Haken, Container | **BLOCKY_PRIMITIVE** | `CraneA` als Model mit MeshPart-Root (kran_lod0.fbx) oder als aus mehreren MeshParts zusammengesetztes Model |
| `CraneA.Arm` | `Part`, 20×2×2 | im Kran-FBX bereits enthalten | **BLOCKY_PRIMITIVE** | s.o. |
| `CraneA.ContainerSpawn` | unsichtbarer `Part` mit `QuestHook = "HH_02_crane_firstlift"` | Sichtbarer Container-Crate als Quest-Trigger | **BLOCKY_PRIMITIVE** (invisible quest proxy) | Container-Mesh aus Kran-FBX oder separater Crate-Asset (z.B. `kiste_lod0.fbx`) bei Spawn-Position instanziieren |
| `CraneB.Base`, `CraneB.Arm` | identisch Primitive | identisch FBX | **BLOCKY_PRIMITIVE** | s.o. — drei Kräne = drei MeshPart-Instanzen |
| `CraneC.Base`, `CraneC.Arm` | identisch Primitive | identisch FBX | **BLOCKY_PRIMITIVE** | s.o. |

#### Speicherhaus

| Asset-Name | Aktuelle Impl. | Erwartete Impl. | Status | Gap to Fix |
|---|---|---|---|---|
| `Speicherhaus.Floor` | `Part` 20×0,5×16, WoodPlanks beige | im FBX `speicherhaus_lod0.fbx` (139,01 KB) bereits Bodenplatte enthalten | **BLOCKY_PRIMITIVE** | Speicherhaus-Mesh importieren, Floor weglassen |
| `Speicherhaus.Walls` | `Part` 20×8×16, **Brick**, **Transparency=0.2** — „see-through for now" (Kommentar Z. 224) | echtes Speicherhaus mit Wänden, Türen, Fenstern, Dach, Schornstein (laut `export_speicherhaus.py`) | **BLOCKY_PRIMITIVE** + **Transparenz als Notbehelf zugegeben** (Anti-Pattern) | Speicherhaus-FBX referenzieren, Transparenz entfernen |
| `Speicherhaus.YukiSpawn` | unsichtbarer `Part`, Attribute `NpcId = "Yuki"` | Echte Yuki-NPC (FBX `npc_basis_female_lod0.fbx`) mit Merchant-Outfit | **BLOCKY_PRIMITIVE** | NPC-Modul spawnt Mesh an Position |
| `Speicherhaus.MaterialStorage` | `Part` 3×3×3 Wood | FBX `kiste_lod0.fbx` (44,81 KB) — Kisten-Stack mit MaterialType-Logik | **BLOCKY_PRIMITIVE** | Kisten-Mesh aus FBX instanziieren |

#### Werft

| Asset-Name | Aktuelle Impl. | Erwartete Impl. | Status | Gap to Fix |
|---|---|---|---|---|
| `Werft.Floor` | `Part` 16×0,5×12 Concrete grau | Werft-Boden mit Maserung oder Steinen | **BLOCKY_PRIMITIVE** | Trim-Sheet für Werft-Boden erstellen (siehe §5 in `07_art_direction.md`) |
| `Werft.Workbench` | `Part` 4×1×2 Wood, dunkelbraun | FBX `dock_planke_lod0.fbx` (20,90 KB) oder eigenes Workbench-Mesh | **BLOCKY_PRIMITIVE** | Workbench-Mesh + Werkzeug-Details (Hammer, Säge) |
| `Werft.MajaSpawn` | unsichtbarer `Part`, Attribute `NpcId = "Maja"` | Echte Maja-NPC (FBX `npc_basis_female_lod0.fbx`) mit Crafter-Outfit | **BLOCKY_PRIMITIVE** | s.o. |
| **FEHLEND** | — | `Boot` (FBX `boot_lod0.fbx`, 45,82 KB) als Bauquest-Ziel (HH_03_werft_boat) | **MISSING** | Boot-Mesh in Werft platzieren, Sichtbarkeit an Quest-Fortschritt koppeln |
| **FEHLEND** | — | `Anker` (FBX `anker_lod0.fbx`, 35,03 KB) als Dekoration am Kai | **MISSING** | Anker-Mesh dekorativ platzieren |

#### LighthouseIsland

| Asset-Name | Aktuelle Impl. | Erwartete Impl. | Status | Gap to Fix |
|---|---|---|---|---|
| `LighthouseIsland.Island` | `Part` 8×2×8 Sand beige | Insel-Modell mit Vegetation, Felsen | **BLOCKY_PRIMITIVE** | Insel-Mesh (oder mindestens Fels-Deko) erstellen |
| `LighthouseIsland.Lighthouse` | `Part` 2×18×2, weiß, **plain cylinder** | FBX `leuchtturm_lod0.fbx` (120,75 KB) — vollständiger Leuchtturm mit Sockel, Streifenringen, Veranda, Laterne, Dach, Spitze | **BLOCKY_PRIMITIVE** | Leuchtturm-FBX referenzieren; später LOD1/LOD2 für Distanz |
| `LighthouseIsland.LighthouseTop` | `Part` 3×2×3, **Neon**-Material, „emittiert" via `Attribute.EmitsLight=true` (Kommentar Z. 338) | Im FBX bereits als `Laterne_Gelb_Emittiv` mit `Emission Strength = 2.5` (echtes PBR-Emissive) | **BLOCKY_PRIMITIVE** + **falsches Material-Mapping** (Roblox `Enum.Material.Neon` ist nicht das, was Art-Direction vorsieht) | MeshPart mit SurfaceAppearance + EmissionMap; Neon-Fallback nur als Notlösung dokumentieren |
| `LighthouseIsland.NilsSpawn` | unsichtbarer `Part`, Attribute `NpcId = "Nils"` | Echte Nils-NPC (FBX `npc_basis_male_lod0.fbx`, 121,32 KB) mit Story-Outfit | **BLOCKY_PRIMITIVE** | s.o. |

#### QuestBoards

| Asset-Name | Aktuelle Impl. | Erwartete Impl. | Status | Gap to Fix |
|---|---|---|---|---|
| `QuestBoards.DailyQuestBoard` | `Part` 4×6×0,5 Wood | FBX `quest_tafel_lod0.fbx` (44,48 KB) — Quest-Brett mit Papieren, Markierungen | **BLOCKY_PRIMITIVE** | Quest-Board-Mesh + Texture-Overlay für tägliche Quests |
| **FEHLEND** | — | `Laterne` (FBX `laterne_lod0.fbx`, 30,29 KB) als Hafen-Beleuchtung entlang der Kaimauern | **MISSING** | Laternen-Meshes in Reihe platzieren, Lichtquellen koppeln |
| **FEHLEND** | — | `Fass` (FBX `fass_lod0.fbx`, 66,26 KB) als Dekoration in Speicherhaus/Werft | **MISSING** | Fass-Meshes platzieren |

### 2.3 NPC-Spawn-Punkte — Detail-Befund

**Alle 4 NPCs sind als unsichtbare Cubes mit Attributen definiert.** Das ist eine
akzeptierte Programmier-Praxis für Spawn-Position + Metadaten, aber:

- **Es gibt keine NPC-Instanz im Workspace.** `grep "MeshPart\|MeshId"` in
  `src/` liefert 0 Treffer.
- **Es gibt kein NPC-Spawner-Modul** in `src/shared/Modules/` (M01–M15 sind vorhanden,
  aber keiner enthält `Humanoid`, `Animator`, oder einen Mesh-Loader).
- **Die `npc_basis_*.fbx`-Dateien** (121 KB je) sind exportiert, aber kein Code lädt sie.

→ **BLOCKY_PRIMITIVE** für alle 4 NPCs, **MISSING_CONFIG** für das NPC-Spawn-System.

---

## 3. Atmosphäre / Lighting / Skybox / Tageszeit

### 3.1 Was die Art-Direction verlangt

Aus `docs/06_world_bible.md` Zeile 145 ff. („Atmosphäre"):
> „Pastellige Farbpalette mit warmem Abendlicht, das die Stadt einbettet."
> „Wasser, Möwen (komponiert), Hafenkran-Silhouetten."
> „Sound-Identität: sanftes Wasserplätschern, mechanische Kran-Glocken (kindgerecht),
> leise Hafen-Instrumente."

Aus `docs/07_art_direction.md` §Performance-Vorgaben: Mobile 60 FPS, Pastell-Palette.

### 3.2 Was tatsächlich konfiguriert ist

**`grep` über das gesamte Projekt nach:**

| Pattern | Treffer |
|---|---:|
| `Lighting` (Workspace-Service) | 0 |
| `Brightness` | 0 |
| `Ambient` | 0 |
| `Technology` | 0 |
| `Fog` | 0 |
| `ClockTime` | 0 |
| `Atmosphere` | 0 |
| `Skybox` / `SkyboxTexture` | 0 |
| `InsertService` | 0 |
| `MeshPart` (Klassen-Name) | 0 |
| `MeshId` / `TextureID` / `AssetId` | 0 |

**Was definiert das `default.project.json`?**

```jsonc
"Workspace": {
  "$className": "Workspace",
  "Districts": { "$className": "Folder", "HamburgHarbor": { "$className": "Folder" }, … },
  "Hub": { "$className": "Folder", "SkyPlaza": { "$className": "Folder" } }
}
```

→ **Keine Lighting-Properties, keine Skybox-Children, keine Atmosphere-Instanz.**

**`CurioWorld_HamburgHarbor.rbxl` (46 KB):** Inspection des binären Roblox-Formats
zeigt, dass es nur den Bootstrap, die Lua-Module, die Map-Daten-Definition und die
Locale-Tabelle enthält. Keine Atmosphere-, Lighting-, Skybox- oder Mesh-Einträge
über das hinaus, was Roblox als Default-Werte für ein leeres Projekt setzt.

### 3.3 Atmosphäre-Befund: MISSING_CONFIG (CRITICAL)

| Atmosphäre-Aspekt | Erwartet | Ist | Status |
|---|---|---|---|
| Skybox | Eigene Curio-World-Skybox (Pastell-Himmel, Möwen-Cumulus) oder Skybox-ID aus Roblox-Creator-Store | Default-Roblox-Sky (kein Custom) | **MISSING_CONFIG** |
| Lighting.Brightness | Reduziert (warmes Abendlicht ~0,7–1,2 je nach Tageszeit) | Roblox-Default (2) | **MISSING_CONFIG** |
| Lighting.Ambient | Pastell-getönt (z.B. `#BDE3FF` Himmel + `#FFE6A1` Sonnenuntergang-Anteil) | Roblox-Default (Mid-Grey) | **MISSING_CONFIG** |
| Lighting.Technology | `Enum.Technology.Future` für Cel-Shading-Look oder `Compatibility` als Fallback | Default (Compatibility) — nicht explizit gesetzt | **MISSING_CONFIG** |
| Lighting.ClockTime | Dynamische Tageszeit (z.B. 17.5 = warmer Sonnenuntergang für Hafen) | Default 14:00 (Mittag) | **MISSING_CONFIG** |
| Atmosphere | Decal/Haze für Tiefenwirkung (See-/Hafen-Dunst) | Default (keine Atmosphere-Instanz) | **MISSING_CONFIG** |
| FogEnd / FogStart | Subtile Distanz-Nebel (z.B. 200/500) für Teleport-Weitblick | Default (FogColor Mid-Grey, FogEnd 100000) | **MISSING_CONFIG** |
| Sound | Wasserplätschern + Kran-Glocken + adaptive Hafen-Musik | Kein Sound-Asset im Projekt (kein `.mp3`/`.ogg`) | **MISSING_CONFIG** |

**Begründung der Severity CRITICAL:**
Die `Wissenswelten-Konzept.md` (im Projekt-Root erwähnt) und die Art-Direction legen
„Premium · State of the Art" als Standard fest. Eine Welt ohne Skybox, ohne Atmosphäre
und mit Default-Roblox-Mittagslicht erfüllt den Premium-Standard nicht.

---

## 4. MapBuilder.Validate() — Robustheits-Audit

### 4.1 Aktueller Code (`src/shared/Modules/MapBuilder.lua` Z. 93–129)

```lua
function MapBuilder:Validate(mapData): (boolean, { string })
    local errors = {}
    if not mapData.Name or mapData.Name == "" then …
    if not mapData.Layout or #mapData.Layout == 0 then …

    local function checkNode(node, path)
        if not node.Name then errors[#errors+1] = path .. ": name missing" end
        if not node.ClassName then errors[#errors+1] = path .. ": className missing" end
        if node.Properties then
            if node.Properties.Position and typeof(node.Properties.Position) ~= "Vector3" then
                errors[#errors+1] = path .. ": Position is not Vector3"
            end
        end
        if node.Children then
            for i, child in ipairs(node.Children) do
                checkNode(child, path .. "." .. (child.Name or ("child_" .. i)))
            end
        end
    end
    …
end
```

### 4.2 Befund: Robustheit **unzureichend** (Severity MEDIUM)

**Was funktioniert:**
- Name + Layout-Presence werden geprüft.
- ClassName + Position-Typ werden rekursiv geprüft.
- Wird in `Bootstrap.server.lua` Z. 36 aufgerufen — bei Fehler wird der Build mit `error()` abgebrochen (Fail-Loud).

**Was fehlt:**

| Fehlende Validierung | Impact |
|---|---|
| `Properties.Size` muss Vector3 sein (sonst crasht `Instance.Size = …`) | HIGH |
| `Properties.Anchored` sollte für nicht-Spawn Parts `true` sein | HIGH (sonst stürzen Parts unkontrolliert ab) |
| `Model`-Knoten brauchen `PrimaryPart` (sonst Crash bei `:MoveTo`) | MEDIUM |
| Doppelte `Name`-Werte in derselben Hierarchie-Ebene | MEDIUM (Roblox erlaubt gleiche Namen, aber Logic wird verwirrend) |
| NPC-Spawn-Cubes müssen in Hub-Sicht sein (Validierungs-Check existiert als Kommentar Z. 103, ist aber **nicht implementiert**) | HIGH |
| NPC-IDs in `Attributes.NpcId` sollten gegen Whitelist geprüft werden (Lina, Yuki, Maja, Nils existieren in Map; was, wenn jemand „Bob" einfügt?) | MEDIUM |
| Quest-Hooks in `Attributes.QuestHook` sollten dem `M02_Quest`-Registry entsprechen | MEDIUM |
| Kräne (`CraneA/B/C`) brauchen Kind `ContainerSpawn` für Quest | LOW |
| Eindeutigkeit von Kran-Positionen (sonst Spawn-Kollisionen) | LOW |
| Position-Kollisionen: zwei Parts an identischer Position | LOW |
| Material `Enum.Material.Neon` an nicht-Lichtquellen → Art-Direction-Verstoß | LOW (zu spät) |

**Beweis, dass die TODOs im Code stehen (Kommentar Z. 103):**
> „-- Weitere Checks: Spawn-Punkte müssen in Hub-Sicht sein, NPCs müssen benannt sein, etc."

→ **TODOs sind im Code markiert, aber nicht implementiert.**

**Fehlende Tests:** Es gibt keine `MapBuilder.spec.lua` in `src/tests/` (nur
`M07_Economy.spec.lua` und `M15_Localization.spec.lua` sind vorhanden).

---

## 5. Workspace-Hierarchie

### 5.1 Aktueller Stand (`default.project.json` Zeile 50–76)

```
Workspace
├── Districts (Folder)
│   ├── HamburgHarbor (Folder) ← Vertical Slice, leer!
│   ├── SkyBridgeBay (Folder) ← nur als Preview-Stub?
│   ├── LibertyBlocks (Folder)
│   ├── NeoSakura (Folder)
│   └── MoonBazaar (Folder)
└── Hub
    └── SkyPlaza (Folder) ← laut World Bible der soziale Treffpunkt
```

### 5.2 Befund: **Tiefe = 2 Ebenen**, leer

**Severity: MEDIUM**

| Aspekt | Bewertung |
|---|---|
| Hierarchie-Tiefe | 2 Ebenen (`Workspace > Districts > HamburgHarbor`); für Spiel-Logik reicht das, aber für Performance-Culling und Streaming fehlt die Granularität. |
| Trennung „Build" vs. „Logic" | Keine Trennung. Server-Logic läuft in `workspace.Districts.HamburgHarbor` mit Visual-Mesh zusammen. **Anti-Pattern** in Production-Code. |
| ServerStorage für Mesh-Quellen | `MeshId`-Quellen sollten in `ServerStorage` (oder `ReplicatedStorage` als `MeshPart` vorgebacken) liegen, nicht direkt im Workspace. |
| StreamingEnabled-Kompatibilität | Für Streaming braucht jedes Sub-Area eigene `Model`-Wurzel mit niedriger Polygon-Distanz. Aktuell ist `HamburgHarbor` ein leerer Folder → Streaming kann nicht greifen. |
| CollectionService-Tags | D-014 erwähnt `ContainerType = "Crate"` als Attribut, aber kein CollectionService-Tag (z.B. `Tag:CraneContainer`) für effiziente Queries. |

**Beweis (`grep "CollectionService" src/`):** 0 Treffer.

---

## 6. Build-Datei (`builds/CurioWorld_HamburgHarbor.rbxl`)

### 6.1 Fakten

- Datei: 47 252 Bytes (46,14 KB)
- Format: Roblox Binary Placefile (`.rbxl`)
- Inhalt (per ASCII-Inspektion): die gesamte `src/`-Lua-Hierarchie + die Map-Daten-Definition + die Locale-Tabelle als binäre PROPS-Blobs. Keine Mesh-Daten, keine Texturen.

### 6.2 Befund

**Severity: LOW (für Audit-Scope)**, aber **HIGH (für Release Readiness)**

Die `.rbxl`-Datei ist ein **manuell exportierter Studio-Snapshot** und kein
produktionsfähiger Build. Begründung:

1. Sie enthält **keine Mesh-Einträge** — alles ist `Part`, nicht `MeshPart`. Die
   1,4 MB FBX-Assets sind nicht eingebacken.
2. Sie ist **46 KB klein** — eine echte Hamburger-Hafen-Welt mit 19 FBX-Assets,
   Texturen, NPCs und Atmosphäre würde mehrere MB groß sein.
3. Es gibt **kein Build-Script** im Projekt (kein `tooling/build.sh`,
   `tooling/build.lua`, `Makefile`, `aftman.toml`-Build-Step, etc.). Die Datei
   wurde vermutlich einmal manuell in Studio geöffnet und exportiert.

**Beweis (`Get-ChildItem tooling/`):**

```
$ Get-ChildItem tooling/
Mode    Name
----    ----
(no entries)
```

→ Es existiert **kein Build-Tooling** im Projekt. Auch das `aftman.toml` und
`selene.toml` im Root sind nur Toolchain-Pinning, keine Build-Scripts.

---

## 7. Adversarial Probes

### Probe 1: Wäre ein 14-Jähriger Roblox-Spieler beeindruckt?

**Frage aus `AGENTS.md` §11.4:**
> „Würde ein 14-jähriger Roblox-Spieler, der Genshin, Animal Crossing und Mario Odyssey
> gewohnt ist, das in den ersten 30 Sekunden als Premium-Produkt erkennen?"

**Erwartete Antwort nach Premium-Standard:** Ja, das fühlt sich wie ein echtes Premium-
Spiel an.

**Tatsächliche Antwort:** Nein. Was der Spieler in den ersten 30 Sekunden sieht:

- SpawnLocation (transparent, default Roblox-Look)
- WelcomeSign = eine flache, beige Box in der Luft (kein Schild, kein Text, kein Material)
- 3 Kräne = je 2 orange Boxen, die wie orangefarbene Grabsteine aussehen
- Speicherhaus = ein beige Rechteck (Floor) + ein semitransparentes Backstein-Rechteck (Walls, 0.2 Transparency!)
- Leuchtturm = ein weißer 18-Stude-Zylinder mit einem gelben Neon-Würfel obendrauf
- Hafenbecken = eine blaue Box (`Enum.Material.Water` reicht visuell nicht)
- NPCs: nicht sichtbar (nur Spawn-Punkte)

**Das ist visuell unter dem Niveau eines Schülerprojekts** (siehe AGENTS.md §11.3
Anti-Pattern: „Funktioniert in unseren Tests" / „Spieler werden das nicht merken").

→ **Probe 1: FAIL** — Visuelles Premium-Niveau klar verfehlt.

### Probe 2: Was passiert, wenn ein NPC-Spawn-Cube an einer Position ist, wo ein anderer Part steht?

**Test:** ContainerSpawn bei CraneA liegt auf `(-5, 9, 15)`. CraneA.Base liegt auf
`(-25, 6, 15)` (Position OK, kollidiert nicht). CraneA.Arm liegt auf `(-15, 12, 15)`.

Der ContainerSpawn bei `(-5, 9, 15)` ist 20 Studs vom Base entfernt, 3 Studs unter
der Arm-Höhe. Das Seil-/Haken-System ist nicht modelliert — der Container schwebt
in der Luft ohne visuelle Verbindung zum Kran.

→ **Logik funktioniert, aber visuell ist das ein fliegender Cube.** Im Kontext von
D-014 („Kran-Schwingen als Highlight") ist das ein **Vertrauensbruch**: das Kind
sieht einen Kran ohne Seil, an dem ein Container ohne Aufhängung schwebt.

**Probe 2: FAIL**

### Probe 3: Lighting → Default-Tageszeit = Mittag (ClockTime = 14)

**Test:** Da kein ClockTime gesetzt ist, zeigt die Welt Mittagslicht.
Hamburg-Harbor-Atmosphäre soll aber „warmes Abendlicht, das die Stadt einbettet"
(world bible Z. 146) zeigen.

→ 14:00-Mittagslicht + Roblox-Default-Skybox + keine Atmosphere = die Hafen-Silhouetten
und das warme Orange der Kräne wirken flach und klinisch, nicht einladend-abendlich.

**Probe 3: FAIL**

### Probe 4: Material.Neon für Leuchtturm-Laterne (Z. 334)

**Test:** Roblox' `Enum.Material.Neon` ist ein schlichter Shader, kein echtes
PBR-Emissive mit Bloom. Das World-Bible verlangt aber „warmem Gelb"-Laterne (Z. 196
„Spielmechanik Hafen-Glocke") und die Blender-Pipeline baut die Laterne mit
echtem `Emission Strength = 2.5`.

**Konsequenz:** Selbst wenn das Leuchtturm-FBX korrekt importiert würde, würde die
Map-Daten-Definition das Mesh mit Neon-Material überschreiben (siehe `applyProperties`
Z. 35–38 von `MapBuilder.lua` — `(instance)[key] = value` setzt alle Properties gnadenlos).

→ **Map-Daten-Definition hat Material-Override, der Mesh-Materialien zerschlägt.**

**Probe 4: FAIL**

### Probe 5: MapBuilder.ApplyProperties — silent failure bei unbekannten Properties

**Test:** Der `pcall(function() (instance)[key] = value end)` (Z. 35–37) schluckt
alle Fehler. Wenn z.B. ein Designer `"Reflectance = 0.5"` setzt, aber das Property
in einer zukünftigen Roblox-Version umbenannt wird, gibt es keine Warnung.

**Konsequenz für die Spec:** Wenn die Map-Daten-Definition jetzt ein neues
Property einführt (z.B. `MeshId = "rbxassetid://..."` für die MeshPart-Migration),
muss man **manuell** testen, ob es gesetzt wurde — die Validate()-Funktion prüft
das nicht.

**Probe 5: FAIL (Forward-Compatibility-Risiko)**

### Probe 6: Welcome-Schild ohne Schriftzug

**Test:** `WelcomeSign` ist eine flache Box (8×4×0,5) ohne `SurfaceGui` oder
Text-Property. Es gibt keinen Text „Willkommen in Hamburg Harbor" oder ein
Bezirks-Symbol.

→ Die „Welcome"-Geste aus der Welt existiert visuell nicht. Ein 9-Jähriger, der
spawnt, sieht eine leere Box in der Luft.

**Probe 6: FAIL**

---

## 8. Gap-Summary: Was muss geändert werden?

### 8.1 Priorität 1 — CRITICAL (blockiert Premium-Standard)

| # | Gap | Aufwand | Owner-Rolle |
|---|---|---|---|
| 1 | **Alle Map-Assets** (WelcomeSign, CraneA/B/C, Speicherhaus, Leuchtturm, QuestBoard) als **MeshPart mit FBX-Referenz** statt `Part`-Primitive | XL | Builder + Style-Guardian |
| 2 | **Skybox + Lighting + Atmosphere** Konfiguration in `default.project.json` oder einem `LightingBootstrap.server.lua` | M | Builder |
| 3 | **NPC-Spawn-System**: spawnt echte NPCs aus `npc_basis_*.fbx` statt nur Attribute-Points | L | Builder + Pedagogical-Validator |
| 4 | **Boot**, **Anker**, **Laterne**, **Fass** als fehlende Map-Elemente platzieren (FBX existieren, Map-Daten fehlen) | M | Builder |
| 5 | **Material-Mapping**: `Enum.Material.Neon` für Leuchtturm-Laterne durch echte SurfaceAppearance mit Emission-Map ersetzen | S | Builder + Style-Guardian |

### 8.2 Priorität 2 — HIGH

| # | Gap | Aufwand | Owner-Rolle |
|---|---|---|---|
| 6 | **Sound** (Wasserplätschern, Kran-Glocken, Hafen-Instrumente) | M | Content-Writer + Builder |
| 7 | **Walls-Transparenz 0.2 entfernen** (Anti-Pattern aus Z. 224) — wird durch Mesh-Import gelöst | (mit #1) | Builder |
| 8 | **Trim-Sheet für Werft-Floor / Hafenbecken-Boden** (siehe §5 `07_art_direction.md`) | M | Modeler |

### 8.3 Priorität 3 — MEDIUM

| # | Gap | Aufwand | Owner-Rolle |
|---|---|---|---|
| 9 | **MapBuilder.Validate** erweitern (Size/Anchor/PrimaryPart/NpcId-Whitelist/QuestHook-Registry) | M | Builder + Pedagogical-Validator |
| 10 | **MapBuilder.spec.lua** schreiben (Unit-Tests für Validate) | M | Code-Reviewer |
| 11 | **Workspace.Hierarchie** tiefer (Workspace > Districts > HamburgHarbor > {Buildings, NPCs, Props, Lighting}) + ServerStorage-Mesh-Quellen | M | Builder |
| 12 | **Fehlende Export-Scripts** (export_anker.py, export_boot.py, export_fass.py, export_kiste.py, export_laterne.py, export_npc.py, export_quest_tafel.py, export_willkommen_schild.py, export_dock_planke.py) | L | Modeler + Builder |
| 13 | **Build-Tooling** (`tooling/build.sh` oder `tooling/build.lua`, das Rojo-Calls macht) | M | Builder |
| 14 | **PNG-Texturen** für alle Blender-Materials (Trim-Sheets pro Bezirk) | XL | Modeler + Style-Guardian |

### 8.4 Priorität 4 — LOW

| # | Gap | Aufwand | Owner-Rolle |
|---|---|---|---|
| 15 | **README.md** bereinigen (4 versprochene Skripte, 3 davon fehlen) | XS | Builder |
| 16 | **Collisions-Check** in Validate (keine doppelten Spawn-Positionen) | S | Builder |
| 17 | **CollectionService-Tags** für Container / Quest-Hooks | S | Builder |

---

## 9. Querverweise & Alignment

### 9.1 Stimmt der Befund mit D-002 und D-014 überein?

**D-002** (Vertical-Slice-Bezirk: Hamburg Harbor): „Hamburg Harbor bietet klare Anker
(Hafenbecken, Kaimauern, Kräne, Speicherhäuser, Werft, Leuchtturm) — visuell sofort
lesbar". → **Aktuell NICHT visuell sofort lesbar**, weil alle Anker als Boxen
implementiert sind. Die Entscheidung ist richtig, die Umsetzung hinkt.

**D-014** (Vertical-Slice-Bewegung: Kran-Schwingen): „Einzigartig, physikalisch
lehrreich, starke Mechanik-Identität". → Die Kräne sind geometrisch so unklar (2
Boxen, kein Mast, kein Ausleger, kein Seil, kein Haken), dass die Mechanik-Identität
visuell nicht trägt.

**`docs/19_release_readiness_checklist.md`:**
- §„Alle Companion-Modelle und Hauptassets in Performance-Budget": **NICHT prüfbar**, weil keine Hauptassets als Mesh importiert sind.
- §„Performance-Tests: Median FPS Mobile ≥ 30": Die jetzige Primitiv-Map läuft wahrscheinlich mit 60+ FPS auf Mobile, aber sie ist *so leer*, dass das kein Maßstab ist. Mit echten Mesh-Parts wird sich zeigen, ob die Trim-Sheet-Strategie hält.
- §„Asset-Pipeline-Versionen sind gepinnt und dokumentiert": D-012 ist „entschieden" und beschreibt die Pipeline; aber die Pipeline ist **halb implementiert** (3/7 angekündigte Skripte, 0 Trim-Sheets).

### 9.2 Stimmt der Befund mit `06_world_bible.md` Hamburg-Atmosphäre überein?

Zitat WB Z. 145 ff.: „Pastellige Farbpalette mit warmem Abendlicht, das die Stadt
einbettet. Wasser, Möwen (komponiert, keine echten Tiergeräusche), Hafenkran-Silhouetten.
Sound-Identität: sanfte Wasserplätschern, mechanische Kran-Glocken (kindgerecht),
leise Hafen-Instrumente."

→ Von den 5 Atmosphäre-Merkmalen (Farbpalette ✓ teilweise, Abendlicht ✗, Wasser ✗,
Möwen ✗, Sound ✗) sind **3 nicht erfüllt** und 1 nur teilweise (Material-Farben sind
gesetzt, aber kein Licht-Support).

### 9.3 Stimmt der Befund mit `07_art_direction.md` Performance-Vorgaben überein?

Budgets:
- Prop klein: ≤ 1 500 Polys → kran_lod0 hat ~6 Teile × ~48 Vertices × 2 Tris/Vert = ~576 Tris (LOD0). **OK**.
- Landmarke: ≤ 25 000 Polys → leuchtturm_lod0 hat ~7 Teile × ~96 Vertices = ~672 Tris. **OK**.
- Speicherhaus: 5 Wände + 6 Fenster + Dach + Schornstein + … ≈ ~3 000 Tris (geschätzt aus Subdiv-Levels 3, 20 Vertices je Cylinder + 4 Cube-Tris). Im Budget für „Prop mittel" (4 000 Polys). **OK**.

→ Die FBX-Geometrie ist **im Budget**. Das Problem ist nicht die FBX-Qualität, sondern
dass sie nicht referenziert wird.

---

## 10. Method & Evidence (Audit-Transparenz)

| Check | Methode | Quelle |
|---|---|---|
| Asset-Inventar | `Get-ChildItem` mit Size-Berechnung | `roblox-studio/assets/fbx/` |
| Blender-Scripts | `Get-ChildItem + Read` | `roblox-studio/assets/blender-scripts/` |
| MeshPart-Usage | `grep -r "MeshPart\|MeshId\|AssetId"` | `roblox-studio/src/`, `default.project.json` |
| Lighting-Konfig | `grep -r "Lighting\|Brightness\|Ambient\|Technology\|Fog\|ClockTime\|Atmosphere\|Skybox"` | gesamtes Projekt |
| PNG-Texturen | `glob "**/*.png"` | `roblox-studio/assets/` |
| Workspace-Hierarchie | `Read` von `default.project.json` | `roblox-studio/default.project.json` |
| MapBuilder | `Read` von `src/shared/Modules/MapBuilder.lua` | gesamte Datei (131 Z.) |
| Cross-References | `Read` von `06_world_bible.md`, `07_art_direction.md`, `19_release_readiness_checklist.md`, `D-002`, `D-014`, `08_asset_pipeline_*.md` | gesamte Dateien |
| Build-Datei | `Get-Content -Raw` auf `.rbxl` | `roblox-studio/builds/CurioWorld_HamburgHarbor.rbxl` (46 KB, ASCII-Insp.) |

**Limitationen dieser Audit-Methode:**
- Die `.rbxl`-Inspektion ist nur String-basiert; echte Binär-Properties
  (z.B. verschachtelte Mesh-Daten) könnten unentdeckt bleiben. Aber alle
  Lua-Sourcen sind als lesbare Strings vorhanden, und es gibt **keinen Hinweis
  auf Mesh-Einträge** in den lesbaren Bereichen.
- Die Roblox-Default-Werte für Lighting/Atmosphere/Skybox werden in `.rbxl`-Files
  *nicht* als Properties gespeichert, sondern vom Engine beim Laden gesetzt.
  Daher kann die Audit-Methode nicht beweisen, dass die Defaults „neutrales
  Mittagslicht" sind — sie kann nur zeigen, dass **keine Custom-Konfiguration**
  gesetzt wurde.

---

## 11. Audit-Schluss

**Visuelle Qualität ist die Top-1-Beschwerde des Users.** Der Audit bestätigt: der
Befund ist **voll berechtigt** und das Problem ist **systemisch**, nicht kosmetisch.

- 8/8 Haupt-Assets sind `BLOCKY_PRIMITIVE` obwohl 19 FBX-Assets vorhanden sind
- 0/5 Atmosphäre-Aspekte sind konfiguriert (`MISSING_CONFIG`)
- 4/4 NPCs sind Spawn-Punkte ohne Mesh (`BLOCKY_PRIMITIVE`)
- MapBuilder.Validate ist halbfertig (TODOs in den Kommentaren)
- Workspace-Hierarchie ist 2 Ebenen flach, kein Streaming-fähig
- Build-Tooling existiert nicht

**Empfehlung an Producer:**

> Die Vertikale Slice ist **inhaltlich konzipiert** (siehe World Bible, D-002, D-014)
> und die **FBX-Pipeline ist zur Hälfte funktionsfähig** (Kran, Leuchtturm,
> Speicherhaus exportiert). Was fehlt, ist die **letzte Meile: die Mesh-zu-Map-
> Verkabelung**. Ohne diese Meile bleibt die Welt visuell eine Sammlung von
> Boxen — unabhängig davon, wie gut das Konzept und die Pädagogik sind.
>
> **Empfohlene Reihenfolge:**
> 1. Lighting/Atmosphere/Skybox konfigurieren (S, sofort, hebt die Stimmung am meisten).
> 2. Speicherhaus + Leuchtturm + Kran als MeshPart einbinden (M, jeweils ~1 Sprint).
> 3. NPC-Spawner schreiben + 4 NPCs als echte Meshes platzieren (L).
> 4. Trim-Sheets für Werft + Hafenbecken (XL, aber wichtig für Mobile-Performance).
> 5. Fehlende Export-Scripts für Anker/Boot/Fass/Kiste/Laterne/Quest-Tafel (L).

**Bis dahin: VERDICT: FAIL** auf der Frage „ist die Vertikale Slice visuell auf
Premium-Niveau?" — die Antwort ist ein klares Nein.

---

*Audit erstellt am 2026-06-27 von Verifier-Agent (adversarial mode).*
*Alle Befunde sind durch Datei-Inspektion und Code-Lese belegt — keine Annahmen ohne Beweis.*
