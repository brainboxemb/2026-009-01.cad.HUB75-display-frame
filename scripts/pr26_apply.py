from pathlib import Path


def read(path):
    return Path(path).read_text(encoding="utf-8")


def write(path, text):
    Path(path).write_text(text, encoding="utf-8")


def replace_once(path, old, new):
    text = read(path)
    count = text.count(old)
    if count != 1:
        raise SystemExit(f"{path}: expected one match, found {count}: {old[:80]!r}")
    write(path, text.replace(old, new, 1))


def replace_section(path, start_marker, end_marker, replacement):
    text = read(path)
    start = text.find(start_marker)
    if start < 0:
        raise SystemExit(f"{path}: start marker not found: {start_marker!r}")
    end = text.find(end_marker, start + len(start_marker))
    if end < 0:
        raise SystemExit(f"{path}: end marker not found: {end_marker!r}")
    write(path, text[:start] + replacement.rstrip() + "\n\n" + text[end:])


def append_before(path, marker, insertion):
    text = read(path)
    idx = text.find(marker)
    if idx < 0:
        raise SystemExit(f"{path}: marker not found: {marker!r}")
    write(path, text[:idx] + insertion.rstrip() + "\n\n" + text[idx:])


source = "dsg/openscad/project_components/corner-edge-coupler/hub75_corner_edge_coupler.scad"
render = "dsg/openscad/project_components/corner-edge-coupler/hub75_corner_edge_coupler_render.scad"
design = "dsg/openscad/project_components/corner-edge-coupler/design/design.md"
fixture = "dsg/openscad/assemblies/verification/corner_edge_coupler_fit_assembly.scad"
verify = "scripts/run-verification.sh"
changelog = "CHANGELOG.md"

# ---------------------------------------------------------------------------
# Production source
# ---------------------------------------------------------------------------
replace_once(
    source,
    """        rear_opening_corner_radius =
            hub75_p5_64x32_panel_rear_opening_corner_radius(panel),

        mounting_tube_outer_diameter =""",
    """        rear_opening_corner_radius =
            hub75_p5_64x32_panel_rear_opening_corner_radius(panel),
        panel_taper_depth = hub75_rear_taper_depth(panel),
        panel_rear_outer_inset_x =
            hub75_p5_64x32_panel_rear_outer_inset_x(panel),
        panel_rear_outer_inset_z =
            hub75_p5_64x32_panel_rear_outer_inset_z(panel),

        mounting_tube_outer_diameter =""",
)

append_before(
    source,
    "// ----------------------------------------------------------------------\n// Base and functional cutters\n// ----------------------------------------------------------------------",
    """// ----------------------------------------------------------------------
// Reinforcement support envelope
// ----------------------------------------------------------------------

function hub75_corner_edge_coupler_reinforcement_relief_diameter(coupler) =
    coupler.reinforcement_bushing_outer_diameter
    + 2 * coupler.reinforcement_bushing_clearance;

function hub75_corner_edge_coupler_reinforcement_support_diameter(coupler) =
    hub75_corner_edge_coupler_reinforcement_relief_diameter(coupler)
    + 2 * coupler.wall_thickness;

module _hub75_corner_edge_coupler_reinforcement_support_envelope_2d(coupler) {
    position = hub75_corner_edge_coupler_reinforcement_position(coupler);

    translate(position)
        circle(
            d = hub75_corner_edge_coupler_reinforcement_support_diameter(coupler)
        );
}

module _hub75_corner_edge_coupler_structural_profile_2d(
    coupler,
    outside_radius_override = undef
) {
    union() {
        _hub75_corner_edge_coupler_profile_2d(
            coupler,
            outside_radius_override = outside_radius_override
        );
        _hub75_corner_edge_coupler_reinforcement_support_envelope_2d(coupler);
    }
}""",
)

replace_section(
    source,
    "module _hub75_corner_edge_coupler_base_solid(coupler) {",
    "module _hub75_corner_edge_coupler_through_hole_y_with_relief(",
    """module _hub75_corner_edge_coupler_base_solid(coupler) {
    _hub75_corner_edge_coupler_extrude_xz_y(
        0,
        coupler.base_thickness
    )
        _hub75_corner_edge_coupler_structural_profile_2d(coupler);
}""",
)

