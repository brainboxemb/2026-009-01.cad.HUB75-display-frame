// File: corner_edge_coupler_profile_sections.scad
//   Canonical full-profile sections for the corner-edge coupler.
//
// These views deliberately retain the complete panel profile in the slice,
// matching the established horizontal-edge verification style. Left/right
// corner geometry is mirrored for these two interfaces, so the default left
// variant is the canonical published evidence while the module remains
// side-selectable for local inspection.

use <../../ext/lib.scad.hub75/openscad/p5-64x32-panel/hub75_p5_64x32_panel.scad>
use <../../project_components/corner-edge-coupler/hub75_corner_edge_coupler.scad>


function _hub75_corner_profile_corner_x(panel, side) =
    (side == "left" ? -1 : 1)
    * hub75_p5_64x32_panel_nominal_width(panel) / 2;

function _hub75_corner_profile_corner_z(panel) =
    hub75_p5_64x32_panel_nominal_height(panel) / 2;


module _hub75_corner_profile_panel(panel) {
    hub75_p5_64x32_panel_render(
        panel,
        view = hub75_p5_64x32_panel_view_id("final"),
        color_scheme = "light_gray"
    );
}


// Module: hub75_corner_edge_coupler_horizontal_profile_section()
// Description:
//   Readable YZ profile through the top/horizontal arm. The complete panel
//   section is retained so the PCB/body taper and the red fitted frame wall can
//   be judged together, rather than showing only the rear structural rail.
module hub75_corner_edge_coupler_horizontal_profile_section(
    side = "left",
    panel = hub75_p5_64x32_panel_create(),
    coupler = undef,
    slice_inward = 20,
    slice_thickness = 0.50,
    crop_inward = 95,
    crop_outward = 10
) {
    active_coupler =
        is_undef(coupler)
            ? hub75_corner_edge_coupler_create(side = side, panel = panel)
            : coupler;
    corner_x = _hub75_corner_profile_corner_x(panel, side);
    corner_z = _hub75_corner_profile_corner_z(panel);
    mounting_y = hub75_p5_64x32_panel_mounting_plane_y(panel);
    x_inward = side == "left" ? 1 : -1;
    slice_x = corner_x + x_inward * slice_inward;
    y_max = mounting_y + active_coupler.base_thickness + 2;

    assert(slice_thickness > 0, "horizontal profile slice thickness must be > 0");

    module _slice_volume() {
        translate([
            slice_x - slice_thickness / 2,
            -0.5,
            corner_z - crop_inward
        ])
            cube([
                slice_thickness,
                y_max + 1,
                crop_inward + crop_outward
            ]);
    }

    intersection() {
        _hub75_corner_profile_panel(panel);
        _slice_volume();
    }

    color([0.72, 0.05, 0.04, 1])
        intersection() {
            translate([corner_x, mounting_y, corner_z])
                hub75_corner_edge_coupler_build(active_coupler);
            _slice_volume();
        }
}


// Module: hub75_corner_edge_coupler_vertical_profile_section()
// Description:
//   Readable XY profile through the side/vertical arm. The complete panel
//   section and the red fitted frame wall are retained in one plane.
module hub75_corner_edge_coupler_vertical_profile_section(
    side = "left",
    panel = hub75_p5_64x32_panel_create(),
    coupler = undef,
    slice_inward = 20,
    slice_thickness = 0.50,
    crop_inward = 95,
    crop_outward = 10
) {
    active_coupler =
        is_undef(coupler)
            ? hub75_corner_edge_coupler_create(side = side, panel = panel)
            : coupler;
    corner_x = _hub75_corner_profile_corner_x(panel, side);
    corner_z = _hub75_corner_profile_corner_z(panel);
    mounting_y = hub75_p5_64x32_panel_mounting_plane_y(panel);
    slice_z = corner_z - slice_inward;
    y_max = mounting_y + active_coupler.base_thickness + 2;
    x_min = side == "left" ? corner_x - crop_outward : corner_x - crop_inward;
    x_max = side == "left" ? corner_x + crop_inward : corner_x + crop_outward;

    assert(slice_thickness > 0, "vertical profile slice thickness must be > 0");

    module _slice_volume() {
        translate([
            x_min,
            -0.5,
            slice_z - slice_thickness / 2
        ])
            cube([
                x_max - x_min,
                y_max + 1,
                slice_thickness
            ]);
    }

    intersection() {
        _hub75_corner_profile_panel(panel);
        _slice_volume();
    }

    color([0.72, 0.05, 0.04, 1])
        intersection() {
            translate([corner_x, mounting_y, corner_z])
                hub75_corner_edge_coupler_build(active_coupler);
            _slice_volume();
        }
}
