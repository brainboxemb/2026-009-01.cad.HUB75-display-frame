// File: middle-coupler-xy-seam-section.scad
//   True XY section below the horizontal rib, through the seam locator.

use <../../dsg/openscad/assemblies/middle_coupler_fit_assembly.scad>

$vpt = [0, 7, -20];
$vpr = [0, 0, 0];
$vpd = 185;

hub75_middle_coupler_fit_cross_section();