replace_section(
    source,
    "module _hub75_corner_edge_coupler_guide_shell_2d(coupler) {",
    "module _hub75_corner_edge_coupler_tall_guide_2d(coupler) {",
    """module _hub75_corner_edge_coupler_guide_shell_2d(coupler) {
    effective_rounding =
        _hub75_corner_edge_coupler_effective_guide_rounding(coupler);

    intersection() {
        difference() {
            _hub75_corner_edge_coupler_structural_profile_2d(coupler);

            offset(delta = coupler.fit_clearance)
                _hub75_corner_edge_coupler_panel_keepout_2d(coupler);
        }

        // This mask can only trim the free ends; it never expands the fitted
        // shell, so the 2 mm small wall cannot be eroded by offset(-r).
        // The reinforcement support envelope remains independent of the
        // cosmetic free-end rounding.
        _hub75_corner_edge_coupler_structural_profile_2d(
            coupler,
            outside_radius_override = effective_rounding
        );
    }
}""",
)

replace_section(
    source,
    "module _hub75_corner_edge_coupler_horizontal_outer_zone_2d(coupler) {",
    "module _hub75_corner_edge_coupler_guide_walls(coupler) {",
    """module _hub75_corner_edge_coupler_horizontal_outer_zone_2d(
    coupler,
    panel_shift_z = 0
) {
    span = 2 * coupler.profile_size + 80;
    boundary =
        coupler.rear_outer_edge_z
        + coupler.fit_clearance
        + panel_shift_z;

    translate([0, boundary + span / 2])
        square([span, span], center = true);
}


module _hub75_corner_edge_coupler_vertical_outer_zone_2d(
    coupler,
    panel_shift_x = 0
) {
    span = 2 * coupler.profile_size + 80;
    boundary =
        coupler.rear_outer_edge_x
        - coupler.x_inward * (coupler.fit_clearance + panel_shift_x);

    if (coupler.side == "left")
        translate([boundary - span / 2, 0])
            square([span, 2 * span], center = true);
    else
        translate([boundary + span / 2, 0])
            square([span, 2 * span], center = true);
}


module _hub75_corner_edge_coupler_horizontal_outer_ridge_2d(
    coupler,
    panel_shift_z = 0
) {
    intersection() {
        _hub75_corner_edge_coupler_guide_shell_2d(coupler);
        _hub75_corner_edge_coupler_horizontal_outer_zone_2d(
            coupler,
            panel_shift_z
        );
    }
}


module _hub75_corner_edge_coupler_vertical_outer_ridge_2d(
    coupler,
    panel_shift_x = 0
) {
    intersection() {
        _hub75_corner_edge_coupler_guide_shell_2d(coupler);
        _hub75_corner_edge_coupler_vertical_outer_zone_2d(
            coupler,
            panel_shift_x
        );
    }
}""",
)

replace_section(
    source,
    "module _hub75_corner_edge_coupler_guide_walls(coupler) {",
    "module _hub75_corner_edge_coupler_outer_ridges(coupler) {",
    """module _hub75_corner_edge_coupler_guide_walls(coupler) {
    reinforcement =
        hub75_corner_edge_coupler_reinforcement_position(coupler);

    difference() {
        _hub75_corner_edge_coupler_extrude_xz_y(
            -coupler.guide_height,
            0
        )
            _hub75_corner_edge_coupler_tall_guide_2d(coupler);

        translate([
            reinforcement[0],
            _HUB75_CORNER_EDGE_COUPLER_EPS,
            reinforcement[1]
        ])
            rotate([90, 0, 0])
                cylinder(
                    d =
                        hub75_corner_edge_coupler_reinforcement_relief_diameter(
                            coupler
                        ),
                    h =
                        coupler.guide_height
                        + 0.30
                );
    }
}""",
)

