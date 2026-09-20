// PNG render entrypoint for the one canonical detachable dovetail tube clamp.

use <../project_components/tube_mount/tube-clamp/hub75_tube_clamp.scad>

clamp = hub75_tube_clamp_create();

$vpt = [0, -3.5, 10];
$vpr = [74, 0, 35];
$vpd = 90;

hub75_tube_clamp_build(
    clamp,
    use_tension_bore = false,
    high_resolution = true
);
