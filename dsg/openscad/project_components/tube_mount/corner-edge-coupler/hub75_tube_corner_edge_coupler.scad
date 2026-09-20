// File: hub75_tube_corner_edge_coupler.scad
//   Tube-aware corner-edge coupler using the same top-entry clamp interface as
//   the horizontal-edge tube coupler.
//
// The accepted corner-edge exterior remains unchanged. Tube clearance, local
// clamp clearance and the female dovetail are cut directly from the existing
// corner geometry. The clamp/interface X datum is the existing vertical
// side-rail centre, because that is the corner mass that reaches the tube height.

use <../../../components/hub75/corner-edge-coupler/hub75_corner_edge_coupler.scad>
use <../tube-clamp/hub75_tube_clamp.scad>
use <../tube_mount_interface.scad>

_HUB75_TUBE_CORNER_EPS = 0.05;

function hub75_tube_corner_edge_clamp_x(coupler) =
    hub75_corner_edge_coupler_side_rail_center_x(coupler);

function hub75_tube_corner_edge_available_interface_width(coupler) =
    hub75_corner_edge_coupler_vertical_arm_width(coupler);

function hub75_tube_corner_edge_required_interface_width(
    coupler,
    clamp = hub75_tube_clamp_create()
) =
    max(
        hub75_tube_mount_dovetail_female_root_width(
            clamp.dovetail
        ),
        clamp.base_clamp.clamp_width
            + 2 * hub75_tube_corner_edge_clamp_body_clearance(coupler)
    );

function hub75_tube_corner_edge_keepout_radial_clearance(coupler) =
    coupler.fit_clearance;

function hub75_tube_corner_edge_clamp_body_clearance(coupler) =
    coupler.fit_clearance;


// ----------------------------------------------------------------------
// Public geometry
// ----------------------------------------------------------------------

module hub75_tube_corner_edge_coupler_build(
    coupler
) {
    clamp =
        hub75_tube_clamp_create(
            dovetail =
                hub75_tube_mount_dovetail_create(
                    host_depth = coupler.base_thickness
                )
        );
    clip_x = hub75_tube_corner_edge_clamp_x(coupler);
    available_interface_width =
        hub75_tube_corner_edge_available_interface_width(coupler);
    required_interface_width =
        hub75_tube_corner_edge_required_interface_width(
            coupler,
            clamp
        );

    assert(
        required_interface_width <= available_interface_width,
        "corner tube-mount interface does not fit inside the existing vertical arm"
    );

    difference() {
        hub75_corner_edge_coupler_build(coupler);

        _hub75_tube_corner_edge_keepout_cutter(
            coupler,
            clamp
        );

        _hub75_tube_corner_edge_clamp_keepout_cutter(
            coupler,
            clamp,
            clip_x
        );

        hub75_tube_mount_dovetail_female_cutter(
            dovetail = clamp.dovetail,
            slide = clamp.dovetail_slide,
            center_x = clip_x,
            center_z = clamp.dovetail_center_z
        );
    }
}


// ----------------------------------------------------------------------
// Private implementation
// ----------------------------------------------------------------------

module _hub75_tube_corner_edge_keepout_cutter(
    coupler,
    clamp
) {
    keepout_d =
        hub75_tube_clamp_functional_diameter(clamp)
        + 2 * hub75_tube_corner_edge_keepout_radial_clearance(coupler);
    cutter_length =
        coupler.profile_size
        + 2 * coupler.outside_projection
        + 2 * _HUB75_TUBE_CORNER_EPS;

    translate([
        -cutter_length / 2,
        hub75_tube_clamp_tube_center_y(clamp),
        hub75_tube_clamp_tube_center_z(clamp)
    ])
        rotate([0, 90, 0])
            cylinder(
                d = keepout_d,
                h = cutter_length,
                $fn = coupler.render_fn
            );
}


