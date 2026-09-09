// File: hub75_horizontal_edge_coupler.scad
//   Project-specific T-shaped coupler for two adjacent portrait HUB75 panels
//   at the top or bottom display edge.
//
// Coordinate system:
// - local X=0 is the nominal seam between the two adjacent panels;
// - local Y=0 is the panel rear mounting plane;
// - local Z=0 is the nominal 320 mm panel edge;
// - the base extends toward +Y, behind the display;
// - guides, reinforcement locators and the seam locator extend toward -Y.
//
// The production component is modelled in the TOP-edge orientation. The same
// printable part is used at the bottom edge after a 180 degree rotation.
//
// This first horizontal-edge implementation deliberately has NO tube clip.
// The objective is to establish the T body and panel fit before adding frame
// reinforcement hardware.

use <../../ext/lib.scad.hub75/openscad/p5-64x32-panel/hub75_p5_64x32_panel.scad>

/* [Core profile] */
profile_size = 80;
wall_thickness = 4;
fit_clearance = 0.25;
base_thickness = 3;
guide_height = 6;
inside_corner_radius = 10;
outside_corner_radius = 6;
guide_end_rounding = 1.5;

/* [Mounting] */
screw_hole_diameter = 3.4;
screw_relief_depth = 0.20;
screw_relief_radial = 0.40;
mounting_tube_radial_clearance = 0.45;
mounting_tube_axial_clearance = 0.40;
locator_pin_clearance = 0.35;

reinforcement_bushing_clearance = 0.45;
reinforcement_locator_pad_radial_clearance = 0.30;
reinforcement_locator_pad_axial_clearance = 0.10;
reinforcement_locator_pin_radial_clearance = 0.20;
reinforcement_locator_pin_length = 2.0;

/* [Surface reference details] */
show_reference_pockets = true;
reference_pocket_diameter = 3.0;
reference_pocket_depth = 2.0;
reference_pocket_min_back_wall = 0.7;
reference_pocket_end_diameter = 2.0;
reference_pocket_taper_depth = 0.5;
reference_pocket_pitch = 10.0;
reference_pocket_steps = [2, 3, 4];
reference_pocket_lane_grid = 2.5;
reference_pocket_lane_fraction = 0.25;
reference_pocket_edge_margin = 4.0;

show_center_reference_marks = true;
center_mark_depth = 0.40;
center_mark_pitch = 10.0;
center_mark_major_length = 4.0;
center_mark_minor_length = 2.2;
center_mark_width = 0.8;
center_mark_cross_length = 6.0;
center_mark_edge_margin = 4.0;
center_mark_screw_keepout = 3.0;

/* [Seam / outer edge locator] */
seam_locator_height = 4;
seam_locator_lead_in_per_side = 0.20;
seam_locator_end_radius = 1.00;
outer_ridge_taper_inset = 0.35;

/* [Preview] */
preview_view = "final"; // [final,functional,profile,base,screw-holes,tube-pockets,locator-pin-clearance,guides,reinforcement-locators,seam-locator,reference-pockets,center-marks]

/* [Resolution] */
render_fn = 192;

$fn = render_fn;

_HUB75_HORIZONTAL_EDGE_COUPLER_EPS = 0.05;


// ----------------------------------------------------------------------
// Public object API
// ----------------------------------------------------------------------

