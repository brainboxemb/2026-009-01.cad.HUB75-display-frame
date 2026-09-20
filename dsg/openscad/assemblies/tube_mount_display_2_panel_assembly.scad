// File: tube_mount_display_2_panel_assembly.scad
//   Compact two-panel integration assembly for the detachable tube-mount layer.
//
// This is the normal interactive inspection entrypoint. Two panels retain one
// internal seam plus all four outside corners while keeping the complete model
// much smaller than the five-panel display.
//
// The shared reference-envelope rule is intentionally retained here:
//   nominal panel array = 320 x 320 mm
//   reference margin    = 20 mm on every outer edge
//   debug frame         = 360 x 360 mm (X/Z = -180 .. +180)
// The tube centres stay at Z = +/-170 mm, 10 mm inside that frame.

use <../ext/lib.scad.hub75/openscad/p5-64x32-panel/hub75_p5_64x32_panel.scad>
use <display_frame_assembly.scad>

function hub75_tube_mount_display_2_panel_count() = 2;

function hub75_tube_mount_display_2_panel_reference_width(panel) =
    hub75_display_frame_reference_width(
        panel,
        hub75_tube_mount_display_2_panel_count()
    );

function hub75_tube_mount_display_2_panel_reference_height(panel) =
    hub75_display_frame_reference_height(panel);

module hub75_tube_mount_display_2_panel_assembly(
    panel = hub75_p5_64x32_panel_create(),
    coupler_size = "medium",
    panel_view = hub75_p5_64x32_panel_view_id("final"),
    clamp_render_fn = 192,
    tube_mount_enabled = true,
    tube_clamps_visible = true,
    aluminium_tubes_visible = true,
    debug_reference_visible = false,
    explode_distance = 0,
    middle_coupler = undef,
    horizontal_coupler = undef,
    left_corner_coupler = undef,
    right_corner_coupler = undef
) {
    hub75_display_frame_assembly(
        panel = panel,
        coupler_size = coupler_size,
        panel_count = hub75_tube_mount_display_2_panel_count(),
        panel_view = panel_view,
        clamp_render_fn = clamp_render_fn,
        panels_visible = true,
        middle_couplers_visible = true,
        horizontal_edge_couplers_visible = true,
        corner_edge_couplers_visible = true,
        tube_mount_enabled = tube_mount_enabled,
        tube_clamps_visible = tube_clamps_visible,
        aluminium_tubes_visible = aluminium_tubes_visible,
        debug_reference_visible = debug_reference_visible,
        explode_distance = explode_distance,
        middle_coupler = middle_coupler,
        horizontal_coupler = horizontal_coupler,
        left_corner_coupler = left_corner_coupler,
        right_corner_coupler = right_corner_coupler
    );
}


/* [Preview] */
preview_coupler_size = "medium"; // [small,medium,large]
show_tube_mount = true;
show_tube_clamps = true;
show_aluminium_tubes = true;
show_debug_reference = false;
preview_explode_distance = 0; // [0:5:80]

hub75_tube_mount_display_2_panel_assembly(
    coupler_size = preview_coupler_size,
    tube_mount_enabled = show_tube_mount,
    tube_clamps_visible = show_tube_clamps,
    aluminium_tubes_visible = show_aluminium_tubes,
    debug_reference_visible = show_debug_reference,
    explode_distance = preview_explode_distance
);
