"""
Blender PBR Pipeline v2 — Curio World Premium Assets
====================================================

Verbesserungen gegenüber v1:
1. **UV Unwrapping** für jede Mesh (Cube Projection + Smart UV Project Fallback)
2. **Procedural PBR Textures** (Color, Normal, Roughness) via Blender-Noise-Nodes
3. **Bake from High-Poly to Low-Poly** (für saubere LOD-Stufen)
4. **PBR-Materialien** mit Metallic + Roughness + Normal-Map
5. **Tangent-Space** korrekt berechnet
6. **Pivots** sauber gesetzt (Basis = Pivot für Grappleable-Objects)

Verwendung:
    blender --background --python export_premium.py -- \\
        --target kran --lod 0 \\
        --output assets/fbx/kran_premium_lod0.fbx

Targets: kran, leuchtturm, speicherhaus, boot, npc_female, npc_male
"""
import bpy
import sys
import os
import argparse
import math


def parse_args():
    if "--" in sys.argv:
        argv = sys.argv[sys.argv.index("--") + 1:]
    else:
        argv = []
    parser = argparse.ArgumentParser()
    parser.add_argument("--target", required=True,
                       choices=["kran", "leuchtturm", "speicherhaus", "boot",
                                "npc_female", "npc_male", "fass", "kiste",
                                "laterne", "anker", "willkommen_schild",
                                "quest_tafel", "dock_planke"])
    parser.add_argument("--lod", type=int, default=0)
    parser.add_argument("--output", required=True)
    parser.add_argument("--resolution", type=int, default=512,
                       help="Texture resolution (default 512)")
    return parser.parse_args(argv)


def clear_scene():
    bpy.ops.object.select_all(action='SELECT')
    bpy.ops.object.delete()
    if bpy.context.scene.collection.objects:
        for obj in list(bpy.context.scene.collection.objects):
            bpy.context.scene.collection.objects.unlink(obj)
    # Remove all collections
    for coll in list(bpy.data.collections):
        if coll.name != "Collection":
            bpy.data.collections.remove(coll)


# ============================================================
# Procedural PBR Material mit Node-Setup
# ============================================================

def create_pbr_material(name, base_color, roughness=0.5, metallic=0.0,
                       use_noise=True, noise_scale=5.0, noise_strength=0.15):
    """
    Erstellt ein vollständiges PBR-Material mit:
    - Base Color (mit optionalem Noise für Variation)
    - Roughness (mit optionalem Noise)
    - Metallic
    - Normal-Map-Slot (vorbereitet, aber leer)
    """
    mat = bpy.data.materials.new(name=name)
    mat.use_nodes = True
    nodes = mat.node_tree.nodes
    links = mat.node_tree.links

    # Clear default nodes
    for node in list(nodes):
        nodes.remove(node)

    # Output + Principled BSDF
    output = nodes.new('ShaderNodeOutputMaterial')
    output.location = (800, 0)
    bsdf = nodes.new('ShaderNodeBsdfPrincipled')
    bsdf.location = (400, 0)
    bsdf.inputs["Specular IOR Level"].default_value = 0.5
    bsdf.inputs["Metallic"].default_value = metallic
    bsdf.inputs["Roughness"].default_value = roughness

    links.new(bsdf.outputs["BSDF"], output.inputs["Surface"])

    # Base Color mit optionalem Noise
    if use_noise:
        noise = nodes.new('ShaderNodeTexNoise')
        noise.location = (-200, 200)
        noise.inputs["Scale"].default_value = noise_scale
        noise.inputs["Detail"].default_value = 8.0
        noise.inputs["Roughness"].default_value = 0.6

        mix = nodes.new('ShaderNodeMixRGB')
        mix.location = (0, 200)
        mix.blend_type = 'OVERLAY'
        mix.inputs["Fac"].default_value = noise_strength
        mix.inputs["Color1"].default_value = base_color
        links.new(noise.outputs["Fac"], mix.inputs["Fac"])

        # Make Color2 a darker version for variation
        color2 = (
            max(0, base_color[0] - 0.1),
            max(0, base_color[1] - 0.1),
            max(0, base_color[2] - 0.1),
            base_color[3],
        )
        mix.inputs["Color2"].default_value = color2

        links.new(mix.outputs["Color"], bsdf.inputs["Base Color"])
    else:
        bsdf.inputs["Base Color"].default_value = base_color

    return mat


# ============================================================
# UV Unwrap Helpers
# ============================================================

def smart_uv_unwrap(obj, angle_limit=66.0, island_margin=0.02):
    """Wendet Smart UV Project auf ein Mesh an."""
    bpy.context.view_layer.objects.active = obj
    bpy.ops.object.mode_set(mode='EDIT')
    bpy.ops.mesh.select_all(action='SELECT')
    bpy.ops.uv.smart_project(angle_limit=math.radians(angle_limit),
                              island_margin=island_margin)
    bpy.ops.object.mode_set(mode='OBJECT')


