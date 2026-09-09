// STL export entrypoint for the milestone-2 middle coupler.

use <../project_components/middle-coupler/hub75_middle_coupler.scad>

size = "medium";

coupler = hub75_middle_coupler_create_for_size(size = size);

expected_profile =
    size == "small" ? [60, 2, 4, 2]
    : size == "large" ? [100, 6, 10, 4]
    : [80, 4, 6, 3];

assert(
    abs(coupler.profile_size - expected_profile[0]) < 0.001
    && abs(coupler.wall_thickness - expected_profile[1]) < 0.001
    && abs(coupler.guide_height - expected_profile[2]) < 0.001
    && abs(coupler.base_thickness - expected_profile[3]) < 0.001,
    "Middle coupler size preset changed"
);

assert(
    abs(coupler.inside_corner_radius - 10) < 0.001
    && abs(coupler.outside_corner_radius - 6) < 0.001,
    "Middle coupler must retain the approved rounded v120 profile"
);

assert(
    abs(coupler.guide_end_rounding - 1.5) < 0.001
    && abs(coupler.seam_locator_end_radius - 1.0) < 0.001,
    "Middle coupler guide/locator rounding changed"
);

assert(
    abs(coupler.screw_relief_depth - 0.20) < 0.001
    && abs(coupler.screw_relief_radial - 0.40) < 0.001,
    "Middle coupler screw anti-elephant-foot relief changed"
);

assert(
    coupler.render_fn >= 192,
    "Middle coupler STL resolution dropped below approved quality"
);

assert(
    abs(coupler.reference_pocket_diameter - 3.0) < 0.001
    && abs(coupler.reference_pocket_depth - 2.5) < 0.001
    && abs(coupler.reference_pocket_end_diameter - 2.0) < 0.001
    && abs(coupler.reference_pocket_taper_depth - 0.5) < 0.001
    && abs(coupler.reference_pocket_pitch - 10.0) < 0.001,
    "Middle coupler reference pocket defaults changed"
);

assert(
    size != "medium"
    ||
    abs(
        hub75_middle_coupler_reference_pocket_lane_offset(
            coupler,
            hub75_middle_coupler_horizontal_arm_height(coupler)
        )
        - 7.5
    ) < 0.001
    &&
    abs(
        hub75_middle_coupler_reference_pocket_lane_offset(
            coupler,
            hub75_middle_coupler_vertical_arm_width(coupler)
        )
        - 7.5
    ) < 0.001,
    "Middle coupler reference pocket lane derivation changed"
);

assert(
    size != "medium"
    || hub75_middle_coupler_reference_pocket_uses_two_lanes(coupler),
    "Default middle coupler should support symmetric two-lane pockets"
);

assert(
    abs(coupler.center_mark_depth - 0.40) < 0.001
    && abs(coupler.center_mark_pitch - 10.0) < 0.001
    && abs(coupler.center_mark_major_length - 4.0) < 0.001
    && abs(coupler.center_mark_minor_length - 2.2) < 0.001
    && abs(coupler.center_mark_width - 0.8) < 0.001
    && abs(coupler.center_mark_cross_length - 6.0) < 0.001,
    "Middle coupler centre-reference defaults changed"
);

assert(
    abs(
        hub75_middle_coupler_reinforcement_locator_pad_diameter(coupler)
        - 9.4
    ) < 0.001
    &&
    abs(
        hub75_middle_coupler_reinforcement_locator_pad_height(coupler)
        - 2.4
    ) < 0.001,
    "Reinforcement locator pad derivation changed"
);

assert(
    abs(
        hub75_middle_coupler_reinforcement_locator_pin_diameter(coupler)
        - 2.1
    ) < 0.001
    &&
    abs(coupler.reinforcement_locator_pin_length - 2.0) < 0.001,
    "Reinforcement locator pin derivation changed"
);

// These are milestone verification expectations, not geometry sources.
assert(
    size != "medium"
    ||
    abs(
        hub75_middle_coupler_horizontal_arm_height(coupler)
        - 28.481875
    ) < 0.001,
    "Default horizontal arm derivation changed"
);

assert(
    size != "medium"
    ||
    abs(
        hub75_middle_coupler_vertical_arm_width(coupler)
        - 33.8
    ) < 0.001,
    "Default vertical arm derivation changed"
);

assert(
    size != "medium"
    ||
    abs(
        hub75_middle_coupler_seam_locator_width(coupler)
        - 2.2953125
    ) < 0.001,
    "Default seam locator derivation changed"
);

assert(
    size != "medium"
    ||
    (
    abs(
        hub75_middle_coupler_screw_x_positions(coupler)[0]
        + 8
    ) < 0.001
    &&
    abs(
        hub75_middle_coupler_screw_x_positions(coupler)[1]
        - 8
    ) < 0.001
    ),
    "Default seam-side screw positions changed"
);

hub75_middle_coupler_build(coupler);
