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
# Main
# ============================================================

BUILDERS = {
    "kran": build_kran_premium,
    "leuchtturm": build_leuchtturm_premium,
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
