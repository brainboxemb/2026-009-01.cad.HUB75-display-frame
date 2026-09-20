// File: dovetail_tube_clamp.scad
//   One canonical detachable HUB75 tube clamp with an integrated male dovetail.
//
// Coordinate system:
//   X = aluminium-tube direction / dovetail slide axis;
//   Y = panel front -> rear, with the coupler mounting plane at Y = 0;
//   Z = outward from the top display edge.
//
// The same clamp is used for small, medium and large couplers. Its male
// dovetail follows the shared tube-mount interface contract.

use <../../ext/lib.scad.clamps/openscad/tube-clamp/tube_clamp.scad>
use <dovetail_interface.scad>

_HUB75_DOVETAIL_TUBE_CLAMP_EPS = 0.05;

function hub75_dovetail_tube_clamp_create(
    tube_center_y = -7,
    tube_center_z = 10,
    tube_diameter = 10,
    tube_clearance = 0.4,
    wall_thickness = 2.6,
    clamp_width = 16,
    opening_angle = 60,
    compact_base_thickness = 0.2,
    transition_depth = 5,
    dovetail = hub75_tube_mount_dovetail_create(),
    dovetail_center_z = 10,
    render_fn = 192
) =
    let(
        // Make the reusable clamp's compact base exactly as wide as the
        // dovetail mouth. This produces one clean transition rather than the
        // previous partial overlap/notch at the circular clamp body.
        transition_width = dovetail.mouth_width,
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

module _hub75_dovetail_tube_clamp_prism(
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

    multmatrix([
        [0, 0, 1, x_min],
        [1, 0, 0, 0],
        [0, 1, 0, center_z],
        [0, 0, 0, 1]
    ])
        linear_extrude(height = x_max - x_min)
            polygon(points = [
                [y_min, -mouth_width / 2],
                [y_min,  mouth_width / 2],
                [y_max,  root_width / 2],
                [y_max, -root_width / 2]
            ]);
}

module hub75_dovetail_tube_clamp_groove_cutter(
    clamp,
    entry_x,
    stop_x
) {
    dovetail = clamp.dovetail;
    x_min = min(entry_x, stop_x) - _HUB75_DOVETAIL_TUBE_CLAMP_EPS;
    x_max = max(entry_x, stop_x) + _HUB75_DOVETAIL_TUBE_CLAMP_EPS;
    clearance = dovetail.fit_clearance;
    female_mouth = dovetail.mouth_width + 2 * clearance;
    female_root = dovetail.root_width + 2 * clearance;

    union() {
        // Exact nominal interface profile: mouth at Y=0, root at Y=depth.
        _hub75_dovetail_tube_clamp_prism(
            x_min = x_min,
            x_max = x_max,
            y_min = 0,
            y_max = dovetail.depth,
            center_z = clamp.dovetail_center_z,
            root_width = female_root,
            mouth_width = female_mouth
        );

        // Boolean opening extensions do not alter the nominal flank angle.
        translate([
            x_min,
            -_HUB75_DOVETAIL_TUBE_CLAMP_EPS,
            clamp.dovetail_center_z - female_mouth / 2
        ])
            cube([
                x_max - x_min,
                2 * _HUB75_DOVETAIL_TUBE_CLAMP_EPS,
                female_mouth
            ]);

        translate([
            x_min,
            dovetail.depth - _HUB75_DOVETAIL_TUBE_CLAMP_EPS,
            clamp.dovetail_center_z - female_root / 2
        ])
            cube([
                x_max - x_min,
                2 * _HUB75_DOVETAIL_TUBE_CLAMP_EPS,
                female_root
            ]);
    }
}

module _hub75_dovetail_tube_clamp_foot(clamp) {
    dovetail = clamp.dovetail;
    half_length =
        hub75_dovetail_tube_clamp_foot_length(clamp) / 2;

    union() {
        // Exact male interface: 8 mm mouth at Y=0, 10 mm root at Y=3.
        _hub75_dovetail_tube_clamp_prism(
            x_min = -half_length,
            x_max = half_length,
            y_min = 0,
            y_max = dovetail.depth,
            center_z = clamp.dovetail_center_z,
            root_width = dovetail.root_width,
            mouth_width = dovetail.mouth_width
        );

        // Straight overlap into the compact base. It is deliberately not part
        // of the sloping interface, so the dovetail remains exactly 3 mm deep.
        translate([
            -half_length,
            -clamp.base_clamp.base_thickness,
            clamp.dovetail_center_z - dovetail.mouth_width / 2
        ])
            cube([
                2 * half_length,
                clamp.base_clamp.base_thickness
                    + _HUB75_DOVETAIL_TUBE_CLAMP_EPS,
                dovetail.mouth_width
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
    part_color = [0.88, 0.08, 0.05, 1]
) {
    $fn = clamp.render_fn;

    color(part_color)
        union() {
            _hub75_dovetail_tube_clamp_oriented_body(clamp);
            _hub75_dovetail_tube_clamp_foot(clamp);
        }
}

_preview_clamp =
    hub75_dovetail_tube_clamp_create();

hub75_dovetail_tube_clamp_build(_preview_clamp);
