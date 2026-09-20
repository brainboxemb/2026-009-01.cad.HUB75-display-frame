// File: tube_mount_interface.scad
//   HUB75 adapter around the reusable lib.scad.mechint sliding dovetail.
//
// Project coordinates:
//   X = aluminium-tube axis;
//   Y = panel front -> rear, with the coupler mounting plane at Y = 0;
//   Z = local display-edge outward direction.
//
// lib.scad.mechint owns the profile, fit, entry slot and lock. HUB75 rotates
// that native interface so the clamp inserts from +Z. The dovetail mouth is
// deliberately 1.5 mm in front of the mounting plane. This shifts the complete
// detachable clamp 0.5 mm toward the panel front so the Ø10 tube starts 1.0 mm
// behind the panel front face. Consumers may cut the female directly into
// existing front-side structure (as the horizontal edge does) or provide local
// carrier material where needed (as the corner variants do). The lock tongue
// uses all remaining host thickness behind the female channel, so the rear face
// stays flat and no print-hostile back cavity is introduced.

use <../../ext/lib.scad.mechint/openscad/sliding-dovetail/sliding_dovetail.scad>
use <../../ext/lib.scad.hub75/openscad/p5-64x32-panel/hub75_p5_64x32_panel.scad>

_HUB75_TUBE_MOUNT_FRONT_OFFSET = 1.0;
_HUB75_TUBE_MOUNT_DOVETAIL_WIDTH = 12;
_HUB75_TUBE_MOUNT_DOVETAIL_HEIGHT = 2.0;
_HUB75_TUBE_MOUNT_DOVETAIL_ANGLE = 30;
_HUB75_TUBE_MOUNT_DOVETAIL_MOUTH_LAND_DEPTH = 0.5;
_HUB75_TUBE_MOUNT_DOVETAIL_ROOT_LAND_DEPTH = 0.5;
_HUB75_TUBE_MOUNT_DOVETAIL_CLEARANCE = 0.20;
_HUB75_TUBE_MOUNT_DOVETAIL_AXIAL_CLEARANCE = 0.25;
_HUB75_TUBE_MOUNT_DOVETAIL_ENTRY_SLOT_LENGTH = 16;
_HUB75_TUBE_MOUNT_DOVETAIL_MOUTH_Y = -1.5;
_HUB75_TUBE_MOUNT_LOCK_MIN_SPRING_THICKNESS = 0.8;

function hub75_tube_mount_tube_front_offset() =
    _HUB75_TUBE_MOUNT_FRONT_OFFSET;

function hub75_tube_mount_tube_center_y(
    tube_diameter = 10,
    panel = hub75_p5_64x32_panel_create()
) =
    hub75_tube_mount_tube_front_offset()
    + tube_diameter / 2
    - hub75_p5_64x32_panel_mounting_plane_y(panel);

function hub75_tube_mount_dovetail_mouth_y() =
    _HUB75_TUBE_MOUNT_DOVETAIL_MOUTH_Y;

function hub75_tube_mount_dovetail_channel_roof_y() =
    _HUB75_TUBE_MOUNT_DOVETAIL_MOUTH_Y
    + _HUB75_TUBE_MOUNT_DOVETAIL_HEIGHT
    + _HUB75_TUBE_MOUNT_DOVETAIL_CLEARANCE;

function hub75_tube_mount_dovetail_min_host_depth() =
    hub75_tube_mount_dovetail_channel_roof_y()
    + _HUB75_TUBE_MOUNT_LOCK_MIN_SPRING_THICKNESS;

function hub75_tube_mount_lock_spring_thickness(host_depth) =
    host_depth
    - hub75_tube_mount_dovetail_channel_roof_y();

function hub75_tube_mount_dovetail_create(
    host_depth = hub75_tube_mount_dovetail_min_host_depth(),
    entry_slot_length = _HUB75_TUBE_MOUNT_DOVETAIL_ENTRY_SLOT_LENGTH
) =
    let(
        spring_thickness =
            hub75_tube_mount_lock_spring_thickness(host_depth)
    )
    assert(
        spring_thickness >= _HUB75_TUBE_MOUNT_LOCK_MIN_SPRING_THICKNESS,
        "tube-mount dovetail host leaves too little material for the lock tongue"
    )
    sliding_dovetail_create(
        width = _HUB75_TUBE_MOUNT_DOVETAIL_WIDTH,
        height = _HUB75_TUBE_MOUNT_DOVETAIL_HEIGHT,
        angle = _HUB75_TUBE_MOUNT_DOVETAIL_ANGLE,
        root_land_depth =
            _HUB75_TUBE_MOUNT_DOVETAIL_ROOT_LAND_DEPTH,
        mouth_land_depth =
            _HUB75_TUBE_MOUNT_DOVETAIL_MOUTH_LAND_DEPTH,
        clearance = _HUB75_TUBE_MOUNT_DOVETAIL_CLEARANCE,
        axial_clearance = _HUB75_TUBE_MOUNT_DOVETAIL_AXIAL_CLEARANCE,
        entry_slot_length = entry_slot_length,
        locking = true,
        lock_spring_thickness = spring_thickness,
        lock_cut_back_clearance = false,
        lock_back_clearance = 0
    );

function hub75_tube_mount_dovetail_angle(dovetail) =
    dovetail.angle;

function hub75_tube_mount_dovetail_mouth_land_depth(dovetail) =
    sliding_dovetail_mouth_land_depth(dovetail);

function hub75_tube_mount_dovetail_root_land_depth(dovetail) =
    sliding_dovetail_root_land_depth(dovetail);

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

module hub75_tube_mount_dovetail_male_relief_cutter(
    dovetail,
    slide,
    relief_width,
    center_x = 0,
    center_z = 0
) {
    _hub75_tube_mount_dovetail_to_project(
        center_x = center_x,
        center_z = center_z
    )
        sliding_dovetail_male_relief_cutter(
            dovetail,
            slide = slide,
            relief_width = relief_width
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
    // Native X becomes project -Z, native Y remains project Y with its mouth
    // at -1.5 mm, and native Z becomes project X.
    multmatrix([
        [ 0, 0, 1, center_x],
        [ 0, 1, 0, _HUB75_TUBE_MOUNT_DOVETAIL_MOUTH_Y],
        [-1, 0, 0, center_z],
        [ 0, 0, 0, 1]
    ])
        children();
}
