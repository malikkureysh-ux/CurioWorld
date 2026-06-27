# 08 — Asset Pipeline (Blender → Roblox)

## Zweck

Dieses Dokument definiert die End-to-End-Asset-Pipeline für Curio World: Erstellung in Blender, Optimierung, Export, Import nach Roblox Studio und Integration in die Experience. Es ist verbindliche Referenz für alle 3D-, Animations- und Materialarbeiten.

## Annahmen

- Roblox ist die Zielplattform; Roblox-Eigenheiten (Größen, Materialien, Meshformat) bestimmen das Export-Profil.
- Performance ist ein First-Class-Citizen; mobile Spielbarkeit ist Pflicht.
- Konsistente Naming-Konventionen sind nicht optional.
- LOD und Trim Sheets reduzieren Komplexität systematisch.
- Versionierung pro Asset ist Standard.
- Pipeline muss reproduzierbar und automatisierbar sein.

## Quellen

- Roblox Creator Documentation: Asset-Import (Stand 2026)
- Blender Export-Dokumentation (FBX, glTF)
- Erfahrungswerte aus Roblox-Creator-Community

## Phasen der Pipeline

### Phase 1 — Konzept und Vorproduktion

- Skizzen (Paper + Digital), Style-Guide-Übereinstimmung.
- Festlegung: Polygon-Budget, LOD-Stufen, Animationen.
- Asset-Card mit:
  - Name
  - Bezirk
  - Beschreibung
  - Polygon-Budget
  - Textur-Budget
  - Animationen
  - Tags

### Phase 2 — Modeling in Blender

- Stilisiertes Modeling auf Basis Style-Guide.
- Modulare Bausteine, wiederverwendbare Topologie.
- Mirror-Modifier, Array-Modifier für Symmetrie/Wiederholung.
- Saubere Vertex-Normals, sauberes UV-Layout.
- UV-Sets nach Trim-Sheet-Logik.
- Naming-Konvention: `mma_<bezirk>_<kategorie>_<name>_<lod>`

### Phase 3 — Material und Textur

- PBR-Materialien (Roblox-kompatibel: Base Color, Metallic, Roughness, Normal, optional Emission).
- Texturen in korrekter Power-of-2-Auflösung (256, 512, 1024).
- Trim Sheets pro Bezirk für Architektur.
- Keine externen Texturen über 1024² für Mobile-Spielbarkeit.

### Phase 4 — Rigging und Animation

- Rigging mit Blender-Armature-Modifier.
- Animationsrate: 30 fps Default.
- Animation-Loops sauber, sauberes Naming.
- NPC-Animationen: Idle, Walk, Run, Wave, Give-Item, Reaction.

### Phase 5 — Export

- Format: FBX (primär) oder glTF (sekundär) je nach Asset-Typ.
- Apply Modifiers vor Export.
- Baking von Animationen in Keyframes.
- Export-Settings:
  - Scale: 1 (Blender-Einheiten = Meter, Roblox-Anpassung im Studio)
  - Forward: -Y oder Z (je nach Asset)
  - Up: Z
  - Smoothing: Face
- Datei-Benennung: `mma_<bezirk>_<kategorie>_<name>_<lod>_v<n>.fbx`

### Phase 6 — Roblox Studio Import

- Nutzung des Asset Managers in Roblox Studio.
- Materialien werden als SurfaceAppearance übersetzt.
- Mesh-Parts werden in `Workspace` oder `ServerStorage` organisiert.
- Verweise über CollectionService für thematische Gruppierung.

### Phase 7 — Qualitätssicherung

- Polygon-Count-Check.
- Textur-Größen-Check.
- Material-Validierung (alle Channels vorhanden).
- LOD-Validierung in Testszene.
- Animation-Loop-Test.

### Phase 8 — Integration

- Asset wird in das LiveGame über Git-Workflow eingecheckt.
- Tagging-System für Designer:innen-Werkzeuge.

## Naming-Konvention

```
mma_<bezirk>_<kategorie>_<name>_<lod>_v<n>.<ext>
```

Beispiele:
- `mma_harbor_prop_kran_L0_v3.fbx`
- `mma_harbor_prop_kran_L1_v3.fbx`
- `mma_harbor_prop_kran_L2_v3.fbx`
- `mma_char_player_base_L0_v1.fbx`
- `mma_char_npc_lina_L0_v2.fbx`
- `mma_harbor_trimsheet_L0_v1.png`

## LOD-Strategie

| Stufe | Distanz | Polygon-Ziel | Textur-Ziel |
|---|---|---|---|
| L0 | 0–20 m | 100 % | 100 % |
| L1 | 20–80 m | 50 % | 50 % |
| L2 | >80 m | 20 % | 25 % |

LOD-Switching passiert automatisch basierend auf Spieler:innen-Distanz im Roblox Streaming-System.

