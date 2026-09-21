// File: hub75_tube_clamp.scad
//   Project-owned detachable Ø10 HUB75 tube clamp.
//
// Design: design/design.md
// Design review: hub75_tube_clamp_render.scad
//
// lib.scad.clamps owns the reusable snap-ring geometry and nominal/tension bore
// semantics. HUB75 keeps the ring compact, narrows it to 12 mm and places the
// size-matched vertical male dovetail beside the compact transition. Small,
// medium and large use 2.0 / 2.5 / 3.0 mm dovetail heights. The complete clamp,
// including its male dovetail, stays positioned from the tube-front datum.

use <../../../ext/lib.scad.clamps/openscad/tube-clamp/tube_clamp.scad>
use <../tube_mount_interface.scad>

/* [Profile] */
preview_profile = "medium"; // [small,medium,large]

/* [Preview] */
preview_view = "complete"; // [complete,body]
preview_bore = "functional"; // [functional,tension]
preview_transition_fillet = true;

/* [Resolution] */
preview_high_resolution = false;


// ----------------------------------------------------------------------
// Fixed clamp-body baseline
// ----------------------------------------------------------------------

// The clamp body must not change when only the coupler/dovetail profile size
// changes.  The accepted body baseline is the medium-interface connection.
// Small/medium/large therefore share this same compact transition; only the
// actual dovetail and the mating relief required for that dovetail vary.
function _hub75_tube_clamp_reference_dovetail() =
    hub75_tube_mount_dovetail_create_for_size("medium");

function _hub75_tube_clamp_reference_transition_width() =
    hub75_tube_mount_dovetail_mouth_width(
        _hub75_tube_clamp_reference_dovetail()
    );

function _hub75_tube_clamp_reference_transition_depth(
    clamp_width = 12
) =
    let(
        ref = _hub75_tube_clamp_reference_dovetail(),
        transition_width =
            _hub75_tube_clamp_reference_transition_width(),
        lateral_step =
            max(0, (clamp_width - transition_width) / 2)
    )
    lateral_step / tan(
        hub75_tube_mount_dovetail_angle(ref)
    );

function hub75_tube_clamp_create(
    tube_center_y = undef,
    tube_center_z = 10,
    tube_diameter = 10,
    tension_diameter = 9.6,
    wall_thickness = 2.0,
    clamp_width = 12,
    opening_angle = 60,
    transition_width = undef,
    transition_depth = undef,
    dovetail_slide = 16,
    dovetail_center_z = undef,
    dovetail_relief_chamfer_depth = undef,
    transition_fillet_radius = 1.0,
    extra = 0.01,
    dovetail = hub75_tube_mount_dovetail_create()
) =
    let(
        active_tube_center_y =
            is_undef(tube_center_y)
                ? hub75_tube_mount_tube_center_y(
                    tube_diameter
                )
                : tube_center_y,
        active_dovetail_center_z =
            is_undef(dovetail_center_z)
                ? tube_center_z
                : dovetail_center_z,
        active_transition_width =
            is_undef(transition_width)
                ? _hub75_tube_clamp_reference_transition_width()
                : transition_width,
        active_transition_depth =
            is_undef(transition_depth)
                ? _hub75_tube_clamp_reference_transition_depth(
                    clamp_width
                )
                : transition_depth,
        active_relief_chamfer_depth =
            is_undef(dovetail_relief_chamfer_depth)
                ? active_transition_depth
                : dovetail_relief_chamfer_depth,
        base_clamp =
            tube_clamp_create(
                tube_diameter = tube_diameter,
                clearance = 0,
                tension_diameter = tension_diameter,
                wall_thickness = wall_thickness,
                clamp_width = clamp_width,
                opening_angle = opening_angle,
                base_thickness = extra,
                transition_width = active_transition_width,
                transition_depth = active_transition_depth,
                extra = extra
            )
    )
    assert(dovetail_slide > 0,
        "tube-clamp dovetail_slide must be > 0")
    assert(active_transition_width > 0,
        "tube-clamp transition_width must be > 0")
    assert(active_transition_width <= clamp_width,
        "tube-clamp transition_width must not exceed clamp_width")
    assert(active_transition_depth > 0,
        "tube-clamp transition_depth must be > 0")
    assert(active_relief_chamfer_depth >= 0,
        "tube-clamp dovetail_relief_chamfer_depth must be >= 0")
    assert(active_relief_chamfer_depth <= active_transition_depth,
        "tube-clamp dovetail_relief_chamfer_depth must not exceed transition_depth")
    assert(transition_fillet_radius >= 0,
        "tube-clamp transition_fillet_radius must be >= 0")
    object(
        tube_center_y = active_tube_center_y,
        tube_center_z = tube_center_z,
        dovetail = dovetail,
        dovetail_slide = dovetail_slide,
        dovetail_center_z = active_dovetail_center_z,
        dovetail_relief_chamfer_depth =
            active_relief_chamfer_depth,
        transition_fillet_radius = transition_fillet_radius,
        base_clamp = base_clamp
    );

