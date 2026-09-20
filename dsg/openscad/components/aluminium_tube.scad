// File: aluminium_tube.scad
//   Generic hollow aluminium tube component.
//
// This file owns only tube geometry. Project-specific length, placement,
// colour and reinforcement meaning belong in assemblies.

function aluminium_tube_create(
    length = 840,
    outer_diameter = 10,
    wall_thickness = 1,
    render_fn = 96
) =
    assert(length > 0, "tube length must be > 0")
    assert(outer_diameter > 0, "tube outer diameter must be > 0")
    assert(wall_thickness > 0, "tube wall thickness must be > 0")
    assert(2 * wall_thickness < outer_diameter,
        "tube wall thickness leaves no inner diameter")
    assert(render_fn >= 24, "tube render_fn must be >= 24")
    object(
        length = length,
        outer_diameter = outer_diameter,
        wall_thickness = wall_thickness,
        render_fn = render_fn
    );

function aluminium_tube_inner_diameter(tube) =
    tube.outer_diameter - 2 * tube.wall_thickness;

module aluminium_tube_build(tube) {
    $fn = tube.render_fn;

    rotate([0, 90, 0])
        difference() {
            cylinder(
                h = tube.length,
                d = tube.outer_diameter
            );

            translate([0, 0, -0.1])
                cylinder(
                    h = tube.length + 0.2,
                    d = aluminium_tube_inner_diameter(tube)
                );
        }
}

// Standalone preview.
_preview_tube = aluminium_tube_create(length = 160);
aluminium_tube_build(_preview_tube);
