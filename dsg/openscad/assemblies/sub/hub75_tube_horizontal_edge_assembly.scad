// File: hub75_tube_horizontal_edge_assembly.scad
//   Physical subassembly: tube-aware horizontal-edge coupler, two detachable
//   top-entry clamps and a short Ø10 aluminium tube.

use <../../components/aluminium_tube.scad>
use <../../components/hub75/horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>
use <../../project_components/tube_mount/horizontal-edge-coupler/hub75_tube_horizontal_edge_coupler.scad>
use <../../project_components/tube_mount/tube-clamp/hub75_tube_clamp.scad>
use <../../project_components/tube_mount/tube_mount_interface.scad>

module hub75_tube_horizontal_edge_assembly(
    size = "medium",
    show_coupler = true,
    show_clamps = true,
    show_tube = true,
    explode_distance = 0,
    clamp_high_resolution = true
) {
    coupler =
        hub75_horizontal_edge_coupler_create_for_size(
            size = size
        );
    clamp =
        hub75_tube_clamp_create(
            dovetail =
                hub75_tube_mount_dovetail_create(
                    host_depth = coupler.base_thickness
                )
        );
    tube_length = coupler.profile_size + 20;
    tube =
        aluminium_tube_create(
            length = tube_length,
            outer_diameter =
                hub75_tube_clamp_functional_diameter(clamp),
            wall_thickness = 1,
            render_fn = 120
        );
    clamp_z_shift = max(0, explode_distance);
    tube_z_shift = 0.65 * max(0, explode_distance);

    if (show_coupler)
        color([0.72, 0.05, 0.04, 1])
            hub75_tube_horizontal_edge_coupler_build(coupler);

    if (show_clamps)
        for (clip_x = hub75_tube_horizontal_edge_clamp_positions(coupler))
            translate([clip_x, 0, clamp_z_shift])
                hub75_tube_clamp_build(
                    clamp,
                    part_color = [0.92, 0.20, 0.08, 1],
                    use_tension_bore = false,
                    high_resolution = clamp_high_resolution
                );

    if (show_tube)
        color([0.72, 0.74, 0.76, 1])
            translate([
                -tube_length / 2,
                hub75_tube_clamp_tube_center_y(clamp),
                hub75_tube_clamp_tube_center_z(clamp)
                    + tube_z_shift
            ])
                aluminium_tube_build(tube);
}