function hub75_horizontal_edge_coupler_create(
    panel = hub75_p5_64x32_panel_create(),
    profile_size = 80,
    wall_thickness = 4,
    fit_clearance = 0.25,
    base_thickness = 3,
    guide_height = 6,
    inside_corner_radius = 10,
    outside_corner_radius = 6,
    guide_end_rounding = 1.5,
    render_fn = 192,

    screw_hole_diameter = 3.4,
    screw_relief_depth = 0.20,
    screw_relief_radial = 0.40,
    mounting_tube_radial_clearance = 0.45,
    mounting_tube_axial_clearance = 0.40,
    locator_pin_clearance = 0.35,

    reinforcement_bushing_clearance = 0.45,
    reinforcement_locator_pad_radial_clearance = 0.30,
    reinforcement_locator_pad_axial_clearance = 0.10,
    reinforcement_locator_pin_radial_clearance = 0.20,
    reinforcement_locator_pin_length = 2.0,

    show_reference_pockets = true,
    reference_pocket_diameter = 3.0,
    reference_pocket_depth = 2.0,
    reference_pocket_min_back_wall = 0.7,
    reference_pocket_end_diameter = 2.0,
    reference_pocket_taper_depth = 0.5,
    reference_pocket_pitch = 10.0,
    reference_pocket_steps = [2, 3, 4],
    reference_pocket_lane_grid = 2.5,
    reference_pocket_lane_fraction = 0.25,
    reference_pocket_edge_margin = 4.0,

    show_center_reference_marks = true,
    center_mark_depth = 0.40,
    center_mark_pitch = 10.0,
    center_mark_major_length = 4.0,
    center_mark_minor_length = 2.2,
    center_mark_width = 0.8,
    center_mark_cross_length = 6.0,
    center_mark_edge_margin = 4.0,
    center_mark_screw_keepout = 3.0,

    seam_locator_height = 4,
    seam_locator_lead_in_per_side = 0.20,
    seam_locator_end_radius = 1.00,
    outer_ridge_taper_inset = 0.35
) =
    let(
        screw_x = _hub75_horizontal_edge_coupler_seam_screw_x_positions(panel),
        screw_row_z = _hub75_horizontal_edge_coupler_top_screw_row_z(panel),
        rear_outer_edge_z =
            _hub75_horizontal_edge_coupler_rear_outer_edge_z(panel)
    )
    assert(profile_size > 0, "profile_size must be > 0")
    assert(wall_thickness > 0, "wall_thickness must be > 0")
    assert(fit_clearance >= 0, "fit_clearance must be >= 0")
    assert(base_thickness > 0, "base_thickness must be > 0")
    assert(guide_height >= 0, "guide_height must be >= 0")
    assert(guide_end_rounding >= 0, "guide_end_rounding must be >= 0")
    assert(render_fn >= 24, "render_fn must be >= 24")
    assert(screw_hole_diameter > 0, "screw_hole_diameter must be > 0")
    assert(screw_relief_depth >= 0, "screw_relief_depth must be >= 0")
    assert(screw_relief_radial >= 0, "screw_relief_radial must be >= 0")
    assert(locator_pin_clearance >= 0, "locator pin clearance must be >= 0")
    assert(reference_pocket_diameter > 0, "reference pocket diameter must be > 0")
    assert(reference_pocket_depth >= 0, "reference pocket depth must be >= 0")
    assert(reference_pocket_min_back_wall >= 0, "reference pocket back wall must be >= 0")
    assert(reference_pocket_end_diameter > 0, "reference pocket end diameter must be > 0")
    assert(reference_pocket_end_diameter <= reference_pocket_diameter,
        "reference pocket end diameter must not exceed visible diameter")
    assert(reference_pocket_taper_depth >= 0, "reference pocket taper must be >= 0")
    assert(reference_pocket_taper_depth <= reference_pocket_depth,
        "reference pocket taper must fit inside pocket depth")
    assert(seam_locator_height >= 0, "seam locator height must be >= 0")
    object(
        profile_size = profile_size,
        wall_thickness = wall_thickness,
        fit_clearance = fit_clearance,
        base_thickness = base_thickness,
        guide_height = guide_height,
        inside_corner_radius = inside_corner_radius,
        outside_corner_radius = outside_corner_radius,
        guide_end_rounding = guide_end_rounding,
        render_fn = render_fn,

        screw_hole_diameter = screw_hole_diameter,
        screw_relief_depth = screw_relief_depth,
        screw_relief_radial = screw_relief_radial,
        mounting_tube_radial_clearance = mounting_tube_radial_clearance,
        mounting_tube_axial_clearance = mounting_tube_axial_clearance,
        locator_pin_clearance = locator_pin_clearance,

        reinforcement_bushing_clearance = reinforcement_bushing_clearance,
        reinforcement_locator_pad_radial_clearance =
            reinforcement_locator_pad_radial_clearance,
        reinforcement_locator_pad_axial_clearance =
            reinforcement_locator_pad_axial_clearance,
        reinforcement_locator_pin_radial_clearance =
            reinforcement_locator_pin_radial_clearance,
        reinforcement_locator_pin_length =
            reinforcement_locator_pin_length,

        show_reference_pockets = show_reference_pockets,
        reference_pocket_diameter = reference_pocket_diameter,
        reference_pocket_depth = reference_pocket_depth,
        reference_pocket_min_back_wall = reference_pocket_min_back_wall,
        reference_pocket_end_diameter = reference_pocket_end_diameter,
        reference_pocket_taper_depth = reference_pocket_taper_depth,
        reference_pocket_pitch = reference_pocket_pitch,
        reference_pocket_steps = reference_pocket_steps,
        reference_pocket_lane_grid = reference_pocket_lane_grid,
        reference_pocket_lane_fraction = reference_pocket_lane_fraction,
        reference_pocket_edge_margin = reference_pocket_edge_margin,

        show_center_reference_marks = show_center_reference_marks,
        center_mark_depth = center_mark_depth,
        center_mark_pitch = center_mark_pitch,
        center_mark_major_length = center_mark_major_length,
        center_mark_minor_length = center_mark_minor_length,
        center_mark_width = center_mark_width,
        center_mark_cross_length = center_mark_cross_length,
        center_mark_edge_margin = center_mark_edge_margin,
        center_mark_screw_keepout = center_mark_screw_keepout,

        seam_locator_height = seam_locator_height,
        seam_locator_lead_in_per_side = seam_locator_lead_in_per_side,
        seam_locator_end_radius = seam_locator_end_radius,
        outer_ridge_taper_inset = outer_ridge_taper_inset,

        rear_seam_gap =
            hub75_p5_64x32_panel_rear_grid_gap_x(panel),
        rear_side_rail_width =
            hub75_p5_64x32_panel_rear_side_rail_width_at_mounting_plane(panel),
        rear_end_rail_width =
            hub75_p5_64x32_panel_rear_end_rail_width_at_mounting_plane(panel),
        rear_opening_corner_radius =
            hub75_p5_64x32_panel_rear_opening_corner_radius(panel),
        rear_outer_edge_z = rear_outer_edge_z,

        mounting_tube_outer_diameter =
            hub75_p5_64x32_panel_mounting_tube_outer_diameter(panel),
        mounting_tube_protrusion =
            hub75_p5_64x32_panel_mounting_tube_protrusion(panel),

        reinforcement_bushing_outer_diameter =
            hub75_p5_64x32_panel_reinforcement_bushing_outer_diameter(panel),
        reinforcement_bushing_recess_diameter =
            hub75_p5_64x32_panel_reinforcement_bushing_recess_diameter(panel),
        reinforcement_bushing_recess_depth =
            hub75_p5_64x32_panel_reinforcement_bushing_recess_depth(panel),
        reinforcement_bushing_hole_diameter =
            hub75_p5_64x32_panel_reinforcement_bushing_hole_diameter(panel),
        reinforcement_bushing_hole_depth =
            hub75_p5_64x32_panel_reinforcement_bushing_hole_depth(panel),
        reinforcement_bushing_offset =
            hub75_p5_64x32_panel_reinforcement_bushing_offset(panel),

        locator_pin_diameter =
            hub75_p5_64x32_panel_locator_pin_diameter(panel),
        locator_pin_protrusion =
            hub75_p5_64x32_panel_locator_pin_protrusion(panel),
        locator_pin_x_delta =
            hub75_locator_pin_near_edge_screw_x_delta(panel),
        locator_pin_z_delta =
            hub75_locator_pin_edge_screw_z_delta(panel),

        screw_x_left = screw_x[0],
        screw_x_right = screw_x[1],
        screw_row_z = screw_row_z
    );


function hub75_horizontal_edge_coupler_create_for_size(
    size = "medium",
    panel = hub75_p5_64x32_panel_create()
) =
    assert(
        size == "small" || size == "medium" || size == "large",
        str("Unsupported horizontal-edge coupler size: ", size)
    )
    size == "small"
        ? hub75_horizontal_edge_coupler_create(
            panel = panel,
            profile_size = 60,
            wall_thickness = 2,
            guide_height = 4,
            base_thickness = 2
        )
        : size == "large"
            ? hub75_horizontal_edge_coupler_create(
                panel = panel,
                profile_size = 100,
                wall_thickness = 6,
                guide_height = 10,
                base_thickness = 4
            )
            : hub75_horizontal_edge_coupler_create(
                panel = panel,
                profile_size = 80,
                wall_thickness = 4,
                guide_height = 6,
                base_thickness = 3
            );


