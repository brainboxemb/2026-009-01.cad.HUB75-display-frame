// YZ top-edge fit section for the top-left corner.
// Selective verification cache probe: no geometry change.

use <../../dsg/openscad/assemblies/verification/corner_edge_coupler_fit_assembly.scad>
use <../../dsg/openscad/ext/lib.scad.hub75/openscad/p5-64x32-panel/hub75_p5_64x32_panel.scad>
use <../../dsg/openscad/project_components/corner-edge-coupler/hub75_corner_edge_coupler.scad>

size = "medium";
side = "left";

panel = hub75_p5_64x32_panel_create();
coupler = hub75_corner_edge_coupler_create_for_size(side = side, size = size, panel = panel);
corner_x = (-1) * hub75_p5_64x32_panel_nominal_width(panel) / 2;
corner_z = hub75_p5_64x32_panel_nominal_height(panel) / 2;
slice_inward = 20;
slice_x = corner_x + (1) * slice_inward;

$vpt = [slice_x, 7, corner_z - 20];
$vpr = [0, 90, 0];
$vpd = size == "small" ? 145 : size == "large" ? 205 : 170;

hub75_corner_edge_coupler_yz_top_edge_section(
    side = side,
    panel = panel,
    coupler = coupler,
    slice_inward = slice_inward,
    slice_thickness = 0.10
);
