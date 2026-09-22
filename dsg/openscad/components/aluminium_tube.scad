// File: aluminium_tube.scad
//   Generic hollow aluminium tube component.
//
// This file owns only tube geometry. Project-specific length, placement,
// colour and reinforcement meaning belong in assemblies.

use <../ext/lib.scad.forge/openscad/resolution.scad>

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

function aluminium_tube_inner_diameter_mm(obj) =
    obj.outer_diameter_mm - 2 * obj.wall_thickness_mm;

module aluminium_tube_build(
    obj,
    resolution = FG_RES_HIGH()
) {
    fg_res_apply(resolution)
        rotate([0, 90, 0])
            difference() {
                cylinder(
                    h = obj.length_mm,
                    d = obj.outer_diameter_mm
                );

                translate([0, 0, -0.1])
                    cylinder(
                        h = obj.length_mm + 0.2,
                        d = aluminium_tube_inner_diameter_mm(obj)
                    );
            }
}

// Standalone preview.
_preview_tube = aluminium_tube_create(length_mm = 160);
aluminium_tube_build(_preview_tube);