function hub75_horizontal_edge_coupler_inward_reach(coupler) =
    coupler.profile_size / 2;

function hub75_horizontal_edge_coupler_seam_keepout_width(coupler) =
    2 * coupler.rear_side_rail_width
    + coupler.rear_seam_gap;

function hub75_horizontal_edge_coupler_vertical_arm_width(coupler) =
    hub75_horizontal_edge_coupler_seam_keepout_width(coupler)
    + 2 * (coupler.wall_thickness + coupler.fit_clearance);

function hub75_horizontal_edge_coupler_horizontal_arm_height(coupler) =
    coupler.rear_end_rail_width
    + 2 * (coupler.wall_thickness + coupler.fit_clearance);

function hub75_horizontal_edge_coupler_rear_rail_center_z(coupler) =
    coupler.rear_outer_edge_z
    - coupler.rear_end_rail_width / 2;

function hub75_horizontal_edge_coupler_outer_projection(coupler) =
    hub75_horizontal_edge_coupler_rear_rail_center_z(coupler)
    + hub75_horizontal_edge_coupler_horizontal_arm_height(coupler) / 2;

function hub75_horizontal_edge_coupler_seam_locator_width(coupler) =
    max(
        0,
        coupler.rear_seam_gap
        - 2 * coupler.fit_clearance
    );

function hub75_horizontal_edge_coupler_screw_x_positions(coupler) =
    [coupler.screw_x_left, coupler.screw_x_right];

function hub75_horizontal_edge_coupler_mounting_tube_pocket_diameter(coupler) =
    coupler.mounting_tube_outer_diameter
    + 2 * coupler.mounting_tube_radial_clearance;

function hub75_horizontal_edge_coupler_mounting_tube_pocket_depth(coupler) =
    coupler.mounting_tube_protrusion
    + coupler.mounting_tube_axial_clearance;

function hub75_horizontal_edge_coupler_locator_pin_position(coupler) =
    [
        coupler.screw_x_right - coupler.locator_pin_x_delta,
        coupler.screw_row_z - coupler.locator_pin_z_delta
    ];

function hub75_horizontal_edge_coupler_locator_pin_clearance_diameter(coupler) =
    coupler.locator_pin_diameter
    + 2 * coupler.locator_pin_clearance;

function hub75_horizontal_edge_coupler_reinforcement_locator_pad_diameter(coupler) =
    max(
        0.2,
        coupler.reinforcement_bushing_recess_diameter
        - 2 * coupler.reinforcement_locator_pad_radial_clearance
    );

function hub75_horizontal_edge_coupler_reinforcement_locator_pad_height(coupler) =
    max(
        0.2,
        coupler.reinforcement_bushing_recess_depth
        - coupler.reinforcement_locator_pad_axial_clearance
    );

function hub75_horizontal_edge_coupler_reinforcement_locator_pin_diameter(coupler) =
    max(
        0.2,
        coupler.reinforcement_bushing_hole_diameter
        - 2 * coupler.reinforcement_locator_pin_radial_clearance
    );

function hub75_horizontal_edge_coupler_reference_pocket_effective_depth(coupler) =
    max(
        0,
        min(
            coupler.reference_pocket_depth,
            coupler.base_thickness
                - coupler.reference_pocket_min_back_wall
        )
    );

function hub75_horizontal_edge_coupler_reference_pocket_straight_depth(coupler) =
    max(
        0,
        hub75_horizontal_edge_coupler_reference_pocket_effective_depth(coupler)
        - min(
            coupler.reference_pocket_taper_depth,
            hub75_horizontal_edge_coupler_reference_pocket_effective_depth(coupler)
        )
    );


// ----------------------------------------------------------------------
// Public production / design geometry
// ----------------------------------------------------------------------

module hub75_horizontal_edge_coupler_build(coupler) {
    $fn = coupler.render_fn;

    assert(
        hub75_horizontal_edge_coupler_horizontal_arm_height(coupler)
            < coupler.profile_size,
        "horizontal arm must fit inside profile_size"
    );
    assert(
        hub75_horizontal_edge_coupler_vertical_arm_width(coupler)
            < coupler.profile_size,
        "vertical arm must fit inside profile_size"
    );
    assert(
        hub75_horizontal_edge_coupler_seam_locator_width(coupler) > 0.5,
        "rear seam is too narrow for the configured locator clearance"
    );
    assert(
        hub75_horizontal_edge_coupler_mounting_tube_pocket_depth(coupler)
            < coupler.base_thickness,
        "mounting-tube pocket must remain blind"
    );
    assert(
        hub75_horizontal_edge_coupler_outer_projection(coupler) < 20,
        "horizontal-edge coupler must remain below 20 mm outside projection"
    );

    union() {
        _hub75_horizontal_edge_coupler_base_with_surface_details(coupler);

        if (coupler.guide_height > 0)
            _hub75_horizontal_edge_coupler_guide_walls(coupler);

        if (coupler.seam_locator_height > 0)
            _hub75_horizontal_edge_coupler_outer_edge_ridge(coupler);

        _hub75_horizontal_edge_coupler_reinforcement_locators(coupler);

        if (coupler.seam_locator_height > 0)
            _hub75_horizontal_edge_coupler_seam_locator(coupler);
    }
}


module hub75_horizontal_edge_coupler_render(coupler, view = "final") {
    $fn = coupler.render_fn;

    existing = [0.72, 0.72, 0.72, 1.0];
    existing_transparent = [0.72, 0.72, 0.72, 0.45];
    current = [0.88, 0.08, 0.06, 0.62];
    final_color = [0.72, 0.05, 0.04, 1.0];

