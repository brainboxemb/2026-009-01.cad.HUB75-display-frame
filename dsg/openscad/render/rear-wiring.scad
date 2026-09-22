// Rear data-chain presentation render.
//
// This focused view exercises the optional panel numbering and IN/OUT
// annotations used to inspect wiring order from the rear of the display.

use <../assemblies/panels_assembly.scad>

panel_obj = hub75_display_panel_create();

hub75_display_verify_nominal_size(panel_obj = panel_obj);

$vpt = [0, 0, 0];
$vpr = [90, 0, 180];
$vpd = 1200;

hub75_panels_assembly(
    panel_obj = panel_obj,
    panel_numbers_visible = true,
    in_out_labels_visible = true
);
