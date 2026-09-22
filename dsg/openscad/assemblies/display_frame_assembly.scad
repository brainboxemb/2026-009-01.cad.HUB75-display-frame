// File: display_frame_assembly.scad
//   Complete display overview with couplers and detachable tube-mount layer.

use <../ext/lib.scad.hub75/openscad/p5-64x32-panel/hub75_p5_64x32_panel.scad>
use <../ext/lib.scad.forge/openscad/resolution.scad>
use <../components/aluminium_tube.scad>
use <panels_assembly.scad>
use <helpers/reference_box.scad>
use <../components/hub75/middle-coupler/hub75_middle_coupler.scad>
use <../components/hub75/horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>
use <../components/hub75/corner-edge-coupler/hub75_corner_edge_coupler.scad>
use <../project_components/tube_mount/horizontal-edge-coupler/hub75_tube_horizontal_edge_coupler.scad>
use <../project_components/tube_mount/corner-edge-coupler/hub75_tube_corner_edge_coupler.scad>
use <../project_components/tube_mount/tube-clamp/hub75_tube_clamp.scad>
use <../project_components/tube_mount/tube_mount_interface.scad>

function _hub75_display_frame_panel_pitch_x(panel) =
    hub75_p5_64x32_panel_nominal_width(panel);

function _hub75_display_frame_half_height(panel) =
    hub75_p5_64x32_panel_nominal_height(panel) / 2;

function _hub75_display_frame_half_width(panel, panel_count = 5) =
    panel_count * _hub75_display_frame_panel_pitch_x(panel) / 2;

function _hub75_display_frame_seam_x(panel, seam_index, panel_count = 5) =
    -_hub75_display_frame_half_width(panel, panel_count)
    + (seam_index + 1) * _hub75_display_frame_panel_pitch_x(panel);

function hub75_display_frame_reference_width(panel, panel_count = 5) =
    panel_count * hub75_p5_64x32_panel_nominal_width(panel) + 40;

function hub75_display_frame_reference_height(panel) =
    hub75_p5_64x32_panel_nominal_height(panel) + 40;

function hub75_display_frame_tube_length(panel, panel_count = 5) =
    hub75_display_frame_reference_width(panel, panel_count);

module _hub75_display_frame_middle_couplers(
    panel,
    coupler,
    panel_count,
    mounting_y,
    coupler_color
) {
    color(coupler_color)
        for (seam_index = [0 : panel_count - 2])
            translate([
                _hub75_display_frame_seam_x(panel, seam_index, panel_count),
                mounting_y,
                0
            ])
                hub75_middle_coupler_build(coupler);
}

module _hub75_display_frame_horizontal_edge_couplers(
    panel,
    coupler,
    panel_count,
    mounting_y,
    coupler_color,
    tube_mount_enabled,
    resolution
) {
    edge_z = _hub75_display_frame_half_height(panel);

    color(coupler_color)
        for (seam_index = [0 : panel_count - 2]) {
            seam_x =
                _hub75_display_frame_seam_x(panel, seam_index, panel_count);

            translate([seam_x, mounting_y, edge_z])
                if (tube_mount_enabled)
                    hub75_tube_horizontal_edge_coupler_build(coupler, resolution = resolution);
                else
                    hub75_horizontal_edge_coupler_build(coupler);

            translate([seam_x, mounting_y, -edge_z])
                rotate([0, 180, 0])
                    if (tube_mount_enabled)
                        hub75_tube_horizontal_edge_coupler_build(coupler, resolution = resolution);
                    else
                        hub75_horizontal_edge_coupler_build(coupler);
        }
}

module _hub75_display_frame_corner_couplers(
    panel,
    left_coupler,
    right_coupler,
    panel_count,
    mounting_y,
    coupler_color,
    tube_mount_enabled,
    resolution
) {
    edge_x = _hub75_display_frame_half_width(panel, panel_count);
    edge_z = _hub75_display_frame_half_height(panel);

    color(coupler_color) {
        translate([-edge_x, mounting_y, edge_z])
            if (tube_mount_enabled)
                hub75_tube_corner_edge_coupler_build(left_coupler, resolution = resolution);
            else
                hub75_corner_edge_coupler_build(left_coupler);

        translate([edge_x, mounting_y, edge_z])
            if (tube_mount_enabled)
                hub75_tube_corner_edge_coupler_build(right_coupler, resolution = resolution);
            else
                hub75_corner_edge_coupler_build(right_coupler);

        translate([edge_x, mounting_y, -edge_z])
            rotate([0, 180, 0])
                if (tube_mount_enabled)
                    hub75_tube_corner_edge_coupler_build(left_coupler, resolution = resolution);
                else
                    hub75_corner_edge_coupler_build(left_coupler);

        translate([-edge_x, mounting_y, -edge_z])
            rotate([0, 180, 0])
                if (tube_mount_enabled)
                    hub75_tube_corner_edge_coupler_build(right_coupler, resolution = resolution);
                else
                    hub75_corner_edge_coupler_build(right_coupler);
    }
}

