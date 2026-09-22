// Official detail render for the middle coupler.

use <../components/hub75/middle-coupler/hub75_middle_coupler.scad>

// tool.scad-project multi-size adapter: overridden by -D size=...
size = "medium";
d_profile = size;

$vpt = [0, 0, 0];
$vpr = [68, 0, 35];
$vpd =
    d_profile == "small" ? 150
    : d_profile == "large" ? 250
    : 200;

coupler = hub75_middle_coupler_create_for_size(size = d_profile);
hub75_middle_coupler_render(coupler, view = "final");
