// PNG render entrypoint for the size-matched detachable dovetail tube clamp.

use <../ext/lib.scad.forge/openscad/resolution.scad>
use <../project_components/tube_mount/tube-clamp/hub75_tube_clamp.scad>

// tool.scad-project multi-size adapter: overridden by -D size=...
size = "medium";
d_profile = size;
_clamp_obj = hub75_tube_clamp_create_for_size(d_profile);

$vpt = [0, -3.5, 10];
$vpr = [74, 0, 35];
$vpd = 90;

hub75_tube_clamp_build(
    _clamp_obj,
    use_tension_bore = false,
    resolution = FG_RES_HIGH()
);
