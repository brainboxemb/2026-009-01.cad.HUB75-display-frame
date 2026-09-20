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

    // The circular outer envelope already contains the compact clamp base and
    // transition once fit clearance is added.  The male dovetail has its own
    // exact female cutter, so the corner only needs the swept outer clip
    // envelope here.  Sweeping two convex cylinders with hull() is equivalent
    // to the former line-segment Minkowski for this envelope, but is much
    // cheaper for repeated PNG/STL production.
    //
    // Filling the ring deliberately clears the snap opening and bore as well:
    // those voids belong to the detachable clamp and must not be occupied by
    // corner material anywhere along the +Z insertion path.
    assert(
        clamp.base_clamp.transition_width
            <= hub75_tube_clamp_outer_diameter(clamp)
                + 2 * clearance,
        "corner ring envelope no longer contains the clamp transition"
    );

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
}
