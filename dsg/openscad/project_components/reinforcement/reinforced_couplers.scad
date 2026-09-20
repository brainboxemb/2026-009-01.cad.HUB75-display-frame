// File: reinforced_couplers.scad
//   Reinforcement-only wrappers around the accepted core coupler geometry.
//
// The core component files remain unchanged. These wrappers subtract only the
// detachable clamp sockets in the outside reinforcement region.

use <../horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>
use <../corner-edge-coupler/hub75_corner_edge_coupler.scad>
use <dovetail_tube_clamp.scad>

module hub75_reinforced_horizontal_edge_coupler_build(coupler) {
    offset = hub75_reinforcement_clip_offset(coupler.profile_size);
    side_offset = hub75_reinforcement_dovetail_side_offset();

    difference() {
        hub75_horizontal_edge_coupler_build(coupler);

        for (clip_x = [-offset, offset]) {
            outward_sign = clip_x < 0 ? -1 : 1;
            hub75_reinforcement_dovetail_socket_cutter(
                coupler_base_thickness = coupler.base_thickness,
                center_x = clip_x + outward_sign * side_offset,
                center_z = hub75_reinforcement_tube_center_z()
            );
        }
    }
}

module hub75_reinforced_corner_edge_coupler_build(coupler) {
    offset = hub75_reinforcement_clip_offset(coupler.profile_size);
    clip_x = coupler.x_inward * offset;
    socket_x =
        clip_x - coupler.x_inward
            * hub75_reinforcement_dovetail_side_offset();

    difference() {
        hub75_corner_edge_coupler_build(coupler);

        hub75_reinforcement_dovetail_socket_cutter(
            coupler_base_thickness = coupler.base_thickness,
            center_x = socket_x,
            center_z = hub75_reinforcement_tube_center_z()
        );
    }
}
