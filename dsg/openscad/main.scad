// File: main.scad
//   Interactive development entrypoint for opening this project directly in OpenSCAD.
//
// Use the Customizer to switch between the complete display, exploded/isolated
// views, connector presets and local fit fixtures. Production geometry remains
// in the component and assembly files; this file only selects and combines it.

use <ext/lib.scad.hub75/openscad/p5-64x32-panel/hub75_p5_64x32_panel.scad>
use <assemblies/display_frame_assembly.scad>
use <assemblies/panels_assembly.scad>
use <assemblies/verification/middle_coupler_fit_assembly.scad>
use <assemblies/verification/horizontal_edge_coupler_fit_assembly.scad>
use <assemblies/verification/corner_edge_coupler_fit_assembly.scad>
use <project_components/middle-coupler/hub75_middle_coupler.scad>
use <project_components/horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>
use <project_components/corner-edge-coupler/hub75_corner_edge_coupler.scad>

/* [View] */
view_mode = "assembly"; // [assembly,exploded,panels,couplers,middle-coupler,horizontal-edge-coupler,corner-edge-left,corner-edge-right,middle-fit,horizontal-edge-fit,corner-edge-fit-left,corner-edge-fit-right]

/* [Coupler profile] */
coupler_profile = "medium"; // [small,medium,large,custom]

/* [Custom coupler dimensions] */
// Used only when coupler_profile = "custom". These values default to the
// medium family dimensions so switching to custom starts from a known shape.
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

/* [Exploded view] */
exploded_distance = 35;

panel = hub75_p5_64x32_panel_create();

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
            guide_end_rounding = guide_end_rounding
        )
        : hub75_middle_coupler_create_for_size(
            size = coupler_profile,
            panel = panel
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
            guide_end_rounding = guide_end_rounding
        )
        : hub75_horizontal_edge_coupler_create_for_size(
            size = coupler_profile,
            panel = panel
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
            guide_end_rounding = guide_end_rounding
        )
        : hub75_corner_edge_coupler_create_for_size(
            side = side,
            size = coupler_profile,
            panel = panel
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
        panels_visible = panels_visible,
        middle_couplers_visible =
            show_couplers && show_middle_couplers,
        horizontal_edge_couplers_visible =
            show_couplers && show_horizontal_edge_couplers,
        corner_edge_couplers_visible =
            show_couplers && show_corner_edge_couplers,
        explode_distance = explode,
        middle_coupler = middle_coupler,
        horizontal_coupler = horizontal_coupler,
        left_corner_coupler = left_corner_coupler,
        right_corner_coupler = right_corner_coupler
    );
}

if (view_mode == "assembly")
    _hub75_main_display();
else if (view_mode == "exploded")
    _hub75_main_display(explode = exploded_distance);
else if (view_mode == "panels")
    hub75_panels_assembly(panel = panel);
else if (view_mode == "couplers")
    _hub75_main_display(panels_visible = false);
else if (view_mode == "middle-coupler")
    hub75_middle_coupler_render(middle_coupler, view = "final");
else if (view_mode == "horizontal-edge-coupler")
    hub75_horizontal_edge_coupler_render(horizontal_coupler, view = "final");
else if (view_mode == "corner-edge-left")
    hub75_corner_edge_coupler_render(left_corner_coupler, view = "final");
else if (view_mode == "corner-edge-right")
    hub75_corner_edge_coupler_render(right_corner_coupler, view = "final");
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
