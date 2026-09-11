// Canonical XY profile through the side/vertical corner arm.
// Selective verification cache probe: no geometry change.

use <../../dsg/openscad/assemblies/verification/corner_edge_coupler_profile_sections.scad>
use <../../dsg/openscad/ext/lib.scad.hub75/openscad/p5-64x32-panel/hub75_p5_64x32_panel.scad>
use <../../dsg/openscad/project_components/corner-edge-coupler/hub75_corner_edge_coupler.scad>

size = "medium";
side = "left";

panel = hub75_p5_64x32_panel_create();
coupler = hub75_corner_edge_coupler_create_for_size(
    side = side,
    size = size,
    panel = panel
);
corner_x = -hub75_p5_64x32_panel_nominal_width(panel) / 2;
corner_z = hub75_p5_64x32_panel_nominal_height(panel) / 2;
slice_inward = 20;
slice_z = corner_z - slice_inward;

$vpt = [corner_x + 35, 7, slice_z];
$vpr = [0, 0, 0];
$vpd = 205;

hub75_corner_edge_coupler_vertical_profile_section(
    side = side,
    panel = panel,
    coupler = coupler,
    slice_inward = slice_inward
);
