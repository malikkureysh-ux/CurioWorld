"""
Blender Export Pipeline — Hamburg Harbor Speicherhaus
======================================================

Verwendung:
    blender --background --python export_speicherhaus.py -- --output assets/fbx/speicherhaus_lod0.fbx --lod 0

Speicherhaus = Hamburger Hafen-Lagerhaus (Speicherstadt-Referenz).
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
    parser = argparse.ArgumentParser()
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


def create_speicherhaus(lod=0):
    """
    Speicherhaus: Backstein + Satteldach + Fenster-Luken.

    Maße (BU):
    - Breite: 16
    - Tiefe: 12
    - Wand-Höhe: 7
    - First-Höhe: +5 (Satteldach)
    """
    subdiv = {0: 3, 1: 2, 2: 1}[lod]

    # 1. Bodenplatte (Stein, leicht überhöht)
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, 0, 0.3))
    boden = bpy.context.active_object
    boden.name = f"Speicher_Boden_LOD{lod}"
    boden.scale = (16.5, 12.5, 0.6)
    add_bevel(boden, width=0.05, segments=1 + lod)

    # 2. Wände (Backstein, mit Aussparung für Tür vorne)
    # Wir bauen 4 Wände einzeln, damit vorne eine Tür ist.
    # Vorderwand (Y=-6), mit Tür in der Mitte
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(-5.5, -6, 3.8))
    v_links = bpy.context.active_object
    v_links.name = f"Speicher_Wand_VL_LOD{lod}"
    v_links.scale = (5.0, 0.4, 7.0)

    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(5.5, -6, 5.0))
    v_oben_links = bpy.context.active_object
    v_oben_links.name = f"Speicher_Wand_VO_LOD{lod}"
    v_oben_links.scale = (5.0, 0.4, 3.5)

    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(5.5, -6, 5.0))
    v_oben_rechts = bpy.context.active_object
    v_oben_rechts.name = f"Speicher_Wand_VOR_LOD{lod}"
    v_oben_rechts.scale = (5.0, 0.4, 3.5)

    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, -6, 6.5))
    v_first = bpy.context.active_object
    v_first.name = f"Speicher_Wand_VF_LOD{lod}"
    v_first.scale = (16.5, 0.4, 1.0)

    # Rückwand (komplett)
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, 6, 3.8))
    wand_hinten = bpy.context.active_object
    wand_hinten.name = f"Speicher_Wand_Hinten_LOD{lod}"
    wand_hinten.scale = (16.5, 0.4, 7.0)

    # Seitenwand links
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(-8, 0, 3.8))
    wand_links = bpy.context.active_object
    wand_links.name = f"Speicher_Wand_Links_LOD{lod}"
    wand_links.scale = (0.4, 12.5, 7.0)

    # Seitenwand rechts
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(8, 0, 3.8))
    wand_rechts = bpy.context.active_object
    wand_rechts.name = f"Speicher_Wand_Rechts_LOD{lod}"
    wand_rechts.scale = (0.4, 12.5, 7.0)

    # 3. Türrahmen + Tür (rot, X mittig vorne)
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, -6.05, 2.0))
    tuer = bpy.context.active_object
    tuer.name = f"Speicher_Tuer_LOD{lod}"
    tuer.scale = (3.5, 0.2, 3.5)

    # 4. Fenster (3 vorne, 3 hinten, je 2 Seiten = insgesamt ~12)
    fenster_pos = [(-5, 5), (0, 5), (5, 5), (-5, -5), (0, -5), (5, -5)]
    fenster_liste = []
    for i, (x, y) in enumerate(fenster_pos):
        bpy.ops.mesh.primitive_cube_add(size=1.0, location=(x, y * 1.07, 5.5))
        f = bpy.context.active_object
        f.name = f"Speicher_Fenster_{i}_LOD{lod}"
        f.scale = (1.4, 0.15, 1.4)
        fenster_liste.append(f)

    # 5. Satteldach (2 schräge Flächen)
    # Linke Dachseite
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(-4, 0, 10))
    dach_l = bpy.context.active_object
    dach_l.name = f"Speicher_Dach_L_LOD{lod}"
    dach_l.scale = (8.5, 12.6, 0.3)
    bpy.ops.transform.rotate(value=0.5236, orient_axis='X')  # 30°

    # Rechte Dachseite
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(4, 0, 10))
    dach_r = bpy.context.active_object
    dach_r.name = f"Speicher_Dach_R_LOD{lod}"
    dach_r.scale = (8.5, 12.6, 0.3)
    bpy.ops.transform.rotate(value=-0.5236, orient_axis='X')

    # 6. Schornstein (Mitte hinten)
    bpy.ops.mesh.primitive_cylinder_add(
        radius=0.6, depth=2.0,
        location=(-3, 4, 11.5),
        vertices=12 * subdiv
    )
    schornstein = bpy.context.active_object
    schornstein.name = f"Speicher_Schornstein_LOD{lod}"

    # 7. Windfahne (auf First)
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.2, location=(0, 0, 13.2))
    fahne_kugel = bpy.context.active_object
    fahne_kugel.name = f"Speicher_Fahnenkugel_LOD{lod}"
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0.3, 0, 13.2))
    fahne_blatt = bpy.context.active_object
    fahne_blatt.name = f"Speicher_Fahnenblatt_LOD{lod}"
    fahne_blatt.scale = (0.5, 0.05, 0.3)

    # Materialien
    mat_backstein = make_material("Speicher_Backstein", (0.65, 0.32, 0.22, 1.0), roughness=0.85)
    mat_backstein_dunkel = make_material("Speicher_Backstein_Dunkel", (0.45, 0.22, 0.15, 1.0), roughness=0.85)
    mat_boden_stein = make_material("Speicher_Boden", (0.55, 0.52, 0.48, 1.0), roughness=0.95)
    mat_holz = make_material("Speicher_Holz", (0.42, 0.28, 0.18, 1.0), roughness=0.7)
    mat_fenster_gelb = make_material("Speicher_Fenster_Gelb", (1.0, 0.95, 0.60, 1.0), roughness=0.2)
    mat_fenster_gelb.node_tree.nodes["Principled BSDF"].inputs["Emission Color"].default_value = (1.0, 0.85, 0.40, 1.0)
    mat_fenster_gelb.node_tree.nodes["Principled BSDF"].inputs["Emission Strength"].default_value = 0.4
    mat_tuer_rot = make_material("Speicher_Tuer_Rot", (0.55, 0.15, 0.15, 1.0), roughness=0.6)
    mat_dach = make_material("Speicher_Dach_Ziegel", (0.30, 0.20, 0.18, 1.0), roughness=0.75)
    mat_schornstein = make_material("Speicher_Schornstein", (0.50, 0.45, 0.40, 1.0), roughness=0.9)
    mat_gold = make_material("Speicher_Fahne_Gold", (0.85, 0.70, 0.30, 1.0), metallic=0.7, roughness=0.3)

    assign_material(boden, mat_boden_stein)
    for w in [v_links, v_oben_links, v_oben_rechts, v_first, wand_hinten, wand_links, wand_rechts]:
        assign_material(w, mat_backstein)
    assign_material(tuer, mat_tuer_rot)
    for f in fenster_liste:
        assign_material(f, mat_fenster_gelb)
    assign_material(dach_l, mat_dach)
    assign_material(dach_r, mat_dach)
    assign_material(schornstein, mat_schornstein)
    assign_material(fahne_kugel, mat_gold)
    assign_material(fahne_blatt, mat_gold)

    coll = bpy.data.collections.new(f"Speicherhaus_LOD{lod}")
    bpy.context.scene.collection.children.link(coll)
    objects = [boden, v_links, v_oben_links, v_oben_rechts, v_first, wand_hinten,
               wand_links, wand_rechts, tuer] + fenster_liste + [dach_l, dach_r,
               schornstein, fahne_kugel, fahne_blatt]
    for obj in objects:
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
        path_mode='AUTO',
        embed_textures=True,
        axis_forward='-Z',
        axis_up='Y',
    )
    print(f"[Speicherhaus] Exportiert nach: {output_path}")


def main():
    args = parse_args()
    print(f"[CurioWorld Blender Pipeline] Starte Speicherhaus-Export (LOD {args.lod})...")
    clear_scene()
    create_speicherhaus(lod=args.lod)
    export_fbx(args.output)
    print(f"[CurioWorld Blender Pipeline] Speicherhaus fertig.")


if __name__ == "__main__":
    main()
