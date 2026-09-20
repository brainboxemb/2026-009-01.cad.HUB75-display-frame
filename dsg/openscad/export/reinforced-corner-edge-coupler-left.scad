// STL export entrypoint for the reinforced left corner-edge coupler.

use <../project_components/corner-edge-coupler/hub75_corner_edge_coupler.scad>
use <../project_components/reinforcement/reinforced_couplers.scad>

size = "medium";

coupler =
    hub75_corner_edge_coupler_create_for_size(
        side = "left",
        size = size
    );

hub75_reinforced_corner_edge_coupler_build(coupler);
