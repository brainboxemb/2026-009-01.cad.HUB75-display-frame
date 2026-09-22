// STL export entrypoint for the right corner-edge tube-mount coupler.

use <../ext/lib.scad.forge/openscad/resolution.scad>
use <../components/hub75/corner-edge-coupler/hub75_corner_edge_coupler.scad>
use <../project_components/tube_mount/corner-edge-coupler/hub75_tube_corner_edge_coupler.scad>

// tool.scad-project multi-size adapter: overridden by -D size=...
size = "medium";
d_profile = size;
_coupler = hub75_corner_edge_coupler_create_for_size(side = "right", size = d_profile);

hub75_tube_corner_edge_coupler_build(
    _coupler,
    resolution = FG_RES_EXPORT()
);
