// File: horizontal_edge_coupler_fit_assembly.scad
//   Local two-panel verification fixture for the horizontal-edge coupler.
//
// Only the top edge around one internal panel seam is retained. This is a
// development fixture, not the complete display assembly.

use <../../ext/lib.scad.hub75/openscad/p5-64x32-panel/hub75_p5_64x32_panel.scad>
use <../../project_components/horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>
use <../helpers/verification_datum_pin.scad>


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
//   Rear-facing thin section centred a fixed distance forward from the rear
//   mounting plane. Grey and red are cut by the same narrow Y slab so the exact
//   panel/coupler mating contours are visible without oblique half-space walls.
module hub75_horizontal_edge_coupler_rear_fit_section(
    panel = hub75_p5_64x32_panel_create(),
    coupler = undef,
    depth = 5.0,
    slice_thickness = 0.10,
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
    assert(slice_thickness > 0, "rear fit slice thickness must be > 0");
    assert(
        section_y - slice_thickness / 2 > 0,
        "rear fit slice must remain behind the HUB75 front face"
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

    module _slice_volume() {
        translate([
            -crop_width / 2,
            section_y - slice_thickness / 2,
            edge_z - crop_inward
        ])
            cube([
                crop_width,
                slice_thickness,
                crop_inward + crop_outward
            ]);
    }

    color([0.68, 0.68, 0.68, 1])
        intersection() {
            _rear_structure();
            _slice_volume();
        }

    color([0.72, 0.05, 0.04, 1])
        intersection() {
            translate([0, mounting_y, edge_z])
                hub75_horizontal_edge_coupler_build(active_coupler);

            _slice_volume();
        }

    hub75_verification_datum_pin(
        x = 0,
        z = edge_z,
        y_min = section_y - 2,
        y_max = section_y + 2
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


// Module: hub75_horizontal_edge_coupler_xy_seam_section()
// Description:
//   Thin XY slice through the vertical panel seam, inward from the top edge.
//   This is the orthogonal companion to the YZ edge section and shows how the
//   vertical T arm fits around both panel side rails and the tapered seam.
module hub75_horizontal_edge_coupler_xy_seam_section(
    panel = hub75_p5_64x32_panel_create(),
    coupler = undef,
    slice_inward = 22,
    slice_thickness = 0.50,
    crop_width = 90
) {
    active_coupler =
        is_undef(coupler)
            ? hub75_horizontal_edge_coupler_create(panel = panel)
            : coupler;

    mounting_y =
        hub75_p5_64x32_panel_mounting_plane_y(panel);
    edge_z =
        _hub75_horizontal_edge_fit_edge_z(panel);
    slice_z =
        edge_z - slice_inward;
    y_max =
        mounting_y
        + active_coupler.base_thickness
        + 2;

    assert(slice_inward > 0, "XY seam section must be inward from the edge");
    assert(slice_thickness > 0, "XY seam slice thickness must be > 0");
    assert(
        slice_inward < hub75_horizontal_edge_coupler_inward_reach(active_coupler),
        "XY seam section must remain inside the vertical coupler arm"
    );

    module _slice_volume() {
        translate([
            -crop_width / 2,
            -0.5,
            slice_z - slice_thickness / 2
        ])
            cube([
                crop_width,
                y_max + 1,
                slice_thickness
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