# Core coupler digital acceptance

This record closes project-plan **Step 2** for the current core HUB75
panel/coupler interfaces. It records what was checked digitally and, equally
important, what is **not** accepted yet.

This is not a replacement for the physical real-panel fit work in Step 3.

## Accepted baseline

Acceptance is against project main commit:

```text
a85c3f31b508a3d761011328768d6ca99f6f3a33
```

with:

- `tool.scad-project` v0.14.9;
- `lib.scad.hub75` v0.1.5;
- SCAD toolchain `ghcr.io/brainboxemb/scad-toolchain-openscad:v0.5.0`.

Production run
[35330842746](https://github.com/brainboxemb/2026-009-01.cad.HUB75-display-frame/actions/runs/35330842746)
is green. Both `prod/bld` and `prod/vrf` publish from that exact commit.

## Family / evidence matrix

| Family | Presets | Focused fit evidence | Additional section evidence | Standalone STL |
| --- | --- | --- | --- | --- |
| middle | small / medium / large | fit detail, rear-fit section | XY seam section | 3 |
| horizontal-edge | small / medium / large | fit detail, rear-fit section | XY seam + YZ outer-edge sections | 3 |
| corner-edge left | small / medium / large | fit detail, rear-fit section | XY side-edge + YZ top-edge sections | 3 |
| corner-edge right | small / medium / large | fit detail, rear-fit section | XY side-edge + YZ top-edge sections | 3 |

The verification publication contains the complete configured set of **51 PNG
targets**. The Build publication contains the **12 core coupler STL files** plus
the separate panel-assembly export.

The current STL files are non-empty and the OpenSCAD/CGAL build log reports the
rendered top-level 3D objects as manifold. No non-manifold / invalid-3D geometry
warning was found in the current production run.

## Datum `+` positions

The engraved `+` is a physical datum, not decoration.

### Middle coupler

The component local origin is:

```text
X = 0   nominal panel seam
Z = 0   middle mounting-hole row
```

The centre-mark geometry draws its cross at that local origin. The middle fit
fixture places the verification datum pin at the same `x=0, z=0` coordinate.

### Horizontal-edge coupler

The component local origin is the intersection of:

```text
X = 0   nominal panel seam
Z = 0   nominal panel outer edge in component-local coordinates
```

The centre-mark source explicitly defines the `+` as the nominal panel-edge /
panel-seam intersection. The fit fixture translates the component to the real
top-edge datum and places the verification pin at that same seam/edge point.

### Corner-edge couplers

The component local origin is the nominal `160 × 320 mm` panel corner. The
centre-mark source places the `+` at that origin. The left/right corner fit
fixtures place the verification datum pin on the exact same nominal corner.

There is therefore no separate presentation offset between the engraved datum
and the mechanical assembly datum in any of the three families.

## Locator-pin clearance

The horizontal-edge and corner-edge couplers derive their locator-pin position
from the pinned HUB75 mating API and use:

```text
panel locator-pin diameter      3.00 mm
coupler radial clearance        0.35 mm
clearance-hole diameter         3.70 mm
```

The corner formula includes the left/right inward direction, so the locator
clearance follows chirality rather than using one hard-coded absolute X
position.

## Corner chirality

The printable corner pair is intentionally:

```text
left variant   -> top-left
right variant  -> top-right

left rotated 180° about Y   -> bottom-right
right rotated 180° about Y  -> bottom-left
```

The full display assembly uses exactly that mapping. Verification publishes
left and right fit/rear/YZ/XY evidence for all three sizes. The two canonical
corner profile orientations are shared because left/right are mirrored at those
interfaces.

## Projection constraint

The project keeps panel-edge coupler projection below 20 mm.

### Corner-edge

The corner component uses:

```text
outside_projection = 19.5 mm
```

and its public constructor asserts:

```text
outside_projection < 20 mm
```

for every preset.

### Horizontal-edge

The outside projection is derived from panel geometry, wall thickness and fit
clearance rather than from a separate fixed limit. With the pinned HUB75 panel:

```text
rear outer edge relative to nominal edge  -1.394 mm

small   wall 2 mm -> 0.856 mm outside nominal edge
medium  wall 4 mm -> 2.856 mm outside nominal edge
large   wall 6 mm -> 4.856 mm outside nominal edge
```

All three remain far below the 20 mm project envelope.

The middle coupler is an internal-seam part and has no outside display-edge
projection.

## Existing digital corrections already incorporated

This acceptance does not reopen work already resolved in merged PRs:

- #14 — panel-derived taper for middle/horizontal mating geometry;
- #23 — straight exposed horizontal-edge guide wall plus thin fit sections;
- #25 — preserved reinforcement-ring support material;
- #26 — panel-derived corner taper, projection verification and complete
  left/right small/medium/large section evidence;
- #31 — alternating panel orientation and updated seam-oriented fit context.

The current production baseline includes all of those corrections.

## Result

No known digital panel-fit blocker remains for the core coupler family.

**Digital acceptance is complete.**

This statement means only that the current model, generated sections, build
outputs and project constraints are internally coherent. It does **not** claim
that printed parts have been accepted on real HUB75 panels.

The next step is project-plan **Step 3 — Physical fit acceptance of the core
couplers**.
