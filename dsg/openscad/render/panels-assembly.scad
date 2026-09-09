// Render entrypoint for milestone 1: five portrait HUB75 panels.
//
// These assertions are project requirements, not duplicated panel geometry.
// The actual placement values still come from lib.scad.hub75 accessors.

use <../assemblies/panels_assembly.scad>

panel = hub75_display_panel_create();

assert(
    abs(hub75_display_nominal_width(panel) - 800) < 0.001,
    "Five-panel display must be 800 mm nominal width"
);

assert(
    abs(hub75_display_nominal_height(panel) - 320) < 0.001,
    "Five-panel display must be 320 mm nominal height"
);

hub75_panels_assembly(panel = panel);