replace_section(
    source,
    "module _hub75_corner_edge_coupler_outer_ridges(coupler) {",
    "// ----------------------------------------------------------------------\n// Reinforcement locator\n// ----------------------------------------------------------------------",
    """module _hub75_corner_edge_coupler_horizontal_outer_ridge(coupler) {
    ridge_h = coupler.guide_height;
    taper_h = min(ridge_h, coupler.panel_taper_depth);
    taper_shift_z = hub75_panel_taper_shift_at_depth(
        taper_h,
        coupler.panel_taper_depth,
        coupler.panel_rear_outer_inset_z
    );

    union() {
        hull() {
            _hub75_corner_edge_coupler_extrude_xz_y(
                -_HUB75_CORNER_EDGE_COUPLER_EPS,
                _HUB75_CORNER_EDGE_COUPLER_EPS
            )
                _hub75_corner_edge_coupler_horizontal_outer_ridge_2d(
                    coupler,
                    0
                );

            _hub75_corner_edge_coupler_extrude_xz_y(
                -taper_h - _HUB75_CORNER_EDGE_COUPLER_EPS,
                -taper_h + _HUB75_CORNER_EDGE_COUPLER_EPS
            )
                _hub75_corner_edge_coupler_horizontal_outer_ridge_2d(
                    coupler,
                    taper_shift_z
                );
        }

        if (ridge_h > taper_h)
            _hub75_corner_edge_coupler_extrude_xz_y(
                -ridge_h - _HUB75_CORNER_EDGE_COUPLER_EPS,
                -taper_h + _HUB75_CORNER_EDGE_COUPLER_EPS
            )
                _hub75_corner_edge_coupler_horizontal_outer_ridge_2d(
                    coupler,
                    taper_shift_z
                );
    }
}


module _hub75_corner_edge_coupler_vertical_outer_ridge(coupler) {
    ridge_h = coupler.guide_height;
    taper_h = min(ridge_h, coupler.panel_taper_depth);
    taper_shift_x = hub75_panel_taper_shift_at_depth(
        taper_h,
        coupler.panel_taper_depth,
        coupler.panel_rear_outer_inset_x
    );

    union() {
        hull() {
            _hub75_corner_edge_coupler_extrude_xz_y(
                -_HUB75_CORNER_EDGE_COUPLER_EPS,
                _HUB75_CORNER_EDGE_COUPLER_EPS
            )
                _hub75_corner_edge_coupler_vertical_outer_ridge_2d(
                    coupler,
                    0
                );

            _hub75_corner_edge_coupler_extrude_xz_y(
                -taper_h - _HUB75_CORNER_EDGE_COUPLER_EPS,
                -taper_h + _HUB75_CORNER_EDGE_COUPLER_EPS
            )
                _hub75_corner_edge_coupler_vertical_outer_ridge_2d(
                    coupler,
                    taper_shift_x
                );
        }

        if (ridge_h > taper_h)
            _hub75_corner_edge_coupler_extrude_xz_y(
                -ridge_h - _HUB75_CORNER_EDGE_COUPLER_EPS,
                -taper_h + _HUB75_CORNER_EDGE_COUPLER_EPS
            )
                _hub75_corner_edge_coupler_vertical_outer_ridge_2d(
                    coupler,
                    taper_shift_x
                );
    }
}


module _hub75_corner_edge_coupler_outer_ridges(coupler) {
    // Build the two orthogonal ridges independently. Hulling their union would
    // bridge disconnected corner patches with a diagonal sheet.
    // Only the panel-facing edge of each ridge follows the real panel taper;
    // the exposed outside contour stays on the fixed coupler profile.
    union() {
        _hub75_corner_edge_coupler_horizontal_outer_ridge(coupler);
        _hub75_corner_edge_coupler_vertical_outer_ridge(coupler);
    }
}""",
)

# ---------------------------------------------------------------------------
# Design render adapter
# ---------------------------------------------------------------------------
replace_section(
    render,
    "module _hub75_corner_edge_design_raw_guide_shell_2d(coupler) {",
    "module _hub75_corner_edge_design_outer_ridges_2d(coupler) {",
    """module _hub75_corner_edge_design_raw_guide_shell_2d(coupler) {
    difference() {
        _hub75_corner_edge_coupler_structural_profile_2d(coupler);
        offset(delta = coupler.fit_clearance)
            _hub75_corner_edge_coupler_panel_keepout_2d(coupler);
    }
}""",
)

replace_section(
    render,
    "module _hub75_corner_edge_design_outer_ridges_2d(coupler) {",
    "module _hub75_corner_edge_design_reinforcement_relief_cutter(coupler) {",
    """module _hub75_corner_edge_design_outer_ridges_2d(
    coupler,
    panel_shift_x = 0,
    panel_shift_z = 0
) {
    union() {
        _hub75_corner_edge_coupler_horizontal_outer_ridge_2d(
            coupler,
            panel_shift_z
        );
        _hub75_corner_edge_coupler_vertical_outer_ridge_2d(
            coupler,
            panel_shift_x
        );
    }
}

module _hub75_corner_edge_design_straight_outer_ridges(coupler) {
    _hub75_corner_edge_coupler_extrude_xz_y(-coupler.guide_height, 0)
        _hub75_corner_edge_design_outer_ridges_2d(coupler);
}""",
)

replace_once(
    render,
    """    relief_diameter =
        coupler.reinforcement_bushing_outer_diameter
        + 2 * coupler.reinforcement_bushing_clearance;""",
    """    relief_diameter =
        hub75_corner_edge_coupler_reinforcement_relief_diameter(coupler);""",
)

