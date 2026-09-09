// File: verification_datum_pin.scad
//   Shared visual datum aid for connector fit verification.
//
// The pin is verification geometry only. It is never referenced by production
// render/export entrypoints and therefore cannot become part of a printable STL.
//
// The cylinder axis is Y, normal to the HUB75 panel plane. X/Z identify the
// engraved + datum of the connector being verified.

module hub75_verification_datum_pin(
    x = 0,
    z = 0,
    y_min = -4,
    y_max = 26,
    diameter = 2.0
) {
    assert(y_max > y_min, "verification datum pin span must be positive");
    assert(diameter > 0, "verification datum pin diameter must be > 0");

    color([0.10, 0.40, 0.95, 1.0])
        translate([x, y_max, z])
            rotate([90, 0, 0])
                cylinder(
                    h = y_max - y_min,
                    d = diameter,
                    $fn = 64
                );
}
