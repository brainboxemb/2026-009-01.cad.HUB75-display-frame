// Five-panel HUB75 display assembly.
//
// The reusable panel geometry and its dimensions come exclusively from
// lib.scad.hub75. This project only decides how many panels are present and
// where their nominal placement cells are located.
//
// Coordinate system:
// X = display width
// Y = panel depth, front to rear
// Z = display height
//
// Each library panel is already modeled in portrait orientation:
// nominal 160 mm in X x 320 mm in Z.
// Five panels are therefore placed side by side without rotation.

use <../ext/lib.scad.hub75/openscad/p5-64x32-panel/hub75_p5_64x32_panel.scad>

HUB75_DISPLAY_PANEL_COUNT = 5;

function hub75_display_panel_create() =
    hub75_p5_64x32_panel_create();

function hub75_display_panel_pitch_x(panel) =
    hub75_p5_64x32_panel_nominal_width(panel);

function hub75_display_panel_pitch_z(panel) =
    hub75_p5_64x32_panel_nominal_height(panel);

function hub75_display_nominal_width(
    panel,
    panel_count = HUB75_DISPLAY_PANEL_COUNT
) =
    panel_count * hub75_display_panel_pitch_x(panel);

function hub75_display_nominal_height(panel) =
    hub75_display_panel_pitch_z(panel);

function hub75_display_panel_center_x(
    panel,
    index,
    panel_count = HUB75_DISPLAY_PANEL_COUNT
) =
    (index - (panel_count - 1) / 2) * hub75_display_panel_pitch_x(panel);

module hub75_display_verify_nominal_size(
    panel = hub75_display_panel_create(),
    panel_count = HUB75_DISPLAY_PANEL_COUNT
) {
    assert(
        panel_count == 5,
        "Current milestone requires exactly five HUB75 panels"
    );
    assert(
        abs(hub75_display_nominal_width(panel, panel_count) - 800) < 0.001,
        "Five-panel display must be 800 mm nominal width"
    );
    assert(
        abs(hub75_display_nominal_height(panel) - 320) < 0.001,
        "Five-panel display must be 320 mm nominal height"
    );
}

module hub75_panels_assembly(
    panel = hub75_display_panel_create(),
    panel_count = HUB75_DISPLAY_PANEL_COUNT
) {
    assert(panel_count >= 1, "panel_count must be at least 1");

    for (index = [0 : panel_count - 1])
        translate([
            hub75_display_panel_center_x(panel, index, panel_count),
            0,
            0
        ])
            hub75_p5_64x32_panel_build(panel);
}
