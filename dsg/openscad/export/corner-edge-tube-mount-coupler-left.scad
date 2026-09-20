// STL export entrypoint for the left corner-edge tube-mount coupler.

use <../components/hub75/corner-edge-coupler/hub75_corner_edge_coupler.scad>
use <../project_components/tube_mount/corner-edge-coupler/hub75_tube_corner_edge_coupler.scad>

size = "medium";
coupler = hub75_corner_edge_coupler_create_for_size(side = "left", size = size);

hub75_tube_corner_edge_coupler_build(coupler);
