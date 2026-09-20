// File: dovetail_tube_clamp.scad
//   One canonical detachable HUB75 tube clamp with a lib.scad.mechint male dovetail.
//
// Coordinate system:
//   X = aluminium-tube direction / dovetail slide axis;
//   Y = panel front -> rear, with the coupler mounting plane at Y = 0;
//   Z = outward from the top display edge.
//
// The same clamp is used for small, medium and large couplers. The reusable
// mechanical interface owns the dovetail profile, fit clearance and lock.

use <../../ext/lib.scad.clamps/openscad/tube-clamp/tube_clamp.scad>
use <dovetail_interface.scad>

_HUB75_DOVETAIL_TUBE_CLAMP_EPS = 0.05;

function hub75_dovetail_tube_clamp_create(
    tube_center_y = -6.4,
    tube_center_z = 10,
    tube_diameter = 10,
    tube_clearance = 0.4,
    wall_thickness = 2.0,
    clamp_width = 16,
    opening_angle = 60,
    compact_base_thickness = 0.2,
    transition_depth = 5,
    dovetail = hub75_tube_mount_dovetail_create(),
    dovetail_center_z = 10,
    render_fn = 192
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
                wall_thickness = wall_thickness,
                clamp_width = clamp_width,
                opening_angle = opening_angle,
                base_thickness = compact_base_thickness,
                transition_width = transition_width,
                transition_depth = transition_depth
            ),
        center_distance =
            compact_base_thickness
            + (tube_diameter + tube_clearance) / 2
            + wall_thickness
            - 1.0
    )
    assert(render_fn >= 24,
        "clamp render_fn must be >= 24")
    assert(abs(center_distance + tube_center_y) < 0.001,
        "compact clamp base no longer preserves the intended tube Y centre")
    object(
        tube_center_y = tube_center_y,
        tube_center_z = tube_center_z,
        dovetail = dovetail,
        dovetail_center_z = dovetail_center_z,
        render_fn = render_fn,
        base_clamp = base_clamp
    );

function hub75_dovetail_tube_clamp_foot_length(clamp) =
    clamp.base_clamp.clamp_width;

function hub75_dovetail_tube_clamp_tube_center_y(clamp) =
    clamp.tube_center_y;

function hub75_dovetail_tube_clamp_tube_center_z(clamp) =
    clamp.tube_center_z;

module hub75_dovetail_tube_clamp_groove_cutter(
    clamp,
    center_x,
    entry_side,
    entry_extension = 0
) {
    hub75_tube_mount_dovetail_female_cutter(
        dovetail = clamp.dovetail,
        slide =
            hub75_dovetail_tube_clamp_foot_length(
                clamp
            ),
        center_x = center_x,
        center_z = clamp.dovetail_center_z,
        entry_side = entry_side,
        entry_extension = entry_extension
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

        // Continue the mouth into the compact reusable clamp base. This overlap
        // is project attachment geometry; the dovetail profile itself remains
        // owned by lib.scad.mechint.
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

module _hub75_dovetail_tube_clamp_oriented_body(clamp) {
    $fn = clamp.render_fn;

    multmatrix([
        [ 0,  0,  1, -clamp.base_clamp.clamp_width / 2],
        [-1,  0,  0,  0],
        [ 0, -1,  0,  clamp.tube_center_z],
        [ 0,  0,  0,  1]
    ])
        tube_clamp_build(clamp.base_clamp);
}

module hub75_dovetail_tube_clamp_build(
    clamp,
    part_color = [0.88, 0.08, 0.05, 1],
    entry_side = -1
) {
    assert(
        entry_side == -1 || entry_side == 1,
        "entry_side must be -1 or +1"
    );

    $fn = clamp.render_fn;

    color(part_color)
        union() {
            _hub75_dovetail_tube_clamp_oriented_body(
                clamp
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
    _preview_clamp
);