    if (view == "functional") {
        color(existing)
            _hub75_horizontal_edge_coupler_functional_build(coupler);

    } else if (view == "profile") {
        color(current)
            _hub75_horizontal_edge_coupler_extrude_xz_y(-0.35, 0.35)
                _hub75_horizontal_edge_coupler_profile_2d(coupler);

    } else if (view == "base") {
        color(current)
            _hub75_horizontal_edge_coupler_base_solid(coupler);

    } else if (view == "screw-holes") {
        color(existing_transparent)
            _hub75_horizontal_edge_coupler_base_solid(coupler);
        color(current)
            _hub75_horizontal_edge_coupler_screw_cutters(coupler);

    } else if (view == "tube-pockets") {
        color(existing)
            _hub75_horizontal_edge_coupler_base_after_screw_holes(coupler);
        color(current)
            _hub75_horizontal_edge_coupler_mounting_tube_pocket_cutters(coupler);

    } else if (view == "locator-pin-clearance") {
        color(existing_transparent)
            _hub75_horizontal_edge_coupler_base_after_pockets(coupler);
        color(current)
            _hub75_horizontal_edge_coupler_locator_pin_clearance_cutter(coupler);

    } else if (view == "guides") {
        color(existing)
            _hub75_horizontal_edge_coupler_base_after_functional_cutters(coupler);
        color(current) {
            _hub75_horizontal_edge_coupler_guide_walls(coupler);
            _hub75_horizontal_edge_coupler_outer_edge_ridge(coupler);
        }

    } else if (view == "reinforcement-locators") {
        color(existing) {
            _hub75_horizontal_edge_coupler_base_after_functional_cutters(coupler);
            _hub75_horizontal_edge_coupler_guide_walls(coupler);
            _hub75_horizontal_edge_coupler_outer_edge_ridge(coupler);
        }
        color(current)
            _hub75_horizontal_edge_coupler_reinforcement_locators(coupler);

    } else if (view == "seam-locator") {
        color(existing) {
            _hub75_horizontal_edge_coupler_base_after_functional_cutters(coupler);
            _hub75_horizontal_edge_coupler_guide_walls(coupler);
            _hub75_horizontal_edge_coupler_outer_edge_ridge(coupler);
            _hub75_horizontal_edge_coupler_reinforcement_locators(coupler);
        }
        color(current)
            _hub75_horizontal_edge_coupler_seam_locator(coupler);

    } else if (view == "reference-pockets") {
        color(existing)
            _hub75_horizontal_edge_coupler_functional_build(coupler);
        color(current)
            _hub75_horizontal_edge_coupler_reference_pocket_cutters(coupler);

    } else if (view == "center-marks") {
        color(existing)
            _hub75_horizontal_edge_coupler_functional_build(coupler);
        color(current) {
            _hub75_horizontal_edge_coupler_reference_pocket_cutters(coupler);
            _hub75_horizontal_edge_coupler_center_mark_cutters(coupler);
        }

    } else {
        color(final_color)
            hub75_horizontal_edge_coupler_build(coupler);
    }
}


// ----------------------------------------------------------------------
// Panel-derived positions
// ----------------------------------------------------------------------

function _hub75_horizontal_edge_coupler_seam_screw_x_positions(panel) =
    let(
        pitch = hub75_p5_64x32_panel_nominal_width(panel),
        hole_x = hub75_p5_64x32_panel_hole_x_positions_centered(panel)
    )
    [
        -pitch / 2 + hole_x[1],
         pitch / 2 + hole_x[0]
    ];

function _hub75_horizontal_edge_coupler_top_screw_row_z(panel) =
    let(
        nominal_half =
            hub75_p5_64x32_panel_nominal_height(panel) / 2,
        hole_z =
            hub75_p5_64x32_panel_hole_z_positions_centered(panel)
    )
    hole_z[2] - nominal_half;

function _hub75_horizontal_edge_coupler_rear_outer_edge_z(panel) =
    hub75_p5_64x32_panel_height(panel) / 2
    - hub75_p5_64x32_panel_rear_outer_inset_z(panel)
    - hub75_p5_64x32_panel_nominal_height(panel) / 2;

function _hub75_horizontal_edge_coupler_reinforcement_positions(coupler) =
    [
        [
            coupler.screw_x_left,
            coupler.screw_row_z - coupler.reinforcement_bushing_offset
        ],
        [
            coupler.screw_x_right,
            coupler.screw_row_z - coupler.reinforcement_bushing_offset
        ]
    ];


// ----------------------------------------------------------------------
// T profile
// ----------------------------------------------------------------------

module _hub75_horizontal_edge_coupler_plus_profile_2d(coupler) {
    width = coupler.profile_size;
    height = 2 * hub75_horizontal_edge_coupler_inward_reach(coupler);
    horizontal_arm_height =
        hub75_horizontal_edge_coupler_horizontal_arm_height(coupler);
    vertical_arm_width =
        hub75_horizontal_edge_coupler_vertical_arm_width(coupler);
    horizontal_center_z =
        hub75_horizontal_edge_coupler_rear_rail_center_z(coupler);

    hw = width / 2;
    hh = height / 2;
    vx_left = -vertical_arm_width / 2;
    vx_right = vertical_arm_width / 2;
    z_top = horizontal_center_z + horizontal_arm_height / 2;
    z_bottom = horizontal_center_z - horizontal_arm_height / 2;

    inside_r = min(
        coupler.inside_corner_radius,
        min(
            min(hw - vx_right, vx_left + hw),
            min(hh - z_top, z_bottom + hh)
        ) - 0.01
    );

    outside_r = min(
        coupler.outside_corner_radius,
        min(vertical_arm_width, horizontal_arm_height) / 2 - 0.01
    );

    steps = max(24, ceil(coupler.render_fn / 4));

    points = concat(
        [[vx_left + outside_r, hh], [vx_right - outside_r, hh]],
        [for (a = [90 : -90 / steps : 0])
            [vx_right - outside_r + outside_r*cos(a),
             hh - outside_r + outside_r*sin(a)]],

        [[vx_right, z_top + inside_r]],
        [for (a = [180 : 90 / steps : 270])
            [vx_right + inside_r + inside_r*cos(a),
             z_top + inside_r + inside_r*sin(a)]],

        [[hw - outside_r, z_top]],
        [for (a = [90 : -90 / steps : 0])
            [hw - outside_r + outside_r*cos(a),
             z_top - outside_r + outside_r*sin(a)]],

        [[hw, z_bottom + outside_r]],
        [for (a = [0 : -90 / steps : -90])
            [hw - outside_r + outside_r*cos(a),
             z_bottom + outside_r + outside_r*sin(a)]],

        [[vx_right + inside_r, z_bottom]],
        [for (a = [90 : 90 / steps : 180])
            [vx_right + inside_r + inside_r*cos(a),
             z_bottom - inside_r + inside_r*sin(a)]],

        [[vx_right, -hh + outside_r]],
        [for (a = [0 : -90 / steps : -90])
            [vx_right - outside_r + outside_r*cos(a),
             -hh + outside_r + outside_r*sin(a)]],

        [[vx_left + outside_r, -hh]],
        [for (a = [-90 : -90 / steps : -180])
            [vx_left + outside_r + outside_r*cos(a),
             -hh + outside_r + outside_r*sin(a)]],

        [[vx_left, z_bottom - inside_r]],
        [for (a = [0 : 90 / steps : 90])
            [vx_left - inside_r + inside_r*cos(a),
             z_bottom - inside_r + inside_r*sin(a)]],

        [[-hw + outside_r, z_bottom]],
        [for (a = [-90 : -90 / steps : -180])
            [-hw + outside_r + outside_r*cos(a),
             z_bottom + outside_r + outside_r*sin(a)]],

        [[-hw, z_top - outside_r]],
        [for (a = [180 : -90 / steps : 90])
            [-hw + outside_r + outside_r*cos(a),
             z_top - outside_r + outside_r*sin(a)]],

        [[vx_left - inside_r, z_top]],
        [for (a = [-90 : 90 / steps : 0])
            [vx_left - inside_r + inside_r*cos(a),
             z_top + inside_r + inside_r*sin(a)]],

        [[vx_left, hh - outside_r]],
        [for (a = [180 : -90 / steps : 90])
            [vx_left + outside_r + outside_r*cos(a),
             hh - outside_r + outside_r*sin(a)]]
    );

