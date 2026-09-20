// Focused assembled view of a tube-mount coupler with the canonical clamp.

use <../../dsg/openscad/assemblies/verification/dovetail_tube_clamp_fit_assembly.scad>

size = "medium";

$vpt = [28, -2, 8];
$vpr = [68, 0, 35];
$vpd = 125;

hub75_dovetail_tube_clamp_fit_assembly(
    size = size
);
