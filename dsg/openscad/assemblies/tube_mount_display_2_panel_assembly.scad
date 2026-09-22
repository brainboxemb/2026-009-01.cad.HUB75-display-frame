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
use <../ext/lib.scad.forge/openscad/resolution.scad>
use <display_frame_assembly.scad>

function hub75_tube_mount_display_2_panel_count() = 2;

function hub75_tube_mount_display_2_panel_reference_width(panel_obj) =
    hub75_display_frame_reference_width(
        panel_obj,
        hub75_tube_mount_display_2_panel_count()
    );

function hub75_tube_mount_display_2_panel_reference_height(panel_obj) =
    hub75_display_frame_reference_height(panel_obj);

module hub75_tube_mount_display_2_panel_assembly(
    panel_obj = hub75_p5_64x32_panel_create(),
    coupler_size = "medium",
    panel_view = hub75_p5_64x32_panel_view_id("final"),
    resolution = FG_RES_HIGH(),
    panel_numbers_visible = false,
    in_out_labels_visible = false,
    tube_mount_enabled = true,
    tube_clamps_visible = true,
    aluminium_tubes_visible = true,
    debug_reference_visible = false,
    explode_distance = 0,
    middle_coupler_obj = undef,
    horizontal_coupler_obj = undef,
    left_corner_coupler_obj = undef,
    right_corner_coupler_obj = undef
) {
    hub75_display_frame_assembly(
        panel_obj = panel_obj,
        coupler_size = coupler_size,
        panel_count = hub75_tube_mount_display_2_panel_count(),
        panel_view = panel_view,
        resolution = resolution,
        panels_visible = true,
        panel_numbers_visible = panel_numbers_visible,
        in_out_labels_visible = in_out_labels_visible,
        middle_couplers_visible = true,
        horizontal_edge_couplers_visible = true,
        corner_edge_couplers_visible = true,
        tube_mount_enabled = tube_mount_enabled,
        tube_clamps_visible = tube_clamps_visible,
        aluminium_tubes_visible = aluminium_tubes_visible,
        debug_reference_visible = debug_reference_visible,
        explode_distance = explode_distance,
        middle_coupler_obj = middle_coupler_obj,
        horizontal_coupler_obj = horizontal_coupler_obj,
        left_corner_coupler_obj = left_corner_coupler_obj,
        right_corner_coupler_obj = right_corner_coupler_obj
    );
}


/* [Preview] */
d_coupler_profile = "medium"; // [small,medium,large]
c_resolution = "high"; // [low,high,export]
c_show_tube_mount = true;
c_show_tube_clamps = true;
c_show_aluminium_tubes = true;
c_show_debug_reference = false;
c_show_panel_numbers = false;
c_show_in_out_labels = false;
c_explode_distance_mm = 0; // [0:5:80]

fg_res_apply(c_resolution) {
    hub75_tube_mount_display_2_panel_assembly(
        coupler_size = d_coupler_profile,
        resolution = c_resolution,
        panel_numbers_visible = c_show_panel_numbers,
        in_out_labels_visible = c_show_in_out_labels,
        tube_mount_enabled = c_show_tube_mount,
        tube_clamps_visible = c_show_tube_clamps,
        aluminium_tubes_visible = c_show_aluminium_tubes,
        debug_reference_visible = c_show_debug_reference,
        explode_distance = c_explode_distance_mm
    );
}
