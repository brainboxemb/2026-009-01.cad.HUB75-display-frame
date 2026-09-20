// File: display_frame_assembly.scad
//   Complete display overview with couplers and detachable tube-mount layer.

use <../ext/lib.scad.hub75/openscad/p5-64x32-panel/hub75_p5_64x32_panel.scad>
use <../components/aluminium_tube.scad>
use <panels_assembly.scad>
use <helpers/reference_box.scad>
use <../project_components/middle-coupler/hub75_middle_coupler.scad>
use <../project_components/horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>
use <../project_components/corner-edge-coupler/hub75_corner_edge_coupler.scad>
use <../project_components/tube_mount/tube_mount_couplers.scad>
use <../project_components/tube_mount/dovetail_tube_clamp.scad>

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
    tube_mount_enabled
) {
    edge_z = _hub75_display_frame_half_height(panel);

    color(coupler_color)
        for (seam_index = [0 : panel_count - 2]) {
            seam_x =
                _hub75_display_frame_seam_x(panel, seam_index, panel_count);

            translate([seam_x, mounting_y, edge_z])
                if (tube_mount_enabled)
                    hub75_horizontal_edge_tube_mount_coupler_build(coupler);
                else
                    hub75_horizontal_edge_coupler_build(coupler);

            translate([seam_x, mounting_y, -edge_z])
                rotate([0, 180, 0])
                    if (tube_mount_enabled)
                        hub75_horizontal_edge_tube_mount_coupler_build(coupler);
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
    tube_mount_enabled
) {
    edge_x = _hub75_display_frame_half_width(panel, panel_count);
    edge_z = _hub75_display_frame_half_height(panel);

    color(coupler_color) {
        translate([-edge_x, mounting_y, edge_z])
            if (tube_mount_enabled)
                hub75_corner_edge_tube_mount_coupler_build(left_coupler);
            else
                hub75_corner_edge_coupler_build(left_coupler);

        translate([edge_x, mounting_y, edge_z])
            if (tube_mount_enabled)
                hub75_corner_edge_tube_mount_coupler_build(right_coupler);
            else
                hub75_corner_edge_coupler_build(right_coupler);

        translate([edge_x, mounting_y, -edge_z])
            rotate([0, 180, 0])
                if (tube_mount_enabled)
                    hub75_corner_edge_tube_mount_coupler_build(left_coupler);
                else
                    hub75_corner_edge_coupler_build(left_coupler);

        translate([-edge_x, mounting_y, -edge_z])
            rotate([0, 180, 0])
                if (tube_mount_enabled)
                    hub75_corner_edge_tube_mount_coupler_build(right_coupler);
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
    clamp_color
) {
    edge_x = _hub75_display_frame_half_width(panel, panel_count);
    edge_z = _hub75_display_frame_half_height(panel);
    horizontal_offset =
        hub75_tube_mount_clip_offset(horizontal_coupler.profile_size);
    left_offset =
        left_coupler.x_inward
        * hub75_tube_mount_clip_offset(left_coupler.profile_size);
    right_offset =
        right_coupler.x_inward
        * hub75_tube_mount_clip_offset(right_coupler.profile_size);
    clamp = hub75_dovetail_tube_clamp_create();

    for (seam_index = [0 : panel_count - 2]) {
        seam_x =
            _hub75_display_frame_seam_x(panel, seam_index, panel_count);

        for (clip_x = [-horizontal_offset, horizontal_offset]) {
            translate([seam_x, mounting_y, edge_z])
                translate([clip_x, 0, 0])
                    hub75_dovetail_tube_clamp_build(
                        clamp,
                        part_color = clamp_color,
                        entry_side = clip_x < 0 ? -1 : 1
                    );

            translate([seam_x, mounting_y, -edge_z])
                rotate([0, 180, 0])
                    translate([clip_x, 0, 0])
                        hub75_dovetail_tube_clamp_build(
                            clamp,
                            part_color = clamp_color,
                            entry_side = clip_x < 0 ? -1 : 1
                        );
        }
    }

    translate([-edge_x, mounting_y, edge_z])
        translate([left_offset, 0, 0])
            hub75_dovetail_tube_clamp_build(
                clamp,
                part_color = clamp_color,
                entry_side = left_coupler.x_inward
            );

    translate([edge_x, mounting_y, edge_z])
        translate([right_offset, 0, 0])
            hub75_dovetail_tube_clamp_build(
                clamp,
                part_color = clamp_color,
                entry_side = right_coupler.x_inward
            );

    translate([edge_x, mounting_y, -edge_z])
        rotate([0, 180, 0])
            translate([left_offset, 0, 0])
                hub75_dovetail_tube_clamp_build(
                    clamp,
                    part_color = clamp_color,
                    entry_side = left_coupler.x_inward
                );

    translate([-edge_x, mounting_y, -edge_z])
        rotate([0, 180, 0])
            translate([right_offset, 0, 0])
                hub75_dovetail_tube_clamp_build(
                    clamp,
                    part_color = clamp_color,
                    entry_side = right_coupler.x_inward
                );
}

module _hub75_display_frame_aluminium_tubes(
    panel,
    panel_count,
    mounting_y,
    top_z_shift = 0,
    bottom_z_shift = 0,
    tube_color = [0.72, 0.74, 0.76, 1]
) {
    edge_z = _hub75_display_frame_half_height(panel);
    length = hub75_display_frame_tube_length(panel, panel_count);
    x_min = -length / 2;
    clamp =
        hub75_dovetail_tube_clamp_create();
    tube =
        aluminium_tube_create(
            length = length,
            outer_diameter = clamp.base_clamp.tube_diameter,
            wall_thickness = 1,
            render_fn = clamp.render_fn
        );
    tube_y =
        mounting_y
        + hub75_dovetail_tube_clamp_tube_center_y(clamp);
    tube_z =
        edge_z
        + hub75_dovetail_tube_clamp_tube_center_z(clamp);

    color(tube_color) {
        translate([x_min, tube_y, tube_z + top_z_shift])
            aluminium_tube_build(tube);

        translate([x_min, tube_y, -tube_z + bottom_z_shift])
            aluminium_tube_build(tube);
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
    coupler_color = [0.72, 0.05, 0.04, 1],
    clamp_color = [0.92, 0.20, 0.08, 1],
    tube_color = [0.72, 0.74, 0.76, 1],
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
                color_scheme = panel_color_scheme
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
            tube_mount_enabled
        );

    if (corner_edge_couplers_visible)
        _hub75_display_frame_corner_couplers(
            panel,
            active_left_corner_coupler,
            active_right_corner_coupler,
            panel_count,
            coupler_mounting_y,
            coupler_color,
            tube_mount_enabled
        );

    if (tube_mount_enabled && tube_clamps_visible)
        _hub75_display_frame_tube_clamps(
            panel,
            active_horizontal_coupler,
            active_left_corner_coupler,
            active_right_corner_coupler,
            panel_count,
            clamp_mounting_y,
            clamp_color
        );

    if (tube_mount_enabled && aluminium_tubes_visible)
        _hub75_display_frame_aluminium_tubes(
            panel,
            panel_count,
            tube_mounting_y,
            top_z_shift = tube_z_gap,
            bottom_z_shift = -tube_z_gap,
            tube_color = tube_color
        );

    if (debug_reference_visible)
        _hub75_display_frame_debug_reference(panel, panel_count);
}
