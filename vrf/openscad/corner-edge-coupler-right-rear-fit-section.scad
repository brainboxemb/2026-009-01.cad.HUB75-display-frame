// Rear-facing top-right corner fit section.

use <../../dsg/openscad/assemblies/verification/corner_edge_coupler_fit_assembly.scad>
use <../../dsg/openscad/ext/lib.scad.hub75/openscad/p5-64x32-panel/hub75_p5_64x32_panel.scad>
use <../../dsg/openscad/project_components/corner-edge-coupler/hub75_corner_edge_coupler.scad>

size = "medium";

panel = hub75_p5_64x32_panel_create();
coupler =
    hub75_corner_edge_coupler_create_for_size(
        side = "right",
        size = size,
        panel = panel
    );

section_depth =
    min(5.0, max(1.0, coupler.guide_height - 1.0));

corner_x =
    hub75_p5_64x32_panel_nominal_width(panel) / 2;
corner_z =
    hub75_p5_64x32_panel_nominal_height(panel) / 2;

$vpt = [corner_x - 35, 9.5, corner_z - 38];
$vpr = [90, 0, 180];
$vpd =
    size == "small" ? 190
    : size == "large" ? 255
    : 220;

hub75_corner_edge_coupler_rear_fit_section(
    side = "right",
    panel = panel,
    coupler = coupler,
    depth = section_depth
);
