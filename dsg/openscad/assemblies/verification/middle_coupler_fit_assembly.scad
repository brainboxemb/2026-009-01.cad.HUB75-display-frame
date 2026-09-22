// File: middle_coupler_fit_assembly.scad
//   Local two-panel verification assembly for the middle coupler.
//
// This file deliberately uses only two panels. It is a development fixture,
// not the final five-panel display assembly.

use <../../ext/lib.scad.hub75/openscad/p5-64x32-panel/hub75_p5_64x32_panel.scad>
use <../../ext/lib.scad.util/openscad/inspection.scad>
use <../panels_assembly.scad>
use <../../components/hub75/middle-coupler/hub75_middle_coupler.scad>
use <../helpers/verification_datum_pin.scad>

function _hub75_middle_coupler_fit_panel_pitch(panel) =
    hub75_p5_64x32_panel_nominal_width(panel);

module _hub75_middle_coupler_fit_panel_pair(panel) {
    hub75_panels_assembly(
        panel = panel,
        panel_count = 2,
        color_scheme = "light_gray"
    );
}

function _hub75_middle_coupler_fit_section_z(coupler) =
    -hub75_middle_coupler_horizontal_arm_height(coupler) / 2
    - 6;

// Module: hub75_middle_coupler_fit_detail()
// Description:
//   Cropped rear context around the seam between two panels and the coupler.
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
    mounting_y =
        hub75_p5_64x32_panel_mounting_plane_y(panel);

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
        _hub75_middle_coupler_fit_panel_pair(panel);
        _crop_volume();
    }

    color([0.72, 0.05, 0.04, 1])
        translate([0, mounting_y, 0])
            hub75_middle_coupler_build(active_coupler);

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
//   crossbar. util_section_inspect() owns the Z slab; this fixture owns only
//   the local X/Y crop and presentation.
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
    mounting_y =
        hub75_p5_64x32_panel_mounting_plane_y(panel);
    slice_z =
        _hub75_middle_coupler_fit_section_z(active_coupler);
    y_max =
        mounting_y
        + active_coupler.base_thickness
        + 2;

    module _crop_volume() {
        translate([
            -crop_width / 2,
            -0.5,
            -1000
        ])
            cube([
                crop_width,
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
            _hub75_middle_coupler_fit_panel_pair(panel);
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
                translate([0, mounting_y, 0])
                    hub75_middle_coupler_build(active_coupler);
            _crop_volume();
        }
}

// Module: hub75_middle_coupler_rear_fit_section()
// Description:
//   Rear-facing retained Y depth through the panel/coupler interface. The
//   retained Y slab is delegated to lib.scad.util; this fixture keeps only
//   the local X/Z crop, color separation and datum.
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
    y_min = -0.5;
    y_max =
        mounting_y
        + active_coupler.base_thickness
        + 2;

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
                    view = hub75_p5_64x32_panel_view_id("structure"),
                    color_scheme = "light_gray"
                );
    }

    module _crop_volume() {
        translate([
            -crop_width / 2,
            y_min,
            -crop_height / 2
        ])
            cube([
                crop_width,
                y_max - y_min,
                crop_height
            ]);
    }

    color([0.68, 0.68, 0.68, 1])
        intersection() {
            util_section_inspect(
                axis = "Y",
                position = y_min,
                depth = section_y - y_min,
                direction = "Positive"
            )
                _panel_pair_rear_structure();
            _crop_volume();
        }

    color([0.72, 0.05, 0.04, 1])
        intersection() {
            util_section_inspect(
                axis = "Y",
                position = y_min,
                depth = section_y - y_min,
                direction = "Positive"
            )
                translate([0, mounting_y, 0])
                    hub75_middle_coupler_build(active_coupler);
            _crop_volume();
        }

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
