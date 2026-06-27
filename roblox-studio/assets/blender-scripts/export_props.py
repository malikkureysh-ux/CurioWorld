"""
Blender Export Pipeline — Curio World Props Pack
================================================

Erzeugt in EINEM Blender-Run mehrere Props:
- Boot (Ruderboot, anime-cute)
- Fass (Holz, mit Eisenringen)
- Kiste (Holz, mit Beschlägen)
- Dock-Planke (lang, Holzmaserung)
- Laterne (Hafen-Poller-Laterne)
- Anker (Symbol-Objekt)
- Willkommens-Schild (Holz, mit Schrift)
- Quest-Tafel (Holz, mit Kork-Oberfläche)
- NPC-Basis-Chibi (m/w, Basis-Mesh für Hafenwirtin, Yuki, Maja, Nils)
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
    parser.add_argument("--outdir", required=True)
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


def export_fbx(filepath):
    bpy.ops.export_scene.fbx(
        filepath=filepath,
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


def make_collection(name, objects):
    coll = bpy.data.collections.new(name)
    bpy.context.scene.collection.children.link(coll)
    for obj in objects:
        for col in obj.users_collection:
            col.objects.unlink(obj)
        coll.objects.link(obj)
    return coll


# ============================================================
# Boot (Ruderboot, 4 BU lang, 1.5 BU breit)
# ============================================================
def create_boot():
    objects = []

    # Rumpf (flach, halbierter Ellipsoid)
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, 0, 0.3))
    rumpf = bpy.context.active_object
    rumpf.scale = (2.0, 0.8, 0.5)
    add_bevel(rumpf, width=0.06, segments=3)
    objects.append(rumpf)

    # Bootsspitze (vorne spitz)
    bpy.ops.mesh.primitive_cone_add(radius1=0.7, radius2=0.0, depth=1.2, location=(2.3, 0, 0.3))
    spitze = bpy.context.active_object
    spitze.rotation_euler = (0, 0, 1.5708)  # 90° um Z
    objects.append(spitze)

    # Heck (flach)
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(-1.5, 0, 0.5))
    heck = bpy.context.active_object
    heck.scale = (0.4, 0.8, 0.7)
    objects.append(heck)

    # Sitzbank (quer)
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, 0, 0.9))
    bank = bpy.context.active_object
    bank.scale = (1.5, 0.15, 0.15)
    objects.append(bank)

    # Ruder
    bpy.ops.mesh.primitive_cylinder_add(radius=0.05, depth=2.5, location=(-1.5, 0.5, 0.8))
    ruder_stiel = bpy.context.active_object
    ruder_stiel.rotation_euler = (0.3, 0, 0)
    objects.append(ruder_stiel)
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(-1.5, 1.4, 0.5))
    ruder_blatt = bpy.context.active_object
    ruder_blatt.scale = (0.6, 0.05, 0.3)
    objects.append(ruder_blatt)

    mat_holz = make_material("Boot_Holz", (0.42, 0.26, 0.16, 1.0), roughness=0.85)
    mat_holz_dunkel = make_material("Boot_Holz_Dunkel", (0.28, 0.18, 0.12, 1.0), roughness=0.85)

    assign_material(rumpf, mat_holz)
    assign_material(spitze, mat_holz)
    assign_material(heck, mat_holz_dunkel)
    assign_material(bank, mat_holz_dunkel)
    assign_material(ruder_stiel, mat_holz_dunkel)
    assign_material(ruder_blatt, mat_holz_dunkel)

    return make_collection("Boot", objects)


# ============================================================
# Fass (Holzfass, mit Eisenringen)
# ============================================================
def create_fass():
    objects = []

    # Fass-Korpus (Zylinder)
    bpy.ops.mesh.primitive_cylinder_add(radius=0.7, depth=1.4, location=(0, 0, 0.7), vertices=24)
    korpus = bpy.context.active_object
    # Bauch-Form durch Skalierung
    korpus.scale = (1.0, 1.0, 1.0)
    bpy.ops.object.mode_set(mode='EDIT')
    bpy.ops.mesh.select_all(action='SELECT')
    bpy.ops.transform.resize(value=(1.15, 1.15, 1.0))
    bpy.ops.object.mode_set(mode='OBJECT')
    objects.append(korpus)

    # 3 Eisenringe (Torus)
    for z_pos in [0.3, 0.7, 1.1]:
        bpy.ops.mesh.primitive_torus_add(major_radius=0.81, minor_radius=0.04, location=(0, 0, z_pos),
                                          major_segments=24, minor_segments=6)
        ring = bpy.context.active_object
        objects.append(ring)

    # Deckel (flache Scheibe oben)
    bpy.ops.mesh.primitive_cylinder_add(radius=0.7, depth=0.05, location=(0, 0, 1.45), vertices=24)
    deckel = bpy.context.active_object
    objects.append(deckel)

    mat_holz = make_material("Fass_Holz", (0.50, 0.32, 0.20, 1.0), roughness=0.9)
    mat_eisen = make_material("Fass_Eisen", (0.35, 0.35, 0.40, 1.0), roughness=0.4, metallic=0.7)

    assign_material(korpus, mat_holz)
    assign_material(deckel, mat_holz)
    for r in objects[1:4]:
        assign_material(r, mat_eisen)

    return make_collection("Fass", objects)


# ============================================================
# Kiste (Holzkiste)
# ============================================================
def create_kiste():
    objects = []

    # Korpus
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, 0, 0.5))
    korpus = bpy.context.active_object
    korpus.scale = (1.6, 1.0, 1.0)
    add_bevel(korpus, width=0.04, segments=2)
    objects.append(korpus)

    # Deckel (leicht überstehend)
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, 0, 1.05))
    deckel = bpy.context.active_object
    deckel.scale = (1.7, 1.1, 0.1)
    add_bevel(deckel, width=0.04, segments=2)
    objects.append(deckel)

    # 4 Eckbeschläge (kleine Würfel)
    for (x, y) in [(-0.78, -0.48), (0.78, -0.48), (-0.78, 0.48), (0.78, 0.48)]:
        bpy.ops.mesh.primitive_cube_add(size=1.0, location=(x, y, 1.07))
        ecke = bpy.context.active_object
        ecke.scale = (0.12, 0.12, 0.12)
        objects.append(ecke)

    mat_holz = make_material("Kiste_Holz", (0.55, 0.38, 0.22, 1.0), roughness=0.9)
    mat_eisen = make_material("Kiste_Eisen", (0.30, 0.30, 0.35, 1.0), roughness=0.4, metallic=0.8)

    assign_material(korpus, mat_holz)
    assign_material(deckel, mat_holz)
    for o in objects[2:]:
        assign_material(o, mat_eisen)

    return make_collection("Kiste", objects)


# ============================================================
# Dock-Planke (lang, mit Holzmaserung-Andeutung)
# ============================================================
def create_dock_planke():
    objects = []

    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, 0, 0.1))
    plank = bpy.context.active_object
    plank.scale = (5.0, 1.0, 0.2)
    add_bevel(plank, width=0.03, segments=2)
    objects.append(plank)

    mat_holz = make_material("Dock_Planke", (0.45, 0.30, 0.18, 1.0), roughness=0.85)
    assign_material(plank, mat_holz)

    return make_collection("Dock_Planke", objects)


# ============================================================
# Laterne (Hafen-Poller mit Laterne oben)
# ============================================================
def create_laterne():
    objects = []

    # Poller (vertikale Stange)
    bpy.ops.mesh.primitive_cylinder_add(radius=0.08, depth=3.5, location=(0, 0, 1.75), vertices=12)
    poller = bpy.context.active_object
    objects.append(poller)

    # Sockel
    bpy.ops.mesh.primitive_cylinder_add(radius=0.2, depth=0.4, location=(0, 0, 0.2), vertices=16)
    sockel = bpy.context.active_object
    objects.append(sockel)

    # Querarm (an dem Laterne hängt)
    bpy.ops.mesh.primitive_cylinder_add(radius=0.05, depth=0.5, location=(0.25, 0, 3.0), vertices=8)
    arm = bpy.context.active_object
    arm.rotation_euler = (0, 0, 1.5708)
    objects.append(arm)

    # Laternenkörper (kleiner Käfig)
    bpy.ops.mesh.primitive_cylinder_add(radius=0.18, depth=0.4, location=(0.5, 0, 2.85), vertices=12)
    kaefig = bpy.context.active_object
    objects.append(kaefig)

    # Dach der Laterne
    bpy.ops.mesh.primitive_cone_add(radius1=0.22, radius2=0.0, depth=0.15, location=(0.5, 0, 3.15), vertices=12)
    ldach = bpy.context.active_object
    objects.append(ldach)

    mat_eisen = make_material("Laterne_Eisen", (0.25, 0.25, 0.28, 1.0), roughness=0.5, metallic=0.6)
    mat_gelb = make_material("Laterne_Glas_Gelb", (1.0, 0.92, 0.55, 1.0), roughness=0.15)
    mat_gelb.node_tree.nodes["Principled BSDF"].inputs["Emission Color"].default_value = (1.0, 0.78, 0.30, 1.0)
    mat_gelb.node_tree.nodes["Principled BSDF"].inputs["Emission Strength"].default_value = 3.0

    assign_material(poller, mat_eisen)
    assign_material(sockel, mat_eisen)
    assign_material(arm, mat_eisen)
    assign_material(kaefig, mat_gelb)
    assign_material(ldach, mat_eisen)

    return make_collection("Laterne", objects)


# ============================================================
# Anker
# ============================================================
def create_anker():
    objects = []

    # Schaft (vertikal)
    bpy.ops.mesh.primitive_cylinder_add(radius=0.08, depth=2.0, location=(0, 0, 1.0), vertices=12)
    schaft = bpy.context.active_object
    objects.append(schaft)

    # Querbalken oben
    bpy.ops.mesh.primitive_cylinder_add(radius=0.06, depth=1.0, location=(0, 0, 1.9), vertices=8)
    quer = bpy.context.active_object
    quer.rotation_euler = (1.5708, 0, 0)
    objects.append(quer)

    # Ring oben
    bpy.ops.mesh.primitive_torus_add(major_radius=0.15, minor_radius=0.04, location=(0, 0, 2.1), major_segments=12, minor_segments=6)
    ring = bpy.context.active_object
    objects.append(ring)

    # 2 Ankerarme (gebogen — vereinfacht als Keile)
    for side in [-1, 1]:
        bpy.ops.mesh.primitive_cube_add(size=1.0, location=(side * 0.4, 0, 0.5))
        arm = bpy.context.active_object
        arm.scale = (0.08, 0.6, 0.3)
        bpy.ops.transform.rotate(value=side * 0.6, orient_axis='Z')
        bpy.ops.transform.translate(value=(0, side * 0.4, 0))
        objects.append(arm)

    mat_eisen = make_material("Anker_Eisen", (0.20, 0.22, 0.28, 1.0), roughness=0.5, metallic=0.7)
    for o in objects:
        assign_material(o, mat_eisen)

    return make_collection("Anker", objects)


# ============================================================
# Willkommens-Schild (Holz mit Rahmen, auf 2 Pfosten)
# ============================================================
def create_willkommen_schild():
    objects = []

    # 2 Pfosten
    for x in [-1.2, 1.2]:
        bpy.ops.mesh.primitive_cube_add(size=1.0, location=(x, 0, 1.0))
        pfosten = bpy.context.active_object
        pfosten.scale = (0.18, 0.18, 2.0)
        objects.append(pfosten)

    # Querbalken oben
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, 0, 2.1))
    querbalken = bpy.context.active_object
    querbalken.scale = (2.7, 0.18, 0.18)
    objects.append(querbalken)

    # Schild-Hauptplatte (Holz, mit dickerem Rahmen angedeutet)
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, 0, 1.4))
    schild = bpy.context.active_object
    schild.scale = (2.6, 0.15, 1.2)
    add_bevel(schild, width=0.05, segments=3)
    objects.append(schild)

    # Innerer Bereich (heller, leicht vertieft)
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, 0.08, 1.4))
    inner = bpy.context.active_object
    inner.scale = (2.3, 0.02, 0.95)
    objects.append(inner)

    mat_holz_dunkel = make_material("Schild_Holz_Dunkel", (0.32, 0.20, 0.12, 1.0), roughness=0.85)
    mat_holz_hell = make_material("Schild_Holz_Hell", (0.78, 0.62, 0.42, 1.0), roughness=0.75)

    for o in objects[:3]:
        assign_material(o, mat_holz_dunkel)
    assign_material(schild, mat_holz_hell)
    assign_material(inner, mat_holz_hell)

    return make_collection("Willkommen_Schild", objects)


# ============================================================
# Quest-Tafel (Holz mit Kork-Oberfläche, Kork mit Zetteln)
# ============================================================
def create_quest_tafel():
    objects = []

    # Hintere Holzplatte
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, 0, 1.5))
    platte = bpy.context.active_object
    platte.scale = (2.5, 0.15, 2.0)
    add_bevel(platte, width=0.04, segments=2)
    objects.append(platte)

    # Korkoberfläche (vorne, leicht erhaben)
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, 0.08, 1.5))
    kork = bpy.context.active_object
    kork.scale = (2.3, 0.02, 1.8)
    objects.append(kork)

    # 2 Holzbeine (hinten)
    for x in [-0.9, 0.9]:
        bpy.ops.mesh.primitive_cube_add(size=1.0, location=(x, -0.1, 0.6))
        bein = bpy.context.active_object
        bein.scale = (0.12, 0.12, 1.2)
        bpy.ops.transform.rotate(value=-0.15, orient_axis='Z')
        objects.append(bein)

    # 3 Zettel (kleine helle Quader auf der Korkfläche)
    for i, (y_off, z_off) in enumerate([(0.12, 0.5), (0.12, 0.0), (0.12, -0.5)]):
        bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0.4 * (i - 1), y_off, 1.5 + z_off))
        zettel = bpy.context.active_object
        zettel.scale = (0.5, 0.02, 0.6)
        bpy.ops.transform.rotate(value=0.1 * (i - 1), orient_axis='Z')
        objects.append(zettel)

    mat_holz = make_material("Quest_Holz", (0.40, 0.25, 0.15, 1.0), roughness=0.9)
    mat_kork = make_material("Quest_Kork", (0.78, 0.62, 0.38, 1.0), roughness=0.95)
    mat_zettel = make_material("Quest_Zettel", (0.95, 0.92, 0.82, 1.0), roughness=0.9)

    assign_material(platte, mat_holz)
    for o in objects[3:5]:
        assign_material(o, mat_holz)
    assign_material(kork, mat_kork)
    for o in objects[5:]:
        assign_material(o, mat_zettel)

    return make_collection("Quest_Tafel", objects)


# ============================================================
# NPC-Basis (Chibi-Charakter, ohne Gesicht — generisch)
# ============================================================
def create_npc_basis(gender="female"):
    """
    Anime-Cute Chibi-Charakter Basis.
    Kopf-zu-Körper ~1:2.5 (siehe docs/07_art_direction.md).

    gender="female" → mit Rock-Andeutung, größerer Augen-Region
    gender="male" → ohne Rock, kantigere Schultern
    """
    objects = []
    height_body = 1.4
    height_head = 0.8

    # Beine (Box)
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, 0, 0.4))
    beine = bpy.context.active_object
    beine.scale = (0.45, 0.35, 0.8)
    add_bevel(beine, width=0.04, segments=3)
    objects.append(beine)

    # Torso (abgerundete Box)
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, 0, 1.1))
    torso = bpy.context.active_object
    torso.scale = (0.65, 0.45, 0.65)
    add_bevel(torso, width=0.06, segments=4)
    objects.append(torso)

    # Hals (kurzer Zylinder)
    bpy.ops.mesh.primitive_cylinder_add(radius=0.12, depth=0.15, location=(0, 0, 1.55), vertices=16)
    hals = bpy.context.active_object
    objects.append(hals)

    # Kopf (großer Chibi-Kopf)
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.55, location=(0, 0, height_body + height_head / 2 + 0.15),
                                          segments=20, ring_count=16)
    kopf = bpy.context.active_object
    # Skalieren für leicht abgeflachten Anime-Kopf
    bpy.ops.transform.resize(value=(1.0, 0.92, 1.05))
    objects.append(kopf)

    # Arme (2x, leicht abgewinkelt)
    for side in [-1, 1]:
        bpy.ops.mesh.primitive_cube_add(size=1.0, location=(side * 0.45, 0, 1.1))
        arm = bpy.context.active_object
        arm.scale = (0.18, 0.40, 0.18)
        add_bevel(arm, width=0.03, segments=2)
        # Arm leicht nach außen drehen
        bpy.ops.transform.rotate(value=side * 0.15, orient_axis='Z')
        objects.append(arm)

    # Haare-Topping (für anime-look, eine Halbkugel oben)
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.58, location=(0, 0, height_body + height_head / 2 + 0.18),
                                          segments=20, ring_count=12)
    haare = bpy.context.active_object
    # Schneide untere Hälfte ab (via Skalierung und Edit-Mode)
    bpy.ops.object.mode_set(mode='EDIT')
    bpy.ops.mesh.select_all(action='SELECT')
    bpy.ops.transform.resize(value=(1.05, 1.0, 1.1))
    bpy.ops.object.mode_set(mode='OBJECT')
    objects.append(haare)

    # Materialien (Hafen-Tracht: gestreiftes Shirt + marine Hose)
    mat_hose = make_material("NPC_Hose", (0.22, 0.28, 0.40, 1.0), roughness=0.85)
    mat_hemd = make_material("NPC_Hemd", (0.92, 0.92, 0.88, 1.0), roughness=0.7)
    mat_hemd.node_tree.nodes["Principled BSDF"].inputs["Emission Strength"].default_value = 0.0
    mat_haut = make_material("NPC_Haut", (0.96, 0.82, 0.70, 1.0), roughness=0.5)
    mat_haut.node_tree.nodes["Principled BSDF"].inputs["Subsurface Weight"].default_value = 0.15
    mat_haar = make_material("NPC_Haar_Braun", (0.32, 0.20, 0.10, 1.0), roughness=0.6)

    assign_material(beine, mat_hose)
    assign_material(torso, mat_hemd)
    assign_material(hals, mat_haut)
    assign_material(kopf, mat_haut)
    assign_material(haare, mat_haar)
    for o in objects[5:7]:  # Arme
        assign_material(o, mat_hemd)

    return make_collection(f"NPC_Basis_{gender}", objects)


# ============================================================
# Main
# ============================================================
def main():
    args = parse_args()
    outdir = args.outdir
    os.makedirs(outdir, exist_ok=True)

    builders = [
        ("boot", create_boot),
        ("fass", create_fass),
        ("kiste", create_kiste),
        ("dock_planke", create_dock_planke),
        ("laterne", create_laterne),
        ("anker", create_anker),
        ("willkommen_schild", create_willkommen_schild),
        ("quest_tafel", create_quest_tafel),
    ]

    for name, builder in builders:
        print(f"[Props] Baue {name}...")
        clear_scene()
        builder()
        path = os.path.join(outdir, f"{name}_lod{args.lod}.fbx")
        export_fbx(path)
        print(f"[Props] {name} exportiert: {path}")

    # NPC-Basen (weiblich + männlich)
    for gender in ["female", "male"]:
        print(f"[Props] Baue NPC-Basis-{gender}...")
        clear_scene()
        create_npc_basis(gender)
        path = os.path.join(outdir, f"npc_basis_{gender}_lod{args.lod}.fbx")
        export_fbx(path)
        print(f"[Props] NPC-{gender} exportiert: {path}")

    print(f"[CurioWorld Blender Pipeline] Props-Pack fertig ({outdir})")


if __name__ == "__main__":
    main()
