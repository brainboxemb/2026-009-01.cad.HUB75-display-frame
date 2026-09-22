// Focused YZ section through the vertical lib.scad.mechint lock.
// With the dovetail slide rotated into project Z, this plane shows the
// threshold ramp, male recess/release and female spring along insertion travel.

use <../../dsg/openscad/ext/lib.scad.util/openscad/inspection.scad>
use <../../dsg/openscad/assemblies/verification/hub75_tube_horizontal_edge_fit_assembly.scad>
use <../../dsg/openscad/components/hub75/horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>
use <../../dsg/openscad/project_components/tube_mount/horizontal-edge-coupler/hub75_tube_horizontal_edge_coupler.scad>

size = "medium";

coupler =
    hub75_horizontal_edge_coupler_create_for_size(
        size = size
    );
clip_positions =
    hub75_tube_horizontal_edge_clamp_positions_mm(coupler);
clip_x = clip_positions[len(clip_positions) - 1];

$vpt = [clip_x, 0.8, 0];
$vpr = [0, 90, 0];
$vpd = 62;

util_section_inspect(
    axis = "X",
    position = clip_x - 0.10,
    depth = 0.20,
    direction = "Positive"
)
    hub75_tube_horizontal_edge_fit_assembly(
        size = size,
        show_tube = false
    );
