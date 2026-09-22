// STL export entrypoint for the milestone-3 horizontal-edge coupler.

use <../components/hub75/horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>
use <../export_support/export_orientation.scad>

// tool.scad-project multi-size adapter: overridden by -D size=...
size = "medium";
d_profile = size;

coupler_obj =
    hub75_horizontal_edge_coupler_create_for_size(
        size = d_profile
    );

expected_profile =
    d_profile == "small" ? [60, 2, 4, 2]
    : d_profile == "large" ? [100, 6, 10, 4]
    : [80, 4, 6, 3];

assert(
    abs(coupler_obj.profile_size - expected_profile[0]) < 0.001
    && abs(coupler_obj.wall_thickness - expected_profile[1]) < 0.001
    && abs(coupler_obj.guide_height - expected_profile[2]) < 0.001
    && abs(coupler_obj.base_thickness - expected_profile[3]) < 0.001,
    "Horizontal-edge coupler size preset changed"
);

assert(
    abs(coupler_obj.screw_row_z + 8.0) < 0.001,
    "Horizontal-edge screw row must remain 8 mm inside nominal edge"
);

assert(
    abs(
        hub75_horizontal_edge_coupler_rear_rail_center_z(coupler_obj)
        + 6.14443359375
    ) < 0.001,
    "Horizontal-edge rear rail centre derivation changed"
);

assert(
    abs(
        hub75_horizontal_edge_coupler_vertical_arm_width(coupler_obj)
        - (
            d_profile == "small" ? 29.8
            : d_profile == "large" ? 37.8
            : 33.8
        )
    ) < 0.001,
    "Horizontal-edge vertical arm derivation changed"
);

assert(
    abs(coupler_obj.screw_relief_depth - 0.20) < 0.001
    && abs(coupler_obj.screw_relief_radial - 0.40) < 0.001,
    "Horizontal-edge screw relief changed"
);

assert(
    abs(coupler_obj.reference_pocket_depth - 2.0) < 0.001
    && abs(coupler_obj.reference_pocket_min_back_wall - 0.7) < 0.001
    && abs(coupler_obj.reference_pocket_end_diameter - 2.0) < 0.001
    && abs(coupler_obj.reference_pocket_taper_depth - 0.5) < 0.001,
    "Horizontal-edge reference pocket defaults changed"
);

assert(
    abs(
        hub75_horizontal_edge_coupler_reference_pocket_effective_depth(coupler_obj)
        - (d_profile == "small" ? 1.3 : 2.0)
    ) < 0.001,
    "Horizontal-edge reference pocket effective depth changed"
);

assert(
    abs(
        hub75_horizontal_edge_coupler_reinforcement_locator_pad_diameter(coupler_obj)
        - 9.4
    ) < 0.001
    &&
    abs(
        hub75_horizontal_edge_coupler_reinforcement_locator_pin_diameter(coupler_obj)
        - 2.1
    ) < 0.001,
    "Horizontal-edge reinforcement locator derivation changed"
);

assert(
    hub75_horizontal_edge_coupler_outer_projection(coupler_obj) < 20,
    "Horizontal-edge outside projection exceeds project limit"
);

hub75_export_rear_face_down(coupler_obj.base_thickness)
    hub75_horizontal_edge_coupler_build(coupler_obj);
