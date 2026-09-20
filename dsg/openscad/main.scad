// File: main.scad
//   Interactive development entrypoint for opening this project in OpenSCAD.

use <ext/lib.scad.hub75/openscad/p5-64x32-panel/hub75_p5_64x32_panel.scad>
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
view_mode = "assembly"; // [assembly,two-panel-assembly,exploded,panels,couplers,middle-coupler,horizontal-edge-coupler,horizontal-edge-tube-mount-coupler,horizontal-edge-tube-mount-assembly,corner-edge-left,corner-edge-right,corner-edge-tube-mount-left,corner-edge-tube-mount-right,corner-edge-tube-mount-left-assembly,corner-edge-tube-mount-right-assembly,tube-clamp,tube-clamp-dov,middle-fit,horizontal-edge-fit,corner-edge-fit-left,corner-edge-fit-right]

/* [Preview detail] */
high_resolution = false;

/* [Coupler profile] */
coupler_profile = "medium"; // [small,medium,large,custom]

/* [Custom coupler dimensions] */
profile_size = 80;
wall_thickness = 4;
fit_clearance = 0.25;
base_thickness = 3;
guide_height = 6;
inside_corner_radius = 10;
outside_corner_radius = 6;
guide_end_rounding = 1.5;
corner_outside_projection = 19.5;

/* [Visibility - assembly / exploded] */
show_panels = true;
show_couplers = true;
show_middle_couplers = true;
show_horizontal_edge_couplers = true;
show_corner_edge_couplers = true;
show_tube_mounts = true;
show_tube_clamps = true;
show_aluminium_tubes = true;
show_debug_frame = false;

/* [Exploded view] */
exploded_distance = 35;

// BEGIN lib.scad.util: section-inspection
/* [Section inspection] */
section_axis = "None"; // [None,X,Y,Z]
section_position_mm = 0; // [-100:0.5:100]
section_depth_mm = 10; // [0.1:0.1:200]
section_direction = "Positive"; // [Positive,Negative]
// END lib.scad.util: section-inspection

panel = hub75_p5_64x32_panel_create();

preview_low_detail = !high_resolution;
preview_render_fn = high_resolution ? 192 : 48;
preview_panel_view =
    hub75_p5_64x32_panel_view_id(
        high_resolution ? "final" : "structure"
    );

$fn = high_resolution ? 48 : 24;

assert(
    coupler_profile == "small"
    || coupler_profile == "medium"
    || coupler_profile == "large"
    || coupler_profile == "custom",
    str("Unsupported coupler_profile: ", coupler_profile)
);

function _hub75_main_middle_coupler(panel) =
    coupler_profile == "custom"
        ? hub75_middle_coupler_create(
            panel = panel,
            profile_size = profile_size,
            wall_thickness = wall_thickness,
            fit_clearance = fit_clearance,
            base_thickness = base_thickness,
            guide_height = guide_height,
            inside_corner_radius = inside_corner_radius,
            outside_corner_radius = outside_corner_radius,
            guide_end_rounding = guide_end_rounding,
            render_fn = preview_render_fn,
            show_reference_pockets = !preview_low_detail,
            show_center_reference_marks = !preview_low_detail
        )
        : hub75_middle_coupler_create_for_size(
            size = coupler_profile,
            panel = panel,
            render_fn = preview_render_fn,
            show_reference_pockets = !preview_low_detail,
            show_center_reference_marks = !preview_low_detail
        );

function _hub75_main_horizontal_coupler(panel) =
    coupler_profile == "custom"
        ? hub75_horizontal_edge_coupler_create(
            panel = panel,
            profile_size = profile_size,
            wall_thickness = wall_thickness,
            fit_clearance = fit_clearance,
            base_thickness = base_thickness,
            guide_height = guide_height,
            inside_corner_radius = inside_corner_radius,
            outside_corner_radius = outside_corner_radius,
            guide_end_rounding = guide_end_rounding,
            render_fn = preview_render_fn,
            show_reference_pockets = !preview_low_detail,
            show_center_reference_marks = !preview_low_detail
        )
        : hub75_horizontal_edge_coupler_create_for_size(
            size = coupler_profile,
            panel = panel,
            render_fn = preview_render_fn,
            show_reference_pockets = !preview_low_detail,
            show_center_reference_marks = !preview_low_detail
        );

function _hub75_main_corner_coupler(panel, side) =
    coupler_profile == "custom"
        ? hub75_corner_edge_coupler_create(
            side = side,
            panel = panel,
            profile_size = profile_size,
            outside_projection = corner_outside_projection,
            wall_thickness = wall_thickness,
            fit_clearance = fit_clearance,
            base_thickness = base_thickness,
            guide_height = guide_height,
            inside_corner_radius = inside_corner_radius,
            outside_corner_radius = outside_corner_radius,
            guide_end_rounding = guide_end_rounding,
            render_fn = preview_render_fn,
            show_reference_pockets = !preview_low_detail,
            show_center_reference_marks = !preview_low_detail
        )
        : hub75_corner_edge_coupler_create_for_size(
            side = side,
            size = coupler_profile,
            panel = panel,
            render_fn = preview_render_fn,
            show_reference_pockets = !preview_low_detail,
            show_center_reference_marks = !preview_low_detail
        );

middle_coupler = _hub75_main_middle_coupler(panel);
horizontal_coupler = _hub75_main_horizontal_coupler(panel);
left_corner_coupler = _hub75_main_corner_coupler(panel, "left");
right_corner_coupler = _hub75_main_corner_coupler(panel, "right");

