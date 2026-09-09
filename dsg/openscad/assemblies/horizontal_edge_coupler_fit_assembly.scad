// File: horizontal_edge_coupler_fit_assembly.scad
//   Local two-panel verification fixture for the horizontal-edge coupler.
//
// Only the top edge around one internal panel seam is retained. This is a
// development fixture, not the complete display assembly.

use <../ext/lib.scad.hub75/openscad/p5-64x32-panel/hub75_p5_64x32_panel.scad>
use <../project_components/horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>
use <verification_datum_pin.scad>


function _hub75_horizontal_edge_fit_panel_pitch(panel) =
    hub75_p5_64x32_panel_nominal_width(panel);

function _hub75_horizontal_edge_fit_edge_z(panel) =
    hub75_p5_64x32_panel_nominal_height(panel) / 2;


module _hub75_horizontal_edge_fit_panel_pair(panel) {
    pitch =
        _hub75_horizontal_edge_fit_panel_pitch(panel);

    for (x = [-pitch / 2, pitch / 2])
        translate([x, 0, 0])
            hub75_p5_64x32_panel_render(
                panel,
                view = hub75_p5_64x32_panel_view_id("final"),
                color_scheme = "light_gray"
            );
}


// Module: hub75_horizontal_edge_coupler_fit_detail()
// Description:
//   Angled local context showing two panel top edges and the T coupler.
module hub75_horizontal_edge_coupler_fit_detail(
    panel = hub75_p5_64x32_panel_create(),
    coupler = undef,
    crop_width = 140,
    crop_inward = 110,
    crop_outward = 10
) {
    active_coupler =
        is_undef(coupler)
            ? hub75_horizontal_edge_coupler_create(panel = panel)
            : coupler;

    mounting_y =
        hub75_p5_64x32_panel_mounting_plane_y(panel);
    edge_z =
        _hub75_horizontal_edge_fit_edge_z(panel);
    y_max =
        mounting_y
        + active_coupler.base_thickness
        + 2;

    module _crop_volume() {
        translate([
            -crop_width / 2,
            -0.5,
            edge_z - crop_inward
        ])
            cube([
                crop_width,
                y_max + 1,
                crop_inward + crop_outward
            ]);
    }

    intersection() {
        _hub75_horizontal_edge_fit_panel_pair(panel);
        _crop_volume();
    }

    color([0.72, 0.05, 0.04, 1])
        translate([0, mounting_y, edge_z])
            hub75_horizontal_edge_coupler_build(active_coupler);

    // Exact seam / nominal-panel-edge datum used by the engraved +.
    hub75_verification_datum_pin(
        x = 0,
        z = edge_z,
        y_min = -4,
        y_max =
            mounting_y
            + active_coupler.base_thickness
            + 8
    );
}


// Module: hub75_horizontal_edge_coupler_rear_fit_section()
// Description:
//   Rear-facing section cut a fixed distance forward from the rear mounting
//   plane. Grey is retained panel structure; red is coupler material entering
//   the same retained volume.
module hub75_horizontal_edge_coupler_rear_fit_section(
    panel = hub75_p5_64x32_panel_create(),
    coupler = undef,
    depth = 5.0,
    crop_width = 140,
    crop_inward = 110,
    crop_outward = 10
) {
    active_coupler =
        is_undef(coupler)
            ? hub75_horizontal_edge_coupler_create(panel = panel)
            : coupler;

    mounting_y =
        hub75_p5_64x32_panel_mounting_plane_y(panel);
    edge_z =
        _hub75_horizontal_edge_fit_edge_z(panel);
    section_y =
        mounting_y - depth;

    assert(depth > 0, "rear fit section depth must be > 0");
    assert(
        section_y > 0,
        "rear fit section must remain behind the HUB75 front face"
    );

    module _rear_structure() {
        pitch =
            _hub75_horizontal_edge_fit_panel_pitch(panel);

        for (x = [-pitch / 2, pitch / 2])
            translate([x, 0, 0])
                hub75_p5_64x32_panel_render(
                    panel,
                    view = hub75_p5_64x32_panel_view_id("structure"),
                    color_scheme = "light_gray"
                );
    }

    module _keep_volume() {
        y_min = -0.5;

        translate([
            -crop_width / 2,
            y_min,
            edge_z - crop_inward
        ])
            cube([
                crop_width,
                section_y - y_min,
                crop_inward + crop_outward
            ]);
    }

    color([0.68, 0.68, 0.68, 1])
        intersection() {
            _rear_structure();
            _keep_volume();
        }

    color([0.72, 0.05, 0.04, 1])
        intersection() {
            translate([0, mounting_y, edge_z])
                hub75_horizontal_edge_coupler_build(active_coupler);

            _keep_volume();
        }

    hub75_verification_datum_pin(
        x = 0,
        z = edge_z,
        y_min = -4,
        y_max =
            mounting_y
            + active_coupler.base_thickness
            + 8
    );
}


// Module: hub75_horizontal_edge_coupler_yz_edge_section()
// Description:
//   Thin YZ slice through the right panel close to the seam. The slice avoids
//   the screw centre so the rear end rail and the fitted guide remain readable.
module hub75_horizontal_edge_coupler_yz_edge_section(
    panel = hub75_p5_64x32_panel_create(),
    coupler = undef,
    slice_x = 12,
    slice_thickness = 0.50,
    crop_inward = 90,
    crop_outward = 10
) {
    active_coupler =
        is_undef(coupler)
            ? hub75_horizontal_edge_coupler_create(panel = panel)
            : coupler;

    mounting_y =
        hub75_p5_64x32_panel_mounting_plane_y(panel);
    edge_z =
        _hub75_horizontal_edge_fit_edge_z(panel);
    y_max =
        mounting_y
        + active_coupler.base_thickness
        + 2;

    module _slice_volume() {
        translate([
            slice_x - slice_thickness / 2,
            -0.5,
            edge_z - crop_inward
        ])
            cube([
                slice_thickness,
                y_max + 1,
                crop_inward + crop_outward
            ]);
    }

    intersection() {
        _hub75_horizontal_edge_fit_panel_pair(panel);
        _slice_volume();
    }

    color([0.72, 0.05, 0.04, 1])
        intersection() {
            translate([0, mounting_y, edge_z])
                hub75_horizontal_edge_coupler_build(active_coupler);

            _slice_volume();
        }
}
