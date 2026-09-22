// HUB75 STL export orientation helpers.
//
// These transforms belong to the project export/manufacturing boundary.
// Component build modules remain in their normal project coordinate systems.

use <../ext/lib.scad.forge/openscad/transform.scad>


// Place a coupler rear face on the printer bed.
//
// Project mapping:
//   +X -> printer +X
//   +Y -> printer -Z
//   +Z -> printer +Y
//
// rear_y_mm is the project-Y coordinate of the flat rear face. Mapping that
// plane to printer Z=0 makes lower project-Y geometry build upward in +Z.
module hub75_export_rear_face_down(rear_y_mm) {
    assert(rear_y_mm >= 0, "rear_y_mm must be >= 0");

    fg_xf_frame(
        pos_mm = [0, 0, rear_y_mm],
        x_axis = [1, 0, 0],
        y_axis = [0, 0, -1]
    )
        children();
}


// Place the detachable tube clamp on its 12 mm side.
//
// Qualified component-lab mapping:
//   project +X / tube axis -> printer +Z
//   project +Y             -> printer +Y
//   project +Z             -> printer -X
//
// The project clamp is centred on X, so half its width lifts the -X side from
// project X=-width/2 onto printer Z=0.
module hub75_export_clamp_side_down(clamp_width_mm) {
    assert(clamp_width_mm > 0, "clamp_width_mm must be > 0");

    fg_xf_frame(
        pos_mm = [0, 0, clamp_width_mm / 2],
        x_axis = [0, 0, 1],
        y_axis = [0, 1, 0]
    )
        children();
}
