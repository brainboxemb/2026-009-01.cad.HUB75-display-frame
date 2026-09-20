// File: tube_mount_interface.scad
//   HUB75 adapter around the reusable lib.scad.mechint sliding dovetail.
//
// Project coordinates:
//   X = aluminium-tube axis;
//   Y = panel front -> rear, with the coupler mounting plane at Y = 0;
//   Z = local display-edge outward direction.
//
// lib.scad.mechint owns the profile, fit, entry slot and lock.  HUB75 only
// rotates that native interface so the clamp inserts from +Z (from above in
// the canonical top-edge orientation).

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

// Native mechint X becomes project -Z. Native -X entry therefore becomes
// project +Z entry. Native profile depth Y remains project Y and native profile
// width Z becomes project X.


// ----------------------------------------------------------------------
// Public geometry API
// ----------------------------------------------------------------------

module hub75_tube_mount_dovetail_male_build(
    dovetail,
    slide,
    center_x = 0,
    center_z = 0
) {
    _hub75_tube_mount_dovetail_to_project(
        center_x = center_x,
        center_z = center_z
    )
        sliding_dovetail_male_build(
            dovetail,
            slide = slide
        );
}

module hub75_tube_mount_dovetail_female_cutter(
    dovetail,
    slide,
    center_x = 0,
    center_z = 0
) {
    _hub75_tube_mount_dovetail_to_project(
        center_x = center_x,
        center_z = center_z
    )
        sliding_dovetail_female_cutter(
            dovetail,
            slide = slide
        );
}


// ----------------------------------------------------------------------
// Private coordinate transform
// ----------------------------------------------------------------------

module _hub75_tube_mount_dovetail_to_project(
    center_x = 0,
    center_z = 0
) {
    multmatrix([
        [ 0, 0, 1, center_x],
        [ 0, 1, 0, 0],
        [-1, 0, 0, center_z],
        [ 0, 0, 0, 1]
    ])
        children();
}

