# Changelog

This file records the functional evolution of the HUB75 display-frame project.

## Unreleased

### Added

- Split the interactive clamp inspection in `main.scad` into `tube-clamp`
  (raw reusable clamp body only) and `tube-clamp-dov` (the same body plus the
  HUB75 dovetail/foot) so clamp thickness and attachment geometry can be
  dimensioned independently.
- Add a `high_resolution` boolean Customizer switch to `main.scad`, off by
  default for faster interactive work. Enabling it restores the full preview;
  the default low-detail path keeps functional coupler/tube-mount geometry but
  removes decorative reference pockets/marks, lowers circular resolution, and
  uses the HUB75 panel's connector/arrow-free structural view.
- Add a dedicated interactive two-panel tube-mount assembly entrypoint; the
  existing two-panel STL export now delegates to that assembly instead of owning
  a second copy of the assembly call; expose the same assembly from `main.scad`
  as the `two-panel-assembly` interactive view.
- Add released `lib.scad.mechint v0.1.3` as the reusable owner of the
  tube-mount sliding-dovetail profile, clearances, 16 mm female entry slot and
  integral lock/release geometry.
- Update the tube clamp to released `lib.scad.clamps v0.1.7`, using an
  explicit Ø10.0 mm functional bore and Ø9.6 mm tension bore instead of using
  positive clearance to create clamping preload.
- Add focused YZ lock-section verification for the detachable top-entry tube mount.

### Changed

- Pin `lib.scad.mechint v0.1.3` and configure a 0.5 mm straight root land on
  the 12 x 2 mm male/female dovetail. The remaining 1.5 mm of profile depth
  keeps the 30° flank while the root ends on a print-friendlier straight land.
- Trim the integrated clamp body with the library-owned
  `sliding_dovetail_male_relief_cutter()` before unioning the male dovetail,
  so local clamp-transition material no longer fills the male undercut. Add a
  HUB75-local finishing wedge at the relief entrance so the remaining clamp
  shoulder transitions into the male mouth with an approximately 45° chamfer
  instead of a sharp 90° step. The raw `tube-clamp` inspection view remains
  untrimmed; `tube-clamp-dov` shows the integrated relieved part.

- Restore the agreed 2.0 mm dovetail profile and narrow the clamp / male-root
  width to 12 mm. Shift the interface mouth to Y = -1 mm so the same geometry
  fits the existing flat 2 / 3 / 4 mm rear hosts.
- Pin `lib.scad.mechint v0.1.3`, which adds the missing transverse relief when
  locking and `entry_slot_length` are combined, keeping the female tongue
  U-shaped.
- Reduce the canonical clamp transition from 3 mm to 2 mm so the 2 mm dovetail
  sits locally beside the ring instead of reading as a thick backing plate.

- Separate accepted HUB75 panel-facing couplers under `components/hub75/` from
  tube-aware project components under `project_components/tube_mount/`; model
  the horizontal tube mount as a real physical subassembly under
  `assemblies/sub/`.
- Rotate the detachable dovetail from the earlier X/side-entry arrangement to a
  Z-axis interface inserted from local +Z. The reusable mechint profile remains
  12 mm root / 2.0 mm height / 30° with a 16 mm entry slot and integral lock.
- Build horizontal-edge and corner tube-aware couplers in functional order:
  subtract a continuous Ø10 tube keep-out first, then add carrier material and
  cut the female dovetail. The official STL/render entrypoints now use these
  tube-aware components rather than the superseded parallel tube-mount path.
- Derive horizontal/corner clamp carrier locations from the available edge
  structure instead of preserving the earlier unexplained 18 / 25 mm offsets.
- Remove the first-pass long clamp spine. Centre the 16 mm vertical male
  dovetail on the Ø10 tube/ring datum so it overlaps the compact
  `lib.scad.clamps` base directly through the existing 0.01 mm Boolean
  `extra`.
