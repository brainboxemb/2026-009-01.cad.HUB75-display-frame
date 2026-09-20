// File: dovetail_interface.scad
//   Shared tube-mount dovetail contract.
//
// Nominal male interface:
//   maximum/root width = 10 mm
//   mouth width        = 8 mm
//   profile depth      = 3 mm
//
// The female side derives its clearance from this same object. This keeps the
// clamp and every tube-mount coupler on one explicit interface definition.

function hub75_tube_mount_dovetail_create(
    root_width = 10.0,
    mouth_width = 8.0,
    depth = 3.0,
    fit_clearance = 0.20,
    axial_clearance = 0.25
) =
    assert(root_width > mouth_width,
        "dovetail root width must exceed mouth width")
    assert(mouth_width > 0,
        "dovetail mouth width must be > 0")
    assert(depth > 0,
        "dovetail depth must be > 0")
    assert(fit_clearance >= 0,
        "dovetail fit clearance must be >= 0")
    assert(axial_clearance >= 0,
        "dovetail axial clearance must be >= 0")
    object(
        root_width = root_width,
        mouth_width = mouth_width,
        depth = depth,
        fit_clearance = fit_clearance,
        axial_clearance = axial_clearance
    );

function hub75_tube_mount_dovetail_flank_angle(dovetail) =
    atan(
        (dovetail.root_width - dovetail.mouth_width)
        / (2 * dovetail.depth)
    );
