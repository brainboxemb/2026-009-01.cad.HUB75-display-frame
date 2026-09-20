// File: tube_mount_couplers.scad
//   Tube-mount variants around the accepted panel-facing core couplers.
//
// The core component files remain unchanged. Every male/female mating feature
// consumes the same locked lib.scad.mechint dovetail object.

use <../horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>
use <../corner-edge-coupler/hub75_corner_edge_coupler.scad>
use <dovetail_interface.scad>
use <dovetail_tube_clamp.scad>

_HUB75_TUBE_MOUNT_EPS = 0.05;

function hub75_tube_mount_clip_offset(profile_size) =
    profile_size <= 60 ? 18 : 25;

function hub75_tube_mount_point_radius() =
    9.5;

// The tube-mount carrier must stay coplanar with the existing coupler rear
// face so the coupler can print rear-face-down without a local support bump.
function hub75_tube_mount_point_depth(coupler) =
    coupler.base_thickness;

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
        hub75_tube_mount_point_depth(coupler);

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

    slide =
        hub75_dovetail_tube_clamp_foot_length(
            clamp
        );
    female_half =
        hub75_tube_mount_dovetail_female_slide(
            clamp.dovetail,
            slide
        ) / 2;
    entry_extension =
        max(
            0,
            entry_half_span
                + _HUB75_TUBE_MOUNT_EPS
                - female_half
        );

    hub75_dovetail_tube_clamp_groove_cutter(
        clamp = clamp,
        center_x = clip_x,
        entry_side = entry_side,
        entry_extension = entry_extension
    );
}

module hub75_horizontal_edge_tube_mount_coupler_build(coupler) {
    offset =
        hub75_tube_mount_clip_offset(
            coupler.profile_size
        );
    clamp =
        hub75_dovetail_tube_clamp_create(
            dovetail =
                hub75_tube_mount_dovetail_create(
                    host_depth = coupler.base_thickness
                )
        );

    difference() {
        union() {
            hub75_horizontal_edge_coupler_build(
                coupler
            );

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
        hub75_tube_mount_clip_offset(
            coupler.profile_size
        );
    clamp =
        hub75_dovetail_tube_clamp_create(
            dovetail =
                hub75_tube_mount_dovetail_create(
                    host_depth = coupler.base_thickness
                )
        );
    clip_x =
        coupler.x_inward * offset;

    difference() {
        union() {
            hub75_corner_edge_coupler_build(
                coupler
            );

            _hub75_tube_mount_point_solid(
                coupler = coupler,
                clamp = clamp,
                clip_x = clip_x
            );
        }

        _hub75_tube_mount_local_dovetail_cutter(
            clamp = clamp,
            clip_x = clip_x,
            entry_side = coupler.x_inward
        );
    }
}
