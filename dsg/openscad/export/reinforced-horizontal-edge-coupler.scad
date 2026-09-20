// STL export entrypoint for the reinforced horizontal-edge coupler.

use <../project_components/horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>
use <../project_components/reinforcement/reinforced_couplers.scad>

size = "medium";

coupler =
    hub75_horizontal_edge_coupler_create_for_size(
        size = size
    );

hub75_reinforced_horizontal_edge_coupler_build(coupler);
