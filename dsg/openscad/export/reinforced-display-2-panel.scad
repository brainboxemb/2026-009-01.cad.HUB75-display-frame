// STL inspection export: complete reinforced assembly with two panels.
//
// Two panels are enough to show one internal seam plus all four outer corners,
// both reinforcement tubes and every detachable clamp type, while keeping the
// generated STL practical to publish and inspect.

use <../assemblies/display_frame_assembly.scad>

hub75_display_frame_assembly(
    coupler_size = "medium",
    panel_count = 2,
    panels_visible = true,
    middle_couplers_visible = true,
    horizontal_edge_couplers_visible = true,
    corner_edge_couplers_visible = true,
    reinforcement_enabled = true,
    reinforcement_clamps_visible = true,
    reinforcement_tubes_visible = true,
    debug_reference_visible = false,
    explode_distance = 0
);
