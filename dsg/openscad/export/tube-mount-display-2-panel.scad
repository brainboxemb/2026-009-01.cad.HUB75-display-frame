// STL inspection export: complete tube-mount assembly with two panels.
//
// The interactive/source assembly lives under assemblies; this file is only
// the deterministic STL export entrypoint.

use <../assemblies/tube_mount_display_2_panel_assembly.scad>

hub75_tube_mount_display_2_panel_assembly(
    coupler_size = "medium",
    tube_mount_enabled = true,
    tube_clamps_visible = true,
    aluminium_tubes_visible = true,
    debug_reference_visible = false,
    explode_distance = 0
);