    polygon(points = points);
}


module _hub75_horizontal_edge_coupler_profile_2d(coupler) {
    width = coupler.profile_size;
    reach = hub75_horizontal_edge_coupler_inward_reach(coupler);
    bar_top = hub75_horizontal_edge_coupler_outer_projection(coupler);

    intersection() {
        _hub75_horizontal_edge_coupler_plus_profile_2d(coupler);

        // TOP-edge T: retain the horizontal arm and only the inward stem.
        translate([-width/2 - 1, -reach - 1])
            square([
                width + 2,
                bar_top + reach + 2
            ]);
    }
}


// ----------------------------------------------------------------------
// Base and functional cutters
// ----------------------------------------------------------------------

module _hub75_horizontal_edge_coupler_extrude_xz_y(y_min, y_max) {
    assert(y_max > y_min, "Y extrusion span must be positive");

    translate([0, y_max, 0])
        rotate([90, 0, 0])
            linear_extrude(height = y_max - y_min)
                children();
}


module _hub75_horizontal_edge_coupler_base_solid(coupler) {
    _hub75_horizontal_edge_coupler_extrude_xz_y(
        0,
        coupler.base_thickness
    )
        _hub75_horizontal_edge_coupler_profile_2d(coupler);
}


module _hub75_horizontal_edge_coupler_through_hole_y_with_relief(
    hole_diameter,
    y_max,
    y_min,
    relief_depth,
    relief_radial
) {
    span = y_max - y_min;
    relief_d = hole_diameter + 2 * relief_radial;
    rd = min(
        relief_depth,
        max(0, span / 2 - _HUB75_HORIZONTAL_EDGE_COUPLER_EPS)
    );

    translate([
        0,
        y_max + _HUB75_HORIZONTAL_EDGE_COUPLER_EPS,
        0
    ])
        rotate([90, 0, 0])
            cylinder(
                d = hole_diameter,
                h = span + 2 * _HUB75_HORIZONTAL_EDGE_COUPLER_EPS
            );

    if (rd > 0 && relief_radial > 0) {
        translate([
            0,
            y_max + _HUB75_HORIZONTAL_EDGE_COUPLER_EPS,
            0
        ])
            rotate([90, 0, 0])
                cylinder(
                    d = relief_d,
                    h = rd + _HUB75_HORIZONTAL_EDGE_COUPLER_EPS
                );

        translate([0, y_min + rd, 0])
            rotate([90, 0, 0])
                cylinder(
                    d = relief_d,
                    h = rd + _HUB75_HORIZONTAL_EDGE_COUPLER_EPS
                );
    }
}


module _hub75_horizontal_edge_coupler_screw_cutters(coupler) {
    for (x = hub75_horizontal_edge_coupler_screw_x_positions(coupler))
        translate([x, 0, coupler.screw_row_z])
            _hub75_horizontal_edge_coupler_through_hole_y_with_relief(
                hole_diameter = coupler.screw_hole_diameter,
                y_max = coupler.base_thickness,
                y_min = 0,
                relief_depth = coupler.screw_relief_depth,
                relief_radial = coupler.screw_relief_radial
            );
}


module _hub75_horizontal_edge_coupler_mounting_tube_pocket_cutters(coupler) {
    pocket_depth =
        hub75_horizontal_edge_coupler_mounting_tube_pocket_depth(coupler);
    pocket_diameter =
        hub75_horizontal_edge_coupler_mounting_tube_pocket_diameter(coupler);

    for (x = hub75_horizontal_edge_coupler_screw_x_positions(coupler))
        translate([
            x,
            -_HUB75_HORIZONTAL_EDGE_COUPLER_EPS,
            coupler.screw_row_z
        ])
            rotate([-90, 0, 0])
                cylinder(
                    h = pocket_depth + _HUB75_HORIZONTAL_EDGE_COUPLER_EPS,
                    d = pocket_diameter
                );
}


module _hub75_horizontal_edge_coupler_locator_pin_clearance_cutter(coupler) {
    position =
        hub75_horizontal_edge_coupler_locator_pin_position(coupler);

    translate([position[0], 0, position[1]])
        _hub75_horizontal_edge_coupler_through_hole_y_with_relief(
            hole_diameter =
                hub75_horizontal_edge_coupler_locator_pin_clearance_diameter(coupler),
            y_max = coupler.base_thickness,
            y_min = 0,
            relief_depth = coupler.screw_relief_depth,
            relief_radial = coupler.screw_relief_radial
        );
}


module _hub75_horizontal_edge_coupler_base_after_screw_holes(coupler) {
    difference() {
        _hub75_horizontal_edge_coupler_base_solid(coupler);
        _hub75_horizontal_edge_coupler_screw_cutters(coupler);
    }
}


module _hub75_horizontal_edge_coupler_base_after_pockets(coupler) {
    difference() {
        _hub75_horizontal_edge_coupler_base_after_screw_holes(coupler);
        _hub75_horizontal_edge_coupler_mounting_tube_pocket_cutters(coupler);
    }
}


module _hub75_horizontal_edge_coupler_base_after_functional_cutters(coupler) {
    difference() {
        _hub75_horizontal_edge_coupler_base_after_pockets(coupler);
        _hub75_horizontal_edge_coupler_locator_pin_clearance_cutter(coupler);
    }
}


