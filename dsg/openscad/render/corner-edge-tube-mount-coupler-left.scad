// PNG render entrypoint for the left corner-edge tube-mount coupler.

use <../ext/lib.scad.forge/openscad/resolution.scad>
use <../components/hub75/corner-edge-coupler/hub75_corner_edge_coupler.scad>
use <../project_components/tube_mount/corner-edge-coupler/hub75_tube_corner_edge_coupler.scad>

// tool.scad-project multi-size adapter: overridden by -D size=...
size = "medium";
d_profile = size;
_coupler_obj = hub75_corner_edge_coupler_create_for_size(side = "left", size = d_profile);

$vpt = [18, _coupler_obj.base_thickness / 2, -10];
$vpr = [68, 0, 35];
$vpd = d_profile == "small" ? 145 : d_profile == "large" ? 235 : 190;

hub75_tube_corner_edge_coupler_build(
    _coupler_obj,
    resolution = FG_RES_HIGH()
);
