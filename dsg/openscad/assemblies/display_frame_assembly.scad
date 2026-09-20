// File: display_frame_assembly.scad
//   Complete five-panel display overview with couplers and reinforcement layer.
//
// The panel-facing core coupler geometry remains owned by the existing component
// files. Optional reinforcement wrappers add only rear-face dovetail grooves.
// Separate tube clips consume lib.scad.clamps and the aluminium tubes reproduce
// the useful 840 x 360 mm structural envelope from the older frame.

use <../ext/lib.scad.hub75/openscad/p5-64x32-panel/hub75_p5_64x32_panel.scad>
use <panels_assembly.scad>
use <helpers/reference_box.scad>
use <../project_components/middle-coupler/hub75_middle_coupler.scad>
use <../project_components/horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>
use <../project_components/corner-edge-coupler/hub75_corner_edge_coupler.scad>
use <../project_components/reinforcement/reinforced_couplers.scad>
use <../project_components/reinforcement/dovetail_tube_clamp.scad>
use <../project_components/reinforcement/aluminium_tube.scad>

function _hub75_display_frame_panel_pitch_x(panel) =
    hub75_p5_64x32_panel_nominal_width(panel);

function _hub75_display_frame_half_height(panel) =
    hub75_p5_64x32_panel_nominal_height(panel) / 2;

function _hub75_display_frame_half_width(
    panel,
    panel_count = 5
) =
    panel_count * _hub75_display_frame_panel_pitch_x(panel) / 2;

