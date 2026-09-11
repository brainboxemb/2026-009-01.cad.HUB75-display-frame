// Angled top-right panel-corner fit detail.
// Selective verification cache probe: no geometry change.

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

corner_x =
    hub75_p5_64x32_panel_nominal_width(panel) / 2;
corner_z =
    hub75_p5_64x32_panel_nominal_height(panel) / 2;

$vpt = [corner_x - 35, 14, corner_z - 38];
$vpr = [78, 0, 140];
$vpd =
    size == "small" ? 215
    : size == "large" ? 285
    : 250;

hub75_corner_edge_coupler_fit_detail(
    side = "right",
    panel = panel,
    coupler = coupler
);
