// File: panels_assembly.scad
//   Parametric portrait HUB75 panel-row assembly.

// HUB75 display panel-row assembly.
//
// The reusable panel geometry and its dimensions come exclusively from
// lib.scad.hub75. This project only decides how many panels are present and
// where their nominal placement cells are located.
//
// Project coordinate system:
// X = display width, centred around X = 0
// Y = panel depth, with the HUB75 front face at Y = 0
// Z = display height, centred around Z = 0
//
// This deliberately preserves the reusable library component's native
// coordinate convention. The panel is not symmetric front-to-rear, so the
// physical front face is the clearest project datum.
//
// Each library panel is already modeled in portrait orientation:
// nominal 160 mm in X x 320 mm in Z.
// Data-chain order is defined from the rear of the assembled display.
// Rear-view left is panel 1 and uses the library's default start orientation.
// From the rear X appears visually mirrored, so panel 1 is the highest-X
// placement cell (the final local placement index). Orientation then alternates
// by chain number rather than by local array index. This keeps focused two-panel
// assemblies in sync with the same end of the five-panel production display.

use <../ext/lib.scad.hub75/openscad/p5-64x32-panel/hub75_p5_64x32_panel.scad>

HUB75_DISPLAY_PANEL_COUNT = 5;

function hub75_display_panel_create() =
    hub75_p5_64x32_panel_create();

function _hub75_display_panel_pitch_x(panel_obj) =
    hub75_p5_64x32_panel_nominal_width(panel_obj);

function _hub75_display_panel_pitch_z(panel_obj) =
    hub75_p5_64x32_panel_nominal_height(panel_obj);

function _hub75_display_nominal_width(
    panel_obj,
    panel_count = HUB75_DISPLAY_PANEL_COUNT
) =
    panel_count * _hub75_display_panel_pitch_x(panel_obj);

function _hub75_display_nominal_height(panel_obj) =
    _hub75_display_panel_pitch_z(panel_obj);

function _hub75_display_panel_front_y(panel_obj) = 0;

function _hub75_display_panel_rear_mounting_y(panel_obj) =
    hub75_p5_64x32_panel_mounting_plane_y(panel_obj);

function _hub75_display_panel_center_x(
    panel_obj,
    index,
    panel_count = HUB75_DISPLAY_PANEL_COUNT
) =
    (index - (panel_count - 1) / 2) * _hub75_display_panel_pitch_x(panel_obj);

function _hub75_display_panel_chain_number(index, panel_count) =
    panel_count - index;

function _hub75_display_panel_input_is_top(index, panel_count) =
    _hub75_display_panel_chain_number(index, panel_count) % 2 == 1;

function _hub75_display_panel_rotated(index, panel_count) =
    !_hub75_display_panel_input_is_top(index, panel_count);

function _hub75_display_panel_connector_z_centered(panel_obj, drawing_z) =
    drawing_z - hub75_p5_64x32_panel_height(panel_obj) / 2;

function _hub75_display_panel_data_connector_z_top(panel_obj) =
    _hub75_display_panel_connector_z_centered(
        panel_obj,
        hub75_p5_64x32_panel_data_connector_z_top(panel_obj)
    );

function _hub75_display_panel_data_connector_z_bottom(panel_obj) =
    _hub75_display_panel_connector_z_centered(
        panel_obj,
        hub75_p5_64x32_panel_data_connector_z_bottom(panel_obj)
    );

function _hub75_display_rear_visual_x(panel_x, visual_offset) =
    panel_x - visual_offset;

module _hub75_display_rear_text_label(
    panel_obj,
    label,
    x,
    z,
    size = 10,
    label_color = [0.25, 0.90, 1.00, 1]
) {
    color(label_color)
        translate([
            x,
            _hub75_display_panel_rear_mounting_y(panel_obj) + 0.35,
            z
        ])
            rotate([90, 0, 180])
                linear_extrude(height = 0.35)
                    text(
                        label,
                        size = size,
                        halign = "center",
                        valign = "center"
                    );
}

