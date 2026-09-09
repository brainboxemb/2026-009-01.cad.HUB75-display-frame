// PNG render entrypoint for the horizontal-edge coupler.

use <../project_components/horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>

size = "medium";

coupler =
    hub75_horizontal_edge_coupler_create_for_size(
        size = size
    );

$vpt = [
    0,
    0,
    -hub75_horizontal_edge_coupler_inward_reach(coupler) / 2
];
$vpr = [68, 0, 35];
$vpd =
    size == "small" ? 150
    : size == "large" ? 250
    : 200;

hub75_horizontal_edge_coupler_build(coupler);
