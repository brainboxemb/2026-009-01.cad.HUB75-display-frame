// Official rear-angled full-display overview with the current coupler family.
// Camera values deliberately match the panel-only rear-angled render so both
// images can be compared directly in the repository README.

use <../assemblies/display_frame_assembly.scad>

$vpt = [0, 0, 0];
$vpr = [85, 0, 220];
$vpd = 1050;

hub75_display_frame_assembly(
    coupler_size = "medium"
);
