// PNG render entrypoint for the right corner-edge coupler.

use <../project_components/corner-edge-coupler/hub75_corner_edge_coupler.scad>

size = "medium";

coupler =
    hub75_corner_edge_coupler_create_for_size(
        side = "right",
        size = size
    );

reach =
    hub75_corner_edge_coupler_inward_reach(coupler);
view_center =
    (reach - coupler.outside_projection) / 2;

$vpt = [
    coupler.x_inward * view_center,
    0,
    -view_center
];
$vpr = [68, 0, 35];
$vpd =
    size == "small" ? 150
    : size == "large" ? 250
    : 200;

hub75_corner_edge_coupler_render(
    coupler,
    view = "final"
);
