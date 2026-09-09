// File: hub75_middle_coupler.scad
//   Project-specific middle coupler for two adjacent portrait HUB75 panels.
//
// Physical role:
// - local X=0 is the nominal seam between the two panels;
// - local Y=0 is the panel-facing surface of the coupler base;
// - local Z=0 is the middle HUB75 mounting-hole row;
// - the base extends toward +Y, behind the display;
// - guides and the seam locator extend toward -Y, into the rear panel geometry.
//
// The reusable HUB75 library is the authority for panel mating dimensions.
// This component owns only printable coupler choices.

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
mounting_tube_radial_clearance = 0.45;
mounting_tube_axial_clearance = 0.40;
reinforcement_bushing_clearance = 0.45;

/* [Seam locator] */
seam_locator_height = 4;
seam_locator_lead_in_per_side = 0.20;
seam_locator_end_radius = 1.00;

/* [Preview] */
preview_view = "final"; // [final,profile,base,screw-holes,tube-pockets,guides,seam-locator]

/* [Resolution] */
render_fn = 192;

$fn = render_fn;

_HUB75_MIDDLE_COUPLER_EPS = 0.05;


// ----------------------------------------------------------------------
// Public object API
// ----------------------------------------------------------------------

// Function: hub75_middle_coupler_create()
// Description:
//   Creates one middle-coupler object. Panel-dependent mating dimensions are
//   captured through the public lib.scad.hub75 API; project code should not
//   duplicate those panel dimensions.
// Arguments:
//   panel = HUB75 panel object that defines the mating geometry.
//   profile_size = Overall X/Z extent of the PLUS plate.
//   wall_thickness = Printed material beside the fitted panel rib keep-out.
//   fit_clearance = Printable clearance per side around HUB75 rear geometry.
//   base_thickness = Coupler plate thickness behind the panel mounting plane.
//   guide_height = Guide-wall insertion depth toward the panel.
//   inside_corner_radius = Concave PLUS-profile corner radius.
//   outside_corner_radius = Convex free-end corner radius.
//   guide_end_rounding = Rounding applied to exposed raised-guide endpoints.
//   render_fn = Facet count used by all curved production geometry.
//   screw_hole_diameter = Through-hole diameter for the two mounting screws.
function hub75_middle_coupler_create(
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
    mounting_tube_radial_clearance = 0.45,
    mounting_tube_axial_clearance = 0.40,
    reinforcement_bushing_clearance = 0.45,
    seam_locator_height = 4,
    seam_locator_lead_in_per_side = 0.20,
    seam_locator_end_radius = 1.00
) =
    let(
        screw_x = _hub75_middle_coupler_seam_screw_x_positions(panel)
    )
    assert(profile_size > 0, "profile_size must be > 0")
    assert(wall_thickness > 0, "wall_thickness must be > 0")
    assert(fit_clearance >= 0, "fit_clearance must be >= 0")
    assert(base_thickness > 0, "base_thickness must be > 0")
    assert(guide_height >= 0, "guide_height must be >= 0")
    assert(guide_end_rounding >= 0, "guide_end_rounding must be >= 0")
    assert(render_fn >= 24, "render_fn must be >= 24")
    assert(screw_hole_diameter > 0, "screw_hole_diameter must be > 0")
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
        mounting_tube_radial_clearance = mounting_tube_radial_clearance,
        mounting_tube_axial_clearance = mounting_tube_axial_clearance,
        reinforcement_bushing_clearance = reinforcement_bushing_clearance,
        seam_locator_height = seam_locator_height,
        seam_locator_lead_in_per_side = seam_locator_lead_in_per_side,
        seam_locator_end_radius = seam_locator_end_radius,

        rear_seam_gap =
            hub75_p5_64x32_panel_rear_grid_gap_x(panel),
        rear_side_rail_width =
            hub75_p5_64x32_panel_rear_side_rail_width_at_mounting_plane(panel),
        rear_crossbar_width =
            hub75_p5_64x32_panel_rear_crossbar_width_at_mounting_plane(panel),
        rear_opening_corner_radius =
            hub75_p5_64x32_panel_rear_opening_corner_radius(panel),

        mounting_tube_outer_diameter =
            hub75_p5_64x32_panel_mounting_tube_outer_diameter(panel),
        mounting_tube_protrusion =
            hub75_p5_64x32_panel_mounting_tube_protrusion(panel),

        reinforcement_bushing_outer_diameter =
            hub75_p5_64x32_panel_reinforcement_bushing_outer_diameter(panel),
        reinforcement_bushing_offset =
            hub75_p5_64x32_panel_reinforcement_bushing_offset(panel),

        screw_x_left = screw_x[0],
        screw_x_right = screw_x[1]
    );


