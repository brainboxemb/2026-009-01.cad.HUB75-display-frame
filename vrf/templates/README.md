# HUB75 display-frame verification

Verification evidence is deliberately separate from normal build output.

The build branch answers **what is built**. This verification branch answers
**whether the current connector-family geometry fits the HUB75 panel model as
intended**.

## Contents

- [PNG verification gallery](png/README.md)
- [STL verification exports](stl/)

## Components

### Middle coupler

Joins two adjacent panels at the middle mounting row. Each small/medium/large
size publishes standalone geometry, an angled local fit view, a size-aware
rear fit section and an XY seam section.

### Horizontal-edge coupler

Joins the same panel seam at the top/bottom display edge. The first
implementation intentionally has no aluminium-tube clip.

Each small/medium/large size publishes standalone geometry, an angled top-edge
fit detail, a size-aware rear fit section, a YZ end-rail profile and an
orthogonal XY seam profile through the vertical arm.

### Corner-edge couplers

The corner family has two printable parts:

- left = top-left and, after 180 degree rotation, bottom-right;
- right = top-right and, after 180 degree rotation, bottom-left.

Each side and size publishes:

- standalone PNG;
- standalone STL;
- angled one-panel corner fit detail;
- size-aware rear fit section through the rounded rear corner opening;
- a 0.10 mm YZ top-edge technical slice;
- a 0.10 mm XY side-edge technical slice.

In addition, each size publishes two canonical readable profile sections shared
by left/right because the two interfaces are mirrored equivalents:

- horizontal profile section through the top arm;
- vertical profile section through the side arm.

These canonical 0.50 mm profile sections retain the complete panel profile with
the red corner coupler around it, matching the presentation style used for the
horizontal-edge profile sections.

The first corner milestone intentionally has no aluminium-tube clip.

## Rear fit sections

The section plane is kept inside the active guide: **3 mm** for the small
4 mm guide and **5 mm** for medium/large.

- grey = real HUB75 rear structural geometry;
- red = only coupler material reaching into the same retained volume;
- blue = Ø2 verification datum pin through the connector's engraved `+`,
  normal to the panel plane.

## Acceptance

These images and STLs are digital verification evidence, not proof of a
physical print fit. Production STLs still need a real-panel fit check before a
connector-family milestone is considered physically accepted.