module _hub75_tube_corner_edge_outer_ring_envelope(
    clamp,
    clip_x,
    radial_clearance = 0,
    lateral_clearance = 0,
    z_shift = 0
) {
    ring_r =
        hub75_tube_clamp_outer_diameter(clamp) / 2
        + radial_clearance;
    ring_width =
        clamp.base_clamp.clamp_width
        + 2 * lateral_clearance;
    ring_fn = 64;

    translate([
        clip_x - ring_width / 2,
        hub75_tube_clamp_tube_center_y(clamp),
        hub75_tube_clamp_tube_center_z(clamp) + z_shift
    ])
        rotate([0, 90, 0])
            cylinder(
                r = ring_r,
                h = ring_width,
                $fn = ring_fn
            );
}


module _hub75_tube_corner_edge_clamp_access_cutter(
    coupler,
    clamp,
    clip_x,
    clearance,
    entry_travel
) {
    ring_r =
        hub75_tube_clamp_outer_diameter(clamp) / 2
        + clearance;
    ring_front_y =
        hub75_tube_clamp_tube_center_y(clamp)
        + ring_r;
    rear_y =
        coupler.base_thickness
        + _HUB75_TUBE_CORNER_EPS;
    access_depth =
        rear_y - ring_front_y;
    z_bottom =
        hub75_tube_clamp_tube_center_z(clamp)
        - ring_r;
    z_top =
        max(
            coupler.outside_projection
                + _HUB75_TUBE_CORNER_EPS,
            hub75_tube_clamp_tube_center_z(clamp)
                + entry_travel
                + ring_r
        );
    opening_width =
        clamp.base_clamp.clamp_width
        + 2 * clearance;

    assert(
        access_depth > 0,
        "corner clamp access opening must reach the rear print face"
    );

    // Open the swept circular clamp cavity all the way to the rear print face.
    // The lower edge rises at 45 degrees from the rear face to the circular
    // envelope, removing the thin plate/shelf that previously sat underneath
    // the clip.  With rear-face-down printing this avoids the unsupported
    // circular roof while keeping the cavity simple and inspectable.
    multmatrix([
        [0, 0, 1, clip_x - opening_width / 2],
        [1, 0, 0, 0],
        [0, 1, 0, 0],
        [0, 0, 0, 1]
    ])
        linear_extrude(height = opening_width)
            polygon(points = [
                [
                    ring_front_y - _HUB75_TUBE_CORNER_EPS,
                    z_bottom
                ],
                [
                    ring_front_y - _HUB75_TUBE_CORNER_EPS,
                    z_top
                ],
                [
                    rear_y,
                    z_top
                ],
                [
                    rear_y,
                    z_bottom - access_depth
                ]
            ]);
}


module _hub75_tube_corner_edge_clamp_keepout_cutter(
    coupler,
    clamp,
    clip_x
) {
    clearance =
        hub75_tube_corner_edge_clamp_body_clearance(coupler);
    entry_travel =
        hub75_tube_mount_dovetail_entry_slot_length(
            clamp.dovetail
        );

    assert(
        entry_travel > 0,
        "corner clamp keepout needs positive dovetail entry travel"
    );

    // Keep the exact swept circular envelope for the clip itself, then connect
    // it to the rear print face with a simple 45-degree access opening.  The
    // male dovetail still owns its own exact female cutter.  Filling the ring
    // deliberately clears the snap opening and bore as well: those voids belong
    // to the detachable clamp and must not be occupied by corner material
    // anywhere along the +Z insertion path.
    assert(
        clamp.base_clamp.transition_width
            <= hub75_tube_clamp_outer_diameter(clamp)
                + 2 * clearance,
        "corner ring envelope no longer contains the clamp transition"
    );

    union() {
        hull() {
            _hub75_tube_corner_edge_outer_ring_envelope(
                clamp,
                clip_x,
                radial_clearance = clearance,
                lateral_clearance = clearance,
                z_shift = 0
            );

            _hub75_tube_corner_edge_outer_ring_envelope(
                clamp,
                clip_x,
                radial_clearance = clearance,
                lateral_clearance = clearance,
                z_shift = entry_travel
            );
        }

        _hub75_tube_corner_edge_clamp_access_cutter(
            coupler,
            clamp,
            clip_x,
            clearance,
            entry_travel
        );
    }
}