// ----------------------------------------------------------------------
// Surface reference geometry
// ----------------------------------------------------------------------

function _hub75_horizontal_edge_coupler_lane_offset(
    coupler,
    arm_thickness
) =
    max(
        coupler.reference_pocket_lane_grid,
        round(
            arm_thickness
            * coupler.reference_pocket_lane_fraction
            / coupler.reference_pocket_lane_grid
        )
        * coupler.reference_pocket_lane_grid
    );


function _hub75_horizontal_edge_coupler_two_lanes_fit(
    coupler,
    arm_thickness,
    lane_offset
) =
    arm_thickness / 2
    - lane_offset
    - coupler.reference_pocket_diameter / 2
    >= coupler.reference_pocket_edge_margin;


function _hub75_horizontal_edge_coupler_reference_pocket_positions(coupler) =
    let(
        stem_width =
            hub75_horizontal_edge_coupler_vertical_arm_width(coupler),
        bar_height =
            hub75_horizontal_edge_coupler_horizontal_arm_height(coupler),
        stem_lane =
            _hub75_horizontal_edge_coupler_lane_offset(coupler, stem_width),
        shared_edge_inset =
            stem_width / 2 - stem_lane,
        real_inboard_edge =
            hub75_horizontal_edge_coupler_rear_rail_center_z(coupler)
            - bar_height / 2,
        virtual_horizontal_half = abs(real_inboard_edge),
        bar_lane = max(0, virtual_horizontal_half - shared_edge_inset),
        stem_lane_signs =
            _hub75_horizontal_edge_coupler_two_lanes_fit(
                coupler,
                stem_width,
                stem_lane
            )
                ? [-1, 1]
                : [0]
    )
    concat(
        [
            for (
                direction = [-1, 1],
                step = coupler.reference_pocket_steps,
                lane = [-1, 1]
            )
                [
                    direction * step * coupler.reference_pocket_pitch,
                    lane * bar_lane
                ]
        ],
        [
            for (
                step = coupler.reference_pocket_steps,
                lane = stem_lane_signs
            )
                [
                    lane * stem_lane,
                    -step * coupler.reference_pocket_pitch
                ]
        ]
    );


module _hub75_horizontal_edge_coupler_center_marks_2d(coupler) {
    difference() {
        union() {
            // The + is the nominal panel edge / panel seam intersection.
            square([
                coupler.center_mark_cross_length,
                coupler.center_mark_width
            ], center = true);

            square([
                coupler.center_mark_width,
                coupler.center_mark_cross_length
            ], center = true);

            for (
                x = [
                    coupler.center_mark_pitch / 2
                    :
                    coupler.center_mark_pitch / 2
                    :
                    coupler.profile_size / 2
                ]
            ) {
                major =
                    abs(
                        x / coupler.center_mark_pitch
                        - round(x / coupler.center_mark_pitch)
                    ) < 0.001;
                tick =
                    major
                        ? coupler.center_mark_major_length
                        : coupler.center_mark_minor_length;

                translate([ x, 0])
                    square([coupler.center_mark_width, tick], center = true);
                translate([-x, 0])
                    square([coupler.center_mark_width, tick], center = true);
            }

            for (
                z = [
                    coupler.center_mark_pitch / 2
                    :
                    coupler.center_mark_pitch / 2
                    :
                    hub75_horizontal_edge_coupler_inward_reach(coupler)
                ]
            ) {
                major =
                    abs(
                        z / coupler.center_mark_pitch
                        - round(z / coupler.center_mark_pitch)
                    ) < 0.001;
                tick =
                    major
                        ? coupler.center_mark_major_length
                        : coupler.center_mark_minor_length;

                // Both directions are generated; the T profile clips away the
                // unsupported outside marks and leaves the inward measuring
                // scale visible.
                translate([0, z])
                    square([tick, coupler.center_mark_width], center = true);
                translate([0,-z])
                    square([tick, coupler.center_mark_width], center = true);
            }
        }

        keepout_radius =
            coupler.screw_hole_diameter / 2
            + coupler.center_mark_screw_keepout;

        for (x = hub75_horizontal_edge_coupler_screw_x_positions(coupler))
            translate([x, coupler.screw_row_z])
                circle(r = keepout_radius);
    }
}


module _hub75_horizontal_edge_coupler_reference_pocket_cutters(coupler) {
    depth =
        hub75_horizontal_edge_coupler_reference_pocket_effective_depth(coupler);
    taper_depth =
        min(coupler.reference_pocket_taper_depth, depth);
    straight_depth = max(0, depth - taper_depth);

    if (coupler.show_reference_pockets && depth > 0)
        intersection() {
            _hub75_horizontal_edge_coupler_extrude_xz_y(
                coupler.base_thickness - depth
                    - _HUB75_HORIZONTAL_EDGE_COUPLER_EPS,
                coupler.base_thickness
                    + _HUB75_HORIZONTAL_EDGE_COUPLER_EPS
            )
                offset(delta = -coupler.reference_pocket_edge_margin)
                    _hub75_horizontal_edge_coupler_profile_2d(coupler);

            union()
                for (position =
                    _hub75_horizontal_edge_coupler_reference_pocket_positions(coupler)
                )
                    translate([position[0], 0, position[1]]) {
                        if (straight_depth > 0)
                            translate([
                                0,
                                coupler.base_thickness
                                    + _HUB75_HORIZONTAL_EDGE_COUPLER_EPS,
                                0
                            ])
                                rotate([90, 0, 0])
                                    cylinder(
                                        h =
                                            straight_depth
                                            + _HUB75_HORIZONTAL_EDGE_COUPLER_EPS,
                                        d = coupler.reference_pocket_diameter
                                    );

                        if (taper_depth > 0)
                            translate([
                                0,
                                coupler.base_thickness
                                    - straight_depth
                                    + _HUB75_HORIZONTAL_EDGE_COUPLER_EPS,
                                0
                            ])
                                rotate([90, 0, 0])
                                    cylinder(
                                        h =
                                            taper_depth
                                            + 2 * _HUB75_HORIZONTAL_EDGE_COUPLER_EPS,
                                        d1 = coupler.reference_pocket_diameter,
                                        d2 = coupler.reference_pocket_end_diameter
                                    );
                    }
        }
}


module _hub75_horizontal_edge_coupler_center_mark_cutters(coupler) {
    depth =
        min(
            coupler.center_mark_depth,
            coupler.base_thickness - 0.2
        );

