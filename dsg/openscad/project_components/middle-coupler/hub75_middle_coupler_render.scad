// File: hub75_middle_coupler_render.scad
//   Design-documentation adapter for the project-specific middle coupler.
//
// This file deliberately contains explanatory construction views that are not
// part of the production component API. They expose the geometric reasoning
// behind the coupler without forcing the production model to be written as the
// same sequence of primitive operations used for teaching the design.

$fn = 120;

use <hub75_middle_coupler.scad>
use <../../ext/lib.scad.hub75/openscad/p5-64x32-panel/hub75_p5_64x32_panel.scad>


module _hub75_middle_coupler_design_thin(y_min = -0.35, y_max = 0.35) {
    // The production profile lives in the physical X/Z plane. The design
    // document uses a zero-rotation camera for these diagram-like stages, so
    // rotate the thin explanatory slice into the screen plane only for the
    // documentation render. Production geometry remains untouched.
    rotate([90, 0, 0])
        _hub75_middle_coupler_extrude_xz_y(y_min, y_max)
            children();
}


module _hub75_middle_coupler_design_horizontal_arm_2d(coupler) {
    square(
        [
            coupler.profile_size,
            hub75_middle_coupler_horizontal_arm_height(coupler)
        ],
        center = true
    );
}


module _hub75_middle_coupler_design_vertical_arm_2d(coupler) {
    square(
        [
            hub75_middle_coupler_vertical_arm_width(coupler),
            coupler.profile_size
        ],
        center = true
    );
}


module _hub75_middle_coupler_design_raw_plus_2d(coupler) {
    union() {
        _hub75_middle_coupler_design_horizontal_arm_2d(coupler);
        _hub75_middle_coupler_design_vertical_arm_2d(coupler);
    }
}


module _hub75_middle_coupler_design_horizontal_rib_2d(coupler) {
    square(
        [
            coupler.profile_size + 4,
            coupler.rear_crossbar_width
        ],
        center = true
    );
}


module _hub75_middle_coupler_design_vertical_rib_2d(coupler) {
    square(
        [
            hub75_middle_coupler_seam_keepout_width(coupler),
            coupler.profile_size + 4
        ],
        center = true
    );
}


module _hub75_middle_coupler_design_profile_outline_2d(
    coupler,
    line_width = 1.0
) {
    difference() {
        _hub75_middle_coupler_profile_2d(coupler);

        offset(delta = -line_width)
            _hub75_middle_coupler_profile_2d(coupler);
    }
}


module _hub75_middle_coupler_design_reinforcement_crop(
    coupler,
    position,
    crop_width = 34,
    crop_height = 34
) {
    translate([
        position[0] - crop_width / 2,
        -coupler.guide_height - 2,
        position[1] - crop_height / 2
    ])
        cube([
            crop_width,
            coupler.guide_height + 3,
            crop_height
        ]);
}


module _hub75_middle_coupler_design_reinforcement_panel_fragment(
    coupler,
    position,
    fragment_length = 24,
    fragment_depth = 6.5
) {
    // Diagrammatic local reconstruction of the physical HUB75 side-rail
    // reinforcement at one of the two coupler contact points. Every dimension
    // comes from the panel-derived coupler object: no panel measurement is
    // duplicated here. The detail deliberately omits unrelated panel area.
    outer_d = coupler.reinforcement_bushing_outer_diameter;
    recess_d = coupler.reinforcement_bushing_recess_diameter;
    recess_depth = coupler.reinforcement_bushing_recess_depth;
    hole_d = coupler.reinforcement_bushing_hole_diameter;
    hole_depth = coupler.reinforcement_bushing_hole_depth;
    rail_width = coupler.rear_side_rail_width;
    eps = 0.04;

    translate([position[0], 0, position[1]])
        difference() {
            // Rear side rail plus the retained circular reinforcement footprint.
            _hub75_middle_coupler_extrude_xz_y(-fragment_depth, 0)
                union() {
                    square([rail_width, fragment_length], center = true);
                    circle(d = outer_d);
                }

            // Large rear-facing recess in the reinforcement feature.
            _hub75_middle_coupler_extrude_xz_y(
                -recess_depth - eps,
                 eps
            )
                circle(d = recess_d);

            // Smaller blind hole continuing from the floor of the recess.
            _hub75_middle_coupler_extrude_xz_y(
                -recess_depth - hole_depth,
                -recess_depth + eps
            )
                circle(d = hole_d);
        }
}


