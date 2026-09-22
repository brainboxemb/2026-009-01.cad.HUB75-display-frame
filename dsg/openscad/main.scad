// File: main.scad
//   Interactive development entrypoint for opening this project in OpenSCAD.

use <ext/lib.scad.hub75/openscad/p5-64x32-panel/hub75_p5_64x32_panel.scad>
use <ext/lib.scad.forge/openscad/resolution.scad>
use <ext/lib.scad.util/openscad/inspection.scad>
use <assemblies/display_frame_assembly.scad>
use <assemblies/tube_mount_display_2_panel_assembly.scad>
use <assemblies/sub/hub75_tube_horizontal_edge_assembly.scad>
use <assemblies/sub/hub75_tube_corner_edge_assembly.scad>
use <assemblies/panels_assembly.scad>
use <assemblies/verification/middle_coupler_fit_assembly.scad>
use <assemblies/verification/horizontal_edge_coupler_fit_assembly.scad>
use <assemblies/verification/corner_edge_coupler_fit_assembly.scad>
use <components/hub75/middle-coupler/hub75_middle_coupler.scad>
use <components/hub75/horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>
use <components/hub75/corner-edge-coupler/hub75_corner_edge_coupler.scad>
use <project_components/tube_mount/horizontal-edge-coupler/hub75_tube_horizontal_edge_coupler.scad>
use <project_components/tube_mount/corner-edge-coupler/hub75_tube_corner_edge_coupler.scad>
use <project_components/tube_mount/tube-clamp/hub75_tube_clamp.scad>

/* [View] */
c_view = "assembly"; // [assembly,two-panel-assembly,exploded,panels,couplers,middle-coupler,horizontal-edge-coupler,horizontal-edge-tube-mount-coupler,horizontal-edge-tube-mount-assembly,corner-edge-left,corner-edge-right,corner-edge-tube-mount-left,corner-edge-tube-mount-right,corner-edge-tube-mount-left-assembly,corner-edge-tube-mount-right-assembly,tube-clamp,tube-clamp-dov,middle-fit,horizontal-edge-fit,corner-edge-fit-left,corner-edge-fit-right]

/* [Resolution] */
c_resolution = "low"; // [low,high,export]

/* [Coupler profile] */
d_coupler_profile = "medium"; // [small,medium,large,custom]

/* [Custom coupler dimensions] */
d_profile_size_mm = 80;
d_wall_thickness_mm = 4;
d_fit_clearance_mm = 0.25;
d_base_thickness_mm = 3;
d_guide_height_mm = 6;
d_inside_corner_radius_mm = 10;
d_outside_corner_radius_mm = 6;
d_guide_end_rounding_mm = 1.5;
d_corner_outside_projection_mm = 19.5;

/* [Visibility - assembly / exploded] */
c_show_panels = true;
c_show_couplers = true;
c_show_middle_couplers = true;
c_show_horizontal_edge_couplers = true;
c_show_corner_edge_couplers = true;
// WIP: detachable tube-mount integration is not yet the default assembly.
c_use_wip_tube_mount_couplers = false;
c_show_tube_clamps = true;
c_show_aluminium_tubes = true;
c_show_debug_frame = false;

/* [Exploded view] */
c_explode_distance_mm = 35;

// BEGIN lib.scad.util: section-inspection
/* [Section inspection] */
c_section_axis = "None"; // [None,X,Y,Z]
c_section_position_mm = 0; // [-100:0.5:100]
c_section_depth_mm = 10; // [0.1:0.1:200]
c_section_direction = "Positive"; // [Positive,Negative]
// END lib.scad.util: section-inspection

panel = hub75_p5_64x32_panel_create();

_preview_low_detail = c_resolution == FG_RES_LOW();
_preview_render_fn = _preview_low_detail ? 48 : 192;
_preview_panel_view =
    hub75_p5_64x32_panel_view_id(
        _preview_low_detail ? "structure" : "final"
    );

assert(
    d_coupler_profile == "small"
    || d_coupler_profile == "medium"
    || d_coupler_profile == "large"
    || d_coupler_profile == "custom",
    str("Unsupported coupler profile: ", d_coupler_profile)
);

