// PNG render entrypoint for the separately printable dovetail tube clamp.

use <../project_components/horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>
use <../project_components/reinforcement/dovetail_tube_clamp.scad>

size = "medium";

coupler =
    hub75_horizontal_edge_coupler_create_for_size(
        size = size
    );
clamp =
    hub75_reinforcement_tube_clamp_create(
        coupler_base_thickness = coupler.base_thickness
    );

$vpt = [0, -3.5, 10];
$vpr = [74, 0, 35];
$vpd = 90;

hub75_reinforcement_tube_clamp_build(clamp);