function hub75_tube_clamp_create_for_host_depth(host_depth) =
    hub75_tube_clamp_create(
        dovetail =
            hub75_tube_mount_dovetail_create(
                host_depth = host_depth
            )
    );

function hub75_tube_clamp_create_for_size(size) =
    hub75_tube_clamp_create(
        dovetail = hub75_tube_mount_dovetail_create_for_size(size)
    );

function hub75_tube_clamp_tube_center_y(clamp) =
    clamp.tube_center_y;

function hub75_tube_clamp_tube_center_z(clamp) =
    clamp.tube_center_z;

function hub75_tube_clamp_functional_diameter(clamp) =
    tube_clamp_functional_diameter(clamp.base_clamp);

function hub75_tube_clamp_tension_diameter(clamp) =
    tube_clamp_tension_diameter(clamp.base_clamp);

function hub75_tube_clamp_outer_diameter(clamp) =
    2 * tube_clamp_outer_radius(clamp.base_clamp);

function hub75_tube_clamp_dovetail_relief_chamfer_depth(clamp) =
    clamp.dovetail_relief_chamfer_depth;


// ----------------------------------------------------------------------
// Public geometry
// ----------------------------------------------------------------------

module hub75_tube_clamp_body_build(
    clamp,
    part_color = [0.88, 0.08, 0.05, 1],
    use_tension_bore = true,
    high_resolution = true,
    apply_transition_fillet = true
) {
    color(part_color)
        _hub75_tube_clamp_ring_build(
            clamp,
            use_tension_bore,
            high_resolution,
            apply_transition_fillet
        );
}

module hub75_tube_clamp_build(
    clamp,
    part_color = [0.88, 0.08, 0.05, 1],
    use_tension_bore = true,
    high_resolution = true,
    apply_transition_fillet = true
) {
    color(part_color)
        union() {
            difference() {
                _hub75_tube_clamp_ring_build(
                    clamp,
                    use_tension_bore,
                    high_resolution,
                    apply_transition_fillet
                );

                _hub75_tube_clamp_dovetail_relief_cutter(clamp);
                _hub75_tube_clamp_dovetail_relief_chamfer_cutter(clamp);
            }

            _hub75_tube_clamp_dovetail_build(clamp);
        }
}


// ----------------------------------------------------------------------
// Private implementation
// ----------------------------------------------------------------------

module _hub75_tube_clamp_ring_build(
    clamp,
    use_tension_bore,
    high_resolution,
    apply_transition_fillet = true
) {
    local_center_x =
        clamp.base_clamp.base_thickness
        + tube_clamp_outer_radius(clamp.base_clamp);
    y_translation =
        clamp.tube_center_y + local_center_x;

    // Library local Z (clamp extrusion) becomes project X (tube axis).
    // Library local X becomes -project Y, keeping the ring tangent near Y=0.
    // Library local Y becomes -project Z around the tube centre.
    multmatrix([
        [ 0,  0,  1, -clamp.base_clamp.clamp_width / 2],
        [-1,  0,  0,  y_translation],
        [ 0, -1,  0,  clamp.tube_center_z],
        [ 0,  0,  0,  1]
    ])
        union() {
            tube_clamp_build(
                clamp.base_clamp,
                use_tension_bore = use_tension_bore,
                high_resolution = high_resolution
            );

            if (
                apply_transition_fillet
                && clamp.transition_fillet_radius > 0
            )
                _hub75_tube_clamp_transition_fillet_local(
                    clamp,
                    high_resolution
                );
        }
}


// Small tangent fill for the sharp concave corner where the compact transition
// meets the round clip body.  This is deliberately ADDITIVE: subtracting another
// round notch would deepen the concavity.  The fill is extruded on native Z,
// which maps to project X / printer Z in the intended side-print orientation.
module _hub75_tube_clamp_transition_fillet_local(
    clamp,
    high_resolution
) {
    b = clamp.base_clamp;
    r = clamp.transition_fillet_radius;
    outer_r = tube_clamp_outer_radius(b);
    center_x = b.base_thickness + outer_r;

    attach_x = min(
        b.base_thickness + b.transition_depth,
        center_x + outer_r - b.extra
    );
    attach_dx = attach_x - center_x;
    attach_y = sqrt(max(
        0.01,
        outer_r * outer_r - attach_dx * attach_dx
    ));

    base_y = b.transition_width / 2;
    vx = attach_x - b.base_thickness;
    vy = attach_y - base_y;
    v_len = sqrt(vx * vx + vy * vy);
    tx = vx / v_len;
    ty = vy / v_len;

    // Upper-side outward normal of the sloped transition.
    nx = -ty;
    ny = tx;

    // A circle outside both source surfaces is tangent to the transition line
    // and externally tangent to the round clip body.  The near quadratic root
    // gives the local solution; the far root belongs to the opposite side of
    // the ring and is intentionally ignored.
    qx = attach_x + r * nx;
    qy = attach_y + r * ny;
    qcx = qx - center_x;
    qcy = qy;
    qb = 2 * (qcx * tx + qcy * ty);
    qc =
        qcx * qcx
        + qcy * qcy
        - (outer_r + r) * (outer_r + r);
    disc = max(0, qb * qb - 4 * qc);
    s1 = (-qb + sqrt(disc)) / 2;
    s2 = (-qb - sqrt(disc)) / 2;
    s = abs(s1) < abs(s2) ? s1 : s2;

    fillet_x = qx + s * tx;
    fillet_y = qy + s * ty;

    line_tangent = [
        fillet_x - r * nx,
        fillet_y - r * ny
    ];

    ring_dx = fillet_x - center_x;
    ring_dy = fillet_y;
    ring_distance = sqrt(
        ring_dx * ring_dx + ring_dy * ring_dy
    );
    ring_tangent = [
        center_x + outer_r * ring_dx / ring_distance,
        outer_r * ring_dy / ring_distance
    ];

    vertex = [attach_x, attach_y];

    assert(v_len > 0,
        "tube-clamp transition fillet needs a non-zero transition edge")
    assert(disc >= -0.000001,
        "tube-clamp transition fillet has no tangent-circle solution");

    linear_extrude(height = b.clamp_width)
        union()
            for (side = [-1, 1])
                scale([1, side])
                    difference() {
                        polygon(points = [
                            line_tangent,
                            vertex,
                            ring_tangent
                        ]);

                        translate([
                            fillet_x,
                            fillet_y
                        ])
                            circle(
                                r = r,
                                $fn =
                                    high_resolution
                                        ? 96
                                        : 32
                            );
                    }
}

