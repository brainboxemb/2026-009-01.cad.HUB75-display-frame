// PNG render entrypoint for the horizontal-edge tube-mount coupler.

use <../ext/lib.scad.forge/openscad/resolution.scad>
use <../components/hub75/horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>
use <../project_components/tube_mount/horizontal-edge-coupler/hub75_tube_horizontal_edge_coupler.scad>

RENDER_PROFILE = "medium";
_coupler = hub75_horizontal_edge_coupler_create_for_size(size = RENDER_PROFILE);

$vpt = [0, _coupler.base_thickness / 2, 0];
$vpr = [68, 0, 35];
$vpd = RENDER_PROFILE == "small" ? 150 : RENDER_PROFILE == "large" ? 250 : 200;

hub75_tube_horizontal_edge_coupler_build(
    _coupler,
    resolution = FG_RES_HIGH()
);