// Function: hub75_middle_coupler_horizontal_arm_height()
// Description: Returns the complete horizontal PLUS-arm height.
function hub75_middle_coupler_horizontal_arm_height(coupler) =
    coupler.rear_crossbar_width
    + 2 * (coupler.wall_thickness + coupler.fit_clearance);

// Function: hub75_middle_coupler_seam_keepout_width()
// Description:
//   Returns the physical rear-rib width occupied by two panel side rails plus
//   the nominal rear seam gap between them.
function hub75_middle_coupler_seam_keepout_width(coupler) =
    2 * coupler.rear_side_rail_width
    + coupler.rear_seam_gap;

// Function: hub75_middle_coupler_vertical_arm_width()
// Description: Returns the complete vertical PLUS-arm width.
function hub75_middle_coupler_vertical_arm_width(coupler) =
    hub75_middle_coupler_seam_keepout_width(coupler)
    + 2 * (coupler.wall_thickness + coupler.fit_clearance);

// Function: hub75_middle_coupler_seam_locator_width()
// Description:
//   Returns the printable locator width inside the rear seam after equal
//   clearance is removed from both mating faces.
function hub75_middle_coupler_seam_locator_width(coupler) =
    max(
        0,
        coupler.rear_seam_gap
        - 2 * coupler.fit_clearance
    );

// Function: hub75_middle_coupler_screw_x_positions()
// Description: Returns the two seam-side screw centres in local X coordinates.
function hub75_middle_coupler_screw_x_positions(coupler) =
    [coupler.screw_x_left, coupler.screw_x_right];

// Function: hub75_middle_coupler_mounting_tube_pocket_diameter()
// Description: Returns the shallow base-pocket diameter around each panel tube.
function hub75_middle_coupler_mounting_tube_pocket_diameter(coupler) =
    coupler.mounting_tube_outer_diameter
    + 2 * coupler.mounting_tube_radial_clearance;

// Function: hub75_middle_coupler_mounting_tube_pocket_depth()
// Description: Returns the panel-facing pocket depth into the base plate.
function hub75_middle_coupler_mounting_tube_pocket_depth(coupler) =
    coupler.mounting_tube_protrusion
    + coupler.mounting_tube_axial_clearance;


// ----------------------------------------------------------------------
// Public geometry
// ----------------------------------------------------------------------

// Module: hub75_middle_coupler_build()
// Usage:
//   coupler = hub75_middle_coupler_create();
//   hub75_middle_coupler_build(coupler);
// Description:
//   Builds the functional middle coupler: fitted base, mounting holes,
//   mounting-tube pockets, raised rib guides and the seam locator.
module hub75_middle_coupler_build(coupler) {
    // Do not rely on a top-level $fn assignment: this module is commonly
    // imported with use <...>, which does not import ordinary variable
    // assignments. Production geometry owns its resolution through the object.
    $fn = coupler.render_fn;