replace_once(
    render,
    """module hub75_corner_edge_coupler_design(view = "final") {
    medium = hub75_corner_edge_coupler_create_for_size(side = "left", size = "medium");
    large = hub75_corner_edge_coupler_create_for_size(side = "left", size = "large");
    right_medium = hub75_corner_edge_coupler_create_for_size(side = "right", size = "medium");
    coupler = view == "locator-pin-clearance" ? large : medium;""",
    """module hub75_corner_edge_coupler_design(view = "final") {
    small = hub75_corner_edge_coupler_create_for_size(side = "left", size = "small");
    medium = hub75_corner_edge_coupler_create_for_size(side = "left", size = "medium");
    large = hub75_corner_edge_coupler_create_for_size(side = "left", size = "large");
    right_medium = hub75_corner_edge_coupler_create_for_size(side = "right", size = "medium");
    coupler =
        view == "locator-pin-clearance"
            ? large
            : view == "reinforcement-support-profile"
                ? small
                : medium;""",
)

replace_once(
    render,
    """    } else if (view == "locator-pin-clearance") {""",
    """    } else if (view == "reinforcement-support-profile") {
        color(existing)
            _hub75_corner_edge_design_thin(-0.42, -0.02)
                _hub75_corner_edge_coupler_profile_2d(coupler);
        color(current)
            _hub75_corner_edge_design_thin(0.02, 0.42)
                difference() {
                    _hub75_corner_edge_coupler_structural_profile_2d(coupler);
                    _hub75_corner_edge_coupler_profile_2d(coupler);
                }

    } else if (view == "locator-pin-clearance") {""",
)

replace_once(
    render,
    """    } else if (view == "guide-reinforcement-relief") {""",
    """    } else if (view == "guide-taper") {
        color(existing_transparent)
            _hub75_corner_edge_design_straight_outer_ridges(coupler);
        color(current)
            _hub75_corner_edge_coupler_outer_ridges(coupler);

    } else if (view == "guide-reinforcement-relief") {""",
)

# ---------------------------------------------------------------------------
# Verification fixture: real 0.10 mm slices
# ---------------------------------------------------------------------------
fixture_text = read(fixture)
marker = "// Module: hub75_corner_edge_coupler_rear_fit_section()"
idx = fixture_text.find(marker)
if idx < 0:
    raise SystemExit(f"{fixture}: rear-fit marker not found")
