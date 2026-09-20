// File: dovetail_tube_clip_fit_assembly.scad
//   Focused reinforcement fixture: one horizontal-edge coupler, one detachable
//   tube clamp and a short section of the real Ø10 aluminium tube.

use <../../project_components/horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>
use <../../project_components/reinforcement/reinforced_couplers.scad>
use <../../project_components/reinforcement/dovetail_tube_clamp.scad>
use <../../project_components/reinforcement/aluminium_tube.scad>

module hub75_dovetail_tube_clip_fit_assembly(
    size = "medium",
    show_coupler = true,
    show_clamp = true,
    show_tube = true,
    explode_distance = 0
) {
    coupler =
        hub75_horizontal_edge_coupler_create_for_size(
            size = size
        );
    clip_x =
        hub75_reinforcement_clip_offset(coupler.profile_size);
    tube_length = 58;
    x_shift = max(0, explode_distance);

    if (show_coupler)
        color([0.72, 0.05, 0.04, 1])
            hub75_reinforced_horizontal_edge_coupler_build(coupler);

    if (show_clamp)
        translate([clip_x + x_shift, 0, 0])
            hub75_reinforcement_dovetail_tube_clamp(
                coupler_base_thickness = coupler.base_thickness,
                part_color = [0.92, 0.20, 0.08, 1]
            );

    if (show_tube)
        translate([
            clip_x + x_shift - tube_length / 2,
            hub75_reinforcement_tube_center_y(),
            hub75_reinforcement_tube_center_z()
        ])
            hub75_reinforcement_aluminium_tube(
                length = tube_length
            );
}
