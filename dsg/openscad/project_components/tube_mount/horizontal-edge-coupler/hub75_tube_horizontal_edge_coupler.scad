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
use <../../../ext/lib.scad.forge/openscad/resolution.scad>
use <../../../ext/lib.scad.forge/openscad/transform.scad>
use <../../../ext/lib.scad.forge/openscad/cutter.scad>
use <../tube-clamp/hub75_tube_clamp.scad>
use <../tube_mount_interface.scad>

_HUB75_TUBE_EDGE_EPS_MM = 0.05;

function hub75_tube_horizontal_edge_carrier_side_wall_mm() = 2;
function hub75_tube_horizontal_edge_carrier_bottom_margin_mm() = 2;
function hub75_tube_horizontal_edge_carrier_top_lip_mm() = 2;

function hub75_tube_horizontal_edge_carrier_front_y_mm() =
    hub75_tube_mount_dovetail_mouth_y_mm();

function hub75_tube_horizontal_edge_carrier_depth_mm(coupler) =
    coupler.base_thickness
    - hub75_tube_horizontal_edge_carrier_front_y_mm();

function hub75_tube_horizontal_edge_carrier_width_mm(
    clamp = hub75_tube_clamp_create()
) =
    hub75_tube_mount_dovetail_female_root_width_mm(
        clamp.dovetail
    )
    + 2 * hub75_tube_horizontal_edge_carrier_side_wall_mm();

function hub75_tube_horizontal_edge_carrier_z_min_mm(clamp) =
    clamp.dovetail_center_z_mm
    - hub75_tube_mount_dovetail_female_slide_len_mm(
        clamp.dovetail,
        clamp.dovetail_slide_len_mm
    ) / 2
    - hub75_tube_horizontal_edge_carrier_bottom_margin_mm();

function hub75_tube_horizontal_edge_carrier_z_max_mm(clamp) =
    clamp.dovetail_center_z_mm
    + hub75_tube_mount_dovetail_female_slide_len_mm(
        clamp.dovetail,
        clamp.dovetail_slide_len_mm
    ) / 2
    + hub75_tube_horizontal_edge_carrier_top_lip_mm();

function hub75_tube_horizontal_edge_carrier_edge_margin_mm() = 4;

function hub75_tube_horizontal_edge_clamp_offset_mm(
    coupler,
    carrier_width_mm = hub75_tube_horizontal_edge_carrier_width_mm(),
    edge_margin_mm = hub75_tube_horizontal_edge_carrier_edge_margin_mm()
) =
    max(
        carrier_width_mm / 2,
        coupler.profile_size / 2
            - carrier_width_mm / 2
            - edge_margin_mm
    );

function hub75_tube_horizontal_edge_clamp_positions_mm(coupler) =
    let(_offset_mm = hub75_tube_horizontal_edge_clamp_offset_mm(coupler))
    [-_offset_mm, _offset_mm];

function hub75_tube_horizontal_edge_keepout_radial_clearance_mm(coupler) =
    coupler.fit_clearance;


// ----------------------------------------------------------------------
// Public geometry
// ----------------------------------------------------------------------

module hub75_tube_horizontal_edge_coupler_build(
    obj,
    resolution = FG_RES_HIGH()
) {
    fg_res_apply(resolution) {
    coupler = obj;
    clamp =
        hub75_tube_clamp_create(
            dovetail =
                hub75_tube_mount_dovetail_create(
                    host_depth_mm = coupler.base_thickness
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

}


// ----------------------------------------------------------------------
// Private implementation
// ----------------------------------------------------------------------

module _hub75_tube_horizontal_edge_keepout_cutter(
    coupler,
    clamp
) {
    keepout_d =
        hub75_tube_clamp_functional_diameter_mm(clamp)
        + 2 * hub75_tube_horizontal_edge_keepout_radial_clearance_mm(coupler);
    cutter_length = coupler.profile_size;

    fg_cut_cylinder(
        diameter_mm = keepout_d,
        height_mm = cutter_length,
        pos_mm = [
            -cutter_length / 2,
            hub75_tube_clamp_tube_center_y_mm(clamp),
            hub75_tube_clamp_tube_center_z_mm(clamp)
        ],
        rot_deg = [0, 90, 0],
        overlap = [FG_BOTTOM(), FG_TOP()],
        overlap_mm = _HUB75_TUBE_EDGE_EPS_MM
    );
}

module _hub75_tube_horizontal_edge_carrier_profile_2d(
    clip_x,
    clamp,
    radius = 4
) {
    width = hub75_tube_horizontal_edge_carrier_width_mm(clamp);
    z_min = hub75_tube_horizontal_edge_carrier_z_min_mm(clamp);
    z_max = hub75_tube_horizontal_edge_carrier_z_max_mm(clamp);
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
            linear_extrude(
                height =
                    hub75_tube_horizontal_edge_carrier_depth_mm(
                        coupler
                    )
            )
                for (clip_x = hub75_tube_horizontal_edge_clamp_positions_mm(coupler))
                    _hub75_tube_horizontal_edge_carrier_profile_2d(
                        clip_x,
                        clamp
                    );
}

module _hub75_tube_horizontal_edge_dovetail_cutters(
    coupler,
    clamp
) {
    for (clip_x = hub75_tube_horizontal_edge_clamp_positions_mm(coupler))
        hub75_tube_mount_dovetail_female_cutter(
            clamp.dovetail,
            slide_len_mm = clamp.dovetail_slide_len_mm,
            center_x_mm = clip_x,
            center_z_mm = clamp.dovetail_center_z_mm
        );
}
