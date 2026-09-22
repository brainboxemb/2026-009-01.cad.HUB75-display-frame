// STL export entrypoint for the size-matched detachable dovetail tube clamp.

use <../ext/lib.scad.forge/openscad/resolution.scad>
use <../project_components/tube_mount/tube-clamp/hub75_tube_clamp.scad>

// tool.scad-project multi-size adapter: overridden by -D size=...
size = "medium";
d_profile = size;
_clamp = hub75_tube_clamp_create_for_size(d_profile);

hub75_tube_clamp_build(
    _clamp,
    resolution = FG_RES_EXPORT()
);
