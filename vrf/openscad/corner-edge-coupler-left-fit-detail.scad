// Angled top-left panel-corner fit detail.

use <../../dsg/openscad/assemblies/verification/corner_edge_coupler_fit_assembly.scad>
use <../../dsg/openscad/ext/lib.scad.hub75/openscad/p5-64x32-panel/hub75_p5_64x32_panel.scad>
use <../../dsg/openscad/components/hub75/corner-edge-coupler/hub75_corner_edge_coupler.scad>

size = "medium";

panel_obj = hub75_p5_64x32_panel_create();
coupler_obj =
    hub75_corner_edge_coupler_create_for_size(
        side = "left",
        size = size,
        panel_obj = panel_obj
    );

corner_x =
    -hub75_p5_64x32_panel_nominal_width(panel_obj) / 2;
corner_z =
    hub75_p5_64x32_panel_nominal_height(panel_obj) / 2;

$vpt = [corner_x + 35, 14, corner_z - 38];
$vpr = [78, 0, 220];
$vpd =
    size == "small" ? 215
    : size == "large" ? 285
    : 250;

hub75_corner_edge_coupler_fit_detail(
    side = "left",
    panel_obj = panel_obj,
    coupler_obj = coupler_obj
);
