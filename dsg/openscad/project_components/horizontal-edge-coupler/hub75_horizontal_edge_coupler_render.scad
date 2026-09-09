// File: hub75_horizontal_edge_coupler_render.scad
//   Design-documentation adapter for the horizontal-edge coupler.

$fn = 120;

use <hub75_horizontal_edge_coupler.scad>

module hub75_horizontal_edge_coupler_design(view = "final") {
    coupler =
        hub75_horizontal_edge_coupler_create_for_size(
            size = "medium"
        );

    hub75_horizontal_edge_coupler_render(
        coupler,
        view = view
    );
}

hub75_horizontal_edge_coupler_design();