    horizontal_arm =
        hub75_middle_coupler_horizontal_arm_height(coupler);
    vertical_arm =
        hub75_middle_coupler_vertical_arm_width(coupler);
    locator_width =
        hub75_middle_coupler_seam_locator_width(coupler);
    pocket_depth =
        hub75_middle_coupler_mounting_tube_pocket_depth(coupler);

    assert(
        horizontal_arm < coupler.profile_size,
        "horizontal arm must fit inside profile_size"
    );
    assert(
        vertical_arm < coupler.profile_size,
        "vertical arm must fit inside profile_size"
    );
    assert(
        locator_width > 0.5,
        "rear seam is too narrow for the configured locator clearance"
    );
    assert(
        pocket_depth < coupler.base_thickness,
        "mounting-tube pocket must remain blind"
    );

    union() {
        _hub75_middle_coupler_base_after_pockets(coupler);

        if (coupler.guide_height > 0)
            _hub75_middle_coupler_guide_walls(coupler);

        if (coupler.seam_locator_height > 0)
            _hub75_middle_coupler_seam_locator(coupler);
    }
}


// Module: hub75_middle_coupler_render()
// Description:
//   Renders named design/debug construction stages without duplicating the
//   production geometry.
// Arguments:
//   coupler = Middle-coupler object.
//   view = final, profile, base, screw-holes, tube-pockets, guides or
//          seam-locator.
module hub75_middle_coupler_render(coupler, view = "final") {
    // Design/debug geometry must tessellate exactly like the production build.
    $fn = coupler.render_fn;

    existing = [0.72, 0.72, 0.72, 1.0];
    existing_transparent = [0.72, 0.72, 0.72, 0.45];
    current = [0.88, 0.08, 0.06, 0.62];
    final_color = [0.72, 0.05, 0.04, 1.0];

    if (view == "profile") {
        color(current)
            _hub75_middle_coupler_extrude_xz_y(
                -0.35,
                 0.35
            )
                _hub75_middle_coupler_profile_2d(coupler);

    } else if (view == "base") {
        color(current)
            _hub75_middle_coupler_base_solid(coupler);

    } else if (view == "screw-holes") {
        color(existing_transparent)
            _hub75_middle_coupler_base_solid(coupler);

        color(current)
            _hub75_middle_coupler_screw_cutters(coupler);

    } else if (view == "tube-pockets") {
        color(existing)
            _hub75_middle_coupler_base_after_screw_holes(coupler);

        color(current)
            _hub75_middle_coupler_mounting_tube_pocket_cutters(coupler);

    } else if (view == "guides") {
        color(existing)
            _hub75_middle_coupler_base_after_pockets(coupler);

        color(current)
            _hub75_middle_coupler_guide_walls(coupler);

    } else if (view == "seam-locator") {
        color(existing) {
            _hub75_middle_coupler_base_after_pockets(coupler);
            _hub75_middle_coupler_guide_walls(coupler);
        }

        color(current)
            _hub75_middle_coupler_seam_locator(coupler);

    } else {
        color(final_color)
            hub75_middle_coupler_build(coupler);
    }
}


// ----------------------------------------------------------------------
// Private derived geometry
// ----------------------------------------------------------------------

function _hub75_middle_coupler_seam_screw_x_positions(panel) =
    let(
        pitch =
            hub75_p5_64x32_panel_nominal_width(panel),
        hole_x =
            hub75_p5_64x32_panel_hole_x_positions_centered(panel)
    )
    [
        -pitch / 2 + hole_x[1],
         pitch / 2 + hole_x[0]
    ];


function _hub75_middle_coupler_reinforcement_positions(coupler) =
    [
        [
            coupler.screw_x_left,
            -coupler.reinforcement_bushing_offset
        ],
        [
            coupler.screw_x_right,
             coupler.reinforcement_bushing_offset
        ]
    ];


// ----------------------------------------------------------------------
// Private PLUS profile
// ----------------------------------------------------------------------

