// File: corner_edge_coupler_fit_assembly.scad
//   Local one-panel verification fixture for the left/right corner couplers.
//
// The fixture keeps only one top panel corner. Bottom-right/bottom-left are
// represented by the documented 180 degree rotation of the two top variants.

use <../../ext/lib.scad.hub75/openscad/p5-64x32-panel/hub75_p5_64x32_panel.scad>
use <../../project_components/corner-edge-coupler/hub75_corner_edge_coupler.scad>
use <../helpers/verification_datum_pin.scad>


function _hub75_corner_edge_fit_corner_x(panel, side) =
    (side == "left" ? -1 : 1)
    * hub75_p5_64x32_panel_nominal_width(panel) / 2;

function _hub75_corner_edge_fit_corner_z(panel) =
    hub75_p5_64x32_panel_nominal_height(panel) / 2;


module _hub75_corner_edge_fit_panel(panel, structure_only = false) {
    hub75_p5_64x32_panel_render(
        panel,
        view =
            hub75_p5_64x32_panel_view_id(
                structure_only ? "structure" : "final"
            ),
        color_scheme = "light_gray"
    );
}


module _hub75_corner_edge_fit_crop_volume(
    panel,
    coupler,
    side,
    crop_inward = 105,
    crop_outward = 10,
    y_max_override = undef
) {
    corner_x =
        _hub75_corner_edge_fit_corner_x(panel, side);
    corner_z =
        _hub75_corner_edge_fit_corner_z(panel);
    mounting_y =
        hub75_p5_64x32_panel_mounting_plane_y(panel);
    y_max =
        is_undef(y_max_override)
            ? mounting_y + coupler.base_thickness + 2
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
// Description:
//   Angled local context showing one real panel corner and its coupler.
module hub75_corner_edge_coupler_fit_detail(
    side = "left",
    panel = hub75_p5_64x32_panel_create(),
    coupler = undef,
    crop_inward = 105,
    crop_outward = 10
) {
    active_coupler =
        is_undef(coupler)
            ? hub75_corner_edge_coupler_create(
                side = side,
                panel = panel
            )
            : coupler;

    corner_x =
        _hub75_corner_edge_fit_corner_x(panel, side);
    corner_z =
        _hub75_corner_edge_fit_corner_z(panel);
    mounting_y =
        hub75_p5_64x32_panel_mounting_plane_y(panel);

    intersection() {
        _hub75_corner_edge_fit_panel(panel);

        _hub75_corner_edge_fit_crop_volume(
            panel,
            active_coupler,
            side,
            crop_inward,
            crop_outward
        );
    }

    color([0.72, 0.05, 0.04, 1])
        translate([
            corner_x,
            mounting_y,
            corner_z
        ])
            hub75_corner_edge_coupler_build(
                active_coupler
            );

    // Exact nominal 160 x 320 mm panel-corner datum of the engraved +.
    hub75_verification_datum_pin(
        x = corner_x,
        z = corner_z,
        y_min = -4,
        y_max =
            mounting_y
            + active_coupler.base_thickness
            + 8
    );
}


// Module: hub75_corner_edge_coupler_rear_fit_section()
// Description:
//   Rear-facing 0.10 mm XZ slice through the physical corner. Grey is panel
//   structure; red is coupler material in exactly the same thin section.
module hub75_corner_edge_coupler_rear_fit_section(
    side = "left",
    panel = hub75_p5_64x32_panel_create(),
    coupler = undef,
    depth = 5.0,
    slice_thickness = 0.10,
    crop_inward = 105,
    crop_outward = 10
) {
    active_coupler =
        is_undef(coupler)
            ? hub75_corner_edge_coupler_create(side = side, panel = panel)
            : coupler;

    corner_x = _hub75_corner_edge_fit_corner_x(panel, side);
    corner_z = _hub75_corner_edge_fit_corner_z(panel);
    mounting_y = hub75_p5_64x32_panel_mounting_plane_y(panel);
    section_y = mounting_y - depth;
    x_min = side == "left" ? corner_x - crop_outward : corner_x - crop_inward;
    x_max = side == "left" ? corner_x + crop_inward : corner_x + crop_outward;

    assert(depth > 0, "rear fit section depth must be > 0");
    assert(slice_thickness > 0, "rear fit slice thickness must be > 0");
    assert(
        section_y - slice_thickness / 2 > 0,
        "rear fit slice must remain behind the HUB75 front face"
    );

    module _slice_volume() {
        translate([
            x_min,
            section_y - slice_thickness / 2,
            corner_z - crop_inward
        ])
            cube([
                x_max - x_min,
                slice_thickness,
                crop_inward + crop_outward
            ]);
    }

    color([0.68, 0.68, 0.68, 1])
        intersection() {
            _hub75_corner_edge_fit_panel(panel, structure_only = true);
            _slice_volume();
        }

    color([0.72, 0.05, 0.04, 1])
        intersection() {
            translate([corner_x, mounting_y, corner_z])
                hub75_corner_edge_coupler_build(active_coupler);
            _slice_volume();
        }

    hub75_verification_datum_pin(
        x = corner_x,
        z = corner_z,
        y_min = section_y - 2,
        y_max = section_y + 2
    );
}


// Module: hub75_corner_edge_coupler_yz_top_edge_section()
// Description:
//   0.10 mm YZ slice through the horizontal outside ridge, safely inward from
//   the corner screw/reinforcement feature.
module hub75_corner_edge_coupler_yz_top_edge_section(
    side = "left",
    panel = hub75_p5_64x32_panel_create(),
    coupler = undef,
    slice_inward = 20,
    slice_thickness = 0.10,
    crop_inward = 60,
    crop_outward = 10
) {
    active_coupler =
        is_undef(coupler)
            ? hub75_corner_edge_coupler_create(side = side, panel = panel)
            : coupler;
    corner_x = _hub75_corner_edge_fit_corner_x(panel, side);
    corner_z = _hub75_corner_edge_fit_corner_z(panel);
    mounting_y = hub75_p5_64x32_panel_mounting_plane_y(panel);
    x_inward = side == "left" ? 1 : -1;
    slice_x = corner_x + x_inward * slice_inward;
    y_max = mounting_y + active_coupler.base_thickness + 2;

    assert(slice_thickness > 0, "top-edge slice thickness must be > 0");

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

    color([0.68, 0.68, 0.68, 1])
        intersection() {
            _hub75_corner_edge_fit_panel(panel, structure_only = true);
            _slice_volume();
        }

    color([0.72, 0.05, 0.04, 1])
        intersection() {
            translate([corner_x, mounting_y, corner_z])
                hub75_corner_edge_coupler_build(active_coupler);
            _slice_volume();
        }
}


// Module: hub75_corner_edge_coupler_xy_side_edge_section()
// Description:
//   0.10 mm XY slice through the vertical outside ridge, safely inward from the
//   corner screw/reinforcement feature.
module hub75_corner_edge_coupler_xy_side_edge_section(
    side = "left",
    panel = hub75_p5_64x32_panel_create(),
    coupler = undef,
    slice_inward = 20,
    slice_thickness = 0.10,
    crop_inward = 60,
    crop_outward = 10
) {
    active_coupler =
        is_undef(coupler)
            ? hub75_corner_edge_coupler_create(side = side, panel = panel)
            : coupler;
    corner_x = _hub75_corner_edge_fit_corner_x(panel, side);
    corner_z = _hub75_corner_edge_fit_corner_z(panel);
    mounting_y = hub75_p5_64x32_panel_mounting_plane_y(panel);
    slice_z = corner_z - slice_inward;
    y_max = mounting_y + active_coupler.base_thickness + 2;
    x_min = side == "left" ? corner_x - crop_outward : corner_x - crop_inward;
    x_max = side == "left" ? corner_x + crop_inward : corner_x + crop_outward;

    assert(slice_thickness > 0, "side-edge slice thickness must be > 0");

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

    color([0.68, 0.68, 0.68, 1])
        intersection() {
            _hub75_corner_edge_fit_panel(panel, structure_only = true);
            _slice_volume();
        }

    color([0.72, 0.05, 0.04, 1])
        intersection() {
            translate([corner_x, mounting_y, corner_z])
                hub75_corner_edge_coupler_build(active_coupler);
            _slice_volume();
        }
}
