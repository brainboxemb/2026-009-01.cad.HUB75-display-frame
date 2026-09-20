// File: hub75_tube_horizontal_edge_coupler.scad
//   Tube-aware horizontal-edge coupler built around the accepted HUB75 core
//   horizontal-edge component.
//
// Construction order:
//   1. start from the accepted core coupler;
//   2. remove one continuous aluminium-tube keep-out;
//   3. derive two interface positions from the existing edge structure;
//   4. cut vertical, top-entry female dovetails directly into that structure.
//
// No positive tube-mount body is added here: the accepted edge-coupler exterior
// remains the exterior of the tube-aware variant.

use <../../../components/hub75/horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>
use <../tube-clamp/hub75_tube_clamp.scad>
use <../tube_mount_interface.scad>

_HUB75_TUBE_EDGE_EPS = 0.05;

function hub75_tube_horizontal_edge_dovetail_side_material() = 2;

function hub75_tube_horizontal_edge_dovetail_envelope_width(
    clamp = hub75_tube_clamp_create()
) =
    hub75_tube_mount_dovetail_female_root_width(
        clamp.dovetail
    )
    + 2 * hub75_tube_horizontal_edge_dovetail_side_material();

function hub75_tube_horizontal_edge_dovetail_edge_margin() = 4;

function hub75_tube_horizontal_edge_clamp_offset(
    coupler,
    interface_width = hub75_tube_horizontal_edge_dovetail_envelope_width(),
    edge_margin = hub75_tube_horizontal_edge_dovetail_edge_margin()
) =
    max(
        interface_width / 2,
        coupler.profile_size / 2
            - interface_width / 2
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
        hub75_horizontal_edge_coupler_build(coupler);

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
