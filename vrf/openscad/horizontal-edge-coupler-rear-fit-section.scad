// Rear-facing 5 mm fit section at the top panel edge.

use <../../dsg/openscad/assemblies/verification/horizontal_edge_coupler_fit_assembly.scad>
use <../../dsg/openscad/project_components/horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>

size = "medium";

$vpt = [0, 9.5, 115];
$vpr = [90, 0, 180];
$vpd = 235;

coupler =
    hub75_horizontal_edge_coupler_create_for_size(
        size = size
    );

section_depth =
    min(5.0, max(1.0, coupler.guide_height - 1.0));

hub75_horizontal_edge_coupler_rear_fit_section(
    coupler = coupler,
    depth = section_depth
);
