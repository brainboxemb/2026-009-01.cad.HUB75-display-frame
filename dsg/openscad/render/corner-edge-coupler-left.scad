// PNG render entrypoint for the left corner-edge coupler.

use <../components/hub75/corner-edge-coupler/hub75_corner_edge_coupler.scad>

// tool.scad-project multi-size adapter: overridden by -D size=...
size = "medium";
d_profile = size;

coupler_obj =
    hub75_corner_edge_coupler_create_for_size(
        side = "left",
        size = d_profile
    );

reach =
    hub75_corner_edge_coupler_inward_reach(coupler_obj);
view_center =
    (reach - coupler_obj.outside_projection) / 2;

$vpt = [
    coupler_obj.x_inward * view_center,
    0,
    -view_center
];
$vpr = [68, 0, 35];
$vpd =
    d_profile == "small" ? 150
    : d_profile == "large" ? 250
    : 200;

hub75_corner_edge_coupler_render(
    coupler_obj,
    view = "final"
);
