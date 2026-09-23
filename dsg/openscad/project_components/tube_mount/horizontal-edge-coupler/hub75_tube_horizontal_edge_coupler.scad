// File: hub75_tube_horizontal_edge_coupler.scad
//   Tube-aware horizontal-edge coupler built around the accepted HUB75 core
//   horizontal-edge component.
//
// - Design: design/design.md
// - Design review: hub75_tube_horizontal_edge_coupler_render.scad
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
use <../../../ext/lib.scad.forge/openscad/csg.scad>
use <../tube-clamp/hub75_tube_clamp.scad>
use <../tube_mount_interface.scad>

_HUB75_TUBE_EDGE_EPS_MM = 0.05;

function hub75_tube_horizontal_edge_carrier_side_wall_mm() = 2;
function hub75_tube_horizontal_edge_carrier_bottom_margin_mm() = 2;
function hub75_tube_horizontal_edge_carrier_top_lip_mm() = 2;

function hub75_tube_horizontal_edge_carrier_front_y_mm() =
    hub75_tube_mount_dovetail_mouth_y_mm();

function hub75_tube_horizontal_edge_carrier_depth_mm(coupler_obj) =
    coupler_obj.base_thickness
    - hub75_tube_horizontal_edge_carrier_front_y_mm();

function hub75_tube_horizontal_edge_carrier_width_mm(
    clamp_obj = hub75_tube_clamp_create()
) =
    hub75_tube_mount_dovetail_female_root_width_mm(
        clamp_obj.dovetail
    )
    + 2 * hub75_tube_horizontal_edge_carrier_side_wall_mm();

function hub75_tube_horizontal_edge_carrier_z_min_mm(clamp_obj) =
    clamp_obj.dovetail_center_z_mm
    - hub75_tube_mount_dovetail_female_slide_len_mm(
        clamp_obj.dovetail,
        clamp_obj.dovetail_slide_len_mm
    ) / 2
    - hub75_tube_horizontal_edge_carrier_bottom_margin_mm();

function hub75_tube_horizontal_edge_carrier_z_max_mm(clamp_obj) =
    clamp_obj.dovetail_center_z_mm
    + hub75_tube_mount_dovetail_female_slide_len_mm(
        clamp_obj.dovetail,
        clamp_obj.dovetail_slide_len_mm
    ) / 2
    + hub75_tube_horizontal_edge_carrier_top_lip_mm();

function hub75_tube_horizontal_edge_carrier_edge_margin_mm() = 4;

function hub75_tube_horizontal_edge_clamp_offset_mm(
    coupler_obj,
    carrier_width_mm = hub75_tube_horizontal_edge_carrier_width_mm(),
    edge_margin_mm = hub75_tube_horizontal_edge_carrier_edge_margin_mm()
) =
    max(
        carrier_width_mm / 2,
        coupler_obj.profile_size / 2
            - carrier_width_mm / 2
            - edge_margin_mm
    );

function hub75_tube_horizontal_edge_clamp_positions_mm(coupler_obj) =
    let(_offset_mm = hub75_tube_horizontal_edge_clamp_offset_mm(coupler_obj))
    [-_offset_mm, _offset_mm];

function hub75_tube_horizontal_edge_keepout_radial_clearance_mm(coupler_obj) =
    coupler_obj.fit_clearance;


// ----------------------------------------------------------------------
// Public geometry
// ----------------------------------------------------------------------

module hub75_tube_horizontal_edge_coupler_build(
    coupler_obj,
    resolution = FG_RES_HIGH()
) {
    fg_res_apply(resolution) {
        clamp_obj =
            hub75_tube_clamp_create(
                dovetail_obj =
                    hub75_tube_mount_dovetail_create(
                        host_depth_mm = coupler_obj.base_thickness
                    )
            );

        fg_diff() {
            fg_body() {
                hub75_horizontal_edge_coupler_build(coupler_obj);
                _hub75_tube_horizontal_edge_carriers(
                    coupler_obj,
                    clamp_obj
                );
            }

            fg_remove() {
                _hub75_tube_horizontal_edge_keepout_cutter(
                    coupler_obj,
                    clamp_obj
                );
                _hub75_tube_horizontal_edge_dovetail_cutters(
                    coupler_obj,
                    clamp_obj
                );
            }
        }
    }
}


// ----------------------------------------------------------------------
// Private implementation
// ----------------------------------------------------------------------

module _hub75_tube_horizontal_edge_keepout_cutter(
    coupler_obj,
    clamp_obj
) {
    keepout_d =
        hub75_tube_clamp_functional_diameter_mm(clamp_obj)
        + 2 * hub75_tube_horizontal_edge_keepout_radial_clearance_mm(coupler_obj);
    cutter_length = coupler_obj.profile_size;

    fg_cut_cylinder(
        diameter_mm = keepout_d,
        height_mm = cutter_length,
        pos_mm = [
            -cutter_length / 2,
            hub75_tube_clamp_tube_center_y_mm(clamp_obj),
            hub75_tube_clamp_tube_center_z_mm(clamp_obj)
        ],
        rot_deg = [0, 90, 0],
        overlap = [FG_BOTTOM(), FG_TOP()],
        overlap_mm = _HUB75_TUBE_EDGE_EPS_MM
    );
}

module _hub75_tube_horizontal_edge_carrier_profile_2d(
    clip_x,
    clamp_obj,
    radius = 4
) {
    width = hub75_tube_horizontal_edge_carrier_width_mm(clamp_obj);
    z_min = hub75_tube_horizontal_edge_carrier_z_min_mm(clamp_obj);
    z_max = hub75_tube_horizontal_edge_carrier_z_max_mm(clamp_obj);
    height = z_max - z_min;

    assert(width > 2 * radius,
        "tube carrier width must exceed twice its radius");
    assert(height > 2 * radius,
        "tube carrier height must exceed twice its radius");

    fg_xf_xzmove([clip_x, (z_min + z_max) / 2])
        offset(r = radius)
            square([
                width - 2 * radius,
                height - 2 * radius
            ], center = true);
}

module _hub75_tube_horizontal_edge_carriers(
    coupler_obj,
    clamp_obj
) {
    fg_xf_frame(
        pos_mm = [0, coupler_obj.base_thickness, 0],
        x_axis = [1, 0, 0],
        z_axis = [0, -1, 0]
    )
        linear_extrude(
            height =
                hub75_tube_horizontal_edge_carrier_depth_mm(
                    coupler_obj
                )
        )
                for (clip_x = hub75_tube_horizontal_edge_clamp_positions_mm(coupler_obj))
                    _hub75_tube_horizontal_edge_carrier_profile_2d(
                        clip_x,
                        clamp_obj
                    );
}

module _hub75_tube_horizontal_edge_dovetail_cutters(
    coupler_obj,
    clamp_obj
) {
    for (clip_x = hub75_tube_horizontal_edge_clamp_positions_mm(coupler_obj))
        hub75_tube_mount_dovetail_female_cutter(
            clamp_obj.dovetail,
            slide_len_mm = clamp_obj.dovetail_slide_len_mm,
            center_x_mm = clip_x,
            center_z_mm = clamp_obj.dovetail_center_z_mm
        );
}
