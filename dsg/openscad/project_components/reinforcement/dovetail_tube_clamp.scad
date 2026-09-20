// File: dovetail_tube_clamp.scad
//   Detachable HUB75 reinforcement clamp using lib.scad.clamps as its base.
//
// Coordinate system after placement:
//   X = aluminium tube direction
//   Y = panel front -> rear
//   Z = outward from the top display edge
//
// The reusable tube clamp remains library-owned. This project adds only the
// dovetail key and a short bridge needed to connect that clamp to a coupler.

use <../../ext/lib.scad.clamps/openscad/tube-clamp/tube_clamp.scad>

_HUB75_DOVETAIL_EPS = 0.05;

function hub75_reinforcement_clip_offset(profile_size) =
    profile_size <= 60 ? 18 : 25;

function hub75_reinforcement_dovetail_side_offset() = 8;
function hub75_reinforcement_dovetail_narrow_width() = 8;
function hub75_reinforcement_dovetail_wide_width() = 10;
function hub75_reinforcement_dovetail_height() = 7;
function hub75_reinforcement_dovetail_clearance() = 0.25;

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
        transition_width = 20,
        transition_depth = 6
    );

module _hub75_dovetail_prism_y(
    y_min,
    y_max,
    center_x,
    center_z,
    narrow_width,
    wide_width,
    height
) {
    assert(y_max > y_min, "dovetail Y span must be positive");
    assert(wide_width >= narrow_width, "wide dovetail width must be >= narrow width");

    translate([0, y_max, 0])
        rotate([90, 0, 0])
            linear_extrude(height = y_max - y_min)
                translate([center_x, center_z])
                    polygon(points = [
                        [-narrow_width / 2, -height / 2],
                        [ narrow_width / 2, -height / 2],
                        [ wide_width / 2,    height / 2],
                        [-wide_width / 2,    height / 2]
                    ]);
}

// Public cutter used by the reinforced coupler wrappers.
// It is deliberately through the coupler base in Y: with the coupler printed
// backside-down this produces vertical walls instead of a blind unsupported roof.
module hub75_reinforcement_dovetail_socket_cutter(
    coupler_base_thickness,
    center_x,
    center_z = 10,
    clearance = hub75_reinforcement_dovetail_clearance()
) {
    _hub75_dovetail_prism_y(
        y_min = -_HUB75_DOVETAIL_EPS,
        y_max = coupler_base_thickness + _HUB75_DOVETAIL_EPS,
        center_x = center_x,
        center_z = center_z,
        narrow_width =
            hub75_reinforcement_dovetail_narrow_width() + 2 * clearance,
        wide_width =
            hub75_reinforcement_dovetail_wide_width() + 2 * clearance,
        height =
            hub75_reinforcement_dovetail_height() + 2 * clearance
    );
}

module _hub75_reinforcement_dovetail_key(
    coupler_base_thickness,
    center_x,
    center_z
) {
    _hub75_dovetail_prism_y(
        y_min = 0,
        y_max = coupler_base_thickness,
        center_x = center_x,
        center_z = center_z,
        narrow_width = hub75_reinforcement_dovetail_narrow_width(),
        wide_width = hub75_reinforcement_dovetail_wide_width(),
        height = hub75_reinforcement_dovetail_height()
    );
}

module hub75_reinforcement_dovetail_tube_clamp(
    coupler_base_thickness = 3,
    dovetail_side = 1,
    part_color = [0.88, 0.08, 0.05, 1]
) {
    clamp = hub75_reinforcement_clamp_object();
    tube_y = hub75_reinforcement_tube_center_y();
    tube_z = hub75_reinforcement_tube_center_z();
    dovetail_x =
        dovetail_side
        * hub75_reinforcement_dovetail_side_offset();

    color(part_color)
        union() {
            // lib.scad.clamps owns the actual snap clamp. Ry(-90) maps the
            // library's tube axis onto project X and its compact base outward
            // toward +Z.
            translate([
                clamp.clamp_width / 2,
                tube_y,
                tube_z - tube_clamp_inner_radius(clamp)
                    - clamp.wall_thickness
                    - clamp.base_thickness
                    + 1
            ])
                rotate([0, -90, 0])
                    tube_clamp_build(clamp);

            // Project-owned key. It overlaps the rear quadrant of the clamp,
            // creating one printable detachable part without modifying the
            // reusable library component.
            _hub75_reinforcement_dovetail_key(
                coupler_base_thickness = coupler_base_thickness,
                center_x = dovetail_x,
                center_z = tube_z
            );

            // Short bridge from the clamp body to the offset key.
            hull() {
                translate([
                    dovetail_side * (clamp.clamp_width / 2 - 1.5),
                    -0.2,
                    tube_z
                ])
                    cube([3, 1.2, 5], center = true);

                translate([
                    dovetail_x,
                    coupler_base_thickness / 2,
                    tube_z
                ])
                    cube([
                        hub75_reinforcement_dovetail_narrow_width() - 1,
                        coupler_base_thickness,
                        4
                    ], center = true);
            }
        }
}