module _hub75_middle_coupler_design_reinforcement_guide_fragment(
    coupler,
    position
) {
    intersection() {
        _hub75_middle_coupler_extrude_xz_y(
            -coupler.guide_height,
            0
        )
            _hub75_middle_coupler_guide_shell_2d(coupler);

        _hub75_middle_coupler_design_reinforcement_crop(
            coupler,
            position
        );
    }
}


module _hub75_middle_coupler_design_reinforcement_clearance_band(
    coupler,
    position
) {
    outer_d =
        coupler.reinforcement_bushing_outer_diameter
        + 2 * coupler.reinforcement_bushing_clearance;
    inner_d = coupler.reinforcement_bushing_outer_diameter;

    // Thin red halo outside the physical reinforcement footprint. It makes the
    // print-clearance requirement visible without hiding the dark panel detail.
    translate([position[0], 0, position[1]])
        difference() {
            _hub75_middle_coupler_extrude_xz_y(
                -coupler.guide_height,
                0
            )
                circle(d = outer_d);

            _hub75_middle_coupler_extrude_xz_y(
                -coupler.guide_height - 0.05,
                0.05
            )
                circle(d = inner_d);
        }
}


module _hub75_middle_coupler_design_reinforcement_collision(
    coupler,
    position
) {
    // Show only guide material that lies inside the reinforcement relief
    // cutter. This is the exact material removed from the unrelieved guide,
    // not the complete abstract cutter cylinder.
    intersection() {
        _hub75_middle_coupler_design_reinforcement_guide_fragment(
            coupler,
            position
        );

        _hub75_middle_coupler_reinforcement_relief_cutters(coupler);
    }
}


module _hub75_middle_coupler_design_after_reference_pockets(coupler) {
    // Construction state used only by the documentation: the complete
    // functional coupler with the blind reference pockets already cut, but
    // before the centre cross and distance ticks are added.
    union() {
        difference() {
            _hub75_middle_coupler_base_after_pockets(coupler);
            _hub75_middle_coupler_reference_pocket_cutters(coupler);
        }

        if (coupler.guide_height > 0)
            _hub75_middle_coupler_guide_walls(coupler);

        _hub75_middle_coupler_reinforcement_locators(coupler);

        if (coupler.seam_locator_height > 0)
            _hub75_middle_coupler_seam_locator(coupler);
    }
}


// Module: hub75_middle_coupler_design()
// Description:
//   Creates the default medium-sized coupler and renders one named design view.
//   Construction-only views live here; production/debug views are delegated to
//   hub75_middle_coupler_render().
module hub75_middle_coupler_design(view = "final") {
    panel = hub75_p5_64x32_panel_create();
    coupler = hub75_middle_coupler_create(panel = panel);

    // Construction diagrams deliberately use a darker grey than the normal
    // 3D debug render. It must remain legible against both the light page
    // background and the red current-operation geometry.
    existing = [0.56, 0.56, 0.56, 1.0];
    existing_transparent = [0.56, 0.56, 0.56, 0.42];
    current = [0.88, 0.08, 0.06, 0.68];

