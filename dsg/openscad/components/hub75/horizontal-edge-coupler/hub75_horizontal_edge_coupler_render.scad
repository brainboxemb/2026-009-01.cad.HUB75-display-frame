// File: hub75_horizontal_edge_coupler_render.scad
// Design-documentation adapter for the horizontal-edge coupler.
// Construction-only views decompose production geometry for explanation.

use <../../../ext/lib.scad.forge/openscad/resolution.scad>
use <hub75_horizontal_edge_coupler.scad>
use <../hub75_panel_mating.scad>

module _hub75_horizontal_edge_design_thin(y_min = -0.35, y_max = 0.35) {
    rotate([90, 0, 0])
        _hub75_horizontal_edge_coupler_extrude_xz_y(y_min, y_max)
            children();
}

module _hub75_horizontal_edge_design_horizontal_arm_2d(coupler_obj) {
    translate([0, hub75_horizontal_edge_coupler_rear_rail_center_z(coupler_obj)])
        square([
            coupler_obj.profile_size,
            hub75_horizontal_edge_coupler_horizontal_arm_height(coupler_obj)
        ], center = true);
}

module _hub75_horizontal_edge_design_vertical_arm_2d(coupler_obj) {
    square([
        hub75_horizontal_edge_coupler_vertical_arm_width(coupler_obj),
        2 * hub75_horizontal_edge_coupler_inward_reach(coupler_obj)
    ], center = true);
}

module _hub75_horizontal_edge_design_raw_cross_2d(coupler_obj) {
    union() {
        _hub75_horizontal_edge_design_horizontal_arm_2d(coupler_obj);
        _hub75_horizontal_edge_design_vertical_arm_2d(coupler_obj);
    }
}

module _hub75_horizontal_edge_design_end_rail_2d(coupler_obj) {
    translate([0, hub75_horizontal_edge_coupler_rear_rail_center_z(coupler_obj)])
        square([
            coupler_obj.profile_size + 6,
            coupler_obj.rear_end_rail_width
        ], center = true);
}

module _hub75_horizontal_edge_design_profile_window_2d(coupler_obj) {
    reach = hub75_horizontal_edge_coupler_inward_reach(coupler_obj);
    outer = max(12, hub75_horizontal_edge_coupler_outer_projection(coupler_obj) + 6);
    translate([0, (outer - reach) / 2])
        square([coupler_obj.profile_size + 10, reach + outer], center = true);
}

module _hub75_horizontal_edge_design_panel_keepout_visible_2d(coupler_obj) {
    intersection() {
        _hub75_horizontal_edge_coupler_panel_keepout_2d(coupler_obj);
        _hub75_horizontal_edge_design_profile_window_2d(coupler_obj);
    }
}

module _hub75_horizontal_edge_design_clearance_band_2d(coupler_obj) {
    difference() {
        intersection() {
            offset(delta = coupler_obj.fit_clearance)
                _hub75_horizontal_edge_coupler_panel_keepout_2d(coupler_obj);
            _hub75_horizontal_edge_design_profile_window_2d(coupler_obj);
        }
        _hub75_horizontal_edge_design_panel_keepout_visible_2d(coupler_obj);
    }
}

module _hub75_horizontal_edge_design_profile_outline_2d(coupler_obj, line_width = 1.0) {
    difference() {
        _hub75_horizontal_edge_coupler_profile_2d(coupler_obj);
        offset(delta = -line_width)
            _hub75_horizontal_edge_coupler_profile_2d(coupler_obj);
    }
}

module _hub75_horizontal_edge_design_reinforcement_relief_cutters(coupler_obj) {
    eps = 0.05;
    relief_diameter =
        hub75_horizontal_edge_coupler_reinforcement_relief_diameter(coupler_obj);
    relief_depth = coupler_obj.guide_height + 0.20;

    for (position = _hub75_horizontal_edge_coupler_reinforcement_positions(coupler_obj))
        translate([position[0], eps, position[1]])
            rotate([90, 0, 0])
                cylinder(d = relief_diameter, h = relief_depth + 2 * eps);
}

module _hub75_horizontal_edge_design_unrelieved_tall_guide(coupler_obj) {
    _hub75_horizontal_edge_coupler_extrude_xz_y(-coupler_obj.guide_height, 0)
        _hub75_horizontal_edge_coupler_tall_guide_2d(coupler_obj);
}

