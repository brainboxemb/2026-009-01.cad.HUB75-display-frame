// File: middle-coupler-xy-seam-section.scad
//   True XY section below the horizontal rib, through the seam locator.

use <../../dsg/openscad/assemblies/verification/middle_coupler_fit_assembly.scad>
use <../../dsg/openscad/project_components/middle-coupler/hub75_middle_coupler.scad>

size = "medium";

$vpt = [0, 7, -20];
$vpr = [0, 0, 0];
$vpd = 185;

coupler = hub75_middle_coupler_create_for_size(size = size);
hub75_middle_coupler_fit_cross_section(coupler = coupler);
