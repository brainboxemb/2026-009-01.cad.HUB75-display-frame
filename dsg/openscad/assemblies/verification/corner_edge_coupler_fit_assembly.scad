// File: corner_edge_coupler_fit_assembly.scad
//   Local one-panel verification fixture for the left/right corner couplers.

use <../../ext/lib.scad.hub75/openscad/p5-64x32-panel/hub75_p5_64x32_panel.scad>
use <../../ext/lib.scad.util/openscad/inspection.scad>
use <../../ext/lib.scad.forge/openscad/transform.scad>
use <../../components/hub75/corner-edge-coupler/hub75_corner_edge_coupler.scad>
use <../helpers/verification_datum_pin.scad>

function _hub75_corner_edge_fit_corner_x(panel_obj, side) =
    (side == "left" ? -1 : 1)
    * hub75_p5_64x32_panel_nominal_width(panel_obj) / 2;

function _hub75_corner_edge_fit_corner_z(panel_obj) =
    hub75_p5_64x32_panel_nominal_height(panel_obj) / 2;

module _hub75_corner_edge_fit_panel(panel_obj, structure_only = false) {
    hub75_p5_64x32_panel_render(
        panel_obj,
        view =
            hub75_p5_64x32_panel_view_id(
                structure_only ? "structure" : "final"
            ),
        color_scheme = "light_gray"
    );
}

module _hub75_corner_edge_fit_crop_volume(
    panel_obj,
    coupler_obj,
    side,
    crop_inward = 105,
    crop_outward = 10,
    y_max_override = undef
) {
    corner_x =
        _hub75_corner_edge_fit_corner_x(panel_obj, side);
    corner_z =
        _hub75_corner_edge_fit_corner_z(panel_obj);
    mounting_y =
        hub75_p5_64x32_panel_mounting_plane_y(panel_obj);
    y_max =
        is_undef(y_max_override)
            ? mounting_y + coupler_obj.base_thickness + 2
            : y_max_override;
    x_min =
        side == "left"
            ? corner_x - crop_outward
            : corner_x - crop_inward;
    x_max =
        side == "left"
            ? corner_x + crop_inward
            : corner_x + crop_outward;

    translate([
        x_min,
        -0.5,
        corner_z - crop_inward
    ])
        cube([
            x_max - x_min,
            y_max + 1,
            crop_inward + crop_outward
        ]);
}

// Module: hub75_corner_edge_coupler_fit_detail()
module hub75_corner_edge_coupler_fit_detail(
    side = "left",
    panel_obj = hub75_p5_64x32_panel_create(),
    coupler_obj = undef,
    crop_inward = 105,
    crop_outward = 10
) {
    active_coupler_obj =
        is_undef(coupler_obj)
            ? hub75_corner_edge_coupler_create(
                side = side,
                panel_obj = panel_obj
            )
            : coupler_obj;
    corner_x =
        _hub75_corner_edge_fit_corner_x(panel_obj, side);
    corner_z =
        _hub75_corner_edge_fit_corner_z(panel_obj);
    mounting_y =
        hub75_p5_64x32_panel_mounting_plane_y(panel_obj);

    intersection() {
        _hub75_corner_edge_fit_panel(panel_obj);
        _hub75_corner_edge_fit_crop_volume(
            panel_obj,
            active_coupler_obj,
            side,
            crop_inward,
            crop_outward
        );
    }

    color([0.72, 0.05, 0.04, 1])
        fg_xf_move([
            corner_x,
            mounting_y,
            corner_z
        ])
            hub75_corner_edge_coupler_build(active_coupler_obj);

    hub75_verification_datum_pin(
        x = corner_x,
        z = corner_z,
        y_min = -4,
        y_max =
            mounting_y
            + active_coupler_obj.base_thickness
            + 8
    );
}

// Module: hub75_corner_edge_coupler_rear_fit_section()
module hub75_corner_edge_coupler_rear_fit_section(
    side = "left",
    panel_obj = hub75_p5_64x32_panel_create(),
    coupler_obj = undef,
    depth = 5.0,
    slice_thickness = 0.10,
    crop_inward = 105,
    crop_outward = undef
) {
    active_coupler_obj =
        is_undef(coupler_obj)
            ? hub75_corner_edge_coupler_create(side = side, panel_obj = panel_obj)
            : coupler_obj;
    corner_x = _hub75_corner_edge_fit_corner_x(panel_obj, side);
    corner_z = _hub75_corner_edge_fit_corner_z(panel_obj);
    mounting_y = hub75_p5_64x32_panel_mounting_plane_y(panel_obj);
    section_y = mounting_y - depth;
    outside_crop = is_undef(crop_outward)
        ? active_coupler_obj.outside_projection + 2
        : crop_outward;

    assert(depth > 0, "rear fit section depth must be > 0");
    assert(slice_thickness > 0, "rear fit slice thickness must be > 0");
    assert(
        section_y - slice_thickness / 2 > 0,
        "rear fit slice must remain behind the HUB75 front face"
    );

    color([0.68, 0.68, 0.68, 1])
        intersection() {
            util_section_inspect(
                axis = "Y",
                position = section_y - slice_thickness / 2,
                depth = slice_thickness,
                direction = "Positive"
            )
                _hub75_corner_edge_fit_panel(panel_obj, structure_only = true);
            _hub75_corner_edge_fit_crop_volume(
                panel_obj,
                active_coupler_obj,
                side,
                crop_inward,
                outside_crop
            );
        }

    color([0.72, 0.05, 0.04, 1])
        intersection() {
            util_section_inspect(
                axis = "Y",
                position = section_y - slice_thickness / 2,
                depth = slice_thickness,
                direction = "Positive"
            )
                fg_xf_move([corner_x, mounting_y, corner_z])
                    hub75_corner_edge_coupler_build(active_coupler_obj);
            _hub75_corner_edge_fit_crop_volume(
                panel_obj,
                active_coupler_obj,
                side,
                crop_inward,
                outside_crop
            );
        }

    hub75_verification_datum_pin(
        x = corner_x,
        z = corner_z,
        y_min = section_y - 2,
        y_max = section_y + 2
    );
}

