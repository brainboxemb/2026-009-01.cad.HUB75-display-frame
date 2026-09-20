// STL export entrypoint for the size-matched detachable dovetail tube clamp.

use <../project_components/tube_mount/tube-clamp/hub75_tube_clamp.scad>

size = "medium";
clamp = hub75_tube_clamp_create_for_size(size);

hub75_tube_clamp_build(clamp);
