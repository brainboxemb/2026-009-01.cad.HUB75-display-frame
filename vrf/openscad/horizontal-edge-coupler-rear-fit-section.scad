// Rear-facing 0.10 mm fit slice at the top panel edge.

use <../../dsg/openscad/assemblies/verification/horizontal_edge_coupler_fit_assembly.scad>
use <../../dsg/openscad/components/hub75/horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>

size = "medium";

$vpt = [0, 9.5, 115];
$vpr = [90, 0, 180];
$vpd = 235;

coupler_obj =
    hub75_horizontal_edge_coupler_create_for_size(
        size = size
    );

section_depth =
    min(5.0, max(1.0, coupler_obj.guide_height - 1.0));

hub75_horizontal_edge_coupler_rear_fit_section(
    coupler_obj = coupler_obj,
    depth = section_depth,
    slice_thickness = 0.10
);