module _hub75_middle_coupler_profile_2d(coupler) {
    width = coupler.profile_size;
    height = coupler.profile_size;
    horizontal_arm_height =
        hub75_middle_coupler_horizontal_arm_height(coupler);
    vertical_arm_width =
        hub75_middle_coupler_vertical_arm_width(coupler);

    hw = width / 2;
    hh = height / 2;

    vx_left = -vertical_arm_width / 2;
    vx_right = vertical_arm_width / 2;
    z_top = horizontal_arm_height / 2;
    z_bottom = -horizontal_arm_height / 2;

    inside_r = min(
        coupler.inside_corner_radius,
        min(
            hw - vx_right,
            hh - z_top
        ) - 0.01
    );

    outside_r = min(
        coupler.outside_corner_radius,
        min(
            vertical_arm_width,
            horizontal_arm_height
        ) / 2 - 0.01
    );

    // Four times this count approximates a complete circle. This deliberately
    // uses the object's production resolution rather than ambient $fn, so the
    // result is identical when this file is imported through use <...>.
    steps = max(24, ceil(coupler.render_fn / 4));

    points = concat(
        [[vx_left + outside_r, hh], [vx_right - outside_r, hh]],
        [for (a = [90 : -90 / steps : 0])
            [
                vx_right - outside_r + outside_r * cos(a),
                hh - outside_r + outside_r * sin(a)
            ]
        ],

        [[vx_right, z_top + inside_r]],
        [for (a = [180 : 90 / steps : 270])
            [
                vx_right + inside_r + inside_r * cos(a),
                z_top + inside_r + inside_r * sin(a)
            ]
        ],

        [[hw - outside_r, z_top]],
        [for (a = [90 : -90 / steps : 0])
            [
                hw - outside_r + outside_r * cos(a),
                z_top - outside_r + outside_r * sin(a)
            ]
        ],

        [[hw, z_bottom + outside_r]],
        [for (a = [0 : -90 / steps : -90])
            [
                hw - outside_r + outside_r * cos(a),
                z_bottom + outside_r + outside_r * sin(a)
            ]
        ],

        [[vx_right + inside_r, z_bottom]],
        [for (a = [90 : 90 / steps : 180])
            [
                vx_right + inside_r + inside_r * cos(a),
                z_bottom - inside_r + inside_r * sin(a)
            ]
        ],

        [[vx_right, -hh + outside_r]],
        [for (a = [0 : -90 / steps : -90])
            [
                vx_right - outside_r + outside_r * cos(a),
                -hh + outside_r + outside_r * sin(a)
            ]
        ],

        [[vx_left + outside_r, -hh]],
        [for (a = [-90 : -90 / steps : -180])
            [
                vx_left + outside_r + outside_r * cos(a),
                -hh + outside_r + outside_r * sin(a)
            ]
        ],

        [[vx_left, z_bottom - inside_r]],
        [for (a = [0 : 90 / steps : 90])
            [
                vx_left - inside_r + inside_r * cos(a),
                z_bottom - inside_r + inside_r * sin(a)
            ]
        ],

        [[-hw + outside_r, z_bottom]],
        [for (a = [-90 : -90 / steps : -180])
            [
                -hw + outside_r + outside_r * cos(a),
                z_bottom + outside_r + outside_r * sin(a)
            ]
        ],

        [[-hw, z_top - outside_r]],
        [for (a = [180 : -90 / steps : 90])
            [
                -hw + outside_r + outside_r * cos(a),
                z_top - outside_r + outside_r * sin(a)
            ]
        ],

        [[vx_left - inside_r, z_top]],
        [for (a = [-90 : 90 / steps : 0])
            [
                vx_left - inside_r + inside_r * cos(a),
                z_top + inside_r + inside_r * sin(a)
            ]
        ],

        [[vx_left, hh - outside_r]],
        [for (a = [180 : -90 / steps : 90])
            [
                vx_left + outside_r + outside_r * cos(a),
                hh - outside_r + outside_r * sin(a)
            ]
        ]
    );

