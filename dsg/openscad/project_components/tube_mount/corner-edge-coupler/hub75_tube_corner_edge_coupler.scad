// File: hub75_tube_corner_edge_coupler.scad
//   Tube-aware corner-edge coupler using the same top-entry clamp interface as
//   the horizontal-edge tube coupler.

use <../../../components/hub75/corner-edge-coupler/hub75_corner_edge_coupler.scad>
use <../tube-clamp/hub75_tube_clamp.scad>
use <../tube_mount_interface.scad>

_HUB75_TUBE_CORNER_EPS = 0.05;

function hub75_tube_corner_edge_carrier_side_wall() = 2;
function hub75_tube_corner_edge_carrier_bottom_margin() = 2;
function hub75_tube_corner_edge_carrier_top_lip() = 2;

function hub75_tube_corner_edge_carrier_front_y() =
    hub75_tube_mount_dovetail_mouth_y();

function hub75_tube_corner_edge_carrier_depth(coupler) =
    coupler.base_thickness
    - hub75_tube_corner_edge_carrier_front_y();

function hub75_tube_corner_edge_carrier_width(
    clamp = hub75_tube_clamp_create()
) =
    hub75_tube_mount_dovetail_female_root_width(
        clamp.dovetail
    )
    + 2 * hub75_tube_corner_edge_carrier_side_wall();

function hub75_tube_corner_edge_carrier_z_min(clamp) =
    clamp.dovetail_center_z
    - hub75_tube_mount_dovetail_female_slide(
        clamp.dovetail,
        clamp.dovetail_slide
    ) / 2
    - hub75_tube_corner_edge_carrier_bottom_margin();

function hub75_tube_corner_edge_carrier_z_max(clamp) =
    clamp.dovetail_center_z
    + hub75_tube_mount_dovetail_female_slide(
        clamp.dovetail,
        clamp.dovetail_slide
    ) / 2
    + hub75_tube_corner_edge_carrier_top_lip();

function hub75_tube_corner_edge_carrier_edge_margin() = 4;

function hub75_tube_corner_edge_clamp_offset(
    coupler,
    carrier_width = hub75_tube_corner_edge_carrier_width(),
    edge_margin = hub75_tube_corner_edge_carrier_edge_margin()
) =
    max(
        carrier_width / 2,
        coupler.profile_size / 2
            - carrier_width / 2
            - edge_margin
    );

function hub75_tube_corner_edge_clamp_x(coupler) =
    coupler.x_inward
    * hub75_tube_corner_edge_clamp_offset(coupler);

function hub75_tube_corner_edge_keepout_radial_clearance(coupler) =
    coupler.fit_clearance;


// ----------------------------------------------------------------------
// Public geometry
// ----------------------------------------------------------------------

module hub75_tube_corner_edge_coupler_build(
    coupler
) {
    clamp =
        hub75_tube_clamp_create(
            dovetail =
                hub75_tube_mount_dovetail_create(
                    host_depth = coupler.base_thickness
                )
        );
    clip_x = hub75_tube_corner_edge_clamp_x(coupler);

    difference() {
        union() {
            hub75_corner_edge_coupler_build(coupler);
            _hub75_tube_corner_edge_carrier(
                coupler,
                clamp
            );
        }

        _hub75_tube_corner_edge_keepout_cutter(
            coupler,
            clamp
        );

        hub75_tube_mount_dovetail_female_cutter(
            dovetail = clamp.dovetail,
            slide = clamp.dovetail_slide,
            center_x = clip_x,
            center_z = clamp.dovetail_center_z
        );
    }
}


// ----------------------------------------------------------------------
// Private implementation
// ----------------------------------------------------------------------

module _hub75_tube_corner_edge_keepout_cutter(
    coupler,
    clamp
) {
    keepout_d =
        hub75_tube_clamp_functional_diameter(clamp)
        + 2 * hub75_tube_corner_edge_keepout_radial_clearance(coupler);
    cutter_length =
        coupler.profile_size
        + 2 * coupler.outside_projection
        + 2 * _HUB75_TUBE_CORNER_EPS;

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

module _hub75_tube_corner_edge_carrier_profile_2d(
    clip_x,
    clamp,
    radius = 4
) {
    width = hub75_tube_corner_edge_carrier_width(clamp);
    z_min = hub75_tube_corner_edge_carrier_z_min(clamp);
    z_max = hub75_tube_corner_edge_carrier_z_max(clamp);
    height = z_max - z_min;

    assert(width > 2 * radius,
        "corner tube carrier width must exceed twice its radius");
    assert(height > 2 * radius,
        "corner tube carrier height must exceed twice its radius");

    translate([clip_x, (z_min + z_max) / 2])
        offset(r = radius)
            square([
                width - 2 * radius,
                height - 2 * radius
            ], center = true);
}

module _hub75_tube_corner_edge_carrier(
    coupler,
    clamp
) {
    clip_x = hub75_tube_corner_edge_clamp_x(coupler);

    translate([0, coupler.base_thickness, 0])
        rotate([90, 0, 0])
            linear_extrude(
                height =
                    hub75_tube_corner_edge_carrier_depth(
                        coupler
                    )
            )
                _hub75_tube_corner_edge_carrier_profile_2d(
                    clip_x,
                    clamp
                );
}
