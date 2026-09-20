// File: dovetail_tube_clamp.scad
//   One canonical detachable HUB75 tube clamp with a lib.scad.mechint male dovetail.
//
// Coordinate system:
//   X = aluminium-tube direction / dovetail slide axis;
//   Y = panel front -> rear, with the coupler mounting plane at Y = 0;
//   Z = outward from the top display edge.
//
// The same clamp is used for small, medium and large couplers. The reusable
// libraries own the tube-clamp fit model and dovetail/lock geometry.

use <../../ext/lib.scad.clamps/openscad/tube-clamp/tube_clamp.scad>
use <dovetail_interface.scad>

_HUB75_DOVETAIL_TUBE_CLAMP_EPS = 0.05;

function hub75_dovetail_tube_clamp_create(
    tube_center_y = -7,
    tube_center_z = 10,
    tube_diameter = 10,
    tube_clearance = 0,
    tension_diameter = 9.6,
    wall_thickness = 2.0,
    clamp_width = 16,
    opening_angle = 60,
    compact_base_thickness = 0.8,
    transition_depth = 3,
    extra = 0.01,
    dovetail = hub75_tube_mount_dovetail_create(),
    dovetail_center_z = 10
) =
    let(
        transition_width =
            hub75_tube_mount_dovetail_mouth_width(
                dovetail
            ),
        base_clamp =
            tube_clamp_create(
                tube_diameter = tube_diameter,
                clearance = tube_clearance,
                tension_diameter = tension_diameter,
                wall_thickness = wall_thickness,
                clamp_width = clamp_width,
                opening_angle = opening_angle,
                base_thickness = compact_base_thickness,
                transition_width = transition_width,
                transition_depth = transition_depth,
                extra = extra
            )
    )
    assert(
        hub75_tube_mount_dovetail_entry_slot_length(dovetail)
            >= clamp_width,
        "female dovetail entry slot must clear the complete clamp width"
    )
    assert(
        hub75_tube_mount_dovetail_female_root_width(dovetail)
            >= 2 * tube_clamp_outer_radius(base_clamp),
        "female dovetail entry slot must clear the clamp outside diameter"
    )
    object(
        tube_center_y = tube_center_y,
        tube_center_z = tube_center_z,
        dovetail = dovetail,
        dovetail_center_z = dovetail_center_z,
        base_clamp = base_clamp
    );

function hub75_dovetail_tube_clamp_foot_length(clamp) =
    clamp.base_clamp.clamp_width;

function hub75_dovetail_tube_clamp_tube_center_y(clamp) =
    clamp.tube_center_y;

function hub75_dovetail_tube_clamp_tube_center_z(clamp) =
    clamp.tube_center_z;

function hub75_dovetail_tube_clamp_functional_diameter(clamp) =
    tube_clamp_functional_diameter(clamp.base_clamp);

function hub75_dovetail_tube_clamp_tension_diameter(clamp) =
    tube_clamp_tension_diameter(clamp.base_clamp);

module hub75_dovetail_tube_clamp_groove_cutter(
    clamp,
    center_x,
    entry_side
) {
    hub75_tube_mount_dovetail_female_cutter(
        dovetail = clamp.dovetail,
        slide =
            hub75_dovetail_tube_clamp_foot_length(
                clamp
            ),
        center_x = center_x,
        center_z = clamp.dovetail_center_z,
        entry_side = entry_side
    );
}

module _hub75_dovetail_tube_clamp_foot(
    clamp,
    entry_side
) {
    half_length =
        hub75_dovetail_tube_clamp_foot_length(
            clamp
        ) / 2;
    mouth_width =
        hub75_tube_mount_dovetail_mouth_width(
            clamp.dovetail
        );

    union() {
        hub75_tube_mount_dovetail_male_build(
            dovetail = clamp.dovetail,
            slide =
                hub75_dovetail_tube_clamp_foot_length(
                    clamp
                ),
            center_z = clamp.dovetail_center_z,
            entry_side = entry_side
        );

        // Continue the mouth into the compact reusable clamp base. This tiny
        // overlap is project attachment geometry; fit stays library-owned.
        translate([
            -half_length,
            -clamp.base_clamp.base_thickness,
            clamp.dovetail_center_z
                - mouth_width / 2
        ])
            cube([
                2 * half_length,
                clamp.base_clamp.base_thickness
                    + _HUB75_DOVETAIL_TUBE_CLAMP_EPS,
                mouth_width
            ]);
    }
}

module _hub75_dovetail_tube_clamp_oriented_body(
    clamp,
    use_tension_bore,
    high_resolution
) {
    local_center_x =
        clamp.base_clamp.base_thickness
        + tube_clamp_outer_radius(clamp.base_clamp);
    y_translation =
        clamp.tube_center_y
        + local_center_x;

    multmatrix([
        [ 0,  0,  1, -clamp.base_clamp.clamp_width / 2],
        [-1,  0,  0,  y_translation],
        [ 0, -1,  0,  clamp.tube_center_z],
        [ 0,  0,  0,  1]
    ])
        tube_clamp_build(
            clamp.base_clamp,
            use_tension_bore = use_tension_bore,
            high_resolution = high_resolution
        );
}

// Module: hub75_dovetail_tube_clamp_body_build()
// Synopsis: Builds only the raw reusable clamp body in HUB75 orientation.
// Description:
//   This intentionally omits the project-local male dovetail/foot so the base
//   clamp can be inspected and dimensioned independently from the attachment.
module hub75_dovetail_tube_clamp_body_build(
    clamp,
    part_color = [0.88, 0.08, 0.05, 1],
    use_tension_bore = true,
    high_resolution = true
) {
    color(part_color)
        _hub75_dovetail_tube_clamp_oriented_body(
            clamp,
            use_tension_bore,
            high_resolution
        );
}

module hub75_dovetail_tube_clamp_build(
    clamp,
    part_color = [0.88, 0.08, 0.05, 1],
    entry_side = -1,
    use_tension_bore = true,
    high_resolution = true
) {
    assert(
        entry_side == -1 || entry_side == 1,
        "entry_side must be -1 or +1"
    );

    color(part_color)
        union() {
            _hub75_dovetail_tube_clamp_oriented_body(
                clamp,
                use_tension_bore,
                high_resolution
            );
            _hub75_dovetail_tube_clamp_foot(
                clamp,
                entry_side
            );
        }
}

_preview_clamp =
    hub75_dovetail_tube_clamp_create();

hub75_dovetail_tube_clamp_build(
    _preview_clamp,
    use_tension_bore = false,
    high_resolution = false
);
