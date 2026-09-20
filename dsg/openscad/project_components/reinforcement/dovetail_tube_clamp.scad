// File: dovetail_tube_clamp.scad
//   Detachable HUB75 reinforcement clamp using lib.scad.clamps as its base.
//
// Local project coordinates:
//   X = aluminium-tube direction
//   Y = panel front -> rear, with the coupler mounting plane at Y = 0
//   Z = outward from the top display edge
//
// The reusable snap-clamp body remains library-owned. This project adds only
// the sliding dovetail rail that attaches the separately printable clamp to a
// coupler.

use <../../ext/lib.scad.clamps/openscad/tube-clamp/tube_clamp.scad>

_HUB75_DOVETAIL_EPS = 0.05;

function hub75_reinforcement_clip_offset(profile_size) =
    profile_size <= 60 ? 18 : 25;

function hub75_reinforcement_dovetail_rail_length() = 12;
function hub75_reinforcement_dovetail_depth() = 1.0;
function hub75_reinforcement_dovetail_mouth_width() = 5.4;
function hub75_reinforcement_dovetail_inner_width() = 7.4;
function hub75_reinforcement_dovetail_clearance() = 0.20;
function hub75_reinforcement_dovetail_mount_z() = 2.2;

function hub75_reinforcement_tube_center_y() = -7;
function hub75_reinforcement_tube_center_z() = 10;

function hub75_reinforcement_clamp_object() =
    tube_clamp_create(
        tube_diameter = 10,
        clearance = 0.4,
        wall_thickness = 2.6,
        clamp_width = 16,
        opening_angle = 60,
        base_thickness = 2,
        transition_width = 22,
        transition_depth = 6
    );

function hub75_reinforcement_dovetail_groove_depth(base_thickness) =
    min(
        hub75_reinforcement_dovetail_depth() + 0.2,
        max(0.6, base_thickness - 0.6)
    );

module _hub75_reinforcement_dovetail_x_prism(
    x_min,
    x_max,
    y_surface,
    depth,
    center_z,
    mouth_width,
    inner_width
) {
    assert(x_max > x_min, "dovetail X span must be positive");
    assert(depth > 0, "dovetail depth must be positive");
    assert(inner_width > mouth_width, "dovetail inner width must exceed mouth width");

    y_inner = y_surface - depth;

    // local X -> global Y
    // local Y -> global Z
    // local Z/extrusion -> global X
    multmatrix([
        [0, 0, 1, x_min],
        [1, 0, 0, 0],
        [0, 1, 0, center_z],
        [0, 0, 0, 1]
    ])
        linear_extrude(height = x_max - x_min)
            polygon(points = [
                [y_inner, -inner_width / 2],
                [y_inner,  inner_width / 2],
                [y_surface, mouth_width / 2],
                [y_surface, -mouth_width / 2]
            ]);
}

// Public cutter used by reinforcement wrappers.
//
// The groove is open at the coupler rear face and slides along X. With the
// coupler printed rear-face-down, the narrow mouth starts at the build plate and
// the wider interior grows through shallow sloped walls. There is no blind roof
// that would require support.
module hub75_reinforcement_dovetail_groove_cutter(
    coupler_base_thickness,
    entry_x,
    stop_x,
    center_z = hub75_reinforcement_dovetail_mount_z(),
    clearance = hub75_reinforcement_dovetail_clearance()
) {
    x_min = min(entry_x, stop_x) - _HUB75_DOVETAIL_EPS;
    x_max = max(entry_x, stop_x) + _HUB75_DOVETAIL_EPS;
    groove_depth =
        hub75_reinforcement_dovetail_groove_depth(coupler_base_thickness);

    _hub75_reinforcement_dovetail_x_prism(
        x_min = x_min,
        x_max = x_max,
        y_surface = coupler_base_thickness + _HUB75_DOVETAIL_EPS,
        depth = groove_depth + _HUB75_DOVETAIL_EPS,
        center_z = center_z,
        mouth_width =
            hub75_reinforcement_dovetail_mouth_width() + 2 * clearance,
        inner_width =
            hub75_reinforcement_dovetail_inner_width() + 2 * clearance
    );
}

module _hub75_reinforcement_dovetail_rail(
    coupler_base_thickness
) {
    rail_length = hub75_reinforcement_dovetail_rail_length();

    _hub75_reinforcement_dovetail_x_prism(
        x_min = -rail_length / 2,
        x_max = rail_length / 2,
        y_surface = coupler_base_thickness - _HUB75_DOVETAIL_EPS,
        depth = hub75_reinforcement_dovetail_depth(),
        center_z = hub75_reinforcement_dovetail_mount_z(),
        mouth_width = hub75_reinforcement_dovetail_mouth_width(),
        inner_width = hub75_reinforcement_dovetail_inner_width()
    );
}

// Public separately printable clip.
//
// Ry(-90) maps the lib.scad.clamps tube axis to project X and points the clamp
// opening outward (+Z). The compact library base already reaches the coupler
// rear region; the dovetail rail overlaps that base directly, so no second
// project-specific clamp body is introduced.
module hub75_reinforcement_dovetail_tube_clamp(
    coupler_base_thickness = 3,
    part_color = [0.88, 0.08, 0.05, 1]
) {
    clamp = hub75_reinforcement_clamp_object();
    tube_y = hub75_reinforcement_tube_center_y();
    tube_z = hub75_reinforcement_tube_center_z();
    clamp_origin_z =
        tube_z
        - (
            clamp.base_thickness
            + tube_clamp_outer_radius(clamp)
            - 1.0
        );

    color(part_color)
        union() {
            translate([
                clamp.clamp_width / 2,
                tube_y,
                clamp_origin_z
            ])
                rotate([0, -90, 0])
                    tube_clamp_build(clamp);

            _hub75_reinforcement_dovetail_rail(
                coupler_base_thickness = coupler_base_thickness
            );
        }
}