module _hub75_display_frame_tube_clamps(
    panel,
    horizontal_coupler,
    left_coupler,
    right_coupler,
    panel_count,
    mounting_y,
    clamp_color,
    resolution
) {
    edge_x = _hub75_display_frame_half_width(panel, panel_count);
    edge_z = _hub75_display_frame_half_height(panel);

    horizontal_positions =
        hub75_tube_horizontal_edge_clamp_positions_mm(horizontal_coupler);
    left_x = hub75_tube_corner_edge_clamp_x_mm(left_coupler);
    right_x = hub75_tube_corner_edge_clamp_x_mm(right_coupler);

    horizontal_clamp =
        hub75_tube_clamp_create(
            dovetail =
                hub75_tube_mount_dovetail_create(
                    host_depth_mm = horizontal_coupler.base_thickness
                )
        );
    left_clamp =
        hub75_tube_clamp_create(
            dovetail =
                hub75_tube_mount_dovetail_create(
                    host_depth_mm = left_coupler.base_thickness
                )
        );
    right_clamp =
        hub75_tube_clamp_create(
            dovetail =
                hub75_tube_mount_dovetail_create(
                    host_depth_mm = right_coupler.base_thickness
                )
        );

    for (seam_index = [0 : panel_count - 2]) {
        seam_x =
            _hub75_display_frame_seam_x(panel, seam_index, panel_count);

        for (clip_x = horizontal_positions) {
            translate([seam_x + clip_x, mounting_y, edge_z])
                hub75_tube_clamp_build(
                    horizontal_clamp,
                    part_color = clamp_color,
                    use_tension_bore = false,
                    resolution = resolution
                );

            translate([seam_x - clip_x, mounting_y, -edge_z])
                rotate([0, 180, 0])
                    hub75_tube_clamp_build(
                        horizontal_clamp,
                        part_color = clamp_color,
                        use_tension_bore = false,
                        resolution = resolution
                    );
        }
    }

    translate([-edge_x + left_x, mounting_y, edge_z])
        hub75_tube_clamp_build(
            left_clamp,
            part_color = clamp_color,
            use_tension_bore = false,
            resolution = resolution
        );

    translate([edge_x + right_x, mounting_y, edge_z])
        hub75_tube_clamp_build(
            right_clamp,
            part_color = clamp_color,
            use_tension_bore = false,
            resolution = resolution
        );

    translate([edge_x - left_x, mounting_y, -edge_z])
        rotate([0, 180, 0])
            hub75_tube_clamp_build(
                left_clamp,
                part_color = clamp_color,
                use_tension_bore = false,
                resolution = resolution
            );

    translate([-edge_x - right_x, mounting_y, -edge_z])
        rotate([0, 180, 0])
            hub75_tube_clamp_build(
                right_clamp,
                part_color = clamp_color,
                use_tension_bore = false,
                resolution = resolution
            );
}

module _hub75_display_frame_aluminium_tubes(
    panel,
    panel_count,
    mounting_y,
    resolution,
    top_z_shift = 0,
    bottom_z_shift = 0,
    tube_color = [0.72, 0.74, 0.76, 1]
) {
    edge_z = _hub75_display_frame_half_height(panel);
    length = hub75_display_frame_tube_length(panel, panel_count);
    x_min = -length / 2;
    clamp = hub75_tube_clamp_create();
    tube =
        aluminium_tube_create(
            length_mm = length,
            outer_diameter_mm = clamp.base_clamp.tube_diameter,
            wall_thickness_mm = 1
        );
    tube_y =
        mounting_y
        + hub75_tube_clamp_tube_center_y_mm(clamp);
    tube_z =
        edge_z
        + hub75_tube_clamp_tube_center_z_mm(clamp);

    color(tube_color) {
        translate([x_min, tube_y, tube_z + top_z_shift])
            aluminium_tube_build(tube, resolution = resolution);

        translate([x_min, tube_y, -tube_z + bottom_z_shift])
            aluminium_tube_build(tube, resolution = resolution);
    }
}