- Derive carrier width from the clearanced female-root width plus 2 mm side
  walls, and limit carrier height to the female channel plus 2 mm bottom/top
  margins. The 16 mm entry approach now continues through free space rather
  than through a tall carrier tunnel.

- Replace the earlier deep tube-mount profile with a project-configured
  `lib.scad.mechint` 12 mm root / 2.0 mm height / 30° sliding dovetail while
  retaining the library's 0.20 mm fit clearance, 0.25 mm axial clearance and
  integral lock/release mechanism.
- Make every tube-mount carrier exactly coplanar with its coupler rear face
  (2 / 3 / 4 mm by profile) and use a 0.8 mm locking tongue plus only the
  required rear-open flex cavity, eliminating the local rearward mounting bump.
- Reduce the canonical Ø10 tube-clamp wall from 2.6 mm to 2.0 mm, narrow the
  clamp from 16 mm to 12 mm and reduce its local transition depth from 5 mm to
  2 mm. The nominal outside ring remains Ø14.0 mm;
  assembly/inspection views use the Ø10.0 mm functional bore while printable
  clamp geometry uses the Ø9.6 mm tension bore.
- Preserve the historical tube centre exactly 7.0 mm in front of the panel rear
  mounting plane by positioning the reusable clamp body from that explicit
  project datum. The datum no longer depends on the clamp library's former
  1 mm base/body overlap shift.
- Replace the HUB75-local female-entry extension cutter with the released
  `lib.scad.mechint v0.1.3` `entry_slot_length` API. The configured 16 mm
  straight entry pocket now combines with the v0.1.2 transverse lock relief, so
  the female spring remains a true U-shaped tongue during top-entry insertion.

### Fixed

- Restore Python-free repository dependency updates on Windows and POSIX by
  routing `update-repo` through the pinned `tool.git-project`; keep SCAD workflow
  ref synchronization in the root wrapper without invoking the Python SCAD CLI.
- Restore the intended alternating five-panel physical orientation: panels 0, 2 and 4 keep the native HUB75 orientation while panels 1 and 3 rotate 180 degrees about Y; focused seam/edge verification now reuses the same project panel-array rule.

Tagged releases summarize reproducible project snapshots. The milestone entries
remain the detailed design history and continue to document geometry decisions,
verification evidence and open physical-fit work.

## v0.0.3

### Changed

- Align the final Migration-005 technical-namespace baseline to released `tool.scad-project v0.14.9`, with exact tool gitlink `a140b22858ac1899e7f2fa71b679639a70d819c3` and matching semantic Production/Release callers.
- Normalize persistent generated-output publication to the canonical technical `bld` / `vrf` namespaces: `dev/pr-N/{bld,vrf}`, `prod/{bld,vrf}` and `rel/vX.Y.Z/{bld,vrf}` while retaining human-facing Build/Verification terminology.
- Requalify the affected rollout PR (`35127778978`) and merged-main Production (`35128211708`) with both normal Build and Verification SCons cache restore/save paths active.
- Keep project geometry, verification content and the existing `lib.scad.hub75 v0.1.5` geometry dependency / exact gitlink `e0432a9533a08a1c0d9e87225c22f3f66b632531` unchanged.

## v0.0.2

### Changed

- Finalize Migration 005 on released `tool.scad-project v0.14.8`, with the committed tool gitlink on exact source `85781a6b21a0f6a06d37be154fd9eb475ecaa2a4` and thin semantic Production/Release callers.
- Retain `lib.scad.hub75 v0.1.5` while qualifying affected production, exact provenance, durable timing evidence, the README-only zero-runtime path and the immutable project-release flow.
- Update the repository tooling baseline to released `tool.scad-project v0.12.0`
  and align the tool gitlink, release workflow and production evidence assertions
  to its exact source commit.
- Update the reusable HUB75 panel dependency from `lib.scad.hub75 v0.1.2` to
  released `v0.1.3`, keeping the frame/coupler geometry unchanged while
  requalifying the complete Build/Verify and publication graph.