    if (coupler.show_center_reference_marks && depth > 0)
        _hub75_horizontal_edge_coupler_extrude_xz_y(
            coupler.base_thickness - depth,
            coupler.base_thickness
                + _HUB75_HORIZONTAL_EDGE_COUPLER_EPS
        )
            intersection() {
                offset(delta = -coupler.center_mark_edge_margin)
                    _hub75_horizontal_edge_coupler_profile_2d(coupler);

                _hub75_horizontal_edge_coupler_center_marks_2d(coupler);
            }
}


module _hub75_horizontal_edge_coupler_base_with_surface_details(coupler) {
    difference() {
        _hub75_horizontal_edge_coupler_base_after_functional_cutters(coupler);
        _hub75_horizontal_edge_coupler_reference_pocket_cutters(coupler);
        _hub75_horizontal_edge_coupler_center_mark_cutters(coupler);
    }
}


// ----------------------------------------------------------------------
// Fitted guide geometry
// ----------------------------------------------------------------------

module _hub75_horizontal_edge_coupler_panel_keepout_2d(coupler) {
    vertical_w =
        hub75_horizontal_edge_coupler_seam_keepout_width(coupler);
    horizontal_w = coupler.rear_end_rail_width;
    rail_center_z =
        hub75_horizontal_edge_coupler_rear_rail_center_z(coupler);
    rail_inner_z =
        coupler.rear_outer_edge_z - horizontal_w;
    corner_r = coupler.rear_opening_corner_radius;

    union() {
        translate([0, rail_center_z])
            square([
                coupler.profile_size + 6,
                horizontal_w
            ], center = true);

        stem_h = coupler.profile_size + 20;
        translate([
            0,
            rail_inner_z - stem_h / 2
        ])
            square([
                vertical_w,
                stem_h
            ], center = true);

        for (sx = [-1, 1])
            translate([
                sx * vertical_w / 2,
                rail_inner_z
            ])
                scale([sx, -1])
                    difference() {
                        square([corner_r, corner_r]);

                        translate([corner_r, corner_r])
                            circle(r = corner_r);
                    }
    }
}


module _hub75_horizontal_edge_coupler_raw_guide_shell_2d(coupler) {
    difference() {
        _hub75_horizontal_edge_coupler_profile_2d(coupler);

        offset(delta = coupler.fit_clearance)
            _hub75_horizontal_edge_coupler_panel_keepout_2d(coupler);
    }
}


function _hub75_horizontal_edge_coupler_effective_guide_rounding(coupler) =
    min(
        coupler.guide_end_rounding,
        max(
            0,
            coupler.wall_thickness / 2
                - _HUB75_HORIZONTAL_EDGE_COUPLER_EPS
        )
    );


module _hub75_horizontal_edge_coupler_guide_shell_2d(coupler) {
    rounding =
        _hub75_horizontal_edge_coupler_effective_guide_rounding(coupler);

    if (rounding > 0)
        offset(r = rounding)
            offset(delta = -rounding)
                _hub75_horizontal_edge_coupler_raw_guide_shell_2d(coupler);
    else
        _hub75_horizontal_edge_coupler_raw_guide_shell_2d(coupler);
}


module _hub75_horizontal_edge_coupler_outer_zone_2d(coupler) {
    z_min =
        coupler.rear_outer_edge_z
        + coupler.fit_clearance;
    big = 2 * coupler.profile_size + 40;

    translate([
        0,
        z_min + big / 2
    ])
        square([
            coupler.profile_size + 20,
            big
        ], center = true);
}


module _hub75_horizontal_edge_coupler_tall_guide_2d(coupler) {
    difference() {
        _hub75_horizontal_edge_coupler_guide_shell_2d(coupler);
        _hub75_horizontal_edge_coupler_outer_zone_2d(coupler);
    }
}


module _hub75_horizontal_edge_coupler_outer_ridge_2d(coupler) {
    intersection() {
        _hub75_horizontal_edge_coupler_guide_shell_2d(coupler);
        _hub75_horizontal_edge_coupler_outer_zone_2d(coupler);
    }
}


module _hub75_horizontal_edge_coupler_guide_walls(coupler) {
    difference() {
        _hub75_horizontal_edge_coupler_extrude_xz_y(
            -coupler.guide_height,
            0
        )
            _hub75_horizontal_edge_coupler_tall_guide_2d(coupler);

        relief_depth =
            coupler.guide_height
            + 0.20;

        for (position =
            _hub75_horizontal_edge_coupler_reinforcement_positions(coupler)
        )
            translate([
                position[0],
                _HUB75_HORIZONTAL_EDGE_COUPLER_EPS,
                position[1]
            ])
                rotate([90, 0, 0])
                    cylinder(
                        d =
                            coupler.reinforcement_bushing_outer_diameter
                            + 2 * coupler.reinforcement_bushing_clearance,
                        h =
                            relief_depth
                            + 2 * _HUB75_HORIZONTAL_EDGE_COUPLER_EPS
                    );
    }
}


module _hub75_horizontal_edge_coupler_outer_edge_ridge(coupler) {
    ridge_h = coupler.seam_locator_height;
    taper = min(
        coupler.outer_ridge_taper_inset,
        coupler.wall_thickness / 4
    );

    hull() {
        _hub75_horizontal_edge_coupler_extrude_xz_y(
            -_HUB75_HORIZONTAL_EDGE_COUPLER_EPS,
             _HUB75_HORIZONTAL_EDGE_COUPLER_EPS
        )
            _hub75_horizontal_edge_coupler_outer_ridge_2d(coupler);

        _hub75_horizontal_edge_coupler_extrude_xz_y(
            -ridge_h - _HUB75_HORIZONTAL_EDGE_COUPLER_EPS,
            -ridge_h + _HUB75_HORIZONTAL_EDGE_COUPLER_EPS
        )
            offset(delta = -taper)
                _hub75_horizontal_edge_coupler_outer_ridge_2d(coupler);
    }
}


// ----------------------------------------------------------------------
// Reinforcement locators
// ----------------------------------------------------------------------

module _hub75_horizontal_edge_coupler_reinforcement_locator(coupler) {
    pad_d =
        hub75_horizontal_edge_coupler_reinforcement_locator_pad_diameter(coupler);
    pad_h =
        hub75_horizontal_edge_coupler_reinforcement_locator_pad_height(coupler);
    pin_d =
        hub75_horizontal_edge_coupler_reinforcement_locator_pin_diameter(coupler);

