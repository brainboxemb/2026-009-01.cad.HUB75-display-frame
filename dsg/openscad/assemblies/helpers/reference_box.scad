// File: reference_box.scad
//   Simple project debug envelope recovered from the older HUB75 model.

module hub75_reference_box_wireframe(
    x_min,
    x_max,
    y_min,
    y_max,
    z_min,
    z_max,
    line_thickness = 0.6,
    box_color = [0.15, 0.35, 0.85, 0.65]
) {
    dx = x_max - x_min;
    dy = y_max - y_min;
    dz = z_max - z_min;
    t = line_thickness;

    color(box_color) {
        for (y = [y_min, y_max])
            for (z = [z_min, z_max])
                translate([(x_min + x_max) / 2, y, z])
                    cube([dx, t, t], center = true);

        for (x = [x_min, x_max])
            for (y = [y_min, y_max])
                translate([x, y, (z_min + z_max) / 2])
                    cube([t, t, dz], center = true);

        for (x = [x_min, x_max])
            for (z = [z_min, z_max])
                translate([x, (y_min + y_max) / 2, z])
                    cube([t, dy, t], center = true);
    }
}
