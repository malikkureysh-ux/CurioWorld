"""
Blender Export Pipeline — Hamburg Harbor Leuchtturm
===================================================

Verwendung:
    blender --background --python export_leuchtturm.py -- --output assets/fbx/leuchtturm_lod0.fbx --lod 0

Phase 2 Asset: Hamburg Harbor Leuchtturm-Insel Höhepunkt.

Stil: Anime-Cute / Hafen-Architektur.
- Streifenweiß-roter Turm (klassisch, aber abgerundet)
- Konische Laterne mit warmem Gelb
- Veranda mit Geländer
- Steinerner Sockel mit Wasser-Spritzer-Detail
"""
import bpy
import sys
import os
import argparse


def parse_args():
    if "--" in sys.argv:
        argv = sys.argv[sys.argv.index("--") + 1:]
    else:
        argv = []
    parser = argparse.ArgumentParser(description="Curio World Leuchtturm Export")
    parser.add_argument("--output", required=True)
    parser.add_argument("--lod", type=int, default=0)
    return parser.parse_args(argv)


def clear_scene():
    bpy.ops.object.select_all(action='SELECT')
    bpy.ops.object.delete()


def make_material(name, color, roughness=0.5, metallic=0.0):
    mat = bpy.data.materials.new(name=name)
    mat.use_nodes = True
    bsdf = mat.node_tree.nodes.get("Principled BSDF")
    if bsdf:
        bsdf.inputs["Base Color"].default_value = color
        bsdf.inputs["Roughness"].default_value = roughness
        bsdf.inputs["Metallic"].default_value = metallic
        bsdf.inputs["Subsurface Weight"].default_value = 0.05
    return mat


def assign_material(obj, material):
    if obj.data.materials:
        obj.data.materials[0] = material
    else:
        obj.data.materials.append(material)


def add_bevel(obj, width=0.1, segments=2):
    mod = obj.modifiers.new(name="Bevel", type='BEVEL')
    mod.width = width
    mod.segments = segments
    mod.profile = 0.7
    bpy.context.view_layer.objects.active = obj
    bpy.ops.object.modifier_apply(modifier=mod.name)


