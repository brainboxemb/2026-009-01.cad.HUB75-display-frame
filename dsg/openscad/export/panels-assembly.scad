// STL export entrypoint for milestone 1.
//
// This export is intended as a verification model that can be opened in a 3D
// viewer and freely rotated/zoomed. It contains only the five HUB75 panels.

use <../assemblies/panels_assembly.scad>

panel_obj = hub75_display_panel_create();

hub75_display_verify_nominal_size(panel_obj = panel_obj);
hub75_panels_assembly(panel_obj = panel_obj);
