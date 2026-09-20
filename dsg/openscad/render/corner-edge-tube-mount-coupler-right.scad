// PNG render entrypoint for the right corner-edge tube-mount coupler.

use <../project_components/corner-edge-coupler/hub75_corner_edge_coupler.scad>
use <../project_components/tube_mount/tube_mount_couplers.scad>

size = "medium";
coupler = hub75_corner_edge_coupler_create_for_size(side = "right", size = size);

$vpt = [-18, coupler.base_thickness / 2, -10];
$vpr = [68, 0, -35];
$vpd = size == "small" ? 145 : size == "large" ? 235 : 190;

hub75_corner_edge_tube_mount_coupler_build(coupler);
