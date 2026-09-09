// Five-panel HUB75 display assembly.
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
// Five panels are therefore placed side by side without rotation.

use <../ext/lib.scad.hub75/openscad/p5-64x32-panel/hub75_p5_64x32_panel.scad>

HUB75_DISPLAY_PANEL_COUNT = 5;

function hub75_display_panel_create() =
    hub75_p5_64x32_panel_create();

function _hub75_display_panel_pitch_x(panel) =
    hub75_p5_64x32_panel_nominal_width(panel);

function _hub75_display_panel_pitch_z(panel) =
    hub75_p5_64x32_panel_nominal_height(panel);

function _hub75_display_nominal_width(
    panel,
    panel_count = HUB75_DISPLAY_PANEL_COUNT
) =
    panel_count * _hub75_display_panel_pitch_x(panel);

function _hub75_display_nominal_height(panel) =
    _hub75_display_panel_pitch_z(panel);

function _hub75_display_panel_front_y(panel) = 0;

function _hub75_display_panel_rear_mounting_y(panel) =
    hub75_p5_64x32_panel_mounting_plane_y(panel);

function _hub75_display_panel_center_x(
    panel,
    index,
    panel_count = HUB75_DISPLAY_PANEL_COUNT
) =
    (index - (panel_count - 1) / 2) * _hub75_display_panel_pitch_x(panel);

module hub75_display_verify_nominal_size(
    panel = hub75_display_panel_create(),
    panel_count = HUB75_DISPLAY_PANEL_COUNT
) {
    assert(
        panel_count == 5,
        "Current milestone requires exactly five HUB75 panels"
    );
    assert(
        abs(_hub75_display_nominal_width(panel, panel_count) - 800) < 0.001,
        "Five-panel display must be 800 mm nominal width"
    );
    assert(
        abs(_hub75_display_nominal_height(panel) - 320) < 0.001,
        "Five-panel display must be 320 mm nominal height"
    );
    assert(
        abs(_hub75_display_panel_front_y(panel)) < 0.001,
        "HUB75 front face must remain on project Y=0"
    );
    assert(
        abs(
            _hub75_display_panel_rear_mounting_y(panel)
            - hub75_p5_64x32_panel_mounting_plane_y(panel)
        ) < 0.001,
        "Rear mounting plane must follow the library mounting-plane datum"
    );
}

// Module: hub75_panels_assembly()
// Description:
//   Places the five physical panels. The project presentation default is
//   light_gray so complete-display renders remain readable and match the
//   library's normal render/debug presentation.
// Arguments:
//   panel = HUB75 panel object.
//   panel_count = Number of portrait panels placed side by side.
//   color_scheme = Library render colour scheme; default light_gray.
module hub75_panels_assembly(
    panel = hub75_display_panel_create(),
    panel_count = HUB75_DISPLAY_PANEL_COUNT,
    color_scheme = "light_gray"
) {
    assert(panel_count >= 1, "panel_count must be at least 1");

    for (index = [0 : panel_count - 1])
        translate([
            _hub75_display_panel_center_x(panel, index, panel_count),
            0,
            0
        ])
            hub75_p5_64x32_panel_render(
                panel,
                view =
                    hub75_p5_64x32_panel_view_id("final"),
                color_scheme = color_scheme
            );
}
