// XY section through the vertical panel seam, inward from the top edge.

use <../../dsg/openscad/assemblies/verification/horizontal_edge_coupler_fit_assembly.scad>
use <../../dsg/openscad/project_components/horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>

size = "medium";

$vpt = [0, 7, 138];
$vpr = [0, 0, 0];
$vpd = 185;

coupler =
    hub75_horizontal_edge_coupler_create_for_size(
        size = size
    );

hub75_horizontal_edge_coupler_xy_seam_section(
    coupler = coupler
);
