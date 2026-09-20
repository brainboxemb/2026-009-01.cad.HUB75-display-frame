// Focused assembled view of the medium detachable tube clamp and dovetail.

use <../../dsg/openscad/assemblies/verification/dovetail_tube_clip_fit_assembly.scad>

size = "medium";

$vpt = [28, -2, 4];
$vpr = [68, 0, 35];
$vpd = 125;

hub75_dovetail_tube_clip_fit_assembly(
    size = size
);
