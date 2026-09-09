# Changelog

This file records the functional evolution of the HUB75 display-frame project.

The project is currently developed in **milestones** rather than tagged
releases. Until version tags are introduced, changes are grouped by milestone.
When tagged releases start, these milestone entries can remain as the design
history and new entries can be grouped by version.

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

### Changed

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
  - rear-facing 5 mm fit section;
  - XY seam section.
- Generated evidence remains separate from normal build output on the
  `verification` branch.

### Status

The geometry is digitally verified against the reusable HUB75 panel model.
Physical print fit is still to be checked before expanding the coupler family
with horizontal-edge and corner components.

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
