// File: tube_mount_couplers.scad
//   Tube-mount variants around the accepted panel-facing core couplers.
//
// The core component files remain unchanged. Every female dovetail consumes the
// same interface object as the one canonical detachable clamp.

use <../horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>
use <../corner-edge-coupler/hub75_corner_edge_coupler.scad>
use <dovetail_tube_clamp.scad>

_HUB75_TUBE_MOUNT_EPS = 0.05;

function hub75_tube_mount_clip_offset(profile_size) =
    profile_size <= 60 ? 18 : 25;

function hub75_tube_mount_point_radius() = 9.5;

module _hub75_tube_mount_point_profile_2d(
    clamp,
    clip_x
) {
    translate([
        clip_x,
        clamp.dovetail_center_z
    ])
        circle(r = hub75_tube_mount_point_radius());
}

module _hub75_tube_mount_point_solid(
    coupler,
    clamp,
    clip_x
) {
    $fn = coupler.render_fn;
    mount_depth =
        max(coupler.base_thickness, clamp.dovetail.depth);

    translate([0, mount_depth, 0])
        rotate([90, 0, 0])
            linear_extrude(height = mount_depth)
                _hub75_tube_mount_point_profile_2d(
                    clamp = clamp,
                    clip_x = clip_x
                );
}

module _hub75_tube_mount_local_dovetail_cutter(
    clamp,
    clip_x,
    entry_side,
    entry_half_span = hub75_tube_mount_point_radius()
) {
    assert(
        entry_side == -1 || entry_side == 1,
        "entry_side must be -1 or +1"
    );

    foot_half =
        hub75_dovetail_tube_clamp_foot_length(clamp) / 2;

    entry_x =
        clip_x
        + entry_side
            * (entry_half_span + _HUB75_TUBE_MOUNT_EPS);
    stop_x =
        clip_x
        - entry_side
            * (foot_half + clamp.dovetail.axial_clearance);

    hub75_dovetail_tube_clamp_groove_cutter(
        clamp = clamp,
        entry_x = entry_x,
        stop_x = stop_x
    );
}

module hub75_horizontal_edge_tube_mount_coupler_build(coupler) {
    offset =
        hub75_tube_mount_clip_offset(coupler.profile_size);
    clamp =
        hub75_dovetail_tube_clamp_create();

    difference() {
        union() {
            hub75_horizontal_edge_coupler_build(coupler);

            for (clip_x = [-offset, offset])
                _hub75_tube_mount_point_solid(
                    coupler = coupler,
                    clamp = clamp,
                    clip_x = clip_x
                );
        }

        for (clip_x = [-offset, offset])
            _hub75_tube_mount_local_dovetail_cutter(
                clamp = clamp,
                clip_x = clip_x,
                entry_side = clip_x < 0 ? -1 : 1
            );
    }
}

module hub75_corner_edge_tube_mount_coupler_build(coupler) {
    offset =
        hub75_tube_mount_clip_offset(coupler.profile_size);
    clamp =
        hub75_dovetail_tube_clamp_create();
    clip_x =
        coupler.x_inward * offset;

    difference() {
        hub75_corner_edge_coupler_build(coupler);

        _hub75_tube_mount_local_dovetail_cutter(
            clamp = clamp,
            clip_x = clip_x,
            entry_side = coupler.x_inward
        );
    }
}
