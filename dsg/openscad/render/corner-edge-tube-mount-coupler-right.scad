// PNG render entrypoint for the right corner-edge tube-mount coupler.

use <../ext/lib.scad.forge/openscad/resolution.scad>
use <../components/hub75/corner-edge-coupler/hub75_corner_edge_coupler.scad>
use <../project_components/tube_mount/corner-edge-coupler/hub75_tube_corner_edge_coupler.scad>

RENDER_PROFILE = "medium";
_coupler = hub75_corner_edge_coupler_create_for_size(side = "right", size = RENDER_PROFILE);

$vpt = [-18, _coupler.base_thickness / 2, -10];
$vpr = [68, 0, -35];
$vpd = RENDER_PROFILE == "small" ? 145 : RENDER_PROFILE == "large" ? 235 : 190;

hub75_tube_corner_edge_coupler_build(
    _coupler,
    resolution = FG_RES_HIGH()
);