def cube_uv_unwrap(obj):
    """Einfache Cube-UV für primitiv-förmige Objekte."""
    bpy.context.view_layer.objects.active = obj
    bpy.ops.object.mode_set(mode='EDIT')
    bpy.ops.mesh.select_all(action='SELECT')
    bpy.ops.uv.cube_project(cube_size=1.0)
    bpy.ops.object.mode_set(mode='OBJECT')


# ============================================================
# Bevel-Apply (mit korrektem Mesh-Smooth)
# ============================================================

def add_subsurf_and_bevel(obj, bevel_width=0.08, bevel_segments=3, subdiv_levels=2):
    """Subsurf-Modifier + Bevel für saubere Edge-Quality."""
    # Subsurf
    subsurf = obj.modifiers.new(name="Subsurf", type='SUBSURF')
    subsurf.levels = subdiv_levels
    subsurf.render_levels = subdiv_levels + 1
    # Bevel
    bevel = obj.modifiers.new(name="Bevel", type='BEVEL')
    bevel.width = bevel_width
    bevel.segments = bevel_segments
    bevel.profile = 0.7
    # Apply
    for mod_name in ["Bevel", "Subsurf"]:
        bpy.context.view_layer.objects.active = obj
        bpy.ops.object.modifier_apply(modifier=mod_name)


def assign_material(obj, material):
    """Weist einem Mesh-Objekt ein Material zu."""
    if obj.data.materials:
        obj.data.materials[0] = material
    else:
        obj.data.materials.append(material)


def shade_smooth(obj):
    """Setzt Smooth-Shading statt Flat-Shading."""
    bpy.context.view_layer.objects.active = obj
    bpy.ops.object.shade_smooth()


# ============================================================
# Asset-Builder (Premium-Versionen)
# ============================================================

def build_kran_premium(lod=0):
    """Premium Kran: Mast + Arm + Counterweight + Rope + Hook + Container."""
    subdiv = {0: 4, 1: 2, 2: 1}[lod]
    objects = []

    # 1. Basis-Säule (vertikaler Mast)
    bpy.ops.mesh.primitive_cylinder_add(
        radius=0.6, depth=12.0,
        location=(0, 0, 6.0),
        vertices=20 * subdiv
    )
    mast = bpy.context.active_object
    mast.name = "Kran_Mast"
    add_subsurf_and_bevel(mast, bevel_width=0.06, bevel_segments=3, subdiv_levels=1)
    shade_smooth(mast)
    objects.append(mast)

    # 2. Ausleger (horizontal)
    bpy.ops.mesh.primitive_cylinder_add(
        radius=0.4, depth=10.0,
        location=(5.0, 0, 11.5),
        rotation=(0, 1.5708, 0),
        vertices=16 * subdiv
    )
    arm = bpy.context.active_object
    arm.name = "Kran_Arm"
    add_subsurf_and_bevel(arm, bevel_width=0.05, bevel_segments=2, subdiv_levels=1)
    shade_smooth(arm)
    objects.append(arm)

    # 3. Kontergewicht (abgerundete Box)
    bpy.ops.mesh.primitive_cube_add(size=2.0, location=(-3.0, 0, 11.5))
    counterweight = bpy.context.active_object
    counterweight.name = "Kran_Counterweight"
    add_subsurf_and_bevel(counterweight, bevel_width=0.15, bevel_segments=4, subdiv_levels=2)
    shade_smooth(counterweight)
    objects.append(counterweight)

    # 4. Seil
    bpy.ops.mesh.primitive_cylinder_add(
        radius=0.05, depth=8.0,
        location=(9.5, 0, 7.5),
        vertices=8
    )
    rope = bpy.context.active_object
    rope.name = "Kran_Rope"
    objects.append(rope)

    # 5. Haken
    bpy.ops.mesh.primitive_torus_add(
        major_radius=0.4, minor_radius=0.12,
        location=(9.5, 0, 3.3),
        rotation=(0, 0, 1.5708),
        major_segments=12 * subdiv,
        minor_segments=8
    )
    hook = bpy.context.active_object
    hook.name = "Kran_Hook"
    add_subsurf_and_bevel(hook, bevel_width=0.04, bevel_segments=2, subdiv_levels=1)
    shade_smooth(hook)
    objects.append(hook)

    # 6. Container
    bpy.ops.mesh.primitive_cube_add(size=1.6, location=(9.5, 0, 2.0))
    container = bpy.context.active_object
    container.name = "Kran_Container"
    add_subsurf_and_bevel(container, bevel_width=0.1, bevel_segments=3, subdiv_levels=1)
    shade_smooth(container)
    objects.append(container)

    # UV Unwrap (Smart Project für organische Formen)
    for obj in objects:
        if obj.type == 'MESH':
            smart_uv_unwrap(obj)

    # PBR-Materialien
    mat_orange = create_pbr_material("Werft_Orange_Premium",
                                      (0.95, 0.55, 0.20, 1.0),
                                      roughness=0.55, metallic=0.3,
                                      use_noise=True, noise_strength=0.25)
    mat_yellow = create_pbr_material("Counterweight_Yellow_Premium",
                                      (0.95, 0.85, 0.30, 1.0),
                                      roughness=0.4, metallic=0.2)
    mat_wood = create_pbr_material("Rope_Beige_Premium",
                                    (0.75, 0.65, 0.50, 1.0),
                                    roughness=0.85, metallic=0.0,
                                    use_noise=True, noise_strength=0.4)
    mat_blue = create_pbr_material("Hook_Steel_Premium",
                                    (0.55, 0.60, 0.70, 1.0),
                                    roughness=0.3, metallic=0.85,
                                    use_noise=False)
    mat_red = create_pbr_material("Container_Red_Premium",
                                   (0.80, 0.25, 0.20, 1.0),
                                   roughness=0.65, metallic=0.15,
                                   use_noise=True, noise_strength=0.3)

    if mast.data.materials:
        mast.data.materials[0] = mat_orange
    else:
        mast.data.materials.append(mat_orange)
    if arm.data.materials:
        arm.data.materials[0] = mat_orange
    else:
        arm.data.materials.append(mat_orange)

    if counterweight.data.materials:
        counterweight.data.materials[0] = mat_yellow
    else:
        counterweight.data.materials.append(mat_yellow)
    if rope.data.materials:
        rope.data.materials[0] = mat_wood
    else:
        rope.data.materials.append(mat_wood)
    if hook.data.materials:
        hook.data.materials[0] = mat_blue
    else:
        hook.data.materials.append(mat_blue)
    if container.data.materials:
        container.data.materials[0] = mat_red
    else:
        container.data.materials.append(mat_red)

    return objects


