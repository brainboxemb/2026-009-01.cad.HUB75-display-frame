// Official detail render for the new middle coupler.

use <../project_components/middle-coupler/hub75_middle_coupler.scad>

$vpt = [0, 0, 0];
$vpr = [68, 0, 35];
$vpd = 150;

coupler = hub75_middle_coupler_create();
hub75_middle_coupler_render(coupler, view = "final");