    polygon(points = points);
}


// ----------------------------------------------------------------------
// Private base and cutters
// ----------------------------------------------------------------------

module _hub75_middle_coupler_extrude_xz_y(y_min, y_max) {
    assert(y_max > y_min, "Y extrusion span must be positive");

    translate([0, y_max, 0])
        rotate([90, 0, 0])
            linear_extrude(height = y_max - y_min)
                children();
}


module _hub75_middle_coupler_base_solid(coupler) {
    _hub75_middle_coupler_extrude_xz_y(
        0,
        coupler.base_thickness
    )
        _hub75_middle_coupler_profile_2d(coupler);
}


module _hub75_middle_coupler_screw_cutters(coupler) {
    for (x = hub75_middle_coupler_screw_x_positions(coupler))
        translate([
            x,
            coupler.base_thickness + _HUB75_MIDDLE_COUPLER_EPS,
            0
        ])
            rotate([90, 0, 0])
                cylinder(
                    h =
                        coupler.base_thickness
                        + 2 * _HUB75_MIDDLE_COUPLER_EPS,
                    d = coupler.screw_hole_diameter
                );
}


module _hub75_middle_coupler_mounting_tube_pocket_cutters(coupler) {
    pocket_depth =
        hub75_middle_coupler_mounting_tube_pocket_depth(coupler);
    pocket_diameter =
        hub75_middle_coupler_mounting_tube_pocket_diameter(coupler);

    for (x = hub75_middle_coupler_screw_x_positions(coupler))
        translate([
            x,
            -_HUB75_MIDDLE_COUPLER_EPS,
            0
        ])
            rotate([-90, 0, 0])
                cylinder(
                    h =
                        pocket_depth
                        + _HUB75_MIDDLE_COUPLER_EPS,
                    d = pocket_diameter
                );
}


module _hub75_middle_coupler_base_after_screw_holes(coupler) {
    difference() {
        _hub75_middle_coupler_base_solid(coupler);
        _hub75_middle_coupler_screw_cutters(coupler);
    }
}


module _hub75_middle_coupler_base_after_pockets(coupler) {
    difference() {
        _hub75_middle_coupler_base_after_screw_holes(coupler);
        _hub75_middle_coupler_mounting_tube_pocket_cutters(coupler);
    }
}


// ----------------------------------------------------------------------
// Private fitted guide geometry
// ----------------------------------------------------------------------

module _hub75_middle_coupler_rib_cross_keepout_2d(coupler) {
    horizontal_rib_width = coupler.rear_crossbar_width;
    vertical_rib_width =
        hub75_middle_coupler_seam_keepout_width(coupler);
    corner_r = max(0, coupler.rear_opening_corner_radius);

    half_horizontal = horizontal_rib_width / 2;
    half_vertical = vertical_rib_width / 2;

    union() {
        square(
            [
                coupler.profile_size + 4,
                horizontal_rib_width
            ],
            center = true
        );

        square(
            [
                vertical_rib_width,
                coupler.profile_size + 4
            ],
            center = true
        );

        // The HUB75 bay corners are rounded. These four pieces add the
        // material occupied by the rounded rib/bay transition so the guide
        // clearance follows the real panel rather than a sharp PLUS.
        for (sx = [-1, 1], sz = [-1, 1])
            scale([sx, sz])
                translate([
                    half_vertical,
                    half_horizontal
                ])
                    difference() {
                        square([corner_r, corner_r]);

                        translate([corner_r, corner_r])
                            circle(r = corner_r);
                    }
    }
}


module _hub75_middle_coupler_raw_guide_shell_2d(coupler) {
    difference() {
        _hub75_middle_coupler_profile_2d(coupler);

        offset(delta = coupler.fit_clearance)
            _hub75_middle_coupler_rib_cross_keepout_2d(coupler);
    }
}


