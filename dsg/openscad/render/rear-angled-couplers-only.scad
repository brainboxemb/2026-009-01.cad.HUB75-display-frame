// Official rear-angled overview of the complete current coupler set without panels.

use <../assemblies/display_frame_assembly.scad>

$vpt = [0, 0, 0];
$vpr = [82, 0, 220];
$vpd = 1180;

hub75_display_frame_assembly(
    coupler_size = "medium",
    panels_visible = false
);
