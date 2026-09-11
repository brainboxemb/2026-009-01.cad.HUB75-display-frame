// File: display_frame_assembly.scad
//   Complete five-panel display overview with the current connector family.
//
// This assembly is presentation geometry, not a new connector design. It places
// the existing middle, horizontal-edge and corner-edge couplers on the nominal
// five-panel datums already established by the project and reusable HUB75 panel
// library. The public module also supports interactive visibility, custom
// coupler objects and a simple front/rear exploded view for main.scad.

use <../ext/lib.scad.hub75/openscad/p5-64x32-panel/hub75_p5_64x32_panel.scad>
use <panels_assembly.scad>
use <../project_components/middle-coupler/hub75_middle_coupler.scad>
use <../project_components/horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>
use <../project_components/corner-edge-coupler/hub75_corner_edge_coupler.scad>


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
    coupler_color
) {
    edge_z = _hub75_display_frame_half_height(panel);

    color(coupler_color)
        for (seam_index = [0 : panel_count - 2]) {
            seam_x =
                _hub75_display_frame_seam_x(panel, seam_index, panel_count);

            // The component is modelled in top-edge orientation.
            translate([seam_x, mounting_y, edge_z])
                hub75_horizontal_edge_coupler_build(coupler);

            // The documented printable part is rotated 180 degrees for bottom.
            translate([seam_x, mounting_y, -edge_z])
                rotate([0, 180, 0])
                    hub75_horizontal_edge_coupler_build(coupler);
        }
}


module _hub75_display_frame_corner_couplers(
    panel,
    left_coupler,
    right_coupler,
    panel_count,
    mounting_y,
    coupler_color
) {
    edge_x = _hub75_display_frame_half_width(panel, panel_count);
    edge_z = _hub75_display_frame_half_height(panel);

    color(coupler_color) {
        // Top-left and top-right use the two native printable variants.
        translate([-edge_x, mounting_y, edge_z])
            hub75_corner_edge_coupler_build(left_coupler);

        translate([edge_x, mounting_y, edge_z])
            hub75_corner_edge_coupler_build(right_coupler);

        // Per the component design authority, rotating left 180 degrees gives
        // bottom-right and rotating right gives bottom-left.
        translate([edge_x, mounting_y, -edge_z])
            rotate([0, 180, 0])
                hub75_corner_edge_coupler_build(left_coupler);

        translate([-edge_x, mounting_y, -edge_z])
            rotate([0, 180, 0])
                hub75_corner_edge_coupler_build(right_coupler);
    }
}


// Module: hub75_display_frame_assembly()
// Description:
//   Renders the established five-panel assembly together with any selected
//   connector families. Preset callers can keep using coupler_size. Interactive
//   callers may instead pass explicit coupler objects, which is how main.scad
//   supports one shared custom profile without duplicating production geometry.
//
//   explode_distance separates the panel layer toward -Y and the coupler layer
//   toward +Y. At zero the assembly remains physically fitted.
// Arguments:
//   panel = HUB75 panel object defining all panel dimensions and mating datums.
//   coupler_size = Existing connector-family preset used when explicit objects
//     are not supplied: "small", "medium" or "large".
//   panel_count = Number of portrait panels; current project milestone requires 5.
//   panel_color_scheme = Reusable HUB75 panel presentation colour scheme.
//   coupler_color = RGBA colour for all printable connector geometry.
//   *_visible = Per-layer/family visibility switches for interactive inspection.
//   explode_distance = Symmetric Y separation applied between panel/coupler layers.
//   *_coupler = Optional explicit production objects; undef resolves from preset.
module hub75_display_frame_assembly(
    panel = hub75_p5_64x32_panel_create(),
    coupler_size = "medium",
    panel_count = 5,
    panel_color_scheme = "light_gray",
    coupler_color = [0.72, 0.05, 0.04, 1],
    panels_visible = true,
    middle_couplers_visible = true,
    horizontal_edge_couplers_visible = true,
    corner_edge_couplers_visible = true,
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
            coupler_color
        );

    if (corner_edge_couplers_visible)
        _hub75_display_frame_corner_couplers(
            panel,
            active_left_corner_coupler,
            active_right_corner_coupler,
            panel_count,
            mounting_y,
            coupler_color
        );
}