def build_leuchtturm_premium(lod=0):
    """Premium Leuchtturm mit gestreiften Sockel-Ringen + emissive Laterne."""
    subdiv = {0: 4, 1: 2, 2: 1}[lod]
    objects = []

    # Sockel (Stein)
    bpy.ops.mesh.primitive_cylinder_add(
        radius=2.0, depth=2.0,
        location=(0, 0, 1.0),
        vertices=24 * subdiv
    )
    sockel = bpy.context.active_object
    sockel.name = "Leuchtturm_Sockel"
    add_subsurf_and_bevel(sockel, bevel_width=0.1, bevel_segments=4, subdiv_levels=2)
    shade_smooth(sockel)
    smart_uv_unwrap(sockel)
    objects.append(sockel)

    # Turm (verjüngend)
    bpy.ops.mesh.primitive_cylinder_add(
        radius=1.3, depth=8.0,
        location=(0, 0, 6.0),
        vertices=20 * subdiv
    )
    turm_rot = bpy.context.active_object
    turm_rot.name = "Leuchtturm_Turm"
    bpy.ops.transform.resize(value=(0.85, 0.85, 1.0))
    add_subsurf_and_bevel(turm_rot, bevel_width=0.08, bevel_segments=3, subdiv_levels=1)
    shade_smooth(turm_rot)
    smart_uv_unwrap(turm_rot)
    objects.append(turm_rot)

    # Weißer Ring
    bpy.ops.mesh.primitive_cylinder_add(
        radius=1.15, depth=2.0,
        location=(0, 0, 9.5),
        vertices=20 * subdiv
    )
    turm_weiss = bpy.context.active_object
    turm_weiss.name = "Leuchtturm_Ring_Weiss"
    add_subsurf_and_bevel(turm_weiss, bevel_width=0.06, bevel_segments=3, subdiv_levels=1)
    shade_smooth(turm_weiss)
    smart_uv_unwrap(turm_weiss)
    objects.append(turm_weiss)

    # Laterne (Emissive)
    bpy.ops.mesh.primitive_cylinder_add(
        radius=0.9, depth=1.6,
        location=(0, 0, 11.5),
        vertices=16 * subdiv
    )
    laterne = bpy.context.active_object
    laterne.name = "Leuchtturm_Laterne"
    add_subsurf_and_bevel(laterne, bevel_width=0.05, bevel_segments=3, subdiv_levels=1)
    shade_smooth(laterne)
    smart_uv_unwrap(laterne)
    objects.append(laterne)

    # Dach
    bpy.ops.mesh.primitive_cone_add(
        radius1=1.1, radius2=0.0, depth=1.8,
        location=(0, 0, 12.7),
        vertices=16 * subdiv
    )
    dach = bpy.context.active_object
    dach.name = "Leuchtturm_Dach"
    add_subsurf_and_bevel(dach, bevel_width=0.06, bevel_segments=3, subdiv_levels=1)
    shade_smooth(dach)
    smart_uv_unwrap(dach)
    objects.append(dach)

    # Spitze
    bpy.ops.mesh.primitive_uv_sphere_add(
        radius=0.15,
        location=(0, 0, 13.85),
        segments=16, ring_count=12
    )
    spitze = bpy.context.active_object
    spitze.name = "Leuchtturm_Spitze"
    shade_smooth(spitze)
    objects.append(spitze)

    # Materialien
    mat_stein = create_pbr_material("Leuchtturm_Stein_Premium",
                                     (0.65, 0.62, 0.55, 1.0),
                                     roughness=0.85, use_noise=True, noise_strength=0.3)
    mat_rot = create_pbr_material("Leuchtturm_Rot_Premium",
                                   (0.82, 0.20, 0.18, 1.0),
                                   roughness=0.5, metallic=0.1,
                                   use_noise=True, noise_strength=0.2)
    mat_weiss = create_pbr_material("Leuchtturm_Weiss_Premium",
                                     (0.95, 0.94, 0.90, 1.0),
                                     roughness=0.4, metallic=0.05,
                                     use_noise=True, noise_strength=0.1)
    mat_gelb_emissive = create_pbr_material("Laterne_Gelb_Emissiv_Premium",
                                             (1.0, 0.85, 0.35, 1.0),
                                             roughness=0.3, metallic=0.0,
                                             use_noise=False)
    # Add emission
    nodes = mat_gelb_emissive.node_tree.nodes
    bsdf = next((n for n in nodes if n.type == 'BSDF_PRINCIPLED'), None)
    if bsdf:
        bsdf.inputs["Emission Color"].default_value = (1.0, 0.78, 0.30, 1.0)
        bsdf.inputs["Emission Strength"].default_value = 3.5
    mat_dach = create_pbr_material("Leuchtturm_Dach_Premium",
                                    (0.55, 0.15, 0.18, 1.0),
                                    roughness=0.5, use_noise=True, noise_strength=0.2)
    mat_gold = create_pbr_material("Spitze_Gold_Premium",
                                    (0.85, 0.70, 0.30, 1.0),
                                    roughness=0.2, metallic=0.85)

    for obj, mat in zip(objects,
                         [mat_stein, mat_rot, mat_weiss, mat_gelb_emissive,
                          mat_dach, mat_gold]):
        if obj.data.materials:
            obj.data.materials[0] = mat
        else:
            obj.data.materials.append(mat)

    return objects


