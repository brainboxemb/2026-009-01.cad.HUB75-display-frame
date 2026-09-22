// File: hub75_tube_corner_edge_assembly.scad
//   Physical subassembly: tube-aware corner-edge coupler, detachable top-entry
//   clamp and a short Ø10 aluminium tube.

use <../../components/aluminium_tube.scad>
use <../../ext/lib.scad.forge/openscad/resolution.scad>
use <../../components/hub75/corner-edge-coupler/hub75_corner_edge_coupler.scad>
use <../../project_components/tube_mount/corner-edge-coupler/hub75_tube_corner_edge_coupler.scad>
use <../../project_components/tube_mount/tube-clamp/hub75_tube_clamp.scad>
use <../../project_components/tube_mount/tube_mount_interface.scad>

module hub75_tube_corner_edge_assembly(
    side = "left",
    size = "medium",
    coupler = undef,
    show_coupler = true,
    show_clamps = true,
    show_tube = true,
    explode_distance = 0,
    resolution = FG_RES_HIGH()
) {
    active_coupler =
        is_undef(coupler)
            ? hub75_corner_edge_coupler_create_for_size(
                side = side,
                size = size
            )
            : coupler;
    clamp =
        hub75_tube_clamp_create(
            dovetail =
                hub75_tube_mount_dovetail_create(
                    host_depth_mm = active_coupler.base_thickness
                )
        );
    clip_x =
        hub75_tube_corner_edge_clamp_x_mm(
            active_coupler
        );
    tube_length =
        active_coupler.profile_size
        + 2 * active_coupler.outside_projection
        + 20;
    tube =
        aluminium_tube_create(
            length_mm = tube_length,
            outer_diameter =
                hub75_tube_clamp_functional_diameter_mm(clamp),
            wall_thickness_mm = 1
        );
    clamp_z_shift = max(0, explode_distance);
    tube_z_shift = 0.65 * max(0, explode_distance);

    if (show_coupler)
        color([0.72, 0.05, 0.04, 1])
            hub75_tube_corner_edge_coupler_build(
                active_coupler,
                resolution = resolution
            );

    if (show_clamps)
        translate([clip_x, 0, clamp_z_shift])
            hub75_tube_clamp_build(
                clamp,
                part_color = [0.92, 0.20, 0.08, 1],
                use_tension_bore = false,
                resolution = resolution
            );

    if (show_tube)
        color([0.72, 0.74, 0.76, 1])
            translate([
                -tube_length / 2,
                hub75_tube_clamp_tube_center_y_mm(clamp),
                hub75_tube_clamp_tube_center_z_mm(clamp)
                    + tube_z_shift
            ])
                aluminium_tube_build(tube, resolution = resolution);
}
