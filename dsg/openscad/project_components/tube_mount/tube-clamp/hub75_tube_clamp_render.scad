// File: hub75_tube_clamp_render.scad
//   Design-render adapter for the HUB75 project-owned tube clamp.
//
// FileSummary: Stable documentation views for the clamp/dovetail adapter.
// The production geometry remains in hub75_tube_clamp.scad.

$fn = 120;

use <hub75_tube_clamp.scad>

/* [Design view] */
view = "final"; // [final,before-relief,relief-detail,body,development-axis]

/* [Profile] */
size = "medium"; // [small,medium,large]

function _hub75_tube_clamp_design_size(size) =
    size == "small" || size == "medium" || size == "large"
        ? size
        : "medium";

module _hub75_tube_clamp_development_z_reference(
    clamp,
    length = 18
) {
    // development Z = -project Y.
    // Documentation-only reference for the relief z_height / z_offset terms.
    color([0.1, 0.75, 0.1, 0.7])
        translate([
            0,
            hub75_tube_clamp_tube_center_y(clamp)
                + length / 2,
            hub75_tube_clamp_tube_center_z(clamp)
        ])
            rotate([90, 0, 0])
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
                    apply_transition_relief = false
                );

                hub75_tube_clamp_build(
                    clamp,
                    use_tension_bore = false,
                    high_resolution = true,
                    apply_transition_relief = true
                );
            }
    } else if (view == "body") {
        hub75_tube_clamp_body_build(
            clamp,
            use_tension_bore = false,
            high_resolution = true
        );
    } else if (view == "development-axis") {
        color([0.88, 0.08, 0.05, 0.35])
            hub75_tube_clamp_build(
                clamp,
                use_tension_bore = false,
                high_resolution = true
            );

        _hub75_tube_clamp_development_z_reference(clamp);
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
