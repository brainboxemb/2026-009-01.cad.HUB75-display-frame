// File: hub75_corner_edge_coupler_render.scad
//   Design-documentation adapter for the corner-edge coupler.

$fn = 120;

use <hub75_corner_edge_coupler.scad>

module hub75_corner_edge_coupler_design(view = "final") {
    coupler =
        hub75_corner_edge_coupler_create_for_size(
            side = "left",
            size = "medium"
        );

    hub75_corner_edge_coupler_render(
        coupler,
        view = view
    );
}

hub75_corner_edge_coupler_design();
