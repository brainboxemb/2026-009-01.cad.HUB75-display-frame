# Changelog

This file records the functional evolution of the HUB75 display-frame project.

The project is currently developed in **milestones** rather than tagged
releases. Until version tags are introduced, changes are grouped by milestone.
When tagged releases start, these milestone entries can remain as the design
history and new entries can be grouped by version.

## Milestone 4 — Corner edge coupler core

### Added

- One parametrised corner-edge coupler component with left and right printable
  variants.
- Top-left / bottom-right mapping from the left part and top-right /
  bottom-left mapping from the right part by 180 degree rotation.
- Nominal 160 x 320 mm panel-corner datum at the component origin.
- Rounded asymmetric corner-cross base using the same small, medium and large
  family presets.
- Single corner mounting hole with shallow anti-elephant-foot relief.
- Shallow mounting-tube pocket.
- Automatic clearance for the physical diagonal Ø3 locator pin on the left /
  bottom-right chirality.
- Fitted guide around the real rounded HUB75 rear corner.
- One reinforcement pad/pin locator at the corner reinforcement circle.
- Same print-friendly tapered Ø3 reference pockets and 5/10 mm reference marks.
- Dedicated one-panel left/right corner fit fixtures and size-aware rear-fit
  sections.
- PNG and STL evidence for left/right × small/medium/large.
- Shared blue Ø2 verification datum pin through the engraved `+` for middle,
  horizontal-edge and corner fit views.
- Complete five-panel rear-angled presentation assembly with all current medium
  middle, horizontal-edge and corner couplers placed on their established
  panel datums.
- Dedicated `rear-angled-couplers.png` build render for direct comparison with
  the existing panel-only rear-angled overview.

### Fixed

- Removed an invalid corner outer-guide taper construction that could bridge
  disconnected ridge patches with a large diagonal sheet.
- Horizontal-edge and corner outside guides now use the same `guide_height`
  as every other guide instead of an undocumented fixed 4 mm height.

### Changed

- Removed the independent corner `outer_ridge_height` parameter; corner guide
  height is controlled only by the family `guide_height` preset.
- Corner outside-guide shape remains straight until tube/clip geometry is
  introduced; height remains fully consistent at 4 / 6 / 10 mm.
- Verification documentation now distinguishes grey panel geometry, red
  coupler geometry and the blue nominal-datum pin.
- The project now pins `tool.scad-project v0.9.1`.
- Normal build output now includes the generic generated `png/README.md`
  gallery, matching the browseable verification PNG gallery pattern.

### Status

The left/right corner core is digitally build- and fit-verified against the
reusable HUB75 panel model. The first corner milestone intentionally excludes
the aluminium reinforcement tube and clips. Physical print fit is still
required before the connector family is treated as physically accepted.

## Milestone 3 — Horizontal edge coupler core

### Added

- Project-specific object-based horizontal-edge coupler using the same
  connector-family dimensions and surface language as the middle coupler.
- Rounded T-shaped base positioned from the real HUB75 rear end rail and the
  nominal 320 mm panel-edge datum.
- Small, medium and large presets matching the middle-coupler family.
- Seam-side screw holes with the same shallow anti-elephant-foot relief.
- Shallow panel mounting-tube pockets.
- Public HUB75 locator-pin mating accessors and automatic locator-pin
  clearance where the selected T profile reaches the physical pin.
- Fitted raised guide around the real rear end rail / seam-rail geometry.
- Tapered outer-edge guide using the same 4 / 6 / 10 mm family guide height,
  without tube clips.
- Reinforcement pad/pin locators for the two edge-row reinforcement circles.
- Tapered seam locator extending inward from the nominal display edge.
- Same print-friendly Ø3 reference pockets with the final 0.5 mm tapered to
  Ø2 mm.
- Centre `+` at the nominal panel edge and 5/10 mm reference ticks.
- Dedicated two-panel top-edge fit fixture.
- Horizontal-edge verification views for angled fit, rear fit section and YZ
  end-rail section.
- PNG and STL evidence for small, medium and large.

### Changed

- Outer-edge guide height now follows the same `guide_height` preset as every
  other guide; the earlier implicit 4 mm coupling to seam-locator height was
  removed.
