// XY section through the integral lib.scad.mechint lock in the right tube mount.

use <../../dsg/openscad/ext/lib.scad.util/openscad/inspection.scad>
use <../../dsg/openscad/assemblies/verification/dovetail_tube_clamp_fit_assembly.scad>
use <../../dsg/openscad/project_components/horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>
use <../../dsg/openscad/project_components/tube_mount/tube_mount_couplers.scad>
use <../../dsg/openscad/project_components/tube_mount/dovetail_tube_clamp.scad>

size = "medium";

coupler =
    hub75_horizontal_edge_coupler_create_for_size(
        size = size
    );
clamp =
    hub75_dovetail_tube_clamp_create();
clip_x =
    hub75_tube_mount_clip_offset(
        coupler.profile_size
    );
section_depth = 0.20;

$vpt = [clip_x, 2.5, clamp.dovetail_center_z];
$vpr = [0, 0, 180];
$vpd = 72;

util_section_inspect(
    axis = "Z",
    position =
        clamp.dovetail_center_z
        - section_depth / 2,
    depth = section_depth,
    direction = "Positive"
)
    hub75_dovetail_tube_clamp_fit_assembly(
        size = size,
        show_tube = false
    );
