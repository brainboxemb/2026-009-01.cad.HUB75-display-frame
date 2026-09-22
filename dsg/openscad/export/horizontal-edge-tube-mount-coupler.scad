// STL export entrypoint for the horizontal-edge tube-mount coupler.

use <../ext/lib.scad.forge/openscad/resolution.scad>
use <../components/hub75/horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>
use <../project_components/tube_mount/horizontal-edge-coupler/hub75_tube_horizontal_edge_coupler.scad>

// tool.scad-project multi-size adapter: overridden by -D size=...
size = "medium";
d_profile = size;
_coupler = hub75_horizontal_edge_coupler_create_for_size(size = d_profile);

hub75_tube_horizontal_edge_coupler_build(
    _coupler,
    resolution = FG_RES_EXPORT()
);