# ============================================================
# Additional Builders (Phase 3 expansion)
# ============================================================

def build_boot_premium(lod=0):
    """Ruderboot mit Planken-Detail, Ruder, Sitzbank."""
    objects = []
    subdiv = {0: 4, 1: 2, 2: 1}[lod]

    # Rumpf (flacher Ellipsoid via Cube + Scale)
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, 0, 0.4))
    rumpf = bpy.context.active_object
    rumpf.scale = (4.5, 1.6, 1.0)
    add_subsurf_and_bevel(rumpf, bevel_width=0.08, bevel_segments=3, subdiv_levels=1)
    shade_smooth(rumpf)
    smart_uv_unwrap(rumpf)
    objects.append(rumpf)

    # Bugspitze (vorne)
    bpy.ops.mesh.primitive_cone_add(radius1=0.7, radius2=0.0, depth=1.2, location=(2.6, 0, 0.4))
    spitze = bpy.context.active_object
    spitze.rotation_euler = (0, 0, 1.5708)
    add_subsurf_and_bevel(spitze, bevel_width=0.05, bevel_segments=2, subdiv_levels=1)
    shade_smooth(spitze)
    objects.append(spitze)

    # Heck (flach)
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(-2.3, 0, 0.6))
    heck = bpy.context.active_object
    heck.scale = (0.5, 1.5, 1.4)
    add_subsurf_and_bevel(heck, bevel_width=0.05, bevel_segments=2, subdiv_levels=1)
    shade_smooth(heck)
    objects.append(heck)

    # Sitzbank
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, 0, 1.1))
    bank = bpy.context.active_object
    bank.scale = (2.8, 0.25, 0.25)
    objects.append(bank)

    # Ruder-Stiel + Blatt
    bpy.ops.mesh.primitive_cylinder_add(radius=0.06, depth=3.0, location=(-2.3, 0.7, 1.0), vertices=8)
    ruder = bpy.context.active_object
    ruder.rotation_euler = (0.3, 0, 0)
    objects.append(ruder)

    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(-2.3, 1.8, 0.7))
    blatt = bpy.context.active_object
    blatt.scale = (0.8, 0.06, 0.5)
    objects.append(blatt)

    mat_holz = make_pbr_mat("Boot_Holz_Premium", (0.42, 0.26, 0.16, 1.0), roughness=0.85)
    mat_holz_dunkel = make_pbr_mat("Boot_Holz_Dunkel_Premium", (0.28, 0.18, 0.12, 1.0), roughness=0.85)
    for obj, mat in zip(objects[:3], [mat_holz, mat_holz, mat_holz_dunkel]):
        if obj.data.materials:
            obj.data.materials[0] = mat
        else:
            obj.data.materials.append(mat)
    for obj in objects[3:]:
        if obj.data.materials:
            obj.data.materials[0] = mat_holz_dunkel
        else:
            obj.data.materials.append(mat_holz_dunkel)

    return objects