module _hub75_tube_clamp_dovetail_relief_cutter(clamp) {
    hub75_tube_mount_dovetail_male_relief_cutter(
        dovetail = clamp.dovetail,
        slide = clamp.dovetail_slide,
        relief_width = clamp.base_clamp.clamp_width,
        center_x = 0,
        center_z = clamp.dovetail_center_z
    );
}

module _hub75_tube_clamp_dovetail_relief_chamfer_cutter(clamp) {
    chamfer_depth =
        hub75_tube_clamp_dovetail_relief_chamfer_depth(clamp);

    if (chamfer_depth > 0) {
        mouth_y =
            hub75_tube_mount_dovetail_mouth_y();
        mouth_half_width =
            hub75_tube_mount_dovetail_mouth_width(
                clamp.dovetail
            ) / 2;
        clamp_half_width =
            clamp.base_clamp.clamp_width / 2;
        z_min =
            clamp.dovetail_center_z
            - clamp.dovetail_slide / 2
            - clamp.base_clamp.extra;
        z_length =
            clamp.dovetail_slide
            + 2 * clamp.base_clamp.extra;

        // Project-local finishing cut. The generic mechint relief owns the
        // exact dovetail contour; this wedge only softens the abrupt clamp-body
        // shoulder immediately in front of the male mouth. Its slope follows
        // the same angle as the dovetail flank.
        translate([0, 0, z_min])
            linear_extrude(height = z_length)
                union() {
                    polygon(points = [
                        [
                            mouth_half_width
                                - clamp.base_clamp.extra,
                            mouth_y + clamp.base_clamp.extra
                        ],
                        [
                            clamp_half_width
                                + clamp.base_clamp.extra,
                            mouth_y + clamp.base_clamp.extra
                        ],
                        [
                            clamp_half_width
                                + clamp.base_clamp.extra,
                            mouth_y
                                - chamfer_depth
                                - clamp.base_clamp.extra
                        ]
                    ]);

                    mirror([1, 0, 0])
                        polygon(points = [
                            [
                                mouth_half_width
                                    - clamp.base_clamp.extra,
                                mouth_y + clamp.base_clamp.extra
                            ],
                            [
                                clamp_half_width
                                    + clamp.base_clamp.extra,
                                mouth_y + clamp.base_clamp.extra
                            ],
                            [
                                clamp_half_width
                                    + clamp.base_clamp.extra,
                                mouth_y
                                    - chamfer_depth
                                    - clamp.base_clamp.extra
                            ]
                        ]);
                }
    }
}

module _hub75_tube_clamp_dovetail_build(clamp) {
    hub75_tube_mount_dovetail_male_build(
        dovetail = clamp.dovetail,
        slide = clamp.dovetail_slide,
        center_x = 0,
        center_z = clamp.dovetail_center_z
    );
}


// ----------------------------------------------------------------------
// Standalone Customizer preview
// ----------------------------------------------------------------------

_preview_clamp =
    hub75_tube_clamp_create_for_size(preview_profile);

_preview_use_tension_bore =
    preview_bore == "tension";

if (preview_view == "body")
    hub75_tube_clamp_body_build(
        _preview_clamp,
        use_tension_bore = _preview_use_tension_bore,
        high_resolution = preview_high_resolution,
        apply_transition_fillet = preview_transition_fillet
    );
else
    hub75_tube_clamp_build(
        _preview_clamp,
        use_tension_bore = _preview_use_tension_bore,
        high_resolution = preview_high_resolution,
        apply_transition_fillet = preview_transition_fillet
    );
