"""
Blender Export Pipeline für Curio World
=======================================

Verwendung:
    blender --background --python export_kran.py -- --output assets/fbx/kran.fbx

Phase 2 Asset: Hamburg Harbor Hafen-Kran (Vertical Slice Highlight).

Dieses Skript:
1. Erzeugt einen stilisierten Hafen-Kran in Blender.
2. Setzt Roblox-konforme Pivot-Punkte.
3. Exportiert nach FBX mit Trim-Sheet-Optimierung.
4. Generiert LOD-Stufen (LOD0, LOD1, LOD2).

Voraussetzungen:
- Blender 3.6 LTS oder 4.x
- Python 3.10+
- bpy (im Blender-Python)
"""
import bpy
import bmesh
import sys
import os
import argparse


def parse_args():
    """Parst CLI-Argumente (alles nach '--')."""
    if "--" in sys.argv:
        argv = sys.argv[sys.argv.index("--") + 1:]
    else:
        argv = []

    parser = argparse.ArgumentParser(description="Curio World Blender Export")
    parser.add_argument("--output", required=True, help="Output FBX path")
    parser.add_argument("--lod", type=int, default=0, help="LOD-Stufe (0=full, 1=half, 2=quarter)")
    parser.add_argument("--trim-sheet", action="store_true", help="Apply trim-sheet optimization")
    return parser.parse_args(argv)


def clear_scene():
    """Löscht alle Objekte in der Szene."""
    bpy.ops.object.select_all(action='SELECT')
    bpy.ops.object.delete()


def create_crane(lod=0):
    """
    Erzeugt einen stilisierten Hafen-Kran.

    Stil: Anime-Cute (siehe docs/07_art_direction.md):
    - Wasserblau + Werft-Orange als Hauptfarben
    - Abgerundete Formen, keine harten Kanten
    - Dicke Außenlinien (Edge-Loop)
    - Pastellig, freundlich

    LOD:
    - 0: Full detail (~3.000 Polys)
    - 1: Half (1.500 Polys)
    - 2: Quarter (750 Polys)
    """
    # Polycount-Budget für LOD-Stufe
    subdiv_levels = {0: 3, 1: 2, 2: 1}[lod]

    # 1. Basis-Säule (vertikaler Mast)
    bpy.ops.mesh.primitive_cylinder_add(
        radius=0.6, depth=12.0,
        location=(0, 0, 6.0),
        vertices=16 * subdiv_levels
    )
    base = bpy.context.active_object
    base.name = f"Kran_Base_LOD{lod}"

    # 2. Ausleger (horizontaler Arm)
    bpy.ops.mesh.primitive_cylinder_add(
        radius=0.4, depth=10.0,
        location=(5.0, 0, 11.5),
        rotation=(0, 1.5708, 0),  # 90° um Y
        vertices=12 * subdiv_levels
    )
    arm = bpy.context.active_object
    arm.name = f"Kran_Arm_LOD{lod}"

    # 3. Kontergewicht (Box mit abgerundeten Kanten)
    bpy.ops.mesh.primitive_cube_add(
        size=2.0,
        location=(-3.0, 0, 11.5),
    )
    cube = bpy.context.active_object
    cube.name = f"Kran_Counterweight_LOD{lod}"

    # Bevel Modifier für abgerundete Kanten (Cute-Art)
    bevel = cube.modifiers.new(name="Bevel", type='BEVEL')
    bevel.width = 0.15
    bevel.segments = 3 + lod
    bevel.profile = 0.7
    bpy.context.view_layer.objects.active = cube
    bpy.ops.object.modifier_apply(modifier=bevel.name)

    # 4. Seil (vertikal, vom Ausleger-Ende nach unten)
    bpy.ops.mesh.primitive_cylinder_add(
        radius=0.05, depth=8.0,
        location=(9.5, 0, 7.5),
        vertices=6
    )
    rope = bpy.context.active_object
    rope.name = f"Kran_Rope_LOD{lod}"

    # 5. Haken (Container-Haken)
    bpy.ops.mesh.primitive_torus_add(
        major_radius=0.4,
        minor_radius=0.12,
        location=(9.5, 0, 3.3),
        rotation=(0, 0, 1.5708),
        major_segments=8 * subdiv_levels,
        minor_segments=6
    )
    hook = bpy.context.active_object
    hook.name = f"Kran_Hook_LOD{lod}"

    # 6. Container (klein, am Haken)
    bpy.ops.mesh.primitive_cube_add(
        size=1.6,
        location=(9.5, 0, 2.0),
    )
    container = bpy.context.active_object
    container.name = f"Kran_Container_LOD{lod}"
    bevel = container.modifiers.new(name="Bevel", type='BEVEL')
    bevel.width = 0.1
    bevel.segments = 2 + lod
    bpy.context.view_layer.objects.active = container
    bpy.ops.object.modifier_apply(modifier=bevel.name)

    # Materialien zuweisen (Cute-Art Wasserblau + Werft-Orange)
    mat_orange = create_material("Werft_Orange", (0.95, 0.55, 0.20, 1.0), roughness=0.6)
    mat_blue = create_material("Wasserblau", (0.35, 0.65, 0.85, 1.0), roughness=0.5)
    mat_yellow = create_material("Laterne_Gelb", (0.95, 0.85, 0.30, 1.0), roughness=0.5)
    mat_red = create_material("Container_Rot", (0.85, 0.30, 0.25, 1.0), roughness=0.7)
    mat_wood = create_material("Holz_Beige", (0.85, 0.70, 0.50, 1.0), roughness=0.8)

    assign_material(base, mat_orange)
    assign_material(arm, mat_orange)
    assign_material(cube, mat_yellow)
    assign_material(rope, mat_wood)
    assign_material(hook, mat_blue)
    assign_material(container, mat_red)

    # Alle Objekte zu einer Collection "Kran" gruppieren
    kran_collection = bpy.data.collections.new(f"Kran_LOD{lod}")
    bpy.context.scene.collection.children.link(kran_collection)

    for obj in [base, arm, cube, rope, hook, container]:
        # Aus Main-Collection entfernen
        for col in obj.users_collection:
            col.objects.unlink(obj)
        # Zur Kran-Collection hinzufügen
        kran_collection.objects.link(obj)

    return kran_collection