// Module: hub75_corner_edge_coupler_yz_top_edge_section()
module hub75_corner_edge_coupler_yz_top_edge_section(
    side = "left",
    panel_obj = hub75_p5_64x32_panel_create(),
    coupler_obj = undef,
    slice_inward = 20,
    slice_thickness = 0.10,
    crop_inward = 60,
    crop_outward = 10
) {
    active_coupler_obj =
        is_undef(coupler_obj)
            ? hub75_corner_edge_coupler_create(side = side, panel_obj = panel_obj)
            : coupler_obj;
    corner_x = _hub75_corner_edge_fit_corner_x(panel_obj, side);
    corner_z = _hub75_corner_edge_fit_corner_z(panel_obj);
    mounting_y = hub75_p5_64x32_panel_mounting_plane_y(panel_obj);
    x_inward = side == "left" ? 1 : -1;
    slice_x = corner_x + x_inward * slice_inward;

    assert(slice_thickness > 0, "top-edge slice thickness must be > 0");

    color([0.68, 0.68, 0.68, 1])
        intersection() {
            util_section_inspect(
                axis = "X",
                position = slice_x - slice_thickness / 2,
                depth = slice_thickness,
                direction = "Positive"
            )
                _hub75_corner_edge_fit_panel(panel_obj, structure_only = true);
            _hub75_corner_edge_fit_crop_volume(
                panel_obj,
                active_coupler_obj,
                side,
                crop_inward,
                crop_outward
            );
        }

    color([0.72, 0.05, 0.04, 1])
        intersection() {
            util_section_inspect(
                axis = "X",
                position = slice_x - slice_thickness / 2,
                depth = slice_thickness,
                direction = "Positive"
            )
                fg_xf_move([corner_x, mounting_y, corner_z])
                    hub75_corner_edge_coupler_build(active_coupler_obj);
            _hub75_corner_edge_fit_crop_volume(
                panel_obj,
                active_coupler_obj,
                side,
                crop_inward,
                crop_outward
            );
        }
}

// Module: hub75_corner_edge_coupler_xy_side_edge_section()
module hub75_corner_edge_coupler_xy_side_edge_section(
    side = "left",
    panel_obj = hub75_p5_64x32_panel_create(),
    coupler_obj = undef,
    slice_inward = 20,
    slice_thickness = 0.10,
    crop_inward = 60,
    crop_outward = 10
) {
    active_coupler_obj =
        is_undef(coupler_obj)
            ? hub75_corner_edge_coupler_create(side = side, panel_obj = panel_obj)
            : coupler_obj;
    corner_x = _hub75_corner_edge_fit_corner_x(panel_obj, side);
    corner_z = _hub75_corner_edge_fit_corner_z(panel_obj);
    mounting_y = hub75_p5_64x32_panel_mounting_plane_y(panel_obj);
    slice_z = corner_z - slice_inward;

    assert(slice_thickness > 0, "side-edge slice thickness must be > 0");

    color([0.68, 0.68, 0.68, 1])
        intersection() {
            util_section_inspect(
                axis = "Z",
                position = slice_z - slice_thickness / 2,
                depth = slice_thickness,
                direction = "Positive"
            )
                _hub75_corner_edge_fit_panel(panel_obj, structure_only = true);
            _hub75_corner_edge_fit_crop_volume(
                panel_obj,
                active_coupler_obj,
                side,
                crop_inward,
                crop_outward
            );
        }

    color([0.72, 0.05, 0.04, 1])
        intersection() {
            util_section_inspect(
                axis = "Z",
                position = slice_z - slice_thickness / 2,
                depth = slice_thickness,
                direction = "Positive"
            )
                fg_xf_move([corner_x, mounting_y, corner_z])
                    hub75_corner_edge_coupler_build(active_coupler_obj);
            _hub75_corner_edge_fit_crop_volume(
                panel_obj,
                active_coupler_obj,
                side,
                crop_inward,
                crop_outward
            );
        }
}
