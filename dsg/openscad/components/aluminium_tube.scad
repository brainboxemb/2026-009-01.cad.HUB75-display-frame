// File: aluminium_tube.scad
//   Generic hollow aluminium tube component.
//
// This file owns only tube geometry. Project-specific length, placement,
// colour and reinforcement meaning belong in assemblies.

use <../ext/lib.scad.forge/openscad/resolution.scad>
use <../ext/lib.scad.forge/openscad/transform.scad>
use <../ext/lib.scad.forge/openscad/cutter.scad>
use <../ext/lib.scad.forge/openscad/csg.scad>

function aluminium_tube_create(
    length_mm = 840,
    outer_diameter_mm = 10,
    wall_thickness_mm = 1
) =
    assert(length_mm > 0, "tube length_mm must be > 0")
    assert(outer_diameter_mm > 0, "tube outer_diameter_mm must be > 0")
    assert(wall_thickness_mm > 0, "tube wall_thickness_mm must be > 0")
    assert(2 * wall_thickness_mm < outer_diameter_mm,
        "tube wall thickness leaves no inner diameter")
    object(
        length_mm = length_mm,
        outer_diameter_mm = outer_diameter_mm,
        wall_thickness_mm = wall_thickness_mm
    );

function aluminium_tube_inner_diameter_mm(tube_obj) =
    tube_obj.outer_diameter_mm - 2 * tube_obj.wall_thickness_mm;

module aluminium_tube_build(
    tube_obj,
    resolution = FG_RES_HIGH()
) {
    fg_res_apply(resolution) {
        // Cylinder primitives run along local +Z; this tube runs along project +X.
        fg_xf_yrot(90)
            fg_diff() {
                fg_body()
                    cylinder(
                        h = tube_obj.length_mm,
                        d = tube_obj.outer_diameter_mm
                    );

                fg_remove()
                    fg_cut_cylinder(
                        diameter_mm =
                            aluminium_tube_inner_diameter_mm(tube_obj),
                        height_mm = tube_obj.length_mm,
                        overlap = [FG_BOTTOM(), FG_TOP()]
                    );
            }
    }
}

// Standalone preview.
_preview_tube = aluminium_tube_create(length_mm = 160);
aluminium_tube_build(_preview_tube);