module _hub75_display_frame_debug_reference(panel, panel_count) {
    width = hub75_display_frame_reference_width(panel, panel_count);
    height = hub75_display_frame_reference_height(panel);

    hub75_reference_box_wireframe(
        x_min = -width / 2,
        x_max = width / 2,
        y_min = 0,
        y_max = hub75_p5_64x32_panel_mounting_plane_y(panel),
        z_min = -height / 2,
        z_max = height / 2
    );
}

module hub75_display_frame_assembly(
    panel = hub75_p5_64x32_panel_create(),
    coupler_size = "medium",
    panel_count = 5,
    panel_color_scheme = "light_gray",
    panel_view = hub75_p5_64x32_panel_view_id("final"),
    coupler_color = [0.72, 0.05, 0.04, 1],
    clamp_color = [0.92, 0.20, 0.08, 1],
    tube_color = [0.72, 0.74, 0.76, 1],
    resolution = FG_RES_HIGH(),
    panels_visible = true,
    middle_couplers_visible = true,
    horizontal_edge_couplers_visible = true,
    corner_edge_couplers_visible = true,
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
    assert(explode_distance >= 0, "explode_distance must be >= 0");

    hub75_display_verify_nominal_size(
        panel = panel,
        panel_count = panel_count
    );

    active_middle_coupler =
        is_undef(middle_coupler)
            ? hub75_middle_coupler_create_for_size(
                size = coupler_size,
                panel = panel
            )
            : middle_coupler;
    active_horizontal_coupler =
        is_undef(horizontal_coupler)
            ? hub75_horizontal_edge_coupler_create_for_size(
                size = coupler_size,
                panel = panel
            )
            : horizontal_coupler;
    active_left_corner_coupler =
        is_undef(left_corner_coupler)
            ? hub75_corner_edge_coupler_create_for_size(
                side = "left",
                size = coupler_size,
                panel = panel
            )
            : left_corner_coupler;
    active_right_corner_coupler =
        is_undef(right_corner_coupler)
            ? hub75_corner_edge_coupler_create_for_size(
                side = "right",
                size = coupler_size,
                panel = panel
            )
            : right_corner_coupler;

    exploded = explode_distance > 0;
    panel_y_shift = exploded ? -explode_distance : 0;
    coupler_y_shift = exploded ? explode_distance : 0;
    clamp_y_shift = exploded ? 2 * explode_distance : 0;
    tube_y_shift = clamp_y_shift;
    tube_z_gap = exploded ? 0.55 * explode_distance : 0;

    base_mounting_y =
        hub75_p5_64x32_panel_mounting_plane_y(panel);
    coupler_mounting_y =
        base_mounting_y + coupler_y_shift;
    clamp_mounting_y =
        base_mounting_y + clamp_y_shift;
    tube_mounting_y =
        base_mounting_y + tube_y_shift;

    if (panels_visible)
        translate([0, panel_y_shift, 0])
            hub75_panels_assembly(
                panel = panel,
                panel_count = panel_count,
                color_scheme = panel_color_scheme,
                panel_view = panel_view
            );

    if (middle_couplers_visible)
        _hub75_display_frame_middle_couplers(
            panel,
            active_middle_coupler,
            panel_count,
            coupler_mounting_y,
            coupler_color
        );

    if (horizontal_edge_couplers_visible)
        _hub75_display_frame_horizontal_edge_couplers(
            panel,
            active_horizontal_coupler,
            panel_count,
            coupler_mounting_y,
            coupler_color,
            tube_mount_enabled,
            resolution
        );

    if (corner_edge_couplers_visible)
        _hub75_display_frame_corner_couplers(
            panel,
            active_left_corner_coupler,
            active_right_corner_coupler,
            panel_count,
            coupler_mounting_y,
            coupler_color,
            tube_mount_enabled,
            resolution
        );

    if (tube_mount_enabled && tube_clamps_visible)
        _hub75_display_frame_tube_clamps(
            panel,
            active_horizontal_coupler,
            active_left_corner_coupler,
            active_right_corner_coupler,
            panel_count,
            clamp_mounting_y,
            clamp_color,
            resolution
        );

    if (tube_mount_enabled && aluminium_tubes_visible)
        _hub75_display_frame_aluminium_tubes(
            panel,
            panel_count,
            tube_mounting_y,
            resolution,
            top_z_shift = tube_z_gap,
            bottom_z_shift = -tube_z_gap,
            tube_color = tube_color
        );

    if (debug_reference_visible)
        _hub75_display_frame_debug_reference(panel, panel_count);
}