- Apply the horizontal-edge fit refinements to the corner-edge family: the top
  and side outside ridges now follow the real HUB75 Z/X taper only on their
  panel-facing edges while the exposed coupler contour stays straight; each
  orthogonal ridge is built independently to avoid diagonal bridging.
- Preserve the configured corner guide wall around the panel reinforcement using
  the same clearance-plus-wall support envelope as the horizontal-edge family.
- Replace corner rear-fit half-space views with true 0.10 mm slices and add
  0.10 mm YZ top-edge plus XY side-edge sections for direct verification of both
  orthogonal taper interfaces.

- Pin the reusable `lib.scad.hub75` dependency to its first immutable release,
  `v0.1.0`, instead of following the moving `main` branch.
- Lock the `dsg/openscad/ext/lib.scad.hub75` gitlink to the exact source commit
  behind `v0.1.0`.
- Upgrade repository tooling from `tool.scad-project` v0.9.11 to v0.9.12 and
  align `project.yml`, the tool gitlink and Build/Verify/Release/PR-cleanup
  workflow callers to the exact v0.9.12 source commit.
- Upgrade the repository tooling again to `tool.scad-project` v0.9.13 so
  verification-only OpenSCAD targets can use dependency-aware SCons selection
  with a cache that is separate from normal Build output.
- Move fit/section verification renders under the reusable verification target
  engine at 1280 x 720 and stop duplicating normal standalone PNG/STL build
  products into `vrf`; project scripts now retain only cheap smoke/index checks.
- Defer generic branch, pull-request and publication workflow guidance to the
  pinned `tools/tool.scad-project/AGENTS.md`; keep the root `AGENTS.md` focused
  on HUB75 display-frame project-specific policy.
- Preserve the configured horizontal-edge guide wall around panel reinforcement
  clearances by locally expanding the structural profile from the real bushing
  clearance plus `wall_thickness`; wider presets remain unchanged wherever the
  existing T already contains that support envelope.

## v0.0.1

### Added

- First versioned development release of the restarted HUB75 display-frame project.
- Reproducible release bundles, checksum manifest and immutable browseable build
  and verification snapshots through the coordinated project Release workflow.

### Changed

- Upgrade the project tooling baseline to `tool.scad-project` v0.9.8 and SCAD
  toolchain v0.4.1.
- Keep the semantic tool dependency as `v0.9.8` in `project.yml`, pin the tool
  gitlink to the corresponding commit, and pin Build, Verify and Release reusable
  workflows to that exact 40-character commit SHA.
- Synchronize the repository updater scripts with the v0.9.8 tool release so
  future dependency upgrades update Build, Verify and Release together using
  exact workflow commit pins.

### Release scope

- Captures the current five-panel assembly plus the middle, horizontal-edge and
  left/right corner-edge connector families in small, medium and large presets.
- Includes generated design documentation, normal PNG/STL build output and the
  dedicated fit/section verification evidence already described by Milestones 1–5.
- This release records the current **digitally verified development state**. It is
  not physical print-fit acceptance: connector geometry, especially the
  horizontal-edge fit, can still be refined against real panels before the
  reinforcement tube and clip system is introduced.

## Milestone 5 — Panel-derived coupler mating taper

### Fixed

- Horizontal-edge outer guide now keeps a constant cross-section and follows the
  real HUB75 Z taper instead of shrinking by an arbitrary 0.35 mm.
- Middle and horizontal-edge seam locators now derive their width at insertion
  depth from the real HUB75 X taper instead of a fixed 0.20 mm-per-side lead-in.

### Clarified

- Middle main rib guides deliberately remain straight: their bay/crossbar mating
  boundaries are vertical in Y, while side-rail widening and seam narrowing cancel
  in the combined keep-out width.
- Corner-edge taper correction is deferred to a separate change because its outer
  geometry must be checked together with the project-wide <20 mm projection limit.

### Verification

- Small, medium and large middle XY seam/rear-fit views and horizontal YZ/rear-fit
  views pass functional verification against the pinned HUB75 panel model.
- Digital fit evidence remains separate from physical print acceptance.

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
