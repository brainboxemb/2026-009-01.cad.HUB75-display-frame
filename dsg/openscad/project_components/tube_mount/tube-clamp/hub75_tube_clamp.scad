// File: hub75_tube_clamp.scad
//   Project-owned detachable Ø10 HUB75 tube clamp.
//
// lib.scad.clamps owns the reusable snap-ring geometry and nominal/tension bore
// semantics. HUB75 keeps the ring compact, narrows it to 12 mm and places the
// 12 x 2 mm vertical male dovetail directly beside the 2 mm transition.

use <../../../ext/lib.scad.clamps/openscad/tube-clamp/tube_clamp.scad>
use <../tube_mount_interface.scad>

function hub75_tube_clamp_create(
    tube_center_y = -7,
    tube_center_z = 10,
    tube_diameter = 10,
    tension_diameter = 9.6,
    wall_thickness = 2.0,
    clamp_width = 12,
    opening_angle = 60,
    transition_depth = 2,
    dovetail_slide = 16,
    dovetail_center_z = undef,
    extra = 0.01,
    dovetail = hub75_tube_mount_dovetail_create()
) =
    let(
        active_dovetail_center_z =
            is_undef(dovetail_center_z)
                ? tube_center_z
                : dovetail_center_z,
        base_clamp =
            tube_clamp_create(
                tube_diameter = tube_diameter,
                clearance = 0,
                tension_diameter = tension_diameter,
                wall_thickness = wall_thickness,
                clamp_width = clamp_width,
                opening_angle = opening_angle,
                base_thickness = extra,
                transition_width =
                    hub75_tube_mount_dovetail_mouth_width(dovetail),
                transition_depth = transition_depth,
                extra = extra
            )
    )
    assert(dovetail_slide > 0,
        "tube-clamp dovetail_slide must be > 0")
    object(
        tube_center_y = tube_center_y,
        tube_center_z = tube_center_z,
        dovetail = dovetail,
        dovetail_slide = dovetail_slide,
        dovetail_center_z = active_dovetail_center_z,
        base_clamp = base_clamp
    );

function hub75_tube_clamp_tube_center_y(clamp) =
    clamp.tube_center_y;

function hub75_tube_clamp_tube_center_z(clamp) =
    clamp.tube_center_z;

function hub75_tube_clamp_functional_diameter(clamp) =
    tube_clamp_functional_diameter(clamp.base_clamp);

function hub75_tube_clamp_tension_diameter(clamp) =
    tube_clamp_tension_diameter(clamp.base_clamp);

function hub75_tube_clamp_outer_diameter(clamp) =
    2 * tube_clamp_outer_radius(clamp.base_clamp);


// ----------------------------------------------------------------------
// Public geometry
// ----------------------------------------------------------------------

module hub75_tube_clamp_body_build(
    clamp,
    part_color = [0.88, 0.08, 0.05, 1],
    use_tension_bore = true,
    high_resolution = true
) {
    color(part_color)
        _hub75_tube_clamp_ring_build(
            clamp,
            use_tension_bore,
            high_resolution
        );
}

module hub75_tube_clamp_build(
    clamp,
    part_color = [0.88, 0.08, 0.05, 1],
    use_tension_bore = true,
    high_resolution = true
) {
    color(part_color)
        union() {
            _hub75_tube_clamp_ring_build(
                clamp,
                use_tension_bore,
                high_resolution
            );
            _hub75_tube_clamp_dovetail_build(clamp);
        }
}


// ----------------------------------------------------------------------
// Private implementation
// ----------------------------------------------------------------------

module _hub75_tube_clamp_ring_build(
    clamp,
    use_tension_bore,
    high_resolution
) {
    local_center_x =
        clamp.base_clamp.base_thickness
        + tube_clamp_outer_radius(clamp.base_clamp);
    y_translation =
        clamp.tube_center_y + local_center_x;

    // Library local Z (clamp extrusion) becomes project X (tube axis).
    // Library local X becomes -project Y, keeping the ring tangent near Y=0.
    // Library local Y becomes -project Z around the tube centre.
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

module _hub75_tube_clamp_dovetail_build(clamp) {
    hub75_tube_mount_dovetail_male_build(
        dovetail = clamp.dovetail,
        slide = clamp.dovetail_slide,
        center_x = 0,
        center_z = clamp.dovetail_center_z
    );
}


_preview_clamp = hub75_tube_clamp_create();

hub75_tube_clamp_build(
    _preview_clamp,
    use_tension_bore = false,
    high_resolution = false
);
