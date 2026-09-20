// File: dovetail_tube_clamp_fit_assembly.scad
//   Focused tube-mount fixture: one horizontal-edge tube-mount coupler,
//   the canonical detachable clamp and a short Ø10 aluminium tube.

use <../../components/aluminium_tube.scad>
use <../../project_components/horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>
use <../../project_components/tube_mount/tube_mount_couplers.scad>
use <../../project_components/tube_mount/dovetail_tube_clamp.scad>

module hub75_dovetail_tube_clamp_fit_assembly(
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
    clamp =
        hub75_dovetail_tube_clamp_create();
    clip_x =
        hub75_tube_mount_clip_offset(coupler.profile_size);
    tube_length = 58;
    slide_shift = max(0, explode_distance);
    tube_z_shift = 0.65 * max(0, explode_distance);
    tube =
        aluminium_tube_create(
            length = tube_length,
            outer_diameter = clamp.base_clamp.tube_diameter,
            wall_thickness = 1,
            render_fn = clamp.render_fn
        );

    if (show_coupler)
        color([0.72, 0.05, 0.04, 1])
            hub75_horizontal_edge_tube_mount_coupler_build(coupler);

    if (show_clamp)
        translate([clip_x + slide_shift, 0, 0])
            hub75_dovetail_tube_clamp_build(
                clamp,
                part_color = [0.92, 0.20, 0.08, 1]
            );

    if (show_tube)
        color([0.72, 0.74, 0.76, 1])
            translate([
                clip_x + slide_shift - tube_length / 2,
                hub75_dovetail_tube_clamp_tube_center_y(clamp),
                hub75_dovetail_tube_clamp_tube_center_z(clamp)
                    + tube_z_shift
            ])
                aluminium_tube_build(tube);
}