module _hub75_middle_coupler_guide_shell_2d(coupler) {
    // The approved v120 shape used a small 2D opening operation on the fitted
    // guide shell. It removes the pointed/triangular guide tips that otherwise
    // appear where the raised guide terminates at the rounded PLUS outline.
    if (coupler.guide_end_rounding > 0)
        offset(r = coupler.guide_end_rounding)
            offset(delta = -coupler.guide_end_rounding)
                _hub75_middle_coupler_raw_guide_shell_2d(coupler);
    else
        _hub75_middle_coupler_raw_guide_shell_2d(coupler);
}


module _hub75_middle_coupler_reinforcement_relief_cutters(coupler) {
    relief_diameter =
        coupler.reinforcement_bushing_outer_diameter
        + 2 * coupler.reinforcement_bushing_clearance;

    for (position =
        _hub75_middle_coupler_reinforcement_positions(coupler)
    )
        translate([
            position[0],
            _HUB75_MIDDLE_COUPLER_EPS,
            position[1]
        ])
            rotate([90, 0, 0])
                cylinder(
                    h =
                        coupler.guide_height
                        + 2 * _HUB75_MIDDLE_COUPLER_EPS,
                    d = relief_diameter
                );
}


module _hub75_middle_coupler_guide_walls(coupler) {
    difference() {
        _hub75_middle_coupler_extrude_xz_y(
            -coupler.guide_height,
             _HUB75_MIDDLE_COUPLER_EPS
        )
            _hub75_middle_coupler_guide_shell_2d(coupler);

        _hub75_middle_coupler_reinforcement_relief_cutters(coupler);
    }
}


// ----------------------------------------------------------------------
// Private seam locator
// ----------------------------------------------------------------------

module _hub75_middle_coupler_locator_section_2d(
    coupler,
    width
) {
    length = coupler.profile_size;
    radius = min(
        coupler.seam_locator_end_radius,
        width / 2 - 0.01,
        length / 2 - 0.01
    );

    offset(r = max(0, radius))
        square(
            [
                max(0.02, width - 2 * radius),
                max(0.02, length - 2 * radius)
            ],
            center = true
        );
}


module _hub75_middle_coupler_seam_locator(coupler) {
    base_width =
        hub75_middle_coupler_seam_locator_width(coupler);
    tip_width = max(
        0.6,
        base_width
        - 2 * coupler.seam_locator_lead_in_per_side
    );

    // Two very thin X/Z sections are hulled into one continuous Y taper.
    // The base overlaps the plate by EPS; the insertion tip is narrower.
    hull() {
        _hub75_middle_coupler_extrude_xz_y(
            -_HUB75_MIDDLE_COUPLER_EPS,
             _HUB75_MIDDLE_COUPLER_EPS
        )
            _hub75_middle_coupler_locator_section_2d(
                coupler,
                base_width
            );

        _hub75_middle_coupler_extrude_xz_y(
            -coupler.seam_locator_height
                - _HUB75_MIDDLE_COUPLER_EPS,
            -coupler.seam_locator_height
                + _HUB75_MIDDLE_COUPLER_EPS
        )
            _hub75_middle_coupler_locator_section_2d(
                coupler,
                tip_width
            );
    }
}


// ----------------------------------------------------------------------
// Standalone Customizer preview
// ----------------------------------------------------------------------

_preview_panel =
    hub75_p5_64x32_panel_create();

_preview_coupler =
    hub75_middle_coupler_create(
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
        mounting_tube_radial_clearance =
            mounting_tube_radial_clearance,
        mounting_tube_axial_clearance =
            mounting_tube_axial_clearance,
        reinforcement_bushing_clearance =
            reinforcement_bushing_clearance,
        seam_locator_height = seam_locator_height,
        seam_locator_lead_in_per_side =
            seam_locator_lead_in_per_side,
        seam_locator_end_radius =
            seam_locator_end_radius
    );

hub75_middle_coupler_render(
    _preview_coupler,
    view = preview_view
);