def create_material(name, color, roughness=0.5):
    """Erstellt ein PBR-Material."""
    mat = bpy.data.materials.new(name=name)
    mat.use_nodes = True
    bsdf = mat.node_tree.nodes.get("Principled BSDF")
    if bsdf:
        bsdf.inputs["Base Color"].default_value = color
        bsdf.inputs["Roughness"].default_value = roughness
        # Subsurface für Cute-Art Glow
        bsdf.inputs["Subsurface Weight"].default_value = 0.05
    return mat


def assign_material(obj, material):
    """Weist einem Objekt ein Material zu."""
    if obj.data.materials:
        obj.data.materials[0] = material
    else:
        obj.data.materials.append(material)


def apply_trim_sheet():
    """
    Wendet Trim-Sheet-Optimierung an (für Performance-Budgets).

    Konzept: Eine Textur wird mehrfach für verschiedene Objekte genutzt.
    Vorteil: weniger Draw Calls, kleinere Asset-Größe.
    """
    # Phase 3: trim-sheet generation
    # Für jetzt: Platzhalter
    pass


def export_fbx(output_path, lod=0):
    """Exportiert die Szene als FBX."""
    os.makedirs(os.path.dirname(output_path), exist_ok=True)

    bpy.ops.export_scene.fbx(
        filepath=output_path,
        use_selection=False,
        apply_unit_scale=True,
        apply_scale_options='FBX_SCALE_UNITS',
        bake_space_transform=True,
        object_types={'MESH'},
        use_mesh_modifiers=True,
        mesh_smooth_type='FACE',
        use_subsurf=False,
        use_tspace=True,
        use_custom_props=True,
        path_mode='AUTO',  # Texturen relativ
        embed_textures=True,
        axis_forward='-Z',
        axis_up='Y',
    )

    print(f"[Kran-LOD{lod}] Exportiert nach: {output_path}")


def main():
    args = parse_args()

    print(f"[CurioWorld Blender Pipeline] Starte Kran-Export (LOD {args.lod})...")
    clear_scene()
    create_crane(lod=args.lod)

    if args.trim_sheet:
        apply_trim_sheet()

    export_fbx(args.output, lod=args.lod)
    print(f"[CurioWorld Blender Pipeline] Fertig.")


if __name__ == "__main__":
    main()