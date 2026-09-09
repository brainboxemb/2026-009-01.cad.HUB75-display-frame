// File: middle_coupler_fit_assembly.scad
//   Local two-panel verification assembly for the middle coupler.
//
// This file deliberately uses only two panels. It is a development fixture,
// not the final five-panel display assembly.

use <../ext/lib.scad.hub75/openscad/p5-64x32-panel/hub75_p5_64x32_panel.scad>
use <../project_components/middle-coupler/hub75_middle_coupler.scad>
use <verification_datum_pin.scad>


function _hub75_middle_coupler_fit_panel_pitch(panel) =
    hub75_p5_64x32_panel_nominal_width(panel);


function _hub75_middle_coupler_fit_section_z(coupler) =
    -hub75_middle_coupler_horizontal_arm_height(coupler) / 2
    - 6;


// Module: hub75_middle_coupler_fit_detail()
// Description:
//   Cropped rear context around the seam between two panels and the coupler.
//   The crop keeps the actual HUB75 geometry but removes unrelated panel area.
module hub75_middle_coupler_fit_detail(
    panel = hub75_p5_64x32_panel_create(),
    coupler = undef,
    crop_width = 140,
    crop_height = 130
) {
    active_coupler =
        is_undef(coupler)
            ? hub75_middle_coupler_create(panel = panel)
            : coupler;

    pitch =
        _hub75_middle_coupler_fit_panel_pitch(panel);
    mounting_y =
        hub75_p5_64x32_panel_mounting_plane_y(panel);

    module _panel_pair() {
        for (x = [-pitch / 2, pitch / 2])
            translate([x, 0, 0])
                hub75_p5_64x32_panel_render(
                    panel,
                    view =
                        hub75_p5_64x32_panel_view_id("final"),
                    color_scheme = "light_gray"
                );
    }

    module _crop_volume() {
        y_max =
            mounting_y
            + active_coupler.base_thickness
            + 2;

        translate([
            -crop_width / 2,
            -0.5,
            -crop_height / 2
        ])
            cube([
                crop_width,
                y_max + 1,
                crop_height
            ]);
    }

    intersection() {
        _panel_pair();
        _crop_volume();
    }

    color([0.72, 0.05, 0.04, 1])
        translate([0, mounting_y, 0])
            hub75_middle_coupler_build(
                active_coupler
            );

    // Blue verification datum through the engraved + at the seam/row origin.
    hub75_verification_datum_pin(
        x = 0,
        z = 0,
        y_min = -4,
        y_max =
            mounting_y
            + active_coupler.base_thickness
            + 8
    );
}


// Module: hub75_middle_coupler_fit_cross_section()
// Description:
//   True XY slice through the vertical seam, below the horizontal rear
//   crossbar. This reveals panel depth, rear seam and locator engagement.
module hub75_middle_coupler_fit_cross_section(
    panel = hub75_p5_64x32_panel_create(),
    coupler = undef,
    slice_thickness = 0.50,
    crop_width = 90
) {
    active_coupler =
        is_undef(coupler)
            ? hub75_middle_coupler_create(panel = panel)
            : coupler;

    pitch =
        _hub75_middle_coupler_fit_panel_pitch(panel);
    mounting_y =
        hub75_p5_64x32_panel_mounting_plane_y(panel);
    slice_z =
        _hub75_middle_coupler_fit_section_z(
            active_coupler
        );

    module _panel_pair() {
        for (x = [-pitch / 2, pitch / 2])
            translate([x, 0, 0])
                hub75_p5_64x32_panel_render(
                    panel,
                    view =
                        hub75_p5_64x32_panel_view_id("final"),
                    color_scheme = "light_gray"
                );
    }

    module _slice_volume() {
        y_max =
            mounting_y
            + active_coupler.base_thickness
            + 2;

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
        _panel_pair();
        _slice_volume();
    }

    color([0.72, 0.05, 0.04, 1])
        intersection() {
            translate([0, mounting_y, 0])
                hub75_middle_coupler_build(
                    active_coupler
                );

            _slice_volume();
        }
}


// Module: hub75_middle_coupler_rear_fit_section()
// Description:
//   Rear-facing section equivalent to the classic "Rear fit section" evidence.
//   The geometry is cut a fixed distance forward from the HUB75 rear mounting
//   plane. Grey shows only the panel rear structure; red shows only coupler
//   geometry that actually penetrates into the same retained volume.
// Arguments:
//   panel = HUB75 panel object.
//   coupler = Middle-coupler object, or undef to construct the default.
//   depth = Distance forward from the rear mounting plane, default 5 mm.
//   crop_width = Local X extent around the seam.
//   crop_height = Local Z extent around the middle mounting row.
module hub75_middle_coupler_rear_fit_section(
    panel = hub75_p5_64x32_panel_create(),
    coupler = undef,
    depth = 5.0,
    crop_width = 140,
    crop_height = 130
) {
    active_coupler =
        is_undef(coupler)
            ? hub75_middle_coupler_create(panel = panel)
            : coupler;

    pitch =
        _hub75_middle_coupler_fit_panel_pitch(panel);
    mounting_y =
        hub75_p5_64x32_panel_mounting_plane_y(panel);
    section_y =
        mounting_y - depth;

    assert(depth > 0, "rear fit section depth must be > 0");
    assert(
        section_y > 0,
        "rear fit section must remain behind the HUB75 front face"
    );

    module _panel_pair_rear_structure() {
        for (x = [-pitch / 2, pitch / 2])
            translate([x, 0, 0])
                hub75_p5_64x32_panel_render(
                    panel,
                    view =
                        hub75_p5_64x32_panel_view_id("structure"),
                    color_scheme = "light_gray"
                );
    }

    module _rear_section_keep_volume() {
        y_min = -0.5;

        translate([
            -crop_width / 2,
            y_min,
            -crop_height / 2
        ])
            cube([
                crop_width,
                section_y - y_min,
                crop_height
            ]);
    }

    // Grey: only actual HUB75 rear structural geometry up to the cut plane.
    color([0.68, 0.68, 0.68, 1])
        intersection() {
            _panel_pair_rear_structure();
            _rear_section_keep_volume();
        }

    // Red: only coupler material that reaches into the same retained volume.
    color([0.72, 0.05, 0.04, 1])
        intersection() {
            translate([0, mounting_y, 0])
                hub75_middle_coupler_build(
                    active_coupler
                );

            _rear_section_keep_volume();
        }

    // Rear view sees this mainly as a blue circle at the exact + datum.
    hub75_verification_datum_pin(
        x = 0,
        z = 0,
        y_min = -4,
        y_max =
            mounting_y
            + active_coupler.base_thickness
            + 8
    );
}
