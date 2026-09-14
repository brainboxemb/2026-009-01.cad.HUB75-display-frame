// Official detail render for the middle coupler.

use <../project_components/middle-coupler/hub75_middle_coupler.scad>

size = "medium";

$vpt = [0, 0, 0];
$vpr = [68, 0, 35];
$vpd =
    size == "small" ? 150
    : size == "large" ? 250
    : 200;

coupler = hub75_middle_coupler_create_for_size(size = size);
hub75_middle_coupler_render(coupler, view = "final");
