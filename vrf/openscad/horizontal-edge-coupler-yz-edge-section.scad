// YZ section through the right panel rear end rail near the seam.

use <../../dsg/openscad/assemblies/horizontal_edge_coupler_fit_assembly.scad>
use <../../dsg/openscad/project_components/horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>

size = "medium";

$vpt = [12, 7, 125];
$vpr = [0, 90, 0];
$vpd = 205;

coupler =
    hub75_horizontal_edge_coupler_create_for_size(
        size = size
    );

hub75_horizontal_edge_coupler_yz_edge_section(
    coupler = coupler
);