    if (view == "mating-reference") {
        // Red expanded envelope is placed behind the physical grey keep-out.
        // The grey reference therefore remains readable while the red border
        // still exposes the added fit clearance on every outside edge.
        color(current)
            _hub75_middle_coupler_design_thin(-0.42, -0.02)
                offset(delta = coupler.fit_clearance)
                    _hub75_middle_coupler_rib_cross_keepout_2d(coupler);

        color(existing)
            _hub75_middle_coupler_design_thin(0.02, 0.42)
                _hub75_middle_coupler_rib_cross_keepout_2d(coupler);

    } else if (view == "profile-horizontal-arm") {
        // Red: complete printable arm envelope. Grey: the physical crossbar
        // reference used to derive its height. Put the reference in front so
        // it cannot disappear inside the larger red rectangle.
        color(current)
            _hub75_middle_coupler_design_thin(-0.42, -0.02)
                _hub75_middle_coupler_design_horizontal_arm_2d(coupler);

        color(existing)
            _hub75_middle_coupler_design_thin(0.02, 0.42)
                _hub75_middle_coupler_design_horizontal_rib_2d(coupler);

    } else if (view == "profile-vertical-arm") {
        // Grey: the already established horizontal arm. Red: the vertical arm
        // around the two side rails and the seam between the panels. Keeping
        // grey in front preserves the visible previous construction state in
        // the overlap region.
        color(current)
            _hub75_middle_coupler_design_thin(-0.42, -0.02)
                _hub75_middle_coupler_design_vertical_arm_2d(coupler);

        color(existing)
            _hub75_middle_coupler_design_thin(0.02, 0.42)
                _hub75_middle_coupler_design_horizontal_arm_2d(coupler);

    } else if (view == "profile-raw-plus") {
        color(current)
            _hub75_middle_coupler_design_thin()
                _hub75_middle_coupler_design_raw_plus_2d(coupler);

    } else if (view == "profile-rounded") {
        // The production profile is a directly generated polygon, but it is
        // easiest to understand as the raw PLUS with concave transitions and
        // convex free ends rounded. Grey remnants show what rounding removes.
        color(existing_transparent)
            _hub75_middle_coupler_design_thin(-0.42, -0.02)
                _hub75_middle_coupler_design_raw_plus_2d(coupler);

        color(current)
            _hub75_middle_coupler_design_thin(0.02, 0.42)
                _hub75_middle_coupler_profile_2d(coupler);

    } else if (view == "guide-keepout") {
        // The guide subtraction only cares about the forbidden region inside
        // the printable PLUS. Show that region in red and keep the complete
        // printable boundary visible as a grey outline instead of hiding it
        // underneath another opaque filled shape.
        color(current)
            _hub75_middle_coupler_design_thin(-0.42, -0.02)
                intersection() {
                    _hub75_middle_coupler_profile_2d(coupler);

                    offset(delta = coupler.fit_clearance)
                        _hub75_middle_coupler_rib_cross_keepout_2d(coupler);
                }

        color(existing)
            _hub75_middle_coupler_design_thin(0.02, 0.42)
                _hub75_middle_coupler_design_profile_outline_2d(coupler);

    } else if (view == "guide-raw-shell") {
        // Keep the starting printable footprint visible behind the subtraction
        // result. Grey is the rounded PLUS; red is the material that remains
        // after the clearance-expanded rib cross has been removed.
        color(existing_transparent)
            _hub75_middle_coupler_design_thin(-0.42, -0.02)
                _hub75_middle_coupler_profile_2d(coupler);

        color(current)
            _hub75_middle_coupler_design_thin(0.02, 0.42)
                _hub75_middle_coupler_raw_guide_shell_2d(coupler);

    } else if (view == "guide-rounded-shell") {
        color(existing_transparent)
            _hub75_middle_coupler_design_thin(-0.42, -0.02)
                _hub75_middle_coupler_raw_guide_shell_2d(coupler);

        color(current)
            _hub75_middle_coupler_design_thin(0.02, 0.42)
                _hub75_middle_coupler_guide_shell_2d(coupler);

    } else if (view == "guide-reinforcement-reliefs") {
        // One enlarged physical detail is clearer than two small mirrored
        // examples. The same relief operation is applied at both reinforcement
        // positions in production. Dark grey is the panel-derived side-rail
        // reinforcement, pale grey the still-unrelieved guide. The transparent
        // red halo shows required print clearance; saturated red is the guide
        // material that actually intrudes into that protected volume.
        detail_position =
            _hub75_middle_coupler_reinforcement_positions(coupler)[1];

        color([0.43, 0.43, 0.43, 1.0])
            _hub75_middle_coupler_design_reinforcement_panel_fragment(
                coupler,
                detail_position
            );

        color([0.72, 0.72, 0.72, 0.48])
            _hub75_middle_coupler_design_reinforcement_guide_fragment(
                coupler,
                detail_position
            );

        color([0.88, 0.08, 0.06, 0.30])
            _hub75_middle_coupler_design_reinforcement_clearance_band(
                coupler,
                detail_position
            );

        color([0.94, 0.03, 0.02, 0.96])
            _hub75_middle_coupler_design_reinforcement_collision(
                coupler,
                detail_position
            );

    } else if (view == "center-marks") {
        // The reference pockets belong to the previous stage. Render them as
        // actual recesses in the grey coupler and highlight only the newly
        // introduced centre cross and distance-tick cutters in red.
        color(existing)
            _hub75_middle_coupler_design_after_reference_pockets(coupler);

        color(current)
            _hub75_middle_coupler_center_mark_cutters(coupler);

    } else {
        hub75_middle_coupler_render(
            coupler,
            view = view
        );
    }
}


// Direct opening shows the finished component.
hub75_middle_coupler_design();
