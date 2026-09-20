// File: hub75_tube_horizontal_edge_fit_assembly.scad
//   Focused verification wrapper around the real horizontal tube-mount
//   subassembly.

use <../sub/hub75_tube_horizontal_edge_assembly.scad>

module hub75_tube_horizontal_edge_fit_assembly(
    size = "medium",
    show_coupler = true,
    show_clamp = true,
    show_tube = true,
    explode_distance = 0,
    clamp_high_resolution = true
) {
    hub75_tube_horizontal_edge_assembly(
        size = size,
        show_coupler = show_coupler,
        show_clamps = show_clamp,
        show_tube = show_tube,
        explode_distance = explode_distance,
        clamp_high_resolution = clamp_high_resolution
    );
}