def create_leuchtturm(lod=0):
    """
    Anime-Cute Leuchtturm. Maße in Blender-Units (1 BU = 1 Roblox-Stud).

    Komponenten:
    - Sockel: Zylinder, Stein-Grau, 4 BU Durchmesser, 2 BU hoch
    - Turm: Zylinder mit rot-weißen Streifen (8 BU hoch, 2.5 BU Durchmesser)
    - Veranda: dünner Ring-Torus auf 7 BU Höhe
    - Laterne: kleines zylindrisches Glas (Neon-Gelb emittierend)
    - Dach: Konus spitz, dunkelrot
    - Spitze: kleine Kugel
    """
    subdiv = {0: 3, 1: 2, 2: 1}[lod]

    # 1. Sockel (Stein)
    bpy.ops.mesh.primitive_cylinder_add(
        radius=2.0, depth=2.0,
        location=(0, 0, 1.0),
        vertices=20 * subdiv
    )
    sockel = bpy.context.active_object
    sockel.name = f"Leuchtturm_Sockel_LOD{lod}"
    add_bevel(sockel, width=0.08, segments=2 + lod)

    # 2. Turm-Streifen-Rot (8 BU hoch, leicht konisch für Perspektive)
    bpy.ops.mesh.primitive_cylinder_add(
        radius=1.3, depth=8.0,
        location=(0, 0, 6.0),
        vertices=16 * subdiv
    )
    turm_rot = bpy.context.active_object
    turm_rot.name = f"Leuchtturm_Turm_LOD{lod}"
    add_bevel(turm_rot, width=0.05, segments=1 + lod)

    # Turm verjüngen (oben schmaler)
    bpy.ops.transform.resize(value=(0.85, 0.85, 1.0))

    # 3. Weißer Streifen-Ring (oberer Teil)
    bpy.ops.mesh.primitive_cylinder_add(
        radius=1.15, depth=2.0,
        location=(0, 0, 9.5),
        vertices=16 * subdiv
    )
    turm_weiss = bpy.context.active_object
    turm_weiss.name = f"Leuchtturm_Turm_Weiss_LOD{lod}"
    add_bevel(turm_weiss, width=0.05, segments=1 + lod)

    # 4. Veranda-Geländer (Ring um den Turm auf 10 BU Höhe)
    bpy.ops.mesh.primitive_torus_add(
        major_radius=1.6, minor_radius=0.08,
        location=(0, 0, 10.2),
        major_segments=16 * subdiv,
        minor_segments=6
    )
    veranda = bpy.context.active_object
    veranda.name = f"Leuchtturm_Veranda_LOD{lod}"

    # 5. Laterne (Glaskasten, emittierend)
    bpy.ops.mesh.primitive_cylinder_add(
        radius=0.9, depth=1.6,
        location=(0, 0, 11.5),
        vertices=12 * subdiv
    )
    laterne = bpy.context.active_object
    laterne.name = f"Leuchtturm_Laterne_LOD{lod}"
    add_bevel(laterne, width=0.03, segments=1 + lod)

    # 6. Dach (Konus spitz)
    bpy.ops.mesh.primitive_cone_add(
        radius1=1.1, radius2=0.0, depth=1.8,
        location=(0, 0, 12.7),
        vertices=12 * subdiv
    )
    dach = bpy.context.active_object
    dach.name = f"Leuchtturm_Dach_LOD{lod}"
    add_bevel(dach, width=0.04, segments=1 + lod)

    # 7. Spitze (Kugel, klein)
    bpy.ops.mesh.primitive_uv_sphere_add(
        radius=0.15,
        location=(0, 0, 13.85),
        segments=12 * subdiv,
        ring_count=8
    )
    spitze = bpy.context.active_object
    spitze.name = f"Leuchtturm_Spitze_LOD{lod}"

    # 8. Fahnenstange (kleines Stäbchen aus der Spitze)
    bpy.ops.mesh.primitive_cylinder_add(
        radius=0.025, depth=0.6,
        location=(0, 0, 14.35),
        vertices=6
    )
    stange = bpy.context.active_object
    stange.name = f"Leuchtturm_Fahne_LOD{lod}"

    # Materialien
    mat_stein = make_material("Leuchtturm_Stein", (0.65, 0.62, 0.55, 1.0), roughness=0.85)
    mat_rot = make_material("Leuchtturm_Rot", (0.82, 0.20, 0.18, 1.0), roughness=0.5)
    mat_weiss = make_material("Leuchtturm_Weiss", (0.95, 0.94, 0.90, 1.0), roughness=0.4)
    mat_gelb = make_material("Laterne_Gelb_Emittiv", (1.0, 0.85, 0.35, 1.0), roughness=0.3)
    mat_gelb.node_tree.nodes["Principled BSDF"].inputs["Emission Color"].default_value = (1.0, 0.78, 0.30, 1.0)
    mat_gelb.node_tree.nodes["Principled BSDF"].inputs["Emission Strength"].default_value = 2.5
    mat_dach_rot = make_material("Dach_Rot", (0.55, 0.15, 0.18, 1.0), roughness=0.4)
    mat_gold = make_material("Spitze_Gold", (0.85, 0.70, 0.30, 1.0), roughness=0.2, metallic=0.8)

    assign_material(sockel, mat_stein)
    assign_material(turm_rot, mat_rot)
    assign_material(turm_weiss, mat_weiss)
    assign_material(veranda, mat_weiss)
    assign_material(laterne, mat_gelb)
    assign_material(dach, mat_dach_rot)
    assign_material(spitze, mat_gold)
    assign_material(stange, mat_gold)

    # Collection
    coll = bpy.data.collections.new(f"Leuchtturm_LOD{lod}")
    bpy.context.scene.collection.children.link(coll)
    for obj in [sockel, turm_rot, turm_weiss, veranda, laterne, dach, spitze, stange]:
        for col in obj.users_collection:
            col.objects.unlink(obj)
        coll.objects.link(obj)

    return coll


def export_fbx(output_path):
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
        path_mode='AUTO',
        embed_textures=True,
        axis_forward='-Z',
        axis_up='Y',
    )
    print(f"[Leuchtturm] Exportiert nach: {output_path}")


def main():
    args = parse_args()
    print(f"[CurioWorld Blender Pipeline] Starte Leuchtturm-Export (LOD {args.lod})...")
    clear_scene()
    create_leuchtturm(lod=args.lod)
    export_fbx(args.output)
    print(f"[CurioWorld Blender Pipeline] Leuchtturm fertig.")


if __name__ == "__main__":
    main()