    translate([
        0,
        _HUB75_HORIZONTAL_EDGE_COUPLER_EPS,
        0
    ])
        rotate([90, 0, 0])
            cylinder(
                d = pad_d,
                h = pad_h + _HUB75_HORIZONTAL_EDGE_COUPLER_EPS
            );

    translate([
        0,
        -pad_h + _HUB75_HORIZONTAL_EDGE_COUPLER_EPS,
        0
    ])
        rotate([90, 0, 0])
            cylinder(
                d = pin_d,
                h =
                    coupler.reinforcement_locator_pin_length
                    + _HUB75_HORIZONTAL_EDGE_COUPLER_EPS
            );
}


module _hub75_horizontal_edge_coupler_reinforcement_locators(coupler) {
    for (position =
        _hub75_horizontal_edge_coupler_reinforcement_positions(coupler)
    )
        translate([position[0], 0, position[1]])
            _hub75_horizontal_edge_coupler_reinforcement_locator(coupler);
}


// ----------------------------------------------------------------------
// Seam locator
// ----------------------------------------------------------------------

module _hub75_horizontal_edge_coupler_seam_locator_section_2d(
    coupler,
    width
) {
    length =
        hub75_horizontal_edge_coupler_inward_reach(coupler);
    radius = min(
        coupler.seam_locator_end_radius,
        width / 2 - 0.01,
        length / 2 - 0.01
    );

    translate([0, -length / 2])
        offset(r = max(0, radius))
            square([
                max(0.02, width - 2 * radius),
                max(0.02, length - 2 * radius)
            ], center = true);
}


module _hub75_horizontal_edge_coupler_seam_locator(coupler) {
    base_width =
        hub75_horizontal_edge_coupler_seam_locator_width(coupler);
    tip_width = max(
        0.6,
        base_width
        - 2 * coupler.seam_locator_lead_in_per_side
    );

    hull() {
        _hub75_horizontal_edge_coupler_extrude_xz_y(
            -_HUB75_HORIZONTAL_EDGE_COUPLER_EPS,
             _HUB75_HORIZONTAL_EDGE_COUPLER_EPS
        )
            _hub75_horizontal_edge_coupler_seam_locator_section_2d(
                coupler,
                base_width
            );

        _hub75_horizontal_edge_coupler_extrude_xz_y(
            -coupler.seam_locator_height
                - _HUB75_HORIZONTAL_EDGE_COUPLER_EPS,
            -coupler.seam_locator_height
                + _HUB75_HORIZONTAL_EDGE_COUPLER_EPS
        )
            _hub75_horizontal_edge_coupler_seam_locator_section_2d(
                coupler,
                tip_width
            );
    }
}


// ----------------------------------------------------------------------
// Functional construction state
// ----------------------------------------------------------------------

module _hub75_horizontal_edge_coupler_functional_build(coupler) {
    union() {
        _hub75_horizontal_edge_coupler_base_after_functional_cutters(coupler);

        if (coupler.guide_height > 0)
            _hub75_horizontal_edge_coupler_guide_walls(coupler);

        if (coupler.seam_locator_height > 0)
            _hub75_horizontal_edge_coupler_outer_edge_ridge(coupler);

        _hub75_horizontal_edge_coupler_reinforcement_locators(coupler);

        if (coupler.seam_locator_height > 0)
            _hub75_horizontal_edge_coupler_seam_locator(coupler);
    }
}


// ----------------------------------------------------------------------
// Standalone Customizer preview
// ----------------------------------------------------------------------

_preview_panel = hub75_p5_64x32_panel_create();

_preview_coupler =
    hub75_horizontal_edge_coupler_create(
        panel = _preview_panel,
        profile_size = profile_size,
        wall_thickness = wall_thickness,
        fit_clearance = fit_clearance,
        base_thickness = base_thickness,
        guide_height = guide_height,
        inside_corner_radius = inside_corner_radius,
        outside_corner_radius = outside_corner_radius,
        guide_end_rounding = guide_end_rounding,
        render_fn = render_fn,

        screw_hole_diameter = screw_hole_diameter,
        screw_relief_depth = screw_relief_depth,
        screw_relief_radial = screw_relief_radial,
        mounting_tube_radial_clearance = mounting_tube_radial_clearance,
        mounting_tube_axial_clearance = mounting_tube_axial_clearance,
        locator_pin_clearance = locator_pin_clearance,

        reinforcement_bushing_clearance = reinforcement_bushing_clearance,
        reinforcement_locator_pad_radial_clearance =
            reinforcement_locator_pad_radial_clearance,
        reinforcement_locator_pad_axial_clearance =
            reinforcement_locator_pad_axial_clearance,
        reinforcement_locator_pin_radial_clearance =
            reinforcement_locator_pin_radial_clearance,
        reinforcement_locator_pin_length =
            reinforcement_locator_pin_length,

        show_reference_pockets = show_reference_pockets,
        reference_pocket_diameter = reference_pocket_diameter,
        reference_pocket_depth = reference_pocket_depth,
        reference_pocket_min_back_wall = reference_pocket_min_back_wall,
        reference_pocket_end_diameter = reference_pocket_end_diameter,
        reference_pocket_taper_depth = reference_pocket_taper_depth,
        reference_pocket_pitch = reference_pocket_pitch,
        reference_pocket_steps = reference_pocket_steps,
        reference_pocket_lane_grid = reference_pocket_lane_grid,
        reference_pocket_lane_fraction = reference_pocket_lane_fraction,
        reference_pocket_edge_margin = reference_pocket_edge_margin,

        show_center_reference_marks = show_center_reference_marks,
        center_mark_depth = center_mark_depth,
        center_mark_pitch = center_mark_pitch,
        center_mark_major_length = center_mark_major_length,
        center_mark_minor_length = center_mark_minor_length,
        center_mark_width = center_mark_width,
        center_mark_cross_length = center_mark_cross_length,
        center_mark_edge_margin = center_mark_edge_margin,
        center_mark_screw_keepout = center_mark_screw_keepout,

        seam_locator_height = seam_locator_height,
        seam_locator_lead_in_per_side = seam_locator_lead_in_per_side,
        seam_locator_end_radius = seam_locator_end_radius,
        outer_ridge_taper_inset = outer_ridge_taper_inset
    );

hub75_horizontal_edge_coupler_render(
    _preview_coupler,
    view = preview_view
);
