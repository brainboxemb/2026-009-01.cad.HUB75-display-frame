// File: hub75_tube_clamp_render.scad
//   Design-render adapter for the HUB75 project-owned tube clamp.
//
// FileSummary: Stable documentation views for the clamp/dovetail adapter.
// The production geometry remains in hub75_tube_clamp.scad.

$fn = 120;

use <hub75_tube_clamp.scad>

/* [Design view] */
view = "final"; // [final,before-relief,relief-detail,body,print-axis]

/* [Profile] */
size = "medium"; // [small,medium,large]

function _hub75_tube_clamp_design_size(size) =
    size == "small" || size == "medium" || size == "large"
        ? size
        : "medium";

module _hub75_tube_clamp_print_axis_reference(
    clamp,
    length = 24
) {
    // Side-print rule:
    //   project X / tube axis becomes printer Z.
    // This cylinder is documentation-only and deliberately does not indicate
    // the final relief position. It freezes the required cutter orientation.
    color([0.1, 0.75, 0.1, 0.7])
        translate([
            -length / 2,
            hub75_tube_clamp_tube_center_y(clamp),
            hub75_tube_clamp_tube_center_z(clamp)
        ])
            rotate([0, 90, 0])
                cylinder(
                    r = 0.65,
                    h = length
                );
}

module hub75_tube_clamp_design(
    view = "final",
    size = "medium"
) {
    active_size = _hub75_tube_clamp_design_size(size);
    clamp = hub75_tube_clamp_create_for_size(active_size);

    if (view == "before-relief") {
        hub75_tube_clamp_build(
            clamp,
            use_tension_bore = false,
            high_resolution = true,
            apply_transition_relief = false
        );
    } else if (view == "relief-detail") {
        color([0.72, 0.72, 0.72, 0.65])
            hub75_tube_clamp_build(
                clamp,
                use_tension_bore = false,
                high_resolution = true,
                apply_transition_relief = false
            );

        color([0.90, 0.08, 0.05, 1])
            difference() {
                hub75_tube_clamp_build(
                    clamp,
                    use_tension_bore = false,
                    high_resolution = true,
                    apply_transition_relief = true
                );

                hub75_tube_clamp_build(
                    clamp,
                    use_tension_bore = false,
                    high_resolution = true,
                    apply_transition_relief = false
                );
            }
    } else if (view == "body") {
        hub75_tube_clamp_body_build(
            clamp,
            use_tension_bore = false,
            high_resolution = true
        );
    } else if (view == "print-axis") {
        color([0.88, 0.08, 0.05, 0.35])
            hub75_tube_clamp_build(
                clamp,
                use_tension_bore = false,
                high_resolution = true
            );

        _hub75_tube_clamp_print_axis_reference(clamp);
    } else {
        hub75_tube_clamp_build(
            clamp,
            use_tension_bore = false,
            high_resolution = true
        );
    }
}

hub75_tube_clamp_design(
    view = view,
    size = size
);