- Rear-fit verification depth is size-aware: 3 mm for the 4 mm small guide and
  5 mm for medium/large, so every preset produces meaningful guide evidence.
- Verification gallery now groups both middle and horizontal-edge connector
  evidence while retaining flat unique filenames.

### Status

The horizontal-edge T body is digitally build- and fit-verified against the
reusable HUB75 panel model. The first version intentionally excludes the
aluminium reinforcement tube and clips. Physical print fit is still to be
checked before the connector family is treated as physically accepted.

## Milestone 2 — Middle coupler core

### Added

- Project-specific object-based middle-coupler component for joining two
  adjacent HUB75 panels at their vertical seam.
- Rounded PLUS-shaped base derived from the approved v120 design reference.
- Seam-side mounting holes and shallow mounting-tube pockets.
- Raised fitted guides around the HUB75 rear rib cross.
- Tapered seam locator.
- Reinforcement locator pads and pins that enter the panel reinforcement
  circles.
- Blind Ø3 mm reference pockets.
- Centre  reference mark and 5/10 mm distance ticks.
- Dedicated two-panel fit assembly for controlled coupler inspection.
- Verification views for angled fit, rear fit section and XY seam section.
- Small, medium and large coupler presets:
  - small: 60 mm profile, 2 mm wall, 4 mm guide, 2 mm base;
  - medium: 80 mm profile, 4 mm wall, 6 mm guide, 3 mm base;
  - large: 100 mm profile, 6 mm wall, 10 mm guide, 4 mm base.
- PNG and STL verification evidence for all three coupler sizes.

### Fixed

- Preserve the complete raised guide wall in the 2 mm small preset by limiting guide-end rounding to the available wall thickness.
- Verification renders now auto-fit each size so the large coupler remains fully visible.

### Changed

- Blind Ø3 mm reference pockets now keep a straight Ø3 section and taper only
  over the final 0.5 mm to a Ø2 mm bottom for friendlier printing.
- Reference pockets are 0.5 mm shallower in their straight section and now keep
  at least 0.7 mm of material behind the pocket; the small preset therefore
  uses 1.3 mm total depth instead of approaching a through-hole.
- Restored the original shallow screw-hole anti-elephant-foot relief:
  0.20 mm deep and 0.40 mm radial widening at both base-plate faces.
- Verification output uses flat `png/` and `stl/` directories with unique size-qualified filenames for easier comparison.
- Verification now publishes a dedicated PNG gallery at `png/README.md`.

- Normal OpenSCAD renders and exports are now discovered from
  `dsg/openscad/render` and `dsg/openscad/export` instead of being listed
  individually in `project.yml`.
- `render.yml` and `export.yml` profiles define special build behaviour such
  as the `multi-size` coupler builds.
- Profile-specific PNG `image_size` is supported by the project tooling.
- The project now pins `tool.scad-project v0.7.1`.
- Complete HUB75 panel assembly renders use the explicit `light_gray` panel
  colour scheme.

### Verification

- The middle coupler is build-verified in small, medium and large sizes.
- Each size publishes:
  - standalone PNG;
  - standalone STL;
  - angled two-panel fit detail;
  - size-aware rear fit section;
  - XY seam section.
- Generated evidence remains separate from normal build output on the
  `verification` branch.

### Status

The geometry is digitally verified against the reusable HUB75 panel model.
Physical print fit is still to be checked. The horizontal-edge family member
is developed separately in Milestone 3.

## Milestone 1 — Five-panel assembly

### Added

- Clean restart of the HUB75 display-frame project.
- Reusable `lib.scad.hub75` integration as the panel geometry authority.
- Five P5 64x32 panels arranged in portrait orientation, side by side.
- Nominal complete display size of 800 x 320 mm with 160 x 64 pixels.
- Project coordinate system aligned with the physical front face of the HUB75
  panels.
- Front, front-angled, rear and rear-angled render entrypoints.
- Five-panel assembly STL for free inspection in a 3D viewer.
- Generated build and verification branches.
- Automated design documentation and build provenance.

### Status

The five-panel arrangement, orientation, nominal spacing and project coordinate
system are established and build-verified.
