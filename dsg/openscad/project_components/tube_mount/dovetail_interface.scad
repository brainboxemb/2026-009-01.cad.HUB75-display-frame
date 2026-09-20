// File: dovetail_interface.scad
//   HUB75 adapter around the reusable lib.scad.mechint sliding dovetail.
//
// The reusable library owns the dovetail, female entry slot and integral lock.
// HUB75 configures a deliberately wide, shallow profile so the tube-mount
// carrier can remain flush with the existing 2 / 3 / 4 mm coupler rear faces:
//   root width        = 14 mm
//   profile height    = 1.0 mm
//   flank angle       = 30 degrees
//   fit clearance     = 0.20 mm
//   axial clearance   = 0.25 mm
//   female entry slot = 16 mm
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
_HUB75_TUBE_MOUNT_DOVETAIL_ENTRY_SLOT_LENGTH = 16;
_HUB75_TUBE_MOUNT_LOCK_SPRING_THICKNESS = 0.8;

function hub75_tube_mount_dovetail_min_host_depth() =
    _HUB75_TUBE_MOUNT_DOVETAIL_HEIGHT
    + _HUB75_TUBE_MOUNT_DOVETAIL_CLEARANCE
    + _HUB75_TUBE_MOUNT_LOCK_SPRING_THICKNESS;

function hub75_tube_mount_dovetail_create(
    host_depth = hub75_tube_mount_dovetail_min_host_depth(),
    entry_slot_length = _HUB75_TUBE_MOUNT_DOVETAIL_ENTRY_SLOT_LENGTH
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
        entry_slot_length = entry_slot_length,
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

function hub75_tube_mount_dovetail_female_root_width(dovetail) =
    sliding_dovetail_female_root_width(dovetail);

function hub75_tube_mount_dovetail_female_slide(
    dovetail,
    slide
) =
    sliding_dovetail_female_slide(
        dovetail,
        slide
    );

function hub75_tube_mount_dovetail_entry_slot_length(dovetail) =
    sliding_dovetail_entry_slot_length(dovetail);

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

module hub75_tube_mount_dovetail_female_cutter(
    dovetail,
    slide,
    center_x = 0,
    center_z = 0,
    entry_side = -1
) {
    assert(
        entry_side == -1 || entry_side == 1,
        "entry_side must be -1 or +1"
    );

    translate([center_x, 0, center_z])
        if (entry_side == -1)
            sliding_dovetail_female_cutter(
                dovetail,
                slide = slide
            );
        else
            mirror([1, 0, 0])
                sliding_dovetail_female_cutter(
                    dovetail,
                    slide = slide
                );
}
