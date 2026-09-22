// PNG render entrypoint for the horizontal-edge coupler.

use <../components/hub75/horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>

// tool.scad-project multi-size adapter: overridden by -D size=...
size = "medium";
d_profile = size;

coupler =
    hub75_horizontal_edge_coupler_create_for_size(
        size = d_profile
    );

$vpt = [
    0,
    0,
    -hub75_horizontal_edge_coupler_inward_reach(coupler) / 2
];
$vpr = [68, 0, 35];
$vpd =
    d_profile == "small" ? 150
    : d_profile == "large" ? 250
    : 200;

hub75_horizontal_edge_coupler_render(coupler, view = "final");