module _hub75_display_panel_chain_annotations(
    panel_obj,
    index,
    panel_count,
    show_number,
    show_io
) {
    chain_number =
        _hub75_display_panel_chain_number(index, panel_count);
    input_top =
        _hub75_display_panel_input_is_top(index, panel_count);
    center_x =
        _hub75_display_panel_center_x(panel_obj, index, panel_count);
    input_z =
        input_top
            ? _hub75_display_panel_data_connector_z_top(panel_obj)
            : _hub75_display_panel_data_connector_z_bottom(panel_obj);
    output_z =
        input_top
            ? _hub75_display_panel_data_connector_z_bottom(panel_obj)
            : _hub75_display_panel_data_connector_z_top(panel_obj);
    io_visual_offset = 28;

    if (show_number)
        _hub75_display_rear_text_label(
            panel_obj = panel_obj,
            label = str(chain_number),
            x = center_x,
            z = 0,
            size = 15
        );

    if (show_io) {
        _hub75_display_rear_text_label(
            panel_obj = panel_obj,
            label = "IN",
            x = _hub75_display_rear_visual_x(
                center_x,
                io_visual_offset
            ),
            z = input_z,
            size = 8,
            label_color = [0.20, 1.00, 0.35, 1]
        );
        _hub75_display_rear_text_label(
            panel_obj = panel_obj,
            label = "OUT",
            x = _hub75_display_rear_visual_x(
                center_x,
                -io_visual_offset
            ),
            z = output_z,
            size = 8
        );
    }
}

module _hub75_display_panel_render(
    panel_obj,
    index,
    panel_count,
    color_scheme,
    panel_view
) {
    if (_hub75_display_panel_rotated(index, panel_count))
        rotate([0, 180, 0])
            hub75_p5_64x32_panel_render(
                panel_obj,
                view = panel_view,
                color_scheme = color_scheme
            );
    else
        hub75_p5_64x32_panel_render(
            panel_obj,
            view = panel_view,
            color_scheme = color_scheme
        );
}

module hub75_display_verify_nominal_size(
    panel_obj = hub75_display_panel_create(),
    panel_count = HUB75_DISPLAY_PANEL_COUNT
) {
    assert(
        panel_count >= 1,
        "panel_count must be at least 1"
    );
    assert(
        abs(_hub75_display_panel_pitch_x(panel_obj) - 160) < 0.001,
        "HUB75 portrait placement cell must remain 160 mm nominal width"
    );
    assert(
        abs(_hub75_display_nominal_width(panel_obj, panel_count)
            - 160 * panel_count) < 0.001,
        "Display nominal width must follow panel_count x 160 mm"
    );
    assert(
        abs(_hub75_display_nominal_height(panel_obj) - 320) < 0.001,
        "HUB75 portrait placement cell must remain 320 mm nominal height"
    );
    if (panel_count == HUB75_DISPLAY_PANEL_COUNT)
        assert(
            abs(_hub75_display_nominal_width(panel_obj, panel_count) - 800) < 0.001,
            "Five-panel production display must remain 800 mm nominal width"
        );
    assert(
        _hub75_display_panel_chain_number(panel_count - 1, panel_count) == 1,
        "Rear-view left panel must remain data-chain panel 1"
    );
    assert(
        !_hub75_display_panel_rotated(panel_count - 1, panel_count),
        "Rear-view left panel must keep the default start orientation"
    );
    assert(
        abs(_hub75_display_panel_front_y(panel_obj)) < 0.001,
        "HUB75 front face must remain on project Y=0"
    );
    assert(
        abs(
            _hub75_display_panel_rear_mounting_y(panel_obj)
            - hub75_p5_64x32_panel_mounting_plane_y(panel_obj)
        ) < 0.001,
        "Rear mounting plane must follow the library mounting-plane datum"
    );
}

// Module: hub75_panels_assembly()
// Description:
//   Places a row of physical panels. The project production default remains
//   five panels; smaller counts are useful for focused inspection assemblies.
//   The project presentation default is
//   light_gray so complete-display renders remain readable and match the
//   library's normal render/debug presentation.
// Arguments:
//   panel_obj = HUB75 panel object.
//   panel_count = Number of portrait panels placed side by side.
//   color_scheme = Library render colour scheme; default light_gray.
//   panel_numbers_visible = Show rear-view data-chain panel numbers.
//   in_out_labels_visible = Show rear-view IN/OUT labels at data connectors.
module hub75_panels_assembly(
    panel_obj = hub75_display_panel_create(),
    panel_count = HUB75_DISPLAY_PANEL_COUNT,
    color_scheme = "light_gray",
    panel_view = hub75_p5_64x32_panel_view_id("final"),
    panel_numbers_visible = false,
    in_out_labels_visible = false
) {
    assert(panel_count >= 1, "panel_count must be at least 1");

    for (index = [0 : panel_count - 1]) {
        translate([
            _hub75_display_panel_center_x(panel_obj, index, panel_count),
            0,
            0
        ])
            _hub75_display_panel_render(
                panel_obj = panel_obj,
                index = index,
                panel_count = panel_count,
                color_scheme = color_scheme,
                panel_view = panel_view
            );

        if (panel_numbers_visible || in_out_labels_visible)
            _hub75_display_panel_chain_annotations(
                panel_obj = panel_obj,
                index = index,
                panel_count = panel_count,
                show_number = panel_numbers_visible,
                show_io = in_out_labels_visible
            );
    }
}