fixture_prefix = fixture_text[:idx]
fixture_replacement = r'''// Module: hub75_corner_edge_coupler_rear_fit_section()
// Description:
//   Rear-facing 0.10 mm XZ slice through the physical corner. Grey is panel
//   structure; red is coupler material in exactly the same thin section.
module hub75_corner_edge_coupler_rear_fit_section(
    side = "left",
    panel = hub75_p5_64x32_panel_create(),
    coupler = undef,
    depth = 5.0,
    slice_thickness = 0.10,
    crop_inward = 105,
    crop_outward = 10
) {
    active_coupler =
        is_undef(coupler)
            ? hub75_corner_edge_coupler_create(side = side, panel = panel)
            : coupler;

    corner_x = _hub75_corner_edge_fit_corner_x(panel, side);
    corner_z = _hub75_corner_edge_fit_corner_z(panel);
    mounting_y = hub75_p5_64x32_panel_mounting_plane_y(panel);
    section_y = mounting_y - depth;
    x_min = side == "left" ? corner_x - crop_outward : corner_x - crop_inward;
    x_max = side == "left" ? corner_x + crop_inward : corner_x + crop_outward;

    assert(depth > 0, "rear fit section depth must be > 0");
    assert(slice_thickness > 0, "rear fit slice thickness must be > 0");
    assert(
        section_y - slice_thickness / 2 > 0,
        "rear fit slice must remain behind the HUB75 front face"
    );

    module _slice_volume() {
        translate([
            x_min,
            section_y - slice_thickness / 2,
            corner_z - crop_inward
        ])
            cube([
                x_max - x_min,
                slice_thickness,
                crop_inward + crop_outward
            ]);
    }

    color([0.68, 0.68, 0.68, 1])
        intersection() {
            _hub75_corner_edge_fit_panel(panel, structure_only = true);
            _slice_volume();
        }

    color([0.72, 0.05, 0.04, 1])
        intersection() {
            translate([corner_x, mounting_y, corner_z])
                hub75_corner_edge_coupler_build(active_coupler);
            _slice_volume();
        }

    hub75_verification_datum_pin(
        x = corner_x,
        z = corner_z,
        y_min = section_y - 2,
        y_max = section_y + 2
    );
}


// Module: hub75_corner_edge_coupler_yz_top_edge_section()
// Description:
//   0.10 mm YZ slice through the horizontal outside ridge, safely inward from
//   the corner screw/reinforcement feature.
module hub75_corner_edge_coupler_yz_top_edge_section(
    side = "left",
    panel = hub75_p5_64x32_panel_create(),
    coupler = undef,
    slice_inward = 20,
    slice_thickness = 0.10,
    crop_inward = 60,
    crop_outward = 10
) {
    active_coupler =
        is_undef(coupler)
            ? hub75_corner_edge_coupler_create(side = side, panel = panel)
            : coupler;
    corner_x = _hub75_corner_edge_fit_corner_x(panel, side);
    corner_z = _hub75_corner_edge_fit_corner_z(panel);
    mounting_y = hub75_p5_64x32_panel_mounting_plane_y(panel);
    x_inward = side == "left" ? 1 : -1;
    slice_x = corner_x + x_inward * slice_inward;
    y_max = mounting_y + active_coupler.base_thickness + 2;

    assert(slice_thickness > 0, "top-edge slice thickness must be > 0");

    module _slice_volume() {
        translate([
            slice_x - slice_thickness / 2,
            -0.5,
            corner_z - crop_inward
        ])
            cube([
                slice_thickness,
                y_max + 1,
                crop_inward + crop_outward
            ]);
    }

    color([0.68, 0.68, 0.68, 1])
        intersection() {
            _hub75_corner_edge_fit_panel(panel, structure_only = true);
            _slice_volume();
        }

    color([0.72, 0.05, 0.04, 1])
        intersection() {
            translate([corner_x, mounting_y, corner_z])
                hub75_corner_edge_coupler_build(active_coupler);
            _slice_volume();
        }
}


// Module: hub75_corner_edge_coupler_xy_side_edge_section()
// Description:
//   0.10 mm XY slice through the vertical outside ridge, safely inward from the
//   corner screw/reinforcement feature.
module hub75_corner_edge_coupler_xy_side_edge_section(
    side = "left",
    panel = hub75_p5_64x32_panel_create(),
    coupler = undef,
    slice_inward = 20,
    slice_thickness = 0.10,
    crop_inward = 60,
    crop_outward = 10
) {
    active_coupler =
        is_undef(coupler)
            ? hub75_corner_edge_coupler_create(side = side, panel = panel)
            : coupler;
    corner_x = _hub75_corner_edge_fit_corner_x(panel, side);
    corner_z = _hub75_corner_edge_fit_corner_z(panel);
    mounting_y = hub75_p5_64x32_panel_mounting_plane_y(panel);
    slice_z = corner_z - slice_inward;
    y_max = mounting_y + active_coupler.base_thickness + 2;
    x_min = side == "left" ? corner_x - crop_outward : corner_x - crop_inward;
    x_max = side == "left" ? corner_x + crop_inward : corner_x + crop_outward;

    assert(slice_thickness > 0, "side-edge slice thickness must be > 0");

    module _slice_volume() {
        translate([
            x_min,
            -0.5,
            slice_z - slice_thickness / 2
        ])
            cube([
                x_max - x_min,
                y_max + 1,
                slice_thickness
            ]);
    }

    color([0.68, 0.68, 0.68, 1])
        intersection() {
            _hub75_corner_edge_fit_panel(panel, structure_only = true);
            _slice_volume();
        }

    color([0.72, 0.05, 0.04, 1])
        intersection() {
            translate([corner_x, mounting_y, corner_z])
                hub75_corner_edge_coupler_build(active_coupler);
            _slice_volume();
        }
}
'''
write(fixture, fixture_prefix + fixture_replacement)

