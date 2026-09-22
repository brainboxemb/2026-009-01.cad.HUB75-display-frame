// File: corner_edge_coupler_profile_sections.scad
//   Canonical full-profile sections for the corner-edge coupler.

use <../../ext/lib.scad.hub75/openscad/p5-64x32-panel/hub75_p5_64x32_panel.scad>
use <../../ext/lib.scad.util/openscad/inspection.scad>
use <../../components/hub75/corner-edge-coupler/hub75_corner_edge_coupler.scad>

function _hub75_corner_profile_corner_x(panel_obj, side) =
    (side == "left" ? -1 : 1)
    * hub75_p5_64x32_panel_nominal_width(panel_obj) / 2;

function _hub75_corner_profile_corner_z(panel_obj) =
    hub75_p5_64x32_panel_nominal_height(panel_obj) / 2;

module _hub75_corner_profile_panel(panel_obj) {
    hub75_p5_64x32_panel_render(
        panel_obj,
        view = hub75_p5_64x32_panel_view_id("final"),
        color_scheme = "light_gray"
    );
}

// Module: hub75_corner_edge_coupler_horizontal_profile_section()
module hub75_corner_edge_coupler_horizontal_profile_section(
    side = "left",
    panel_obj = hub75_p5_64x32_panel_create(),
    coupler_obj = undef,
    slice_inward = 20,
    slice_thickness = 0.50,
    crop_inward = 95,
    crop_outward = 10
) {
    active_coupler_obj =
        is_undef(coupler_obj)
            ? hub75_corner_edge_coupler_create(side = side, panel_obj = panel_obj)
            : coupler_obj;
    corner_x = _hub75_corner_profile_corner_x(panel_obj, side);
    corner_z = _hub75_corner_profile_corner_z(panel_obj);
    mounting_y = hub75_p5_64x32_panel_mounting_plane_y(panel_obj);
    x_inward = side == "left" ? 1 : -1;
    slice_x = corner_x + x_inward * slice_inward;
    y_max = mounting_y + active_coupler_obj.base_thickness + 2;

    assert(slice_thickness > 0, "horizontal profile slice thickness must be > 0");

    module _crop_volume() {
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

    intersection() {
        util_section_inspect(
            axis = "X",
            position = slice_x - slice_thickness / 2,
            depth = slice_thickness,
            direction = "Positive"
        )
            _hub75_corner_profile_panel(panel_obj);
        _crop_volume();
    }

    color([0.72, 0.05, 0.04, 1])
        intersection() {
            util_section_inspect(
                axis = "X",
                position = slice_x - slice_thickness / 2,
                depth = slice_thickness,
                direction = "Positive"
            )
                translate([corner_x, mounting_y, corner_z])
                    hub75_corner_edge_coupler_build(active_coupler_obj);
            _crop_volume();
        }
}

// Module: hub75_corner_edge_coupler_vertical_profile_section()
module hub75_corner_edge_coupler_vertical_profile_section(
    side = "left",
    panel_obj = hub75_p5_64x32_panel_create(),
    coupler_obj = undef,
    slice_inward = 20,
    slice_thickness = 0.50,
    crop_inward = 95,
    crop_outward = 10
) {
    active_coupler_obj =
        is_undef(coupler_obj)
            ? hub75_corner_edge_coupler_create(side = side, panel_obj = panel_obj)
            : coupler_obj;
    corner_x = _hub75_corner_profile_corner_x(panel_obj, side);
    corner_z = _hub75_corner_profile_corner_z(panel_obj);
    mounting_y = hub75_p5_64x32_panel_mounting_plane_y(panel_obj);
    slice_z = corner_z - slice_inward;
    y_max = mounting_y + active_coupler_obj.base_thickness + 2;
    x_min = side == "left" ? corner_x - crop_outward : corner_x - crop_inward;
    x_max = side == "left" ? corner_x + crop_inward : corner_x + crop_outward;

    assert(slice_thickness > 0, "vertical profile slice thickness must be > 0");

    module _crop_volume() {
        translate([
            x_min,
            -0.5,
            -1000
        ])
            cube([
                x_max - x_min,
                y_max + 1,
                2000
            ]);
    }

    intersection() {
        util_section_inspect(
            axis = "Z",
            position = slice_z - slice_thickness / 2,
            depth = slice_thickness,
            direction = "Positive"
        )
            _hub75_corner_profile_panel(panel_obj);
        _crop_volume();
    }

    color([0.72, 0.05, 0.04, 1])
        intersection() {
            util_section_inspect(
                axis = "Z",
                position = slice_z - slice_thickness / 2,
                depth = slice_thickness,
                direction = "Positive"
            )
                translate([corner_x, mounting_y, corner_z])
                    hub75_corner_edge_coupler_build(active_coupler_obj);
            _crop_volume();
        }
}