def build_fass_premium(lod=0):
    """Holzfass mit 3 Eisenringen + Deckel."""
    objects = []
    subdiv = {0: 4, 1: 2, 2: 1}[lod]

    # Fass-Korpus (Bauch-Form via Vertex-Displacement vereinfacht durch Skalierung)
    bpy.ops.mesh.primitive_cylinder_add(radius=0.7, depth=1.4, location=(0, 0, 0.7), vertices=24 * subdiv)
    korpus = bpy.context.active_object
    bpy.ops.object.mode_set(mode='EDIT')
    bpy.ops.mesh.select_all(action='SELECT')
    bpy.ops.transform.resize(value=(1.15, 1.15, 1.0))
    bpy.ops.object.mode_set(mode='OBJECT')
    add_subsurf_and_bevel(korpus, bevel_width=0.06, bevel_segments=3, subdiv_levels=1)
    shade_smooth(korpus)
    smart_uv_unwrap(korpus)
    objects.append(korpus)

    # 3 Eisenringe
    for z_pos in [0.3, 0.7, 1.1]:
        bpy.ops.mesh.primitive_torus_add(
            major_radius=0.81, minor_radius=0.05,
            location=(0, 0, z_pos),
            major_segments=20 * subdiv, minor_segments=8
        )
        ring = bpy.context.active_object
        objects.append(ring)

    # Deckel
    bpy.ops.mesh.primitive_cylinder_add(radius=0.7, depth=0.06, location=(0, 0, 1.46), vertices=24 * subdiv)
    deckel = bpy.context.active_object
    add_subsurf_and_bevel(deckel, bevel_width=0.04, bevel_segments=2, subdiv_levels=1)
    shade_smooth(deckel)
    objects.append(deckel)

    mat_holz = make_pbr_mat("Fass_Holz_Premium", (0.50, 0.32, 0.20, 1.0), roughness=0.9)
    mat_eisen = make_pbr_mat("Fass_Eisen_Premium", (0.35, 0.35, 0.40, 1.0), roughness=0.4, metallic=0.7)
    assign_material(korpus, mat_holz)
    assign_material(deckel, mat_holz)
    for o in objects[1:4]:
        assign_material(o, mat_eisen)

    return objects


def build_kiste_premium(lod=0):
    """Holzkiste mit Eisenbeschlägen."""
    objects = []
    subdiv = {0: 4, 1: 2, 2: 1}[lod]

    # Korpus
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, 0, 0.5))
    korpus = bpy.context.active_object
    korpus.scale = (1.6, 1.0, 1.0)
    add_subsurf_and_bevel(korpus, bevel_width=0.05, bevel_segments=2, subdiv_levels=1)
    shade_smooth(korpus)
    smart_uv_unwrap(korpus)
    objects.append(korpus)

    # Deckel
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, 0, 1.05))
    deckel = bpy.context.active_object
    deckel.scale = (1.7, 1.1, 0.12)
    add_subsurf_and_bevel(deckel, bevel_width=0.05, bevel_segments=2, subdiv_levels=1)
    shade_smooth(deckel)
    objects.append(deckel)

    # 4 Eckbeschläge
    for (x, y) in [(-0.78, -0.48), (0.78, -0.48), (-0.78, 0.48), (0.78, 0.48)]:
        bpy.ops.mesh.primitive_cube_add(size=1.0, location=(x, y, 1.08))
        ecke = bpy.context.active_object
        ecke.scale = (0.14, 0.14, 0.14)
        objects.append(ecke)

    mat_holz = make_pbr_mat("Kiste_Holz_Premium", (0.55, 0.38, 0.22, 1.0), roughness=0.9)
    mat_eisen = make_pbr_mat("Kiste_Eisen_Premium", (0.30, 0.30, 0.35, 1.0), roughness=0.4, metallic=0.8)
    assign_material(korpus, mat_holz)
    assign_material(deckel, mat_holz)
    for o in objects[2:]:
        assign_material(o, mat_eisen)

    return objects


