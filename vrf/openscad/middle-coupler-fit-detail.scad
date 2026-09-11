// File: middle-coupler-fit-detail.scad
//   Angled two-panel context view for middle-coupler verification.

use <../../dsg/openscad/assemblies/verification/middle_coupler_fit_assembly.scad>
use <../../dsg/openscad/project_components/middle-coupler/hub75_middle_coupler.scad>

size = "medium";

$vpt = [0, 14, 0];
$vpr = [78, 0, 220];
$vpd = 230;

coupler = hub75_middle_coupler_create_for_size(size = size);
hub75_middle_coupler_fit_detail(coupler = coupler);