module _hub75_horizontal_edge_design_reinforcement_crop(
    coupler_obj,
    position,
    crop_width = 34,
    crop_height = 34
) {
    translate([
        position[0] - crop_width / 2,
        -coupler_obj.guide_height - 2,
        position[1] - crop_height / 2
    ])
        cube([crop_width, coupler_obj.guide_height + 3, crop_height]);
}

module _hub75_horizontal_edge_design_reinforcement_panel_fragment(
    coupler_obj,
    position,
    fragment_length = 24,
    fragment_depth = 6.5
) {
    outer_d = coupler_obj.reinforcement_bushing_outer_diameter;
    recess_d = coupler_obj.reinforcement_bushing_recess_diameter;
    recess_depth = coupler_obj.reinforcement_bushing_recess_depth;
    hole_d = coupler_obj.reinforcement_bushing_hole_diameter;
    hole_depth = coupler_obj.reinforcement_bushing_hole_depth;
    rail_width = coupler_obj.rear_side_rail_width;
    eps = 0.04;

    translate([position[0], 0, position[1]])
        difference() {
            _hub75_horizontal_edge_coupler_extrude_xz_y(-fragment_depth, 0)
                union() {
                    square([rail_width, fragment_length], center = true);
                    circle(d = outer_d);
                }
            _hub75_horizontal_edge_coupler_extrude_xz_y(-recess_depth - eps, eps)
                circle(d = recess_d);
            _hub75_horizontal_edge_coupler_extrude_xz_y(
                -recess_depth - hole_depth,
                -recess_depth + eps
            )
                circle(d = hole_d);
        }
}

module _hub75_horizontal_edge_design_reinforcement_guide_fragment(coupler_obj, position) {
    intersection() {
        _hub75_horizontal_edge_design_unrelieved_tall_guide(coupler_obj);
        _hub75_horizontal_edge_design_reinforcement_crop(coupler_obj, position);
    }
}

module _hub75_horizontal_edge_design_reinforcement_clearance_band(coupler_obj, position) {
    outer_d =
        coupler_obj.reinforcement_bushing_outer_diameter
        + 2 * coupler_obj.reinforcement_bushing_clearance;
    inner_d = coupler_obj.reinforcement_bushing_outer_diameter;

    translate([position[0], 0, position[1]])
        difference() {
            _hub75_horizontal_edge_coupler_extrude_xz_y(-coupler_obj.guide_height, 0)
                circle(d = outer_d);
            _hub75_horizontal_edge_coupler_extrude_xz_y(-coupler_obj.guide_height - 0.05, 0.05)
                circle(d = inner_d);
        }
}

module _hub75_horizontal_edge_design_reinforcement_collision(coupler_obj, position) {
    intersection() {
        _hub75_horizontal_edge_design_reinforcement_guide_fragment(coupler_obj, position);
        _hub75_horizontal_edge_design_reinforcement_relief_cutters(coupler_obj);
    }
}

module _hub75_horizontal_edge_design_physical_locator_pin(coupler_obj) {
    position = hub75_horizontal_edge_coupler_locator_pin_position(coupler_obj);
    translate([position[0], 0, position[1]])
        rotate([-90, 0, 0])
            cylinder(d = coupler_obj.locator_pin_diameter, h = coupler_obj.locator_pin_protrusion);
}

module _hub75_horizontal_edge_design_locator_crop(coupler_obj, width = 34) {
    position = hub75_horizontal_edge_coupler_locator_pin_position(coupler_obj);
    translate([
        position[0] - width / 2,
        -2,
        position[1] - width / 2
    ])
        cube([width, coupler_obj.base_thickness + 5, width]);
}

module _hub75_horizontal_edge_design_outer_ridge_detail_2d(
    coupler_obj,
    panel_shift_z = 0
) {
    intersection() {
        _hub75_horizontal_edge_coupler_outer_ridge_2d(
            coupler_obj,
            panel_shift_z
        );
        square([18, 32], center = true);
    }
}

module _hub75_horizontal_edge_design_after_reference_pockets(coupler_obj) {
    union() {
        difference() {
            _hub75_horizontal_edge_coupler_base_after_functional_cutters(coupler_obj);
            _hub75_horizontal_edge_coupler_reference_pocket_cutters(coupler_obj);
        }
        if (coupler_obj.guide_height > 0) {
            _hub75_horizontal_edge_coupler_guide_walls(coupler_obj);
            _hub75_horizontal_edge_coupler_outer_edge_ridge(coupler_obj);
        }
        _hub75_horizontal_edge_coupler_reinforcement_locators(coupler_obj);
        if (coupler_obj.seam_locator_height > 0)
            _hub75_horizontal_edge_coupler_seam_locator(coupler_obj);
    }
}

