// File: hub75_tube_corner_edge_coupler.scad
//   Tube-aware corner-edge coupler using the same top-entry clamp interface as
//   the horizontal-edge tube coupler.
//
// The accepted corner-edge exterior remains unchanged. Tube clearance and the
// female dovetail are both cut directly from the existing corner geometry.

use <../../../components/hub75/corner-edge-coupler/hub75_corner_edge_coupler.scad>
use <../tube-clamp/hub75_tube_clamp.scad>
use <../tube_mount_interface.scad>

_HUB75_TUBE_CORNER_EPS = 0.05;

function hub75_tube_corner_edge_dovetail_side_material() = 2;

function hub75_tube_corner_edge_dovetail_envelope_width(
    clamp = hub75_tube_clamp_create()
) =
    hub75_tube_mount_dovetail_female_root_width(
        clamp.dovetail
    )
    + 2 * hub75_tube_corner_edge_dovetail_side_material();

function hub75_tube_corner_edge_dovetail_edge_margin() = 4;

function hub75_tube_corner_edge_clamp_offset(
    coupler,
    interface_width = hub75_tube_corner_edge_dovetail_envelope_width(),
    edge_margin = hub75_tube_corner_edge_dovetail_edge_margin()
) =
    max(
        interface_width / 2,
        coupler.profile_size / 2
            - interface_width / 2
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
        hub75_corner_edge_coupler_build(coupler);

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
