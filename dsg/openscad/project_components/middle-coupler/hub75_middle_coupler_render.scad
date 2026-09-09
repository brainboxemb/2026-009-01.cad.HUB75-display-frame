// File: hub75_middle_coupler_render.scad
//   Design-documentation adapter for the project-specific middle coupler.

$fn = 120;

use <hub75_middle_coupler.scad>

// Module: hub75_middle_coupler_design()
// Description:
//   Creates the default medium-sized coupler and renders one named design view.
module hub75_middle_coupler_design(view = "final") {
    coupler = hub75_middle_coupler_create();

    hub75_middle_coupler_render(
        coupler,
        view = view
    );
}

// Direct opening shows the finished component.
hub75_middle_coupler_design();
