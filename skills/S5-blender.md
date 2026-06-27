# Skill S5 — Blender-Asset-Standard

## Zweck
Stellt sicher, dass alle 3D-Assets (Charaktere, NPCs, Items, Welten) **konsistent, performant und Roblox-tauglich** sind.

## Wann anwenden
- **Bei:** jedem neuen Mesh, jeder Textur, jeder Animation
- **Loop:** B (Produkt)
- **Sub-Agent-Rolle:** Style-Guardian prüft visuelle Konsistenz, Code-Reviewer prüft Export-Korrektheit

## Charakter-Modelle

### Triangle-Budget

```
☐ Avatare (Spieler-Charakter): ≤ 5.000 Triangles
☐ NPCs (einzelne Charaktere): ≤ 8.000 Triangles
☐ Bosse (große Gegner): ≤ 15.000 Triangles
☐ Lumi: ≤ 4.000 Triangles (Liebling, muss schnell laden)
☐ Tiere: ≤ 3.000 Triangles
```

### Topologie-Regeln

```
☐ Saubere Edge-Loop-Flow (keine Pole, wo sie vermeidbar sind)
☐ Quads wo möglich, Triangles nur an joint-Nähe
☐ Symmetrie (Mirror-Modifier vor Export anwenden)
☐ Sauberes UV (kein Overlap, 0-1 Space genutzt)
☐ Polygon-Density: gleichmäßig, keine Spike-Vertices
☐ Origin am Boden (0,0,0) für Roblox-Platzierung
☐ Forward = -Z, Up = +Y (Roblox-Convention)
```

### Rigging-Standard

```
☐ Humanoid-Rig mit Standard-Bones:
   - Head, Neck, Spine, Hip, Upper/Lower-Arm, Upper/Lower-Leg, Hands, Feet
☐ Optional: Mixamo-kompatibel (für Auto-Rigging neuer NPCs)
☐ Bone-Naming folgt Roblox-Konvention
☐ Skinning testen: keine zerknautschten Stellen bei Posen
☐ IK-Handles für Hände und Füße (für saubere Animationen)
```

### Outfits als separates Mesh

```
☐ Charakter-Body + Outfit separat (skinnable)
☐ Outfit-Meshes parented an Body-Bones
☐ Verschiedene Outfits dürfen Body nicht verformen
☐ Skins (Materialien) austauschbar ohne Geometrie-Änderung
```

## Animationen

```
☐ Stand-Animationen (Idle, Sit, Sleep)
☐ Bewegungs-Animationen (Walk, Run, Jump, Fall, Land)
☐ Action-Animationen (Climb, Swim, Dance, Wave)
☐ Emote-Set (mindestens 6 distinkte Emotes)
☐ Facial: mind. 6 Mundformen + 6 Augenformen (für Lip-Sync)
☐ Framerate: 30 FPS für Bewegungen, 60 FPS für Facial
☐ Loop-Animationen sauber (kein Pop am Übergang)
```

## Umgebungen

### Modularer Aufbau

```
☐ Module-Größe: 4×4×4 Studs Standard (für Snap-Grid)
☐ Module-Typen: Boden, Wand, Dach, Fenster, Tür, Treppe, Geländer, Brücke
☐ Snap-Points klar definiert (Vertices zum Ausrichten)
☐ Module-Kombinationen vorher getestet (3 Module × 3 Rotationen)
☐ Materialien tauschbar (Mauer/Holz/Stein für selbe Geometrie)
```

### Städte — Performance

```
☐ Pro Stadt: 80–150 Module insgesamt
☐ Streaming-Enabled (Roblox lädt on-demand)
☐ Detail-Reduction mit LOD (3 Stufen):
   - LOD0: < 50m, volle Geometrie
   - LOD1: 50–150m, ~50% Tris
   - LOD2: > 150m, ~20% Tris, billboard-ähnlich
☐ Lightmaps vorgebacken für statisches Licht
☐ Keine unnötigen Echtzeit-Lichter in LOD2-Bereichen
```

## Texturen

```
☐ Auflösung Standard:
   - Charaktere: 512×512
   - Items: 256×256
   - Umgebungen: 1024×1024 (max 2048×2048)
☐ Format: PNG (transparent) oder JPG (opak)
☐ Farbprofil: sRGB
☐ Normal-Maps für Materialien, die nicht flach wirken sollen
☐ Keine Texturen > 4 MB im Final-Build
```

## Export-Pipeline (kritischer Schritt)

```
☐ Export-Format: FBX (nicht glTF, weil Roblox-Importer reifer)
☐ Apply-Transformations: ✓
☐ Forward: -Z Forward, Up: +Y Up (Roblox-Default)
☐ Animationen eingebettet, Bake-Action: ✓
☐ Nur ausgewählte Objekte exportieren
☐ Datei-Größe-Check: < 50 MB pro Asset
☐ Smoke-Test: in Roblox importieren, platzieren, spielen
☐ Versions-Hash in Dateiname: lumi_v3_happy_idle.fbx
```

## Roblox-Import

```
☐ Avatar-Importer für humanoide Charaktere
☐ Mesh-Part-Import für Umgebungs-Module
☐ Material-ID dokumentiert für jede Textur
☐ Animation-ID nach Import notiert
☐ Performance-Profiler-Check auf Zielgerät
```

## Häufige Fehler

| Fehler | Auswirkung |
|---|---|
| Zu viele Triangles | Lag, 15 FPS auf Mobile |
| Kein LOD | Lange Ladezeiten |
| Falsche Forward/Up | Charakter steht seitwärts/kopfüber |
| UV-Overlap | Texturen wirken kaputt |
| Mixamo-Rig ohne Anpassung | Animationen clippen |
| Texturen > 4 MB | Roblox-Build schlägt fehl |
| Kein Origin am Boden | Charakter schwebt |

## Verbindlich mit anderen Skills
- **Skill S2** (Anime-Ästhetik) — visuelle Treue
- **Skill S4** (Luau-Code) — Naming-Konventionen müssen matchen

## Version
v1.0 — Juni 2026 — Initial definiert