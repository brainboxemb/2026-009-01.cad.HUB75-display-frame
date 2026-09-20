// File: horizontal_edge_coupler_fit_assembly.scad
//   Local two-panel verification fixture for the horizontal-edge coupler.

use <../../ext/lib.scad.hub75/openscad/p5-64x32-panel/hub75_p5_64x32_panel.scad>
use <../../ext/lib.scad.util/openscad/inspection.scad>
use <../panels_assembly.scad>
use <../../components/hub75/horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>
use <../helpers/verification_datum_pin.scad>

function _hub75_horizontal_edge_fit_panel_pitch(panel) =
    hub75_p5_64x32_panel_nominal_width(panel);

function _hub75_horizontal_edge_fit_edge_z(panel) =
    hub75_p5_64x32_panel_nominal_height(panel) / 2;

module _hub75_horizontal_edge_fit_panel_pair(panel) {
    hub75_panels_assembly(
        panel = panel,
        panel_count = 2,
        color_scheme = "light_gray"
    );
}

// Module: hub75_horizontal_edge_coupler_fit_detail()
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
//   Rear-facing thin Y section. lib.scad.util owns the slab; this fixture
//   retains only the local crop and presentation.
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
    y_max =
        mounting_y
        + active_coupler.base_thickness
        + 2;

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

    color([0.68, 0.68, 0.68, 1])
        intersection() {
            util_section_inspect(
                axis = "Y",
                position = section_y - slice_thickness / 2,
                depth = slice_thickness,
                direction = "Positive"
            )
                _rear_structure();
            _crop_volume();
        }

    color([0.72, 0.05, 0.04, 1])
        intersection() {
            util_section_inspect(
                axis = "Y",
                position = section_y - slice_thickness / 2,
                depth = slice_thickness,
                direction = "Positive"
            )
                translate([0, mounting_y, edge_z])
                    hub75_horizontal_edge_coupler_build(active_coupler);
            _crop_volume();
        }

    hub75_verification_datum_pin(
        x = 0,
        z = edge_z,
        y_min = section_y - 2,
        y_max = section_y + 2
    );
}

// Module: hub75_horizontal_edge_coupler_yz_edge_section()
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

    module _crop_volume() {
        translate([
            -1000,
            -0.5,
            edge_z - crop_inward
        ])
            cube([
                2000,
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
            _hub75_horizontal_edge_fit_panel_pair(panel);
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
                translate([0, mounting_y, edge_z])
                    hub75_horizontal_edge_coupler_build(active_coupler);
            _crop_volume();
        }
}

// Module: hub75_horizontal_edge_coupler_xy_seam_section()
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
            _hub75_horizontal_edge_fit_panel_pair(panel);
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
                translate([0, mounting_y, edge_z])
                    hub75_horizontal_edge_coupler_build(active_coupler);
            _crop_volume();
        }
}
