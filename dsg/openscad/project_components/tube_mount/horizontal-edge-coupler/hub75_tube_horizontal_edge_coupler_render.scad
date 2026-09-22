// File: hub75_tube_horizontal_edge_coupler_render.scad
//   Design-documentation adapter for the tube-aware horizontal-edge coupler.

use <../../../ext/lib.scad.forge/openscad/resolution.scad>
use <hub75_tube_horizontal_edge_coupler.scad>
use <../tube-clamp/hub75_tube_clamp.scad>
use <../tube_mount_interface.scad>
use <../../../components/aluminium_tube.scad>
use <../../../components/hub75/horizontal-edge-coupler/hub75_horizontal_edge_coupler.scad>
use <../../../assemblies/sub/hub75_tube_horizontal_edge_assembly.scad>


// ----------------------------------------------------------------------
// Public design-review API
// ----------------------------------------------------------------------

module hub75_tube_horizontal_edge_coupler_design(
    view = "final",
    size = "medium"
) {
    coupler =
        hub75_horizontal_edge_coupler_create_for_size(
            size = size
        );
    clamp =
        hub75_tube_clamp_create(
            dovetail =
                hub75_tube_mount_dovetail_create(
                    host_depth_mm = coupler.base_thickness
                )
        );

    if (view == "core") {
        color([0.72, 0.72, 0.72, 1])
            hub75_horizontal_edge_coupler_build(coupler);

    } else if (view == "tube-keepout") {
        color([0.72, 0.72, 0.72, 0.55])
            hub75_horizontal_edge_coupler_build(coupler);
        color([1, 0, 0, 0.55])
            _hub75_tube_horizontal_edge_keepout_cutter(
                coupler,
                clamp
            );

    } else if (view == "carrier-position") {
        color([0.72, 0.72, 0.72, 1])
            hub75_horizontal_edge_coupler_build(coupler);
        _hub75_tube_horizontal_edge_reference_tube(
            coupler,
            clamp
        );
        _hub75_tube_horizontal_edge_position_markers(coupler);

    } else if (view == "carriers") {
        color([0.72, 0.72, 0.72, 1])
            hub75_horizontal_edge_coupler_build(coupler);
        color([1, 0, 0, 0.70])
            _hub75_tube_horizontal_edge_carriers(
                coupler,
                clamp
            );
        _hub75_tube_horizontal_edge_reference_tube(
            coupler,
            clamp,
            alpha = 0.45
        );

    } else if (view == "dovetail") {
        color([0.72, 0.72, 0.72, 0.75])
            union() {
                hub75_horizontal_edge_coupler_build(coupler);
                _hub75_tube_horizontal_edge_carriers(
                coupler,
                clamp
            );
            }
        color([1, 0, 0, 0.55])
            _hub75_tube_horizontal_edge_dovetail_cutters(
                coupler,
                clamp
            );

    } else if (view == "assembled") {
        hub75_tube_horizontal_edge_assembly(
            size = size,
            explode_distance = 10,
            resolution = FG_RES_LOW()
        );

    } else {
        color([0.72, 0.05, 0.04, 1])
            hub75_tube_horizontal_edge_coupler_build(coupler);
        _hub75_tube_horizontal_edge_reference_tube(
            coupler,
            clamp
        );
    }
}


// ----------------------------------------------------------------------
// Private design helpers
// ----------------------------------------------------------------------

module _hub75_tube_horizontal_edge_reference_tube(
    coupler,
    clamp,
    alpha = 0.65
) {
    length = coupler.profile_size + 20;
    tube =
        aluminium_tube_create(
            length_mm = length,
            outer_diameter =
                hub75_tube_clamp_functional_diameter_mm(clamp),
            wall_thickness_mm = 1
        );

    color([0.55, 0.57, 0.60, alpha])
        translate([
            -length / 2,
            hub75_tube_clamp_tube_center_y_mm(clamp),
            hub75_tube_clamp_tube_center_z_mm(clamp)
        ])
            aluminium_tube_build(tube);
}

module _hub75_tube_horizontal_edge_position_markers(coupler) {
    for (clip_x = hub75_tube_horizontal_edge_clamp_positions_mm(coupler))
        color([1, 0, 0, 0.75])
            translate([clip_x - 0.6, -0.4, -12])
                cube([1.2, 0.8, 38]);
}