module hub75_horizontal_edge_coupler_design(view = "final") {
    small = hub75_horizontal_edge_coupler_create_for_size(size = "small");
    medium = hub75_horizontal_edge_coupler_create_for_size(size = "medium");
    large = hub75_horizontal_edge_coupler_create_for_size(size = "large");
    coupler =
        view == "locator-pin-clearance"
            ? large
            : view == "reinforcement-support-profile"
                ? small
                : medium;

    existing = [0.56, 0.56, 0.56, 1.0];
    existing_transparent = [0.56, 0.56, 0.56, 0.42];
    current = [0.88, 0.08, 0.06, 0.68];

    if (view == "mating-reference") {
        color(current)
            _hub75_horizontal_edge_design_thin(-0.42, -0.02)
                _hub75_horizontal_edge_design_clearance_band_2d(coupler);
        color(existing)
            _hub75_horizontal_edge_design_thin(0.02, 0.42)
                _hub75_horizontal_edge_design_panel_keepout_visible_2d(coupler);

    } else if (view == "profile-horizontal-arm") {
        color(current)
            _hub75_horizontal_edge_design_thin(-0.42, -0.02)
                _hub75_horizontal_edge_design_horizontal_arm_2d(coupler);
        color(existing)
            _hub75_horizontal_edge_design_thin(0.02, 0.42)
                _hub75_horizontal_edge_design_end_rail_2d(coupler);

    } else if (view == "profile-vertical-arm") {
        color(current)
            _hub75_horizontal_edge_design_thin(-0.42, -0.02)
                _hub75_horizontal_edge_design_vertical_arm_2d(coupler);
        color(existing)
            _hub75_horizontal_edge_design_thin(0.02, 0.42)
                _hub75_horizontal_edge_design_horizontal_arm_2d(coupler);

    } else if (view == "profile-raw-cross") {
        color(current)
            _hub75_horizontal_edge_design_thin()
                _hub75_horizontal_edge_design_raw_cross_2d(coupler);

    } else if (view == "profile-rounded-cross") {
        color(existing_transparent)
            _hub75_horizontal_edge_design_thin(-0.42, -0.02)
                _hub75_horizontal_edge_design_raw_cross_2d(coupler);
        color(current)
            _hub75_horizontal_edge_design_thin(0.02, 0.42)
                _hub75_horizontal_edge_coupler_plus_profile_2d(coupler);

    } else if (view == "profile-t") {
        color(existing_transparent)
            _hub75_horizontal_edge_design_thin(-0.42, -0.02)
                _hub75_horizontal_edge_coupler_plus_profile_2d(coupler);
        color(current)
            _hub75_horizontal_edge_design_thin(0.02, 0.42)
                _hub75_horizontal_edge_coupler_profile_2d(coupler);

    } else if (view == "reinforcement-support-profile") {
        // This explanatory state deliberately uses the small preset, where the
        // required support envelope first extends beyond the normal T profile.
        color(existing)
            _hub75_horizontal_edge_design_thin(-0.42, -0.02)
                _hub75_horizontal_edge_coupler_profile_2d(coupler);
        color(current)
            _hub75_horizontal_edge_design_thin(0.02, 0.42)
                difference() {
                    _hub75_horizontal_edge_coupler_structural_profile_2d(coupler);
                    _hub75_horizontal_edge_coupler_profile_2d(coupler);
                }

    } else if (view == "locator-pin-clearance") {
        position = hub75_horizontal_edge_coupler_locator_pin_position(coupler);
        translate([0, 0, -20])
            scale([2.25, 2.25, 2.25])
                translate([-position[0], 0, -position[1]]) {
                    color(existing_transparent)
                        intersection() {
                            _hub75_horizontal_edge_coupler_base_after_pockets(coupler);
                            _hub75_horizontal_edge_design_locator_crop(coupler);
                        }
                    color([0.43, 0.43, 0.43, 1.0])
                        _hub75_horizontal_edge_design_physical_locator_pin(coupler);
                    color([0.88, 0.08, 0.06, 0.30])
                        _hub75_horizontal_edge_coupler_locator_pin_clearance_cutter(coupler);
                }

    } else if (view == "guide-keepout") {
        color(current)
            _hub75_horizontal_edge_design_thin(-0.42, -0.02)
                intersection() {
                    _hub75_horizontal_edge_coupler_profile_2d(coupler);
                    offset(delta = coupler.fit_clearance)
                        _hub75_horizontal_edge_coupler_panel_keepout_2d(coupler);
                }
        color(existing)
            _hub75_horizontal_edge_design_thin(0.02, 0.42)
                _hub75_horizontal_edge_design_profile_outline_2d(coupler);

    } else if (view == "guide-raw-shell") {
        color(existing_transparent)
            _hub75_horizontal_edge_design_thin(-0.42, -0.02)
                _hub75_horizontal_edge_coupler_profile_2d(coupler);
        color(current)
            _hub75_horizontal_edge_design_thin(0.02, 0.42)
                _hub75_horizontal_edge_coupler_raw_guide_shell_2d(coupler);

    } else if (view == "guide-rounded-shell") {
        color(existing_transparent)
            _hub75_horizontal_edge_design_thin(-0.42, -0.02)
                _hub75_horizontal_edge_coupler_raw_guide_shell_2d(coupler);
        color(current)
            _hub75_horizontal_edge_design_thin(0.02, 0.42)
                _hub75_horizontal_edge_coupler_guide_shell_2d(coupler);

    } else if (view == "guide-zones") {
        color(existing)
            _hub75_horizontal_edge_design_thin(-0.42, -0.02)
                _hub75_horizontal_edge_coupler_tall_guide_2d(coupler);
        color(current)
            _hub75_horizontal_edge_design_thin(0.02, 0.42)
                _hub75_horizontal_edge_coupler_outer_ridge_2d(coupler);

    } else if (view == "guide-outer-taper") {
        taper_h = min(coupler.guide_height, coupler.panel_taper_depth);
        taper_shift_z = hub75_panel_taper_shift_at_depth_mm(
            taper_h,
            coupler.panel_taper_depth,
            coupler.panel_rear_outer_inset_z
        );
        translate([0, 0, -10])
            scale([2.0, 2.0, 2.0]) {
                color(existing)
                    _hub75_horizontal_edge_coupler_extrude_xz_y(-0.08, 0.08)
                        _hub75_horizontal_edge_design_outer_ridge_detail_2d(
                            coupler,
                            0
                        );
                color(current)
                    _hub75_horizontal_edge_coupler_extrude_xz_y(
                        -taper_h - 0.08,
                        -taper_h + 0.08
                    )
                        _hub75_horizontal_edge_design_outer_ridge_detail_2d(
                            coupler,
                            taper_shift_z
                        );
            }

    } else if (view == "guide-reinforcement-reliefs") {
        color(existing_transparent)
            _hub75_horizontal_edge_design_unrelieved_tall_guide(coupler);
        color(current)
            _hub75_horizontal_edge_design_reinforcement_relief_cutters(coupler);

    } else if (view == "guide-reinforcement-detail") {
        detail_position = _hub75_horizontal_edge_coupler_reinforcement_positions(coupler)[1];
        translate([0, 0, -10])
            scale([2.2, 2.2, 2.2])
                translate([-detail_position[0], 0, -detail_position[1]]) {
                    color([0.43, 0.43, 0.43, 1.0])
                        _hub75_horizontal_edge_design_reinforcement_panel_fragment(coupler, detail_position);
                    color([0.72, 0.72, 0.72, 0.48])
                        _hub75_horizontal_edge_design_reinforcement_guide_fragment(coupler, detail_position);
                    color([0.88, 0.08, 0.06, 0.30])
                        _hub75_horizontal_edge_design_reinforcement_clearance_band(coupler, detail_position);
                    color([0.94, 0.03, 0.02, 0.96])
                        _hub75_horizontal_edge_design_reinforcement_collision(coupler, detail_position);
                }

    } else if (view == "center-marks") {
        color(existing)
            _hub75_horizontal_edge_design_after_reference_pockets(coupler);
        color(current)
            _hub75_horizontal_edge_coupler_center_mark_cutters(coupler);

    } else {
        hub75_horizontal_edge_coupler_render(coupler, view = view);
    }
}

fg_res_apply(FG_RES_HIGH())
    hub75_horizontal_edge_coupler_design();
