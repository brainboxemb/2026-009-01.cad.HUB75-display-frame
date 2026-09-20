// STL export entrypoint for the horizontal-edge tube-mount coupler.

use <../project_components/horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>
use <../project_components/tube_mount/tube_mount_couplers.scad>

size = "medium";
coupler = hub75_horizontal_edge_coupler_create_for_size(size = size);

hub75_horizontal_edge_tube_mount_coupler_build(coupler);