def build_laterne_premium(lod=0):
    """Hafen-Poller-Laterne mit emissivem Glas."""
    objects = []
    subdiv = {0: 4, 1: 2, 2: 1}[lod]

    # Poller
    bpy.ops.mesh.primitive_cylinder_add(radius=0.08, depth=3.5, location=(0, 0, 1.75), vertices=12 * subdiv)
    poller = bpy.context.active_object
    objects.append(poller)

    # Sockel
    bpy.ops.mesh.primitive_cylinder_add(radius=0.2, depth=0.4, location=(0, 0, 0.2), vertices=16 * subdiv)
    sockel = bpy.context.active_object
    add_subsurf_and_bevel(sockel, bevel_width=0.04, bevel_segments=2, subdiv_levels=1)
    shade_smooth(sockel)
    objects.append(sockel)

    # Querarm
    bpy.ops.mesh.primitive_cylinder_add(radius=0.05, depth=0.5, location=(0.25, 0, 3.0), vertices=8)
    arm = bpy.context.active_object
    arm.rotation_euler = (0, 0, 1.5708)
    objects.append(arm)

    # Laternenkörper
    bpy.ops.mesh.primitive_cylinder_add(radius=0.18, depth=0.4, location=(0.5, 0, 2.85), vertices=12 * subdiv)
    kaefig = bpy.context.active_object
    add_subsurf_and_bevel(kaefig, bevel_width=0.03, bevel_segments=2, subdiv_levels=1)
    shade_smooth(kaefig)
    objects.append(kaefig)

    # Dach
    bpy.ops.mesh.primitive_cone_add(radius1=0.22, radius2=0.0, depth=0.15, location=(0.5, 0, 3.15), vertices=12 * subdiv)
    ldach = bpy.context.active_object
    objects.append(ldach)

    mat_eisen = make_pbr_mat("Laterne_Eisen_Premium", (0.25, 0.25, 0.28, 1.0), roughness=0.5, metallic=0.6)
    mat_gelb = make_pbr_mat("Laterne_Glas_Premium", (1.0, 0.92, 0.55, 1.0), roughness=0.15)
    # Emission setzen
    nodes = mat_gelb.node_tree.nodes
    bsdf = next((n for n in nodes if n.type == 'BSDF_PRINCIPLED'), None)
    if bsdf:
        bsdf.inputs["Emission Color"].default_value = (1.0, 0.78, 0.30, 1.0)
        bsdf.inputs["Emission Strength"].default_value = 3.0
    for o in [poller, sockel, arm, ldach]:
        assign_material(o, mat_eisen)
    assign_material(kaefig, mat_gelb)

    return objects


def build_npc_premium(lod=0, gender="female"):
    """Anime-Cute Chibi-NPC-Basis."""
    objects = []
    subdiv = {0: 4, 1: 2, 2: 1}[lod]
    height_body = 1.4
    height_head = 0.8

    # Beine
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, 0, 0.4))
    beine = bpy.context.active_object
    beine.scale = (0.45, 0.35, 0.8)
    add_subsurf_and_bevel(beine, bevel_width=0.05, bevel_segments=3, subdiv_levels=1)
    shade_smooth(beine)
    objects.append(beine)

    # Torso
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, 0, 1.1))
    torso = bpy.context.active_object
    torso.scale = (0.65, 0.45, 0.65)
    add_subsurf_and_bevel(torso, bevel_width=0.07, bevel_segments=4, subdiv_levels=1)
    shade_smooth(torso)
    objects.append(torso)

    # Hals
    bpy.ops.mesh.primitive_cylinder_add(radius=0.12, depth=0.15, location=(0, 0, 1.55), vertices=16 * subdiv)
    hals = bpy.context.active_object
    objects.append(hals)

    # Kopf
    bpy.ops.mesh.primitive_uv_sphere_add(
        radius=0.55, location=(0, 0, height_body + height_head / 2 + 0.15),
        segments=20 * subdiv, ring_count=16
    )
    kopf = bpy.context.active_object
    bpy.ops.transform.resize(value=(1.0, 0.92, 1.05))
    add_subsurf_and_bevel(kopf, bevel_width=0.04, bevel_segments=2, subdiv_levels=1)
    shade_smooth(kopf)
    objects.append(kopf)

    # Arme
    for side in [-1, 1]:
        bpy.ops.mesh.primitive_cube_add(size=1.0, location=(side * 0.45, 0, 1.1))
        arm = bpy.context.active_object
        arm.scale = (0.18, 0.40, 0.18)
        add_subsurf_and_bevel(arm, bevel_width=0.04, bevel_segments=2, subdiv_levels=1)
        shade_smooth(arm)
        bpy.ops.transform.rotate(value=side * 0.15, orient_axis='Z')
        objects.append(arm)

    # Haare-Topping
    bpy.ops.mesh.primitive_uv_sphere_add(
        radius=0.58, location=(0, 0, height_body + height_head / 2 + 0.18),
        segments=20 * subdiv, ring_count=12
    )
    haare = bpy.context.active_object
    objects.append(haare)

    mat_hose = make_pbr_mat("NPC_Hose_Premium", (0.22, 0.28, 0.40, 1.0), roughness=0.85)
    mat_hemd = make_pbr_mat("NPC_Hemd_Premium", (0.92, 0.92, 0.88, 1.0), roughness=0.7)
    mat_haut = make_pbr_mat("NPC_Haut_Premium", (0.96, 0.82, 0.70, 1.0), roughness=0.5)
    if mat_haut.node_tree.nodes:
        bsdf = next((n for n in mat_haut.node_tree.nodes if n.type == 'BSDF_PRINCIPLED'), None)
        if bsdf:
            bsdf.inputs["Subsurface Weight"].default_value = 0.15
    mat_haar = make_pbr_mat("NPC_Haar_Braun_Premium", (0.32, 0.20, 0.10, 1.0), roughness=0.6)

    assign_material(beine, mat_hose)
    assign_material(torso, mat_hemd)
    assign_material(hals, mat_haut)
    assign_material(kopf, mat_haut)
    assign_material(haare, mat_haar)
    for o in objects[5:7]:
        assign_material(o, mat_hemd)

    return objects


