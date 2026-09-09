// STL export entrypoint for the milestone-2 middle coupler.

use <../project_components/middle-coupler/hub75_middle_coupler.scad>

coupler = hub75_middle_coupler_create();

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
    coupler.render_fn >= 192,
    "Middle coupler STL resolution dropped below approved quality"
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
    abs(
        hub75_middle_coupler_horizontal_arm_height(coupler)
        - 28.481875
    ) < 0.001,
    "Default horizontal arm derivation changed"
);

assert(
    abs(
        hub75_middle_coupler_vertical_arm_width(coupler)
        - 33.8
    ) < 0.001,
    "Default vertical arm derivation changed"
);

assert(
    abs(
        hub75_middle_coupler_seam_locator_width(coupler)
        - 2.2953125
    ) < 0.001,
    "Default seam locator derivation changed"
);

assert(
    abs(
        hub75_middle_coupler_screw_x_positions(coupler)[0]
        + 8
    ) < 0.001
    &&
    abs(
        hub75_middle_coupler_screw_x_positions(coupler)[1]
        - 8
    ) < 0.001,
    "Default seam-side screw positions changed"
);

hub75_middle_coupler_build(coupler);
