// STL export entrypoint for the right corner-edge coupler.

use <../project_components/corner-edge-coupler/hub75_corner_edge_coupler.scad>

size = "medium";

coupler =
    hub75_corner_edge_coupler_create_for_size(
        side = "right",
        size = size
    );

expected_profile =
    size == "small" ? [60, 2, 4, 2]
    : size == "large" ? [100, 6, 10, 4]
    : [80, 4, 6, 3];

expected_horizontal_arm =
    size == "small" ? 14.0011328125
    : size == "large" ? 22.0011328125
    : 18.0011328125;

expected_vertical_arm =
    size == "small" ? 15.75234375
    : size == "large" ? 23.75234375
    : 19.75234375;

expected_screw_x =
    "right" == "left" ? 8 : -8;

assert(
    abs(coupler.profile_size - expected_profile[0]) < 0.001
    && abs(coupler.wall_thickness - expected_profile[1]) < 0.001
    && abs(coupler.guide_height - expected_profile[2]) < 0.001
    && abs(coupler.base_thickness - expected_profile[3]) < 0.001,
    "Corner-edge size preset changed"
);

assert(
    abs(coupler.outside_projection - 19.5) < 0.001,
    "Corner-edge outside projection changed"
);

assert(
    abs(coupler.screw_x - expected_screw_x) < 0.001
    && abs(coupler.screw_z + 8.0) < 0.001,
    "Corner-edge screw position changed"
);

assert(
    abs(
        hub75_corner_edge_coupler_side_rail_center_x(coupler)
        - ("right" == "left" ? 7.023828125 : -7.023828125)
    ) < 0.001,
    "Corner-edge side-rail centre derivation changed"
);

assert(
    abs(
        hub75_corner_edge_coupler_end_rail_center_z(coupler)
        + 6.14443359375
    ) < 0.001,
    "Corner-edge end-rail centre derivation changed"
);

assert(
    abs(
        hub75_corner_edge_coupler_horizontal_arm_height(coupler)
        - expected_horizontal_arm
    ) < 0.001,
    "Corner-edge horizontal arm derivation changed"
);

assert(
    abs(
        hub75_corner_edge_coupler_vertical_arm_width(coupler)
        - expected_vertical_arm
    ) < 0.001,
    "Corner-edge vertical arm derivation changed"
);

assert(
    abs(coupler.screw_relief_depth - 0.20) < 0.001
    && abs(coupler.screw_relief_radial - 0.40) < 0.001,
    "Corner-edge screw relief changed"
);

assert(
    abs(
        hub75_corner_edge_coupler_reference_pocket_effective_depth(coupler)
        - (size == "small" ? 1.3 : 2.0)
    ) < 0.001,
    "Corner-edge reference pocket depth changed"
);

assert(
    abs(
        hub75_corner_edge_coupler_reinforcement_locator_pad_diameter(coupler)
        - 9.4
    ) < 0.001
    &&
    abs(
        hub75_corner_edge_coupler_reinforcement_locator_pin_diameter(coupler)
        - 2.1
    ) < 0.001,
    "Corner-edge reinforcement locator derivation changed"
);

assert(
    hub75_corner_edge_coupler_has_locator_pin(coupler)
        == ("right" == "left"),
    "Corner-edge locator-pin chirality changed"
);

if ("right" == "left") {
    locator =
        hub75_corner_edge_coupler_locator_pin_position(coupler);

    assert(
        abs(locator[0] - 5.0) < 0.001
        && abs(locator[1] + 50.0) < 0.001,
        "Top-left locator-pin position changed"
    );
}

hub75_corner_edge_coupler_build(coupler);
