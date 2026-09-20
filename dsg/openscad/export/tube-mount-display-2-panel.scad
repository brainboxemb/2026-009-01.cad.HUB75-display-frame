// STL inspection export: complete tube-mount assembly with two panels.
//
// Two panels show one internal seam, all four outer corners, both aluminium
// tubes and the canonical detachable clamp without the huge five-panel STL.

use <../assemblies/display_frame_assembly.scad>

hub75_display_frame_assembly(
    coupler_size = "medium",
    panel_count = 2,
    panels_visible = true,
    middle_couplers_visible = true,
    horizontal_edge_couplers_visible = true,
    corner_edge_couplers_visible = true,
    tube_mount_enabled = true,
    tube_clamps_visible = true,
    aluminium_tubes_visible = true,
    debug_reference_visible = false,
    explode_distance = 0
);
