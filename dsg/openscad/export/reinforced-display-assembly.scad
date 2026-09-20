// STL export entrypoint for the complete reinforced five-panel assembly.
//
// This is intentionally a whole-model inspection STL: panels, reinforced
// couplers, separate clamps and both aluminium tubes are all present.

use <../assemblies/display_frame_assembly.scad>

size = "medium";

hub75_display_frame_assembly(
    coupler_size = size,
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