# Add verification renders to the existing corner matrix.
replace_once(
    verify,
    '''  render_png \\
    "Corner-edge ${side} coupler ${size} rear fit section" \\
    "${size}" \\
    "${ROOT_DIR}/vrf/openscad/corner-edge-coupler-${side}-rear-fit-section.scad" \\
    "${PNG_DIR}/corner-edge-coupler-${side}-${size}-rear-fit-section.png"
}''',
    '''  render_png \\
    "Corner-edge ${side} coupler ${size} rear fit section" \\
    "${size}" \\
    "${ROOT_DIR}/vrf/openscad/corner-edge-coupler-${side}-rear-fit-section.scad" \\
    "${PNG_DIR}/corner-edge-coupler-${side}-${size}-rear-fit-section.png"

  render_png \\
    "Corner-edge ${side} coupler ${size} YZ top-edge section" \\
    "${size}" \\
    "${ROOT_DIR}/vrf/openscad/corner-edge-coupler-${side}-yz-top-edge-section.scad" \\
    "${PNG_DIR}/corner-edge-coupler-${side}-${size}-yz-top-edge-section.png"

  render_png \\
    "Corner-edge ${side} coupler ${size} XY side-edge section" \\
    "${size}" \\
    "${ROOT_DIR}/vrf/openscad/corner-edge-coupler-${side}-xy-side-edge-section.scad" \\
    "${PNG_DIR}/corner-edge-coupler-${side}-${size}-xy-side-edge-section.png"
}''',
)

# Side-specific thin-section entrypoints.
for side in ("left", "right"):
    x_inward = "1" if side == "left" else "-1"
    corner_sign = "-1" if side == "left" else "1"
    yz_vpr = "[0, 90, 0]" if side == "left" else "[0, -90, 0]"
    yz = f'''// YZ top-edge fit section for the top-{side} corner.

use <../../dsg/openscad/assemblies/verification/corner_edge_coupler_fit_assembly.scad>
use <../../dsg/openscad/ext/lib.scad.hub75/openscad/p5-64x32-panel/hub75_p5_64x32_panel.scad>
use <../../dsg/openscad/project_components/corner-edge-coupler/hub75_corner_edge_coupler.scad>

size = "medium";
side = "{side}";

panel = hub75_p5_64x32_panel_create();
coupler = hub75_corner_edge_coupler_create_for_size(side = side, size = size, panel = panel);
corner_x = ({corner_sign}) * hub75_p5_64x32_panel_nominal_width(panel) / 2;
corner_z = hub75_p5_64x32_panel_nominal_height(panel) / 2;
slice_inward = 20;
slice_x = corner_x + ({x_inward}) * slice_inward;

$vpt = [slice_x, 7, corner_z - 20];
$vpr = {yz_vpr};
$vpd = size == "small" ? 145 : size == "large" ? 205 : 170;

hub75_corner_edge_coupler_yz_top_edge_section(
    side = side,
    panel = panel,
    coupler = coupler,
    slice_inward = slice_inward,
    slice_thickness = 0.10
);
'''
    Path(f"vrf/openscad/corner-edge-coupler-{side}-yz-top-edge-section.scad").write_text(yz, encoding="utf-8")

    xy = f'''// XY side-edge fit section for the top-{side} corner.

use <../../dsg/openscad/assemblies/verification/corner_edge_coupler_fit_assembly.scad>
use <../../dsg/openscad/ext/lib.scad.hub75/openscad/p5-64x32-panel/hub75_p5_64x32_panel.scad>
use <../../dsg/openscad/project_components/corner-edge-coupler/hub75_corner_edge_coupler.scad>

size = "medium";
side = "{side}";

panel = hub75_p5_64x32_panel_create();
coupler = hub75_corner_edge_coupler_create_for_size(side = side, size = size, panel = panel);
corner_x = ({corner_sign}) * hub75_p5_64x32_panel_nominal_width(panel) / 2;
corner_z = hub75_p5_64x32_panel_nominal_height(panel) / 2;
slice_inward = 20;
slice_z = corner_z - slice_inward;

$vpt = [corner_x + ({x_inward}) * 20, 7, slice_z];
$vpr = [0, 0, 0];
$vpd = size == "small" ? 150 : size == "large" ? 215 : 180;

hub75_corner_edge_coupler_xy_side_edge_section(
    side = side,
    panel = panel,
    coupler = coupler,
    slice_inward = slice_inward,
    slice_thickness = 0.10
);
'''
    Path(f"vrf/openscad/corner-edge-coupler-{side}-xy-side-edge-section.scad").write_text(xy, encoding="utf-8")

# ---------------------------------------------------------------------------
# Design documentation — heading based, not brittle whole-file matches
# ---------------------------------------------------------------------------
replace_once(
    design,
    """   rounded asymmetric profile
       ↓
   extrude base""",
    """   rounded asymmetric profile
       ↓
   reinforcement support envelope where required
       ↓
   extrude base""",
)
replace_once(
    design,
    """   split inward guide / two outside ridges
       ↓
   reinforcement relief
       ↓
   complete guide system""",
    """   split inward guide / two outside ridges
       ↓
   panel-derived X/Z taper on the two outside ridges
       ↓
   reinforcement support + relief
       ↓
   complete guide system""",
)

