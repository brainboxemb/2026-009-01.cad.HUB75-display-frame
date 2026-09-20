// File: reinforced_couplers.scad
//   Reinforcement-only wrappers around the accepted core coupler geometry.
//
// The panel-facing core component files remain unchanged. Reinforced variants
// add only the local mounting material needed for detachable tube clamps.
//
// Horizontal-edge rule:
//   - two rounded mounting points, one per clamp;
//   - one short female dovetail in each point;
//   - left point inserts from the left, right point from the right.
//
// Corner-edge rule:
//   - use the existing horizontal arm as the local mounting point;
//   - replace the previous long arm groove with the same short local side-entry
//     female dovetail.

use <../horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>
use <../corner-edge-coupler/hub75_corner_edge_coupler.scad>
use <dovetail_tube_clamp.scad>

_HUB75_REINFORCED_COUPLER_EPS = 0.05;

function hub75_reinforcement_mount_point_radius() = 10.5;
function hub75_reinforcement_mount_point_inner_center_z() = -3.5;
function hub75_reinforcement_mount_point_outer_center_z() = 5.5;

module _hub75_reinforcement_mount_point_profile_2d(
    clip_x
) {
    radius =
        hub75_reinforcement_mount_point_radius();

    // A vertical rounded tab: the lower round merges deeply into the existing
    // edge arm, while the upper round creates the local point shown in the
    // design sketch. Maximum outside projection remains below 20 mm.
    hull() {
        translate([
            clip_x,
            hub75_reinforcement_mount_point_inner_center_z()
        ])
            circle(r = radius);

        translate([
            clip_x,
            hub75_reinforcement_mount_point_outer_center_z()
        ])
            circle(r = radius);
    }
}

module _hub75_reinforcement_mount_point_solid(
    coupler,
    clip_x
) {
    $fn = coupler.render_fn;

    translate([0, coupler.base_thickness, 0])
        rotate([90, 0, 0])
            linear_extrude(height = coupler.base_thickness)
                _hub75_reinforcement_mount_point_profile_2d(
                    clip_x = clip_x
                );
}

// Cut one local side-entry slot.
//
// entry_side = -1 : open on left, insert left -> right.
// entry_side = +1 : open on right, insert right -> left.
module _hub75_reinforcement_local_dovetail_cutter(
    clamp,
    clip_x,
    entry_side,
    entry_half_span =
        hub75_reinforcement_mount_point_radius()
) {
    assert(
        entry_side == -1 || entry_side == 1,
        "entry_side must be -1 or +1"
    );

    foot_half =
        hub75_reinforcement_tube_clamp_foot_length(clamp) / 2;

    entry_x =
        clip_x
        + entry_side
            * (entry_half_span + _HUB75_REINFORCED_COUPLER_EPS);
    stop_x =
        clip_x
        - entry_side
            * (foot_half + clamp.dovetail_axial_clearance);

    hub75_reinforcement_dovetail_groove_cutter(
        clamp = clamp,
        entry_x = entry_x,
        stop_x = stop_x
    );
}

module hub75_reinforced_horizontal_edge_coupler_build(coupler) {
    offset =
        hub75_reinforcement_clip_offset(coupler.profile_size);
    clamp =
        hub75_reinforcement_tube_clamp_create(
            coupler_base_thickness = coupler.base_thickness
        );

    difference() {
        union() {
            // Accepted panel-facing T stays authoritative.
            hub75_horizontal_edge_coupler_build(coupler);

            // Two independent local points, as in the agreed sketch.
            for (clip_x = [-offset, offset])
                _hub75_reinforcement_mount_point_solid(
                    coupler = coupler,
                    clip_x = clip_x
                );
        }

        for (clip_x = [-offset, offset])
            _hub75_reinforcement_local_dovetail_cutter(
                clamp = clamp,
                clip_x = clip_x,
                entry_side = clip_x < 0 ? -1 : 1
            );
    }
}

module hub75_reinforced_corner_edge_coupler_build(coupler) {
    offset =
        hub75_reinforcement_clip_offset(coupler.profile_size);
    clamp =
        hub75_reinforcement_tube_clamp_create(
            coupler_base_thickness = coupler.base_thickness
        );
    clip_x =
        coupler.x_inward * offset;

    difference() {
        hub75_corner_edge_coupler_build(coupler);

        // The corner already has local edge material. Use only a short side
        // entry around the clamp location instead of a channel from the remote
        // end of the whole arm.
        _hub75_reinforcement_local_dovetail_cutter(
            clamp = clamp,
            clip_x = clip_x,
            entry_side = coupler.x_inward
        );
    }
}