function _hub75_main_middle_coupler(panel) =
    d_coupler_profile == "custom"
        ? hub75_middle_coupler_create(
            panel = panel,
            profile_size = d_profile_size_mm,
            wall_thickness = d_wall_thickness_mm,
            fit_clearance = d_fit_clearance_mm,
            base_thickness = d_base_thickness_mm,
            guide_height = d_guide_height_mm,
            inside_corner_radius = d_inside_corner_radius_mm,
            outside_corner_radius = d_outside_corner_radius_mm,
            guide_end_rounding = d_guide_end_rounding_mm,
            render_fn = _preview_render_fn,
            show_reference_pockets = !_preview_low_detail,
            show_center_reference_marks = !_preview_low_detail
        )
        : hub75_middle_coupler_create_for_size(
            size = d_coupler_profile,
            panel = panel,
            render_fn = _preview_render_fn,
            show_reference_pockets = !_preview_low_detail,
            show_center_reference_marks = !_preview_low_detail
        );

function _hub75_main_horizontal_coupler(panel) =
    d_coupler_profile == "custom"
        ? hub75_horizontal_edge_coupler_create(
            panel = panel,
            profile_size = d_profile_size_mm,
            wall_thickness = d_wall_thickness_mm,
            fit_clearance = d_fit_clearance_mm,
            base_thickness = d_base_thickness_mm,
            guide_height = d_guide_height_mm,
            inside_corner_radius = d_inside_corner_radius_mm,
            outside_corner_radius = d_outside_corner_radius_mm,
            guide_end_rounding = d_guide_end_rounding_mm,
            render_fn = _preview_render_fn,
            show_reference_pockets = !_preview_low_detail,
            show_center_reference_marks = !_preview_low_detail
        )
        : hub75_horizontal_edge_coupler_create_for_size(
            size = d_coupler_profile,
            panel = panel,
            render_fn = _preview_render_fn,
            show_reference_pockets = !_preview_low_detail,
            show_center_reference_marks = !_preview_low_detail
        );

function _hub75_main_corner_coupler(panel, side) =
    d_coupler_profile == "custom"
        ? hub75_corner_edge_coupler_create(
            side = side,
            panel = panel,
            profile_size = d_profile_size_mm,
            outside_projection = d_corner_outside_projection_mm,
            wall_thickness = d_wall_thickness_mm,
            fit_clearance = d_fit_clearance_mm,
            base_thickness = d_base_thickness_mm,
            guide_height = d_guide_height_mm,
            inside_corner_radius = d_inside_corner_radius_mm,
            outside_corner_radius = d_outside_corner_radius_mm,
            guide_end_rounding = d_guide_end_rounding_mm,
            render_fn = _preview_render_fn,
            show_reference_pockets = !_preview_low_detail,
            show_center_reference_marks = !_preview_low_detail
        )
        : hub75_corner_edge_coupler_create_for_size(
            side = side,
            size = d_coupler_profile,
            panel = panel,
            render_fn = _preview_render_fn,
            show_reference_pockets = !_preview_low_detail,
            show_center_reference_marks = !_preview_low_detail
        );

middle_coupler = _hub75_main_middle_coupler(panel);
horizontal_coupler = _hub75_main_horizontal_coupler(panel);
left_corner_coupler = _hub75_main_corner_coupler(panel, "left");
right_corner_coupler = _hub75_main_corner_coupler(panel, "right");

function _hub75_main_tube_clamp() =
    d_coupler_profile == "custom"
        ? hub75_tube_clamp_create_for_host_depth(
            d_base_thickness_mm
        )
        : hub75_tube_clamp_create_for_size(
            d_coupler_profile
        );

module _hub75_main_display(explode = 0, panels_visible = c_show_panels) {
    hub75_display_frame_assembly(
        panel = panel,
        coupler_size =
            d_coupler_profile == "custom" ? "medium" : d_coupler_profile,
        panel_view = _preview_panel_view,
        resolution = c_resolution,
        panels_visible = panels_visible,
        middle_couplers_visible =
            c_show_couplers && c_show_middle_couplers,
        horizontal_edge_couplers_visible =
            c_show_couplers && c_show_horizontal_edge_couplers,
        corner_edge_couplers_visible =
            c_show_couplers && c_show_corner_edge_couplers,
        tube_mount_enabled = c_use_wip_tube_mount_couplers,
        tube_clamps_visible = c_show_tube_clamps,
        aluminium_tubes_visible = c_show_aluminium_tubes,
        debug_reference_visible = c_show_debug_frame,
        explode_distance = explode,
        middle_coupler = middle_coupler,
        horizontal_coupler = horizontal_coupler,
        left_corner_coupler = left_corner_coupler,
        right_corner_coupler = right_corner_coupler
    );
}

