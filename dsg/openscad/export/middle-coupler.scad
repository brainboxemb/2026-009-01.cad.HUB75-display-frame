// STL export entrypoint for the milestone-2 middle coupler.

use <../project_components/middle-coupler/hub75_middle_coupler.scad>

coupler = hub75_middle_coupler_create();

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