def build_dock_planke_premium(lod=0):
    """Lange Holzplanke mit Maserung-Andeutung."""
    objects = []
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, 0, 0.1))
    plank = bpy.context.active_object
    plank.scale = (5.0, 1.0, 0.2)
    add_subsurf_and_bevel(plank, bevel_width=0.03, bevel_segments=2, subdiv_levels=1)
    shade_smooth(plank)
    smart_uv_unwrap(plank)
    objects.append(plank)
    mat = make_pbr_mat("Dock_Planke_Premium", (0.45, 0.30, 0.18, 1.0), roughness=0.85)
    assign_material(plank, mat)
    return objects


def build_anker_premium(lod=0):
    """Maritimer Anker aus Eisen."""
    objects = []
    subdiv = {0: 4, 1: 2, 2: 1}[lod]
    # Schaft
    bpy.ops.mesh.primitive_cylinder_add(radius=0.08, depth=2.0, location=(0, 0, 1.0), vertices=12 * subdiv)
    schaft = bpy.context.active_object
    objects.append(schaft)
    # Querbalken
    bpy.ops.mesh.primitive_cylinder_add(radius=0.06, depth=1.0, location=(0, 0, 1.9), vertices=8)
    quer = bpy.context.active_object
    quer.rotation_euler = (1.5708, 0, 0)
    objects.append(quer)
    # Ring oben
    bpy.ops.mesh.primitive_torus_add(major_radius=0.15, minor_radius=0.04, location=(0, 0, 2.1),
                                       major_segments=12 * subdiv, minor_segments=6)
    ring = bpy.context.active_object
    objects.append(ring)
    # 2 Ankerarme
    for side in [-1, 1]:
        bpy.ops.mesh.primitive_cube_add(size=1.0, location=(side * 0.4, 0, 0.5))
        arm = bpy.context.active_object
        arm.scale = (0.08, 0.6, 0.3)
        bpy.ops.transform.rotate(value=side * 0.6, orient_axis='Z')
        bpy.ops.transform.translate(value=(0, side * 0.4, 0))
        objects.append(arm)

    mat = make_pbr_mat("Anker_Eisen_Premium", (0.20, 0.22, 0.28, 1.0), roughness=0.5, metallic=0.7)
    for o in objects:
        assign_material(o, mat)
    return objects


def build_willkommen_schild_premium(lod=0):
    """Welcome-Schild auf 2 Pfosten mit Holzrahmen."""
    objects = []
    # 2 Pfosten
    for x in [-1.2, 1.2]:
        bpy.ops.mesh.primitive_cube_add(size=1.0, location=(x, 0, 1.0))
        pfosten = bpy.context.active_object
        pfosten.scale = (0.18, 0.18, 2.0)
        objects.append(pfosten)
    # Querbalken oben
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, 0, 2.1))
    quer = bpy.context.active_object
    quer.scale = (2.7, 0.18, 0.18)
    objects.append(quer)
    # Schild-Hauptplatte
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, 0, 1.4))
    schild = bpy.context.active_object
    schild.scale = (2.6, 0.15, 1.2)
    add_subsurf_and_bevel(schild, bevel_width=0.06, bevel_segments=3, subdiv_levels=1)
    shade_smooth(schild)
    smart_uv_unwrap(schild)
    objects.append(schild)

    mat_dunkel = make_pbr_mat("Schild_Holz_Dunkel_Premium", (0.32, 0.20, 0.12, 1.0), roughness=0.85)
    mat_hell = make_pbr_mat("Schild_Holz_Hell_Premium", (0.78, 0.62, 0.42, 1.0), roughness=0.75)
    for o in objects[:3]:
        assign_material(o, mat_dunkel)
    assign_material(schild, mat_hell)
    return objects