replace_section(
    design,
    "## 6. Extrude the profile into the base plate",
    "## 7. Cut the corner screw bore",
    """## 6. Preserve structural material and extrude the base plate

The physical corner reinforcement keeps the same diameter for every family
preset. On the 2 mm small profile, subtracting its required clearance from the
nominal corner shape can otherwise leave less than one configured wall thickness.

The structural profile therefore unions a local support envelope around the
panel-derived reinforcement position:

```text
reinforcement support diameter
    physical bushing outside diameter
  + 2 × reinforcement clearance
  + 2 × wall thickness
```

The image deliberately uses the **small** preset. Gray is the unchanged family
profile; red is only the extra structural footprint required around the physical
reinforcement. Wider presets gain nothing where their existing arm already
contains that envelope.

<!-- scad-render
view: reinforcement-support-profile
vpr: [0, 0, 0]
vpt: [8, 0, -8]
-->

Production exposes and constructs this footprint through:

```scad
hub75_corner_edge_coupler_reinforcement_relief_diameter(coupler)
hub75_corner_edge_coupler_reinforcement_support_diameter(coupler)
_hub75_corner_edge_coupler_reinforcement_support_envelope_2d(coupler)
_hub75_corner_edge_coupler_structural_profile_2d(coupler)
```

That structural profile is extruded from the panel mounting plane toward the
back of the display:

```text
Y = 0
    ↓
Y = base_thickness
```

<!-- scad-render
view: base
-->

The production module is:

```scad
_hub75_corner_edge_coupler_base_solid(coupler)
```

The normal `_hub75_corner_edge_coupler_profile_2d()` remains the family reference
contour used for surface markings. The local structural extension exists only
where the reinforcement clearance requires more load-bearing material.""",
)

replace_section(
    design,
    "## 13. Split the shell into inward guide and outside ridges",
    "## 14. Reserve space around the corner reinforcement",
    """## 13. Split the shell and follow both physical outside tapers

A corner guide crosses two orthogonal physical panel edges. The source therefore
separates:

```text
inside-panel quadrant
    tall fitted guide

outside horizontal zone
    top outside ridge

outside vertical zone
    side outside ridge
```

Gray is the inward guide region. Red is the two rear-plane outside ridge
footprints.

<!-- scad-render
view: guide-zones
vpr: [0, 0, 0]
vpt: [8, 0, -8]
-->

The rear-plane split uses:

```scad
_hub75_corner_edge_coupler_inside_panel_2d(coupler)
_hub75_corner_edge_coupler_tall_guide_2d(coupler)
_hub75_corner_edge_coupler_horizontal_outer_ridge_2d(coupler)
_hub75_corner_edge_coupler_vertical_outer_ridge_2d(coupler)
```

Those rear footprints cannot simply be extruded straight toward the panel front.
The real HUB75 outside faces widen continuously over the physical taper depth.
The horizontal ridge must therefore move only its **panel-facing Z edge**; the
vertical ridge must move only its **panel-facing X edge**. Their exposed outside
coupler contour stays stationary.

Gray in the next image is the old documentation-only straight extrusion. Red is
the actual production geometry with the two panel-facing edges following the
physical X/Z taper.

<!-- scad-render
view: guide-taper
vpr: [68, 0, 35]
vpt: [8, -2, -8]
-->

The panel-derived inputs are:

```scad
coupler.panel_taper_depth
coupler.panel_rear_outer_inset_x
coupler.panel_rear_outer_inset_z
hub75_panel_taper_shift_at_depth(...)
```

Production builds the two ridges **independently**:

```scad
_hub75_corner_edge_coupler_horizontal_outer_ridge(coupler)
_hub75_corner_edge_coupler_vertical_outer_ridge(coupler)
```

and unions them only afterwards in:

```scad
_hub75_corner_edge_coupler_outer_ridges(coupler)
```

That separation is important. An earlier corner experiment hulled disconnected
horizontal and vertical ridge patches together and could create a diagonal sheet
between them. The current construction cannot make that bridge.""",
)