## Trim-Sheet-Strategie

Pro Bezirk 1–2 Trim Sheets:
- Architektur-Trim: Wände, Dächer, Fenster, Türen
- Prop-Trim: Kisten, Fässer, Schilder, Laternen

Trim Sheets werden in UV-Räumen organisiert:
- Wand: 1024 × 1024 Tile, 8 × 8 Wiederholungen pro Sheet
- Dach: 512 × 512 Tile
- Fenster-Slot: 256 × 256 Slot

## Performance-Budgets pro Asset-Kategorie

| Kategorie | Polygone | Texturen | Animation |
|---|---|---|---|
| Spieler:in Basis | 8.000 | 4 × 512² | Skelett-Rig, 12 Animationen |
| NPC Basis | 6.000 | 4 × 512² | Skelett-Rig, 6 Animationen |
| Companion | 4.000 | 2 × 256² | Skelett-Rig, 4 Animationen |
| Prop klein | 1.500 | 1 × 256² | Statisch |
| Prop mittel | 4.000 | 2 × 512² | Statisch |
| Landmarke | 25.000 | 4 × 1024² | Statisch |
| Bauklotz | 2.500 | 1 × 256² | Statisch |

## Versions- und Asset-Management

- Versionskontrolle: Git LFS für FBX und große Texturen.
- Asset-Card (Markdown oder YAML) pro Asset in `assets/<bezirk>/<name>/ASSETCARD.md`.
- Tagging: Status (WIP / Review / Approved / Live).
- Library-Struktur: `assets/<bezirk>/<kategorie>/<name>/`

## Automation

### Blender-Python-Skript: `validate_export.py`

Funktionen:
- Naming-Convention-Check.
- Polygon-Count-Check gegen Budget.
- Textur-Größen-Check (Power of 2).
- UV-Layout-Check (keine Überlappungen).
- Animation-Loop-Check.

### Roblox Studio Plugin (intern)

- Asset-Import-Wrapper mit voreingestellten Materialien.
- Auto-LOD-Erzeugung (geplant Phase 3).
- Performance-Profiler-Integration (geplant Phase 3).

## Konkrete Schritte für Vertical Slice Hamburg Harbor

1. **Erste Test-Assets (Phase 2 Start):**
   - Hafen-Kran L0/L1/L2
   - Eine Tür (mit drei Größen)
   - Eine Wand (gerade und Kurve)
   - Eine Speicherhaus-Fassade
   - Ein Leuchtturm-Modul

2. **Erste Charakter-Assets:**
   - Spieler:innen-Basis (m/w/d, drei Höhen)
   - Käpt'n Lina (NPC)
   - Hafen-Katze Sumi (Companion)

3. **Pipeline-Validierung:**
   - Export → Import → Material-Anwendung → Performance-Messung.
   - Optimierungsschleife, falls Budgets überschritten.

## Risiken

- **Pipeline-Bruch:** Versionswechsel in Blender oder Roblox kann Pipeline zerschießen. Mitigation: Version-Pinning, Regression-Tests.
- **Asset-Flut:** Ohne klare Asset-Cards entstehen Duplikate und Inkonsistenzen. Mitigation: Card-Pflicht, Review vor Approved-Status.
- **Performance-Überschreitung:** Mobile ist die kritischste Plattform. Mitigation: Strikte Budgets, automatische Validierung.

## Offene Fragen

- Welche Blender-Version ist die Pipeline-Referenz? (Vorschlag: 4.2 LTS, Phase 2-Validierung.)
- Wie integrieren wir Animationen effizient in Roblox (Animation Editor vs. KeyframeSequence)? (Phase 3.)
- Wie verwalten wir Audio-Assets? (Phase 3 mit `09_system_architecture.md`.)

## Nächste Schritte

1. Blender-Skript `validate_export.py` schreiben.
2. Erste Hafen-Assets modellieren und durch die Pipeline schicken.
3. Asset-Card-Template finalisieren.
4. Roblox Studio Asset-Manager-Struktur anlegen.

## Änderungsverlauf

| Datum | Version | Änderung | Autor |
|---|---|---|---|
| 2026-06-27 | 0.1 | Initiale Asset-Pipeline-Spezifikation | Mavis (Agent) |
| 2026-06-27 14:25 | 0.2 | Refit: Curio World + 5-District-Plan + Gold/Gems/Robux (kein Stamina) + VIP-Komfort-Pass | Mavis (Agent) |
| 2026-06-27 14:50 | 0.3 | Refit: Wonder World → Curio World (Naming-Kollision mit existierendem Roblox-Pet-Game aufgedeckt) | Mavis (Agent) |
| 2026-06-27 | 0.1 | Initiale Asset-Pipeline-Spezifikation | Mavis (Agent) |