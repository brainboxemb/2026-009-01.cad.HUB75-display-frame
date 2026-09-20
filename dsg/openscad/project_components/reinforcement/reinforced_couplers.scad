// File: reinforced_couplers.scad
//   Reinforcement-only wrappers around the accepted core coupler geometry.
//
// The panel-facing production component files remain unchanged. These wrappers
// subtract shallow rear-face dovetail grooves only in the outside reinforcement
// arm, so the detachable tube-clip work does not redefine HUB75 panel mating.

use <../horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>
use <../corner-edge-coupler/hub75_corner_edge_coupler.scad>
use <dovetail_tube_clamp.scad>

module hub75_reinforced_horizontal_edge_coupler_build(coupler) {
    offset = hub75_reinforcement_clip_offset(coupler.profile_size);
    rail_half = hub75_reinforcement_dovetail_rail_length() / 2;

    difference() {
        hub75_horizontal_edge_coupler_build(coupler);

        for (clip_x = [-offset, offset]) {
            side = clip_x < 0 ? -1 : 1;
            entry_x = side * coupler.profile_size / 2;
            stop_x = clip_x - side * rail_half;

            hub75_reinforcement_dovetail_groove_cutter(
                coupler_base_thickness = coupler.base_thickness,
                entry_x = entry_x,
                stop_x = stop_x
            );
        }
    }
}

module hub75_reinforced_corner_edge_coupler_build(coupler) {
    offset = hub75_reinforcement_clip_offset(coupler.profile_size);
    rail_half = hub75_reinforcement_dovetail_rail_length() / 2;
    clip_x = coupler.x_inward * offset;
    entry_x =
        coupler.x_inward
        * hub75_corner_edge_coupler_inward_reach(coupler);
    stop_x = clip_x - coupler.x_inward * rail_half;

    difference() {
        hub75_corner_edge_coupler_build(coupler);

        hub75_reinforcement_dovetail_groove_cutter(
            coupler_base_thickness = coupler.base_thickness,
            entry_x = entry_x,
            stop_x = stop_x
        );
    }
}
