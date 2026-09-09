// File: middle-coupler-rear-fit-section.scad
//   Rear-facing 5 mm fit section through the panel/coupler interface.

use <../../dsg/openscad/assemblies/middle_coupler_fit_assembly.scad>

$vpt = [0, 9.5, 0];
$vpr = [90, 0, 180];
$vpd = 210;

hub75_middle_coupler_rear_fit_section(
    depth = 5.0
);
