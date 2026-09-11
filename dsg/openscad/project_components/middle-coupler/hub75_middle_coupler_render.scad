// File: hub75_middle_coupler_render.scad
//   Design-documentation adapter for the project-specific middle coupler.
//
// This file deliberately contains explanatory construction views that are not
// part of the production component API. They expose the geometric reasoning
// behind the coupler without forcing the production model to be written as the
// same sequence of primitive operations used for teaching the design.

$fn = 120;

use <hub75_middle_coupler.scad>


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


// Module: hub75_middle_coupler_design()
// Description:
//   Creates the default medium-sized coupler and renders one named design view.
//   Construction-only views live here; production/debug views are delegated to
//   hub75_middle_coupler_render().
module hub75_middle_coupler_design(view = "final") {
    coupler = hub75_middle_coupler_create();

    existing = [0.72, 0.72, 0.72, 1.0];
    existing_transparent = [0.72, 0.72, 0.72, 0.38];
    current = [0.88, 0.08, 0.06, 0.68];

    if (view == "mating-reference") {
        // Grey: actual rear rib cross. Red: printable clearance envelope around
        // the panel material. This is the physical reference from which both
        // PLUS-arm thicknesses are derived.
        color(existing)
            _hub75_middle_coupler_design_thin(-0.40, 0.0)
                _hub75_middle_coupler_rib_cross_keepout_2d(coupler);

        color(current)
            _hub75_middle_coupler_design_thin(0.02, 0.42)
                offset(delta = coupler.fit_clearance)
                    _hub75_middle_coupler_rib_cross_keepout_2d(coupler);

    } else if (view == "profile-horizontal-arm") {
        // The horizontal arm is the physical crossbar plus clearance and wall
        // material on both Z sides.
        color(existing)
            _hub75_middle_coupler_design_thin(-0.40, 0.0)
                _hub75_middle_coupler_design_horizontal_rib_2d(coupler);

        color(current)
            _hub75_middle_coupler_design_thin(0.02, 0.42)
                _hub75_middle_coupler_design_horizontal_arm_2d(coupler);

    } else if (view == "profile-vertical-arm") {
        // Grey: the already established horizontal arm. Red: the vertical arm
        // around the two side rails and the seam between the panels.
        color(existing)
            _hub75_middle_coupler_design_thin(-0.40, 0.0)
                _hub75_middle_coupler_design_horizontal_arm_2d(coupler);

        color(current)
            _hub75_middle_coupler_design_thin(0.02, 0.42)
                _hub75_middle_coupler_design_vertical_arm_2d(coupler);

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
        // Grey: printable PLUS area. Red: actual rear rib cross expanded by the
        // fit clearance that the raised guides must stay outside of.
        color(existing_transparent)
            _hub75_middle_coupler_design_thin(-0.42, -0.02)
                _hub75_middle_coupler_profile_2d(coupler);

        color(current)
            _hub75_middle_coupler_design_thin(0.02, 0.42)
                offset(delta = coupler.fit_clearance)
                    _hub75_middle_coupler_rib_cross_keepout_2d(coupler);

    } else if (view == "guide-raw-shell") {
        color(current)
            _hub75_middle_coupler_design_thin()
                _hub75_middle_coupler_raw_guide_shell_2d(coupler);

    } else if (view == "guide-rounded-shell") {
        color(existing_transparent)
            _hub75_middle_coupler_design_thin(-0.42, -0.02)
                _hub75_middle_coupler_raw_guide_shell_2d(coupler);

        color(current)
            _hub75_middle_coupler_design_thin(0.02, 0.42)
                _hub75_middle_coupler_guide_shell_2d(coupler);

    } else if (view == "guide-reinforcement-reliefs") {
        color(existing_transparent)
            _hub75_middle_coupler_extrude_xz_y(
                -coupler.guide_height,
                0
            )
                _hub75_middle_coupler_guide_shell_2d(coupler);

        color(current)
            _hub75_middle_coupler_reinforcement_relief_cutters(coupler);

    } else {
        hub75_middle_coupler_render(
            coupler,
            view = view
        );
    }
}


// Direct opening shows the finished component.
hub75_middle_coupler_design();
