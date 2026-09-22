// STL export entrypoint for the right corner-edge tube-mount coupler.

use <../ext/lib.scad.forge/openscad/resolution.scad>
use <../components/hub75/corner-edge-coupler/hub75_corner_edge_coupler.scad>
use <../project_components/tube_mount/corner-edge-coupler/hub75_tube_corner_edge_coupler.scad>

EXPORT_PROFILE = "medium";
_coupler = hub75_corner_edge_coupler_create_for_size(side = "right", size = EXPORT_PROFILE);

hub75_tube_corner_edge_coupler_build(
    _coupler,
    resolution = FG_RES_EXPORT()
);