module _hub75_main_display(explode = 0, panels_visible = show_panels) {
    hub75_display_frame_assembly(
        panel = panel,
        coupler_size =
            coupler_profile == "custom" ? "medium" : coupler_profile,
        panel_view = preview_panel_view,
        clamp_high_resolution = high_resolution,
        panels_visible = panels_visible,
        middle_couplers_visible =
            show_couplers && show_middle_couplers,
        horizontal_edge_couplers_visible =
            show_couplers && show_horizontal_edge_couplers,
        corner_edge_couplers_visible =
            show_couplers && show_corner_edge_couplers,
        tube_mount_enabled = show_tube_mounts,
        tube_clamps_visible = show_tube_clamps,
        aluminium_tubes_visible = show_aluminium_tubes,
        debug_reference_visible = show_debug_frame,
        explode_distance = explode,
        middle_coupler = middle_coupler,
        horizontal_coupler = horizontal_coupler,
        left_corner_coupler = left_corner_coupler,
        right_corner_coupler = right_corner_coupler
    );
}

module _hub75_main_selected_view() {
    if (view_mode == "assembly")
        _hub75_main_display();
    else if (view_mode == "two-panel-assembly")
        hub75_tube_mount_display_2_panel_assembly(
            panel = panel,
            coupler_size =
                coupler_profile == "custom" ? "medium" : coupler_profile,
            panel_view = preview_panel_view,
            clamp_high_resolution = high_resolution,
            tube_mount_enabled = show_tube_mounts,
            tube_clamps_visible = show_tube_clamps,
            aluminium_tubes_visible = show_aluminium_tubes,
            debug_reference_visible = show_debug_frame,
            explode_distance = 0,
            middle_coupler = middle_coupler,
            horizontal_coupler = horizontal_coupler,
            left_corner_coupler = left_corner_coupler,
            right_corner_coupler = right_corner_coupler
        );
    else if (view_mode == "exploded")
        _hub75_main_display(explode = exploded_distance);
    else if (view_mode == "panels")
        hub75_panels_assembly(
            panel = panel,
            panel_view = preview_panel_view
        );
    else if (view_mode == "couplers")
        _hub75_main_display(panels_visible = false);
    else if (view_mode == "middle-coupler")
        hub75_middle_coupler_render(middle_coupler, view = "final");
    else if (view_mode == "horizontal-edge-coupler")
        hub75_horizontal_edge_coupler_render(horizontal_coupler, view = "final");
    else if (view_mode == "horizontal-edge-tube-mount-coupler")
        hub75_tube_horizontal_edge_coupler_build(
            horizontal_coupler
        );
    else if (view_mode == "horizontal-edge-tube-mount-assembly")
        hub75_tube_horizontal_edge_assembly(
            coupler = horizontal_coupler,
            show_coupler = show_couplers,
            show_clamps = show_tube_clamps,
            show_tube = show_aluminium_tubes,
            clamp_high_resolution = high_resolution
        );
    else if (view_mode == "corner-edge-left")
        hub75_corner_edge_coupler_render(left_corner_coupler, view = "final");
    else if (view_mode == "corner-edge-right")
        hub75_corner_edge_coupler_render(right_corner_coupler, view = "final");
    else if (view_mode == "corner-edge-tube-mount-left")
        hub75_tube_corner_edge_coupler_build(
            left_corner_coupler
        );
    else if (view_mode == "corner-edge-tube-mount-right")
        hub75_tube_corner_edge_coupler_build(
            right_corner_coupler
        );
    else if (view_mode == "corner-edge-tube-mount-left-assembly")
        hub75_tube_corner_edge_assembly(
            side = "left",
            coupler = left_corner_coupler,
            show_coupler = show_couplers,
            show_clamps = show_tube_clamps,
            show_tube = show_aluminium_tubes,
            clamp_high_resolution = high_resolution
        );
    else if (view_mode == "corner-edge-tube-mount-right-assembly")
        hub75_tube_corner_edge_assembly(
            side = "right",
            coupler = right_corner_coupler,
            show_coupler = show_couplers,
            show_clamps = show_tube_clamps,
            show_tube = show_aluminium_tubes,
            clamp_high_resolution = high_resolution
        );
    else if (view_mode == "tube-clamp")
        let(clamp = hub75_tube_clamp_create())
            hub75_tube_clamp_body_build(
                clamp,
                use_tension_bore = false,
                high_resolution = high_resolution
            );
    else if (view_mode == "tube-clamp-dov")
        let(clamp = hub75_tube_clamp_create())
            hub75_tube_clamp_build(
                clamp,
                use_tension_bore = false,
                high_resolution = high_resolution
            );
    else if (view_mode == "middle-fit")
        hub75_middle_coupler_fit_detail(
            panel = panel,
            coupler = middle_coupler
        );
    else if (view_mode == "horizontal-edge-fit")
        hub75_horizontal_edge_coupler_fit_detail(
            panel = panel,
            coupler = horizontal_coupler
        );
    else if (view_mode == "corner-edge-fit-left")
        hub75_corner_edge_coupler_fit_detail(
            side = "left",
            panel = panel,
            coupler = left_corner_coupler
        );
    else if (view_mode == "corner-edge-fit-right")
        hub75_corner_edge_coupler_fit_detail(
            side = "right",
            panel = panel,
            coupler = right_corner_coupler
        );
    else
        assert(false, str("Unsupported view_mode: ", view_mode));
}

util_section_inspect(
    axis = section_axis,
    position = section_position_mm,
    depth = section_depth_mm,
    direction = section_direction
)
    _hub75_main_selected_view();
