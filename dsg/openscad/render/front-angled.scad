// Official milestone-1 full-display render.
// Camera values deliberately match the old HUB75 display-frame project.

use <../assemblies/panels_assembly.scad>

panel_obj = hub75_display_panel_create();

hub75_display_verify_nominal_size(panel_obj = panel_obj);

$vpt = [0, 0, 0];
$vpr = [85, 0, 40];
$vpd = 1050;

hub75_panels_assembly(panel_obj = panel_obj);
