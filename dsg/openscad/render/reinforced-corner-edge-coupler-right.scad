// PNG render entrypoint for the reinforced right corner-edge coupler.

use <../project_components/corner-edge-coupler/hub75_corner_edge_coupler.scad>
use <../project_components/reinforcement/reinforced_couplers.scad>

size = "medium";

coupler =
    hub75_corner_edge_coupler_create_for_size(
        side = "right",
        size = size
    );

$vpt = [-18, coupler.base_thickness / 2, -10];
$vpr = [68, 0, -35];
$vpd =
    size == "small" ? 145
    : size == "large" ? 235
    : 190;

hub75_reinforced_corner_edge_coupler_build(coupler);
