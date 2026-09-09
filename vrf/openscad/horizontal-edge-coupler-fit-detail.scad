// Angled two-panel top-edge context for horizontal-edge verification.

use <../../dsg/openscad/assemblies/horizontal_edge_coupler_fit_assembly.scad>
use <../../dsg/openscad/project_components/horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>

size = "medium";

$vpt = [0, 14, 115];
$vpr = [78, 0, 220];
$vpd = 260;

coupler =
    hub75_horizontal_edge_coupler_create_for_size(
        size = size
    );

hub75_horizontal_edge_coupler_fit_detail(
    coupler = coupler
);
