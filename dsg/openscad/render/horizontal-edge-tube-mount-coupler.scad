// PNG render entrypoint for the horizontal-edge tube-mount coupler.

use <../components/hub75/horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>
use <../project_components/tube_mount/horizontal-edge-coupler/hub75_tube_horizontal_edge_coupler.scad>

size = "medium";
coupler = hub75_horizontal_edge_coupler_create_for_size(size = size);

$vpt = [0, coupler.base_thickness / 2, 0];
$vpr = [68, 0, 35];
$vpd = size == "small" ? 150 : size == "large" ? 250 : 200;

hub75_tube_horizontal_edge_coupler_build(coupler);