module _hub75_main_selected_view() {
    if (c_view == "assembly")
        _hub75_main_display();
    else if (c_view == "two-panel-assembly")
        hub75_tube_mount_display_2_panel_assembly(
            panel = panel,
            coupler_size =
                d_coupler_profile == "custom" ? "medium" : d_coupler_profile,
            panel_view = _preview_panel_view,
            resolution = c_resolution,
            tube_mount_enabled = c_use_wip_tube_mount_couplers,
            tube_clamps_visible = c_show_tube_clamps,
            aluminium_tubes_visible = c_show_aluminium_tubes,
            debug_reference_visible = c_show_debug_frame,
            explode_distance = 0,
            middle_coupler = middle_coupler,
            horizontal_coupler = horizontal_coupler,
            left_corner_coupler = left_corner_coupler,
            right_corner_coupler = right_corner_coupler
        );
    else if (c_view == "exploded")
        _hub75_main_display(explode = c_explode_distance_mm);
    else if (c_view == "panels")
        hub75_panels_assembly(
            panel = panel,
            panel_view = _preview_panel_view
        );
    else if (c_view == "couplers")
        _hub75_main_display(panels_visible = false);
    else if (c_view == "middle-coupler")
        hub75_middle_coupler_render(middle_coupler, view = "final");
    else if (c_view == "horizontal-edge-coupler")
        hub75_horizontal_edge_coupler_render(horizontal_coupler, view = "final");
    else if (c_view == "horizontal-edge-tube-mount-coupler")
        hub75_tube_horizontal_edge_coupler_build(
            horizontal_coupler,
            resolution = c_resolution
        );
    else if (c_view == "horizontal-edge-tube-mount-assembly")
        hub75_tube_horizontal_edge_assembly(
            coupler = horizontal_coupler,
            show_coupler = c_show_couplers,
            show_clamps = c_show_tube_clamps,
            show_tube = c_show_aluminium_tubes,
            resolution = c_resolution
        );
    else if (c_view == "corner-edge-left")
        hub75_corner_edge_coupler_render(left_corner_coupler, view = "final");
    else if (c_view == "corner-edge-right")
        hub75_corner_edge_coupler_render(right_corner_coupler, view = "final");
    else if (c_view == "corner-edge-tube-mount-left")
        hub75_tube_corner_edge_coupler_build(
            left_corner_coupler,
            resolution = c_resolution
        );
    else if (c_view == "corner-edge-tube-mount-right")
        hub75_tube_corner_edge_coupler_build(
            right_corner_coupler,
            resolution = c_resolution
        );
    else if (c_view == "corner-edge-tube-mount-left-assembly")
        hub75_tube_corner_edge_assembly(
            side = "left",
            coupler = left_corner_coupler,
            show_coupler = c_show_couplers,
            show_clamps = c_show_tube_clamps,
            show_tube = c_show_aluminium_tubes,
            resolution = c_resolution
        );
    else if (c_view == "corner-edge-tube-mount-right-assembly")
        hub75_tube_corner_edge_assembly(
            side = "right",
            coupler = right_corner_coupler,
            show_coupler = c_show_couplers,
            show_clamps = c_show_tube_clamps,
            show_tube = c_show_aluminium_tubes,
            resolution = c_resolution
        );
    else if (c_view == "tube-clamp")
        let(clamp = _hub75_main_tube_clamp())
            hub75_tube_clamp_body_build(
                clamp,
                use_tension_bore = false,
                resolution = c_resolution
            );
    else if (c_view == "tube-clamp-dov")
        let(clamp = _hub75_main_tube_clamp())
            hub75_tube_clamp_build(
                clamp,
                use_tension_bore = false,
                resolution = c_resolution
            );
    else if (c_view == "middle-fit")
        hub75_middle_coupler_fit_detail(
            panel = panel,
            coupler = middle_coupler
        );
    else if (c_view == "horizontal-edge-fit")
        hub75_horizontal_edge_coupler_fit_detail(
            panel = panel,
            coupler = horizontal_coupler
        );
    else if (c_view == "corner-edge-fit-left")
        hub75_corner_edge_coupler_fit_detail(
            side = "left",
            panel = panel,
            coupler = left_corner_coupler
        );
    else if (c_view == "corner-edge-fit-right")
        hub75_corner_edge_coupler_fit_detail(
            side = "right",
            panel = panel,
            coupler = right_corner_coupler
        );
    else
        assert(false, str("Unsupported c_view: ", c_view));
}

fg_res_apply(c_resolution)
    util_section_inspect(
        axis = c_section_axis,
        position = c_section_position_mm,
        depth = c_section_depth_mm,
        direction = c_section_direction
    )
        _hub75_main_selected_view();
