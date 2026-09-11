// XY side-edge fit section for the top-left corner.

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
slice_z = corner_z - slice_inward;

$vpt = [corner_x + (1) * 20, 7, slice_z];
$vpr = [0, 0, 0];
$vpd = size == "small" ? 150 : size == "large" ? 215 : 180;

hub75_corner_edge_coupler_xy_side_edge_section(
    side = side,
    panel = panel,
    coupler = coupler,
    slice_inward = slice_inward,
    slice_thickness = 0.10
);
