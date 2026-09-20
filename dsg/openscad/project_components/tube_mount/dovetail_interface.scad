// File: dovetail_interface.scad
//   HUB75 adapter around the reusable lib.scad.mechint sliding dovetail.
//
// The reusable library owns the dovetail and integral lock mechanism. HUB75
// configures a deliberately wide, shallow profile so the tube-mount carrier can
// remain flush with the existing 2 / 3 / 4 mm coupler rear faces:
//   root width        = 14 mm
//   profile height    = 1.0 mm
//   flank angle       = 30 degrees
//   fit clearance     = 0.20 mm
//   axial clearance   = 0.25 mm
//   spring tongue     = 0.8 mm
//
// The host-depth parameter only controls how much optional cavity is cut behind
// that 0.8 mm tongue. It does not change the male mating profile.

use <../../ext/lib.scad.mechint/openscad/sliding-dovetail/sliding_dovetail.scad>

_HUB75_TUBE_MOUNT_DOVETAIL_WIDTH = 14;
_HUB75_TUBE_MOUNT_DOVETAIL_HEIGHT = 1.0;
_HUB75_TUBE_MOUNT_DOVETAIL_ANGLE = 30;
_HUB75_TUBE_MOUNT_DOVETAIL_CLEARANCE = 0.20;
_HUB75_TUBE_MOUNT_DOVETAIL_AXIAL_CLEARANCE = 0.25;
_HUB75_TUBE_MOUNT_LOCK_SPRING_THICKNESS = 0.8;

function hub75_tube_mount_dovetail_min_host_depth() =
    _HUB75_TUBE_MOUNT_DOVETAIL_HEIGHT
    + _HUB75_TUBE_MOUNT_DOVETAIL_CLEARANCE
    + _HUB75_TUBE_MOUNT_LOCK_SPRING_THICKNESS;

function hub75_tube_mount_dovetail_create(
    host_depth = hub75_tube_mount_dovetail_min_host_depth()
) =
    let(
        back_clearance =
            host_depth
            - hub75_tube_mount_dovetail_min_host_depth(),
        cut_back_clearance = back_clearance > 0
    )
    assert(
        host_depth >= hub75_tube_mount_dovetail_min_host_depth(),
        "tube-mount dovetail host is too shallow"
    )
    assert(
        !cut_back_clearance || back_clearance >= 0.5,
        "tube-mount lock back clearance must be 0 or at least threshold height"
    )
    sliding_dovetail_create(
        width = _HUB75_TUBE_MOUNT_DOVETAIL_WIDTH,
        height = _HUB75_TUBE_MOUNT_DOVETAIL_HEIGHT,
        angle = _HUB75_TUBE_MOUNT_DOVETAIL_ANGLE,
        clearance = _HUB75_TUBE_MOUNT_DOVETAIL_CLEARANCE,
        axial_clearance = _HUB75_TUBE_MOUNT_DOVETAIL_AXIAL_CLEARANCE,
        locking = true,
        lock_spring_thickness =
            _HUB75_TUBE_MOUNT_LOCK_SPRING_THICKNESS,
        lock_cut_back_clearance = cut_back_clearance,
        lock_back_clearance = back_clearance
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
