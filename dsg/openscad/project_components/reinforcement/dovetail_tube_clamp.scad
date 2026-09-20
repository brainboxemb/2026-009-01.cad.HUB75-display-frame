// File: dovetail_tube_clamp.scad
//   Detachable HUB75 reinforcement clamp using lib.scad.clamps as its base.
//
// Coordinate system:
//   X = aluminium-tube direction;
//   Y = panel front -> rear, with the coupler mounting plane at Y = 0;
//   Z = outward from the top display edge.
//
// Orientation deliberately follows the proven V1.2 clip:
//   - tube axis runs in X;
//   - snap opening points away from the plate in -Y;
//   - the compact clamp base faces the coupler in +Y.
//
// The project-specific mounting foot IS the male dovetail. It is not a small
// secondary rail attached somewhere else on the clamp.

use <../../ext/lib.scad.clamps/openscad/tube-clamp/tube_clamp.scad>

_HUB75_REINFORCEMENT_EPS = 0.05;

function hub75_reinforcement_clip_offset(profile_size) =
    profile_size <= 60 ? 18 : 25;

function hub75_reinforcement_tube_clamp_create(
    coupler_base_thickness = 3,
    tube_center_y = -7,
    tube_center_z = 10,
    tube_diameter = 10,
    tube_clearance = 0.4,
    wall_thickness = 2.6,
    clamp_width = 16,
    opening_angle = 60,
    compact_base_thickness = 0.2,
    transition_width = 16,
    transition_depth = 5,
    dovetail_root_width = 15,
    dovetail_mouth_width = 11,
    dovetail_clearance = 0.25,
    render_fn = 192
) =
    let(
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
    assert(coupler_base_thickness > 0,
        "coupler base thickness must be > 0")
    assert(dovetail_root_width > dovetail_mouth_width,
        "dovetail root must be wider than the rear mouth")
    assert(dovetail_mouth_width > 0,
        "dovetail mouth width must be > 0")
    assert(dovetail_clearance >= 0,
        "dovetail clearance must be >= 0")
    assert(render_fn >= 24,
        "clamp render_fn must be >= 24")
    // Preserve the proven V1.2 tube centre by choosing the library compact
    // base so its ring centre lands exactly at tube_center_y after transform.
    assert(abs(center_distance + tube_center_y) < 0.001,
        "compact clamp base no longer preserves the intended tube Y centre")
    object(
        coupler_base_thickness = coupler_base_thickness,
        tube_center_y = tube_center_y,
        tube_center_z = tube_center_z,
        dovetail_root_width = dovetail_root_width,
        dovetail_mouth_width = dovetail_mouth_width,
        dovetail_clearance = dovetail_clearance,
        render_fn = render_fn,
        base_clamp = base_clamp
    );

function hub75_reinforcement_tube_clamp_foot_length(clamp) =
    clamp.base_clamp.clamp_width;

function hub75_reinforcement_tube_clamp_tube_center_y(clamp) =
    clamp.tube_center_y;

function hub75_reinforcement_tube_clamp_tube_center_z(clamp) =
    clamp.tube_center_z;

module _hub75_reinforcement_dovetail_prism(
    x_min,
    x_max,
    y_min,
    y_max,
    center_z,
    root_width,
    mouth_width
) {
    assert(x_max > x_min, "dovetail X span must be positive");
    assert(y_max > y_min, "dovetail Y span must be positive");
    assert(root_width > mouth_width,
        "dovetail root must be wider than mouth");

    // 2D polygon is [Y,Z], extrusion becomes project X.
    multmatrix([
        [0, 0, 1, x_min],
        [1, 0, 0, 0],
        [0, 1, 0, center_z],
        [0, 0, 0, 1]
    ])
        linear_extrude(height = x_max - x_min)
            polygon(points = [
                [y_min, -root_width / 2],
                [y_min,  root_width / 2],
                [y_max,  mouth_width / 2],
                [y_max, -mouth_width / 2]
            ]);
}

// Public female cutter for the coupler wrapper.
//
// It is open through the reinforcement-only base area, so a coupler printed
// rear-face-down has no blind roof over this slot. The shape slides in X.
module hub75_reinforcement_dovetail_groove_cutter(
    clamp,
    entry_x,
    stop_x
) {
    x_min = min(entry_x, stop_x) - _HUB75_REINFORCEMENT_EPS;
    x_max = max(entry_x, stop_x) + _HUB75_REINFORCEMENT_EPS;
    clearance = clamp.dovetail_clearance;

    _hub75_reinforcement_dovetail_prism(
        x_min = x_min,
        x_max = x_max,
        y_min = -_HUB75_REINFORCEMENT_EPS,
        y_max =
            clamp.coupler_base_thickness
            + _HUB75_REINFORCEMENT_EPS,
        center_z = clamp.tube_center_z,
        root_width =
            clamp.dovetail_root_width + 2 * clearance,
        mouth_width =
            clamp.dovetail_mouth_width + 2 * clearance
    );
}

module _hub75_reinforcement_dovetail_foot(clamp) {
    half_length =
        hub75_reinforcement_tube_clamp_foot_length(clamp) / 2;

    _hub75_reinforcement_dovetail_prism(
        x_min = -half_length,
        x_max = half_length,
        y_min = -0.12,
        y_max = clamp.coupler_base_thickness,
        center_z = clamp.tube_center_z,
        root_width = clamp.dovetail_root_width,
        mouth_width = clamp.dovetail_mouth_width
    );
}

// Correct project orientation for the reusable clamp.
//
// Source lib.scad.clamps:
//   +Z = clamp/tube axis
//   +X = from compact rear base toward ring/opening
//
// Project:
//   +X = tube axis
//   -Y = from coupler toward ring/opening
//
// Mapping:
//   project X = source Z
//   project Y = -source X
//   project Z = -source Y + tube centre Z
module _hub75_reinforcement_oriented_library_clamp(clamp) {
    $fn = clamp.render_fn;

    multmatrix([
        [ 0,  0,  1, -clamp.base_clamp.clamp_width / 2],
        [-1,  0,  0,  0],
        [ 0, -1,  0,  clamp.tube_center_z],
        [ 0,  0,  0,  1]
    ])
        tube_clamp_build(clamp.base_clamp);
}

module hub75_reinforcement_tube_clamp_build(
    clamp,
    part_color = [0.88, 0.08, 0.05, 1]
) {
    $fn = clamp.render_fn;

    color(part_color)
        union() {
            _hub75_reinforcement_oriented_library_clamp(clamp);
            _hub75_reinforcement_dovetail_foot(clamp);
        }
}

// Standalone preview.
_preview_clamp =
    hub75_reinforcement_tube_clamp_create();

hub75_reinforcement_tube_clamp_build(_preview_clamp);