replace_section(
    design,
    "## 14. Reserve space around the corner reinforcement",
    "## 15. Extrude the complete corner guide system",
    """## 14. Preserve a full wall around the corner reinforcement

The reinforcement support envelope introduced in step 6 is also the starting
boundary for the fitted guide shell. The real panel keep-out is still subtracted
first, so the local extension cannot grow back into panel material.

The final circular relief then removes exactly the physical reinforcement plus
print clearance:

```text
inner cleared diameter
    physical reinforcement outside diameter
  + 2 × reinforcement clearance

outer support diameter
    inner cleared diameter
  + 2 × wall thickness
```

This is the same rule as the horizontal-edge family and is not a small-only
special case. If medium or large already contain the support envelope, their
visible contour remains unchanged.

The first image keeps the supported coupler construction visible: gray is the
unrelieved guide; red is the cylindrical material-removal volume.

<!-- scad-render
view: guide-reinforcement-relief
alt: Corner supported guide reinforcement relief construction
-->

The detail image explains the physical reason. Dark gray is the HUB75
reinforcement feature, light gray the supported guide, transparent red the
required clearance band and bright red exactly the guide material that must be
removed.

<!-- scad-render
view: guide-reinforcement-detail
alt: Corner HUB75 reinforcement and supported guide clearance detail
size: [480, 360]
-->

Production uses:

```scad
hub75_corner_edge_coupler_reinforcement_relief_diameter(coupler)
hub75_corner_edge_coupler_reinforcement_support_diameter(coupler)
hub75_corner_edge_coupler_reinforcement_position(coupler)
_hub75_corner_edge_coupler_guide_walls(coupler)
```

The documentation adapter gives the embedded cylindrical subtraction a named
explanatory helper only so the Boolean operation can be shown independently.""",
)

replace_section(
    design,
    "## 15. Extrude the complete corner guide system",
    "## 16. Add the reinforcement pad/pin locator",
    """## 15. Extrude the complete corner guide system

The inward guide is extruded to `guide_height` with the reinforcement relief
removed. The two outside ridges use that same 4 / 6 / 10 mm height, but their
panel-facing X/Z edges follow the continuous physical taper from step 13.

<!-- scad-render
view: guides
-->

Production uses:

```scad
_hub75_corner_edge_coupler_guide_walls(coupler)
_hub75_corner_edge_coupler_outer_ridges(coupler)
```

The latter is a union of two independently tapered ridge solids. It never hulls
the combined horizontal/vertical ridge set.""",
)

# Fit verification and deferred sections exist near the end of the document.
text = read(design)
if "## Fit verification" not in text or "## Deferred" not in text:
    raise SystemExit(f"{design}: expected Fit verification and Deferred headings")
replace_section(
    design,
    "## Fit verification",
    "## Deferred",
    """## Fit verification

Left and right verification entrypoints provide local fit details plus three
true **0.10 mm** slices for every size:

```text
rear-fit XZ slice
    complete corner relationship at the selected insertion depth

YZ top-edge slice
    horizontal ridge against the physical Z taper

XY side-edge slice
    vertical ridge against the physical X taper
```

Each thin slice cuts on both sides of its section plane instead of keeping a
complete half-space. That makes the red/gray mating contours readable even where
the panel outside wall is sloped.

These verification images answer a different question from the construction
walkthrough:

```text
design.md
    How is the corner coupler constructed and why?

verification evidence
    Does that construction fit the authoritative HUB75 geometry in X, Y and Z?
```""",
)

# Replace the whole Deferred section through EOF; it is the final heading.
text = read(design)
idx = text.find("## Deferred")
if idx < 0:
    raise SystemExit(f"{design}: Deferred heading not found")
write(
    design,
    text[:idx]
    + """## Deferred

The aluminium reinforcement tube and corner C-clip remain intentionally deferred.
The panel-fit geometry of the corner body, including both outside-ridge tapers,
is now explicit and independently verifiable before that reinforcement hardware
is introduced.
""",
)

# Changelog entry directly under Unreleased / Changed.
replace_once(
    changelog,
    "## Unreleased\n\n### Changed\n",
    """## Unreleased

### Changed

- Apply the horizontal-edge fit refinements to the corner-edge family: the top
  and side outside ridges now follow the real HUB75 Z/X taper only on their
  panel-facing edges while the exposed coupler contour stays straight; each
  orthogonal ridge is built independently to avoid diagonal bridging.
- Preserve the configured corner guide wall around the panel reinforcement using
  the same clearance-plus-wall support envelope as the horizontal-edge family.
- Replace corner rear-fit half-space views with true 0.10 mm slices and add
  0.10 mm YZ top-edge plus XY side-edge sections for direct verification of both
  orthogonal taper interfaces.
""",
)

# Remove the temporary PR plan and this patch script from the eventual commit.
Path("dsg/openscad/project_components/corner-edge-coupler/design/pr-26-plan.md").unlink(missing_ok=True)
Path(__file__).unlink(missing_ok=True)
