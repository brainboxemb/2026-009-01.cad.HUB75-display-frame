// File: hub75_tube_horizontal_edge_coupler.scad
//   Tube-aware horizontal-edge coupler built around the accepted HUB75 core
//   horizontal-edge component.
//
// Construction order:
//   1. start from the accepted core coupler;
//   2. remove one continuous aluminium-tube keep-out;
//   3. add two compact rear carriers at structurally derived X positions;
//   4. cut vertical, top-entry female dovetails into those carriers.

use <../../../components/hub75/horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>
use <../tube-clamp/hub75_tube_clamp.scad>
use <../tube_mount_interface.scad>

_HUB75_TUBE_EDGE_EPS = 0.05;

function hub75_tube_horizontal_edge_carrier_side_wall() = 2;
function hub75_tube_horizontal_edge_carrier_bottom_margin() = 2;
function hub75_tube_horizontal_edge_carrier_top_lip() = 2;

function hub75_tube_horizontal_edge_carrier_width(
    clamp = hub75_tube_clamp_create()
) =
    hub75_tube_mount_dovetail_female_root_width(
        clamp.dovetail
    )
    + 2 * hub75_tube_horizontal_edge_carrier_side_wall();

function hub75_tube_horizontal_edge_carrier_z_min(clamp) =
    clamp.dovetail_center_z
    - hub75_tube_mount_dovetail_female_slide(
        clamp.dovetail,
        clamp.dovetail_slide
    ) / 2
    - hub75_tube_horizontal_edge_carrier_bottom_margin();

function hub75_tube_horizontal_edge_carrier_z_max(clamp) =
    clamp.dovetail_center_z
    + hub75_tube_mount_dovetail_female_slide(
        clamp.dovetail,
        clamp.dovetail_slide
    ) / 2
    + hub75_tube_horizontal_edge_carrier_top_lip();

function hub75_tube_horizontal_edge_carrier_edge_margin() = 4;

function hub75_tube_horizontal_edge_clamp_offset(
    coupler,
    carrier_width = hub75_tube_horizontal_edge_carrier_width(),
    edge_margin = hub75_tube_horizontal_edge_carrier_edge_margin()
) =
    max(
        carrier_width / 2,
        coupler.profile_size / 2
            - carrier_width / 2
            - edge_margin
    );

function hub75_tube_horizontal_edge_clamp_positions(coupler) =
    let(offset = hub75_tube_horizontal_edge_clamp_offset(coupler))
    [-offset, offset];

function hub75_tube_horizontal_edge_keepout_radial_clearance(coupler) =
    coupler.fit_clearance;


// ----------------------------------------------------------------------
// Public geometry
// ----------------------------------------------------------------------

module hub75_tube_horizontal_edge_coupler_build(
    coupler
) {
    clamp =
        hub75_tube_clamp_create(
            dovetail =
                hub75_tube_mount_dovetail_create(
                    host_depth = coupler.base_thickness
                )
        );

    difference() {
        union() {
            hub75_horizontal_edge_coupler_build(coupler);
            _hub75_tube_horizontal_edge_carriers(
                coupler,
                clamp
            );
        }

        _hub75_tube_horizontal_edge_keepout_cutter(
            coupler,
            clamp
        );
        _hub75_tube_horizontal_edge_dovetail_cutters(
            coupler,
            clamp
        );
    }
}


// ----------------------------------------------------------------------
// Private implementation
// ----------------------------------------------------------------------

module _hub75_tube_horizontal_edge_keepout_cutter(
    coupler,
    clamp
) {
    keepout_d =
        hub75_tube_clamp_functional_diameter(clamp)
        + 2 * hub75_tube_horizontal_edge_keepout_radial_clearance(coupler);
    cutter_length = coupler.profile_size + 2 * _HUB75_TUBE_EDGE_EPS;

    translate([
        -cutter_length / 2,
        hub75_tube_clamp_tube_center_y(clamp),
        hub75_tube_clamp_tube_center_z(clamp)
    ])
        rotate([0, 90, 0])
            cylinder(
                d = keepout_d,
                h = cutter_length,
                $fn = coupler.render_fn
            );
}

module _hub75_tube_horizontal_edge_carrier_profile_2d(
    clip_x,
    clamp,
    radius = 4
) {
    width = hub75_tube_horizontal_edge_carrier_width(clamp);
    z_min = hub75_tube_horizontal_edge_carrier_z_min(clamp);
    z_max = hub75_tube_horizontal_edge_carrier_z_max(clamp);
    height = z_max - z_min;

    assert(width > 2 * radius,
        "tube carrier width must exceed twice its radius");
    assert(height > 2 * radius,
        "tube carrier height must exceed twice its radius");

    translate([clip_x, (z_min + z_max) / 2])
        offset(r = radius)
            square([
                width - 2 * radius,
                height - 2 * radius
            ], center = true);
}

module _hub75_tube_horizontal_edge_carriers(
    coupler,
    clamp
) {
    translate([0, coupler.base_thickness, 0])
        rotate([90, 0, 0])
            linear_extrude(height = coupler.base_thickness)
                for (clip_x = hub75_tube_horizontal_edge_clamp_positions(coupler))
                    _hub75_tube_horizontal_edge_carrier_profile_2d(
                        clip_x,
                        clamp
                    );
}

module _hub75_tube_horizontal_edge_dovetail_cutters(
    coupler,
    clamp
) {
    for (clip_x = hub75_tube_horizontal_edge_clamp_positions(coupler))
        hub75_tube_mount_dovetail_female_cutter(
            dovetail = clamp.dovetail,
            slide = clamp.dovetail_slide,
            center_x = clip_x,
            center_z = clamp.dovetail_center_z
        );
}
