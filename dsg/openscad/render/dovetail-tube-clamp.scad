// PNG render entrypoint for the separately printable dovetail tube clamp.

use <../project_components/horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>
use <../project_components/reinforcement/dovetail_tube_clamp.scad>

size = "medium";

coupler =
    hub75_horizontal_edge_coupler_create_for_size(
        size = size
    );

$vpt = [0, -4, 6];
$vpr = [68, 0, 35];
$vpd = 95;

hub75_reinforcement_dovetail_tube_clamp(
    coupler_base_thickness = coupler.base_thickness
);