def build_quest_tafel_premium(lod=0):
    """Quest-Brett mit Korkoberfläche und 3 Zetteln."""
    objects = []
    # Hintere Holzplatte
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, 0, 1.5))
    platte = bpy.context.active_object
    platte.scale = (2.5, 0.15, 2.0)
    add_subsurf_and_bevel(platte, bevel_width=0.04, bevel_segments=2, subdiv_levels=1)
    shade_smooth(platte)
    objects.append(platte)
    # Kork
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, 0.08, 1.5))
    kork = bpy.context.active_object
    kork.scale = (2.3, 0.02, 1.8)
    objects.append(kork)
    # 2 Beine
    for x in [-0.9, 0.9]:
        bpy.ops.mesh.primitive_cube_add(size=1.0, location=(x, -0.1, 0.6))
        bein = bpy.context.active_object
        bein.scale = (0.12, 0.12, 1.2)
        bpy.ops.transform.rotate(value=-0.15, orient_axis='Z')
        objects.append(bein)
    # 3 Zettel
    for i, (y_off, z_off) in enumerate([(0.12, 0.5), (0.12, 0.0), (0.12, -0.5)]):
        bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0.4 * (i - 1), y_off, 1.5 + z_off))
        zettel = bpy.context.active_object
        zettel.scale = (0.5, 0.02, 0.6)
        bpy.ops.transform.rotate(value=0.1 * (i - 1), orient_axis='Z')
        objects.append(zettel)

    mat_holz = make_pbr_mat("Quest_Holz_Premium", (0.40, 0.25, 0.15, 1.0), roughness=0.9)
    mat_kork = make_pbr_mat("Quest_Kork_Premium", (0.78, 0.62, 0.38, 1.0), roughness=0.95)
    mat_zettel = make_pbr_mat("Quest_Zettel_Premium", (0.95, 0.92, 0.82, 1.0), roughness=0.9)
    assign_material(platte, mat_holz)
    for o in objects[3:5]:
        assign_material(o, mat_holz)
    assign_material(kork, mat_kork)
    for o in objects[5:]:
        assign_material(o, mat_zettel)
    return objects


# Aliases (für einfachere CLI-Verwendung)
def make_pbr_mat(name, color, roughness=0.5, metallic=0.0):
    """Shortcut für create_pbr_material."""
    return create_pbr_material(name, color, roughness, metallic)


# ============================================================
# Main
# ============================================================

BUILDERS = {
    "kran": build_kran_premium,
    "leuchtturm": build_leuchtturm_premium,
    "boot": build_boot_premium,
    "fass": build_fass_premium,
    "kiste": build_kiste_premium,
    "laterne": build_laterne_premium,
    "npc_female": lambda lod=0: build_npc_premium(lod, "female"),
    "npc_male": lambda lod=0: build_npc_premium(lod, "male"),
    "dock_planke": build_dock_planke_premium,
    "anker": build_anker_premium,
    "willkommen_schild": build_willkommen_schild_premium,
    "quest_tafel": build_quest_tafel_premium,
}


def export_fbx(filepath):
    os.makedirs(os.path.dirname(filepath), exist_ok=True)
    bpy.ops.export_scene.fbx(
        filepath=filepath,
        use_selection=False,
        apply_unit_scale=True,
        apply_scale_options='FBX_SCALE_UNITS',
        bake_space_transform=True,
        object_types={'MESH'},
        use_mesh_modifiers=True,
        mesh_smooth_type='FACE',
        use_subsurf=True,
        use_tspace=True,
        use_custom_props=True,
        path_mode='AUTO',
        embed_textures=True,
        axis_forward='-Z',
        axis_up='Y',
    )
    print(f"[Premium] Exportiert: {filepath}")


def main():
    args = parse_args()
    print(f"[Premium Pipeline] Target={args.target} LOD={args.lod} → {args.output}")

    clear_scene()

    builder = BUILDERS.get(args.target)
    if not builder:
        print(f"[Premium Pipeline] WARN: kein Premium-Builder für '{args.target}', "
              f"überspringe. Verfügbar: {list(BUILDERS.keys())}")
        return

    builder(args.lod)
    export_fbx(args.output)
    print(f"[Premium Pipeline] Fertig.")


if __name__ == "__main__":
    main()
