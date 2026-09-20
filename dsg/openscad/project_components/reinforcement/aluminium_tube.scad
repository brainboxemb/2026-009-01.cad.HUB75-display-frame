// File: aluminium_tube.scad
//   Project reinforcement tube recovered from the older HUB75 frame.
//
// The old frame established the useful physical choice: a continuous 10 mm
// aluminium tube with a 1 mm wall. Placement remains project-owned.

function hub75_reinforcement_tube_outer_diameter() = 10.0;
function hub75_reinforcement_tube_wall_thickness() = 1.0;

module hub75_reinforcement_aluminium_tube(
    length = 840,
    outer_diameter = hub75_reinforcement_tube_outer_diameter(),
    wall_thickness = hub75_reinforcement_tube_wall_thickness(),
    part_color = [0.72, 0.74, 0.76, 1]
) {
    inner_diameter = outer_diameter - 2 * wall_thickness;

    assert(length > 0, "tube length must be > 0");
    assert(inner_diameter > 0, "tube wall leaves no inner diameter");

    color(part_color)
        rotate([0, 90, 0])
            difference() {
                cylinder(h = length, d = outer_diameter);
                translate([0, 0, -0.1])
                    cylinder(h = length + 0.2, d = inner_diameter);
            }
}
