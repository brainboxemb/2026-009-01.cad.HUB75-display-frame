// YZ section through the assembled dovetail rail, clamp and aluminium tube.

use <../../dsg/openscad/ext/lib.scad.util/openscad/inspection.scad>
use <../../dsg/openscad/assemblies/verification/dovetail_tube_clip_fit_assembly.scad>
use <../../dsg/openscad/project_components/horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>
use <../../dsg/openscad/project_components/reinforcement/dovetail_tube_clamp.scad>

size = "medium";

coupler =
    hub75_horizontal_edge_coupler_create_for_size(
        size = size
    );
clip_x =
    hub75_reinforcement_clip_offset(coupler.profile_size);

$vpt = [clip_x, -2, 4];
$vpr = [0, 90, 0];
$vpd = 95;

util_section_inspect(
    axis = "X",
    position = clip_x - 0.10,
    depth = 0.20,
    direction = "Positive"
)
    hub75_dovetail_tube_clip_fit_assembly(
        size = size
    );
