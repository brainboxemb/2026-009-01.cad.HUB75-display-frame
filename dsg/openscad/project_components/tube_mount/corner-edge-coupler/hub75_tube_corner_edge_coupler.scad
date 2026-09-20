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
    clip_x
) {
    ring_r =
        hub75_tube_clamp_outer_diameter(clamp) / 2;
    ring_width =
        clamp.base_clamp.clamp_width;
    ring_fn = 64;

    translate([
        clip_x - ring_width / 2,
        hub75_tube_clamp_tube_center_y(clamp),
        hub75_tube_clamp_tube_center_z(clamp)
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
    base_clamp = clamp.base_clamp;
    entry_travel =
        hub75_tube_mount_dovetail_entry_slot_length(
            clamp.dovetail
        );
    sweep_eps = _HUB75_TUBE_CORNER_EPS;

    assert(
        entry_travel > 0,
        "corner clamp keepout needs positive dovetail entry travel"
    );

    // Build a slightly enlarged copy of the actual clamp body, then sweep it
    // over exactly the same +Z approach distance as the female dovetail entry
    // slot. In addition to the detailed body, clear the complete solid outer
    // ring envelope. The old hollow-body-only sweep could leave corner material
    // inside the clamp bore/opening volume, which visually and physically
    // blocked the complete clip even though the female dovetail itself fitted.
    keepout_clamp =
        hub75_tube_clamp_create(
            tube_center_y =
                hub75_tube_clamp_tube_center_y(clamp),
            tube_center_z =
                hub75_tube_clamp_tube_center_z(clamp),
            tube_diameter =
                hub75_tube_clamp_functional_diameter(clamp),
            tension_diameter =
                hub75_tube_clamp_functional_diameter(clamp),
            wall_thickness =
                base_clamp.wall_thickness + clearance,
            clamp_width =
                base_clamp.clamp_width + 2 * clearance,
            opening_angle =
                base_clamp.opening_angle,
            // Let the enlarged keepout clamp derive the transition again.
            // With a 30-degree dovetail the extra lateral clearance requires
            // more transition depth than a simple +clearance offset.
            transition_depth = undef,
            dovetail_slide =
                clamp.dovetail_slide,
            dovetail_center_z =
                clamp.dovetail_center_z,
            dovetail_relief_chamfer_depth = 0,
            extra =
                base_clamp.extra,
            dovetail =
                clamp.dovetail
        );

    // Minkowski with a narrow +Z segment is the actual translational swept
    // volume. The union uses the detailed enlarged body for its transition and
    // a filled outer-ring cylinder for the complete clip envelope.
    minkowski() {
        union() {
            translate([clip_x, 0, 0])
                hub75_tube_clamp_body_build(
                    keepout_clamp,
                    use_tension_bore = false,
                    high_resolution = false
                );

            _hub75_tube_corner_edge_outer_ring_envelope(
                keepout_clamp,
                clip_x
            );
        }

        translate([
            -sweep_eps / 2,
            -sweep_eps / 2,
            0
        ])
            cube([
                sweep_eps,
                sweep_eps,
                entry_travel + sweep_eps
            ]);
    }
}