function _hub75_display_frame_seam_x(
    panel,
    seam_index,
    panel_count = 5
) =
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
    reinforcement_enabled
) {
    edge_z = _hub75_display_frame_half_height(panel);

    color(coupler_color)
        for (seam_index = [0 : panel_count - 2]) {
            seam_x =
                _hub75_display_frame_seam_x(panel, seam_index, panel_count);

            translate([seam_x, mounting_y, edge_z])
                if (reinforcement_enabled)
                    hub75_reinforced_horizontal_edge_coupler_build(coupler);
                else
                    hub75_horizontal_edge_coupler_build(coupler);

            translate([seam_x, mounting_y, -edge_z])
                rotate([0, 180, 0])
                    if (reinforcement_enabled)
                        hub75_reinforced_horizontal_edge_coupler_build(coupler);
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
    reinforcement_enabled
) {
    edge_x = _hub75_display_frame_half_width(panel, panel_count);
    edge_z = _hub75_display_frame_half_height(panel);

    color(coupler_color) {
        translate([-edge_x, mounting_y, edge_z])
            if (reinforcement_enabled)
                hub75_reinforced_corner_edge_coupler_build(left_coupler);
            else
                hub75_corner_edge_coupler_build(left_coupler);

        translate([edge_x, mounting_y, edge_z])
            if (reinforcement_enabled)
                hub75_reinforced_corner_edge_coupler_build(right_coupler);
            else
                hub75_corner_edge_coupler_build(right_coupler);

        translate([edge_x, mounting_y, -edge_z])
            rotate([0, 180, 0])
                if (reinforcement_enabled)
                    hub75_reinforced_corner_edge_coupler_build(left_coupler);
                else
                    hub75_corner_edge_coupler_build(left_coupler);

        translate([-edge_x, mounting_y, -edge_z])
            rotate([0, 180, 0])
                if (reinforcement_enabled)
                    hub75_reinforced_corner_edge_coupler_build(right_coupler);
                else
                    hub75_corner_edge_coupler_build(right_coupler);
    }
}

module _hub75_display_frame_reinforcement_clamps(
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
        hub75_reinforcement_clip_offset(horizontal_coupler.profile_size);
    left_offset =
        left_coupler.x_inward
        * hub75_reinforcement_clip_offset(left_coupler.profile_size);
    right_offset =
        right_coupler.x_inward
        * hub75_reinforcement_clip_offset(right_coupler.profile_size);

    for (seam_index = [0 : panel_count - 2]) {
        seam_x =
            _hub75_display_frame_seam_x(panel, seam_index, panel_count);

        for (clip_x = [-horizontal_offset, horizontal_offset]) {
            translate([seam_x, mounting_y, edge_z])
                translate([clip_x, 0, 0])
                    hub75_reinforcement_dovetail_tube_clamp(
                        coupler_base_thickness = horizontal_coupler.base_thickness,
                        part_color = clamp_color
                    );

            translate([seam_x, mounting_y, -edge_z])
                rotate([0, 180, 0])
                    translate([clip_x, 0, 0])
                        hub75_reinforcement_dovetail_tube_clamp(
                            coupler_base_thickness = horizontal_coupler.base_thickness,
                            part_color = clamp_color
                        );
        }
    }

    translate([-edge_x, mounting_y, edge_z])
        translate([left_offset, 0, 0])
            hub75_reinforcement_dovetail_tube_clamp(
                coupler_base_thickness = left_coupler.base_thickness,
                part_color = clamp_color
            );

    translate([edge_x, mounting_y, edge_z])
        translate([right_offset, 0, 0])
            hub75_reinforcement_dovetail_tube_clamp(
                coupler_base_thickness = right_coupler.base_thickness,
                part_color = clamp_color
            );

    translate([edge_x, mounting_y, -edge_z])
        rotate([0, 180, 0])
            translate([left_offset, 0, 0])
                hub75_reinforcement_dovetail_tube_clamp(
                    coupler_base_thickness = left_coupler.base_thickness,
                    part_color = clamp_color
                );

    translate([-edge_x, mounting_y, -edge_z])
        rotate([0, 180, 0])
            translate([right_offset, 0, 0])
                hub75_reinforcement_dovetail_tube_clamp(
                    coupler_base_thickness = right_coupler.base_thickness,
                    part_color = clamp_color
                );
}

module _hub75_display_frame_reinforcement_tubes(
    panel,
    panel_count,
    mounting_y
) {
    edge_z = _hub75_display_frame_half_height(panel);
    length = hub75_display_frame_tube_length(panel, panel_count);
    x_min = -length / 2;
    tube_y = mounting_y + hub75_reinforcement_tube_center_y();
    tube_z = edge_z + hub75_reinforcement_tube_center_z();

    translate([x_min, tube_y, tube_z])
        hub75_reinforcement_aluminium_tube(length = length);

    translate([x_min, tube_y, -tube_z])
        hub75_reinforcement_aluminium_tube(length = length);
}

module _hub75_display_frame_debug_reference(
    panel,
    panel_count
) {
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

// Module: hub75_display_frame_assembly()
// Description:
//   Five-panel assembly with optional detachable reinforcement layer.
//
//   The reinforcement layer is project-owned and may be inspected independently
//   while the core panel-fit acceptance remains open. It does not alter the
//   panel-facing geometry in the core component files.
module hub75_display_frame_assembly(
    panel = hub75_p5_64x32_panel_create(),
    coupler_size = "medium",
    panel_count = 5,
    panel_color_scheme = "light_gray",
    coupler_color = [0.72, 0.05, 0.04, 1],
    clamp_color = [0.92, 0.20, 0.08, 1],
    panels_visible = true,
    middle_couplers_visible = true,
    horizontal_edge_couplers_visible = true,
    corner_edge_couplers_visible = true,
    reinforcement_enabled = true,
    reinforcement_clamps_visible = true,
    reinforcement_tubes_visible = true,
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
    panel_y_offset = exploded ? -explode_distance : 0;
    coupler_y_offset = exploded ? explode_distance : 0;
    mounting_y =
        hub75_p5_64x32_panel_mounting_plane_y(panel)
        + coupler_y_offset;

    if (panels_visible)
        translate([0, panel_y_offset, 0])
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
            mounting_y,
            coupler_color
        );

    if (horizontal_edge_couplers_visible)
        _hub75_display_frame_horizontal_edge_couplers(
            panel,
            active_horizontal_coupler,
            panel_count,
            mounting_y,
            coupler_color,
            reinforcement_enabled
        );

    if (corner_edge_couplers_visible)
        _hub75_display_frame_corner_couplers(
            panel,
            active_left_corner_coupler,
            active_right_corner_coupler,
            panel_count,
            mounting_y,
            coupler_color,
            reinforcement_enabled
        );

    if (reinforcement_enabled && reinforcement_clamps_visible)
        _hub75_display_frame_reinforcement_clamps(
            panel,
            active_horizontal_coupler,
            active_left_corner_coupler,
            active_right_corner_coupler,
            panel_count,
            mounting_y,
            clamp_color
        );

    if (reinforcement_enabled && reinforcement_tubes_visible)
        _hub75_display_frame_reinforcement_tubes(
            panel,
            panel_count,
            mounting_y
        );

    if (debug_reference_visible)
        _hub75_display_frame_debug_reference(panel, panel_count);
}
