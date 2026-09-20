// File: dovetail_interface.scad
//   HUB75 adapter around the reusable lib.scad.mechint sliding dovetail.
//
// The consumer uses the released library defaults for the mechanical profile:
//   root width        = 10 mm
//   profile height    = 3 mm
//   flank angle       = 20 degrees
//   fit clearance     = 0.20 mm
//   axial clearance   = 0.25 mm
//
// Integral locking and screwdriver release are enabled through the same shared
// interface object. Project code owns only placement/orientation and the short
// entry extension needed to open the groove through the rounded mount lobe.

use <../../ext/lib.scad.mechint/openscad/sliding-dovetail/sliding_dovetail.scad>

function hub75_tube_mount_dovetail_create() =
    sliding_dovetail_create(
        locking = true
    );

function hub75_tube_mount_dovetail_mouth_width(dovetail) =
    sliding_dovetail_mouth_width(dovetail);

function hub75_tube_mount_dovetail_female_height(dovetail) =
    sliding_dovetail_female_height(dovetail);

function hub75_tube_mount_dovetail_female_slide(
    dovetail,
    slide
) =
    sliding_dovetail_female_slide(
        dovetail,
        slide
    );

function _hub75_tube_mount_plain_dovetail(dovetail) =
    sliding_dovetail_create(
        width = dovetail.width,
        height = dovetail.height,
        angle = dovetail.angle,
        clearance = dovetail.clearance,
        axial_clearance = 0,
        extra = dovetail.extra,
        locking = false
    );

module hub75_tube_mount_dovetail_male_build(
    dovetail,
    slide,
    center_z = 0,
    entry_side = -1
) {
    assert(
        entry_side == -1 || entry_side == 1,
        "entry_side must be -1 or +1"
    );

    translate([0, 0, center_z])
        if (entry_side == -1)
            sliding_dovetail_male_build(
                dovetail,
                slide = slide
            );
        else
            mirror([1, 0, 0])
                sliding_dovetail_male_build(
                    dovetail,
                    slide = slide
                );
}

module _hub75_tube_mount_native_female_cutter(
    dovetail,
    slide,
    entry_extension
) {
    sliding_dovetail_female_cutter(
        dovetail,
        slide = slide
    );

    if (entry_extension > 0) {
        plain_dovetail =
            _hub75_tube_mount_plain_dovetail(
                dovetail
            );
        nominal_entry_x =
            -hub75_tube_mount_dovetail_female_slide(
                dovetail,
                slide
            ) / 2;

        translate([
            nominal_entry_x - entry_extension / 2,
            0,
            0
        ])
            sliding_dovetail_female_cutter(
                plain_dovetail,
                slide = entry_extension
            );
    }
}

module hub75_tube_mount_dovetail_female_cutter(
    dovetail,
    slide,
    center_x = 0,
    center_z = 0,
    entry_side = -1,
    entry_extension = 0
) {
    assert(
        entry_side == -1 || entry_side == 1,
        "entry_side must be -1 or +1"
    );
    assert(
        entry_extension >= 0,
        "entry_extension must be >= 0"
    );

    translate([center_x, 0, center_z])
        if (entry_side == -1)
            _hub75_tube_mount_native_female_cutter(
                dovetail,
                slide,
                entry_extension
            );
        else
            mirror([1, 0, 0])
                _hub75_tube_mount_native_female_cutter(
                    dovetail,
                    slide,
                    entry_extension
                );
}
