// STL export entrypoint for the left corner-edge tube-mount coupler.

use <../project_components/corner-edge-coupler/hub75_corner_edge_coupler.scad>
use <../project_components/tube_mount/tube_mount_couplers.scad>

size = "medium";
coupler = hub75_corner_edge_coupler_create_for_size(side = "left", size = size);

hub75_corner_edge_tube_mount_coupler_build(coupler);
