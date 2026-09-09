#!/usr/bin/env bash
set -euo pipefail

OUT_DIR="vrf/out"
PNG_DIR="${OUT_DIR}/png"
STL_DIR="${OUT_DIR}/stl"

mkdir -p "${PNG_DIR}" "${STL_DIR}"

cat > "${OUT_DIR}/README.md" <<'EOF'
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
fit detail, a size-aware rear fit section and a YZ end-rail section.

### Corner-edge couplers

The corner family has two printable parts:

- left = top-left and, after 180 degree rotation, bottom-right;
- right = top-right and, after 180 degree rotation, bottom-left.

Each side and size publishes:

- standalone PNG;
- standalone STL;
- angled one-panel corner fit detail;
- size-aware rear fit section through the rounded rear corner opening.

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
EOF

cat > "${PNG_DIR}/README.md" <<'EOF'
# Connector verification renders

All verification renders use unique filenames so component and size variants
can be compared directly without navigating through separate directories.

# Middle coupler

## Small

![Middle small](middle-coupler-small.png)

![Middle small rear fit](middle-coupler-small-rear-fit-section.png)

![Middle small XY seam](middle-coupler-small-xy-seam-section.png)

![Middle small angled fit](middle-coupler-small-fit-detail.png)

## Medium

![Middle medium](middle-coupler-medium.png)

![Middle medium rear fit](middle-coupler-medium-rear-fit-section.png)

![Middle medium XY seam](middle-coupler-medium-xy-seam-section.png)

![Middle medium angled fit](middle-coupler-medium-fit-detail.png)

## Large

![Middle large](middle-coupler-large.png)

![Middle large rear fit](middle-coupler-large-rear-fit-section.png)

![Middle large XY seam](middle-coupler-large-xy-seam-section.png)

![Middle large angled fit](middle-coupler-large-fit-detail.png)

# Horizontal-edge coupler

## Small

![Horizontal edge small](horizontal-edge-coupler-small.png)

![Horizontal edge small rear fit](horizontal-edge-coupler-small-rear-fit-section.png)

![Horizontal edge small YZ section](horizontal-edge-coupler-small-yz-edge-section.png)

![Horizontal edge small angled fit](horizontal-edge-coupler-small-fit-detail.png)

## Medium

![Horizontal edge medium](horizontal-edge-coupler-medium.png)

![Horizontal edge medium rear fit](horizontal-edge-coupler-medium-rear-fit-section.png)

![Horizontal edge medium YZ section](horizontal-edge-coupler-medium-yz-edge-section.png)

![Horizontal edge medium angled fit](horizontal-edge-coupler-medium-fit-detail.png)

## Large

![Horizontal edge large](horizontal-edge-coupler-large.png)

![Horizontal edge large rear fit](horizontal-edge-coupler-large-rear-fit-section.png)

![Horizontal edge large YZ section](horizontal-edge-coupler-large-yz-edge-section.png)

![Horizontal edge large angled fit](horizontal-edge-coupler-large-fit-detail.png)

# Corner-edge couplers

## Small left

![Corner left small](corner-edge-coupler-left-small.png)

![Corner left small rear fit](corner-edge-coupler-left-small-rear-fit-section.png)

![Corner left small angled fit](corner-edge-coupler-left-small-fit-detail.png)

## Small right

![Corner right small](corner-edge-coupler-right-small.png)

![Corner right small rear fit](corner-edge-coupler-right-small-rear-fit-section.png)

![Corner right small angled fit](corner-edge-coupler-right-small-fit-detail.png)

## Medium left

![Corner left medium](corner-edge-coupler-left-medium.png)

![Corner left medium rear fit](corner-edge-coupler-left-medium-rear-fit-section.png)

![Corner left medium angled fit](corner-edge-coupler-left-medium-fit-detail.png)

## Medium right

![Corner right medium](corner-edge-coupler-right-medium.png)

![Corner right medium rear fit](corner-edge-coupler-right-medium-rear-fit-section.png)

![Corner right medium angled fit](corner-edge-coupler-right-medium-fit-detail.png)

## Large left

![Corner left large](corner-edge-coupler-left-large.png)

![Corner left large rear fit](corner-edge-coupler-left-large-rear-fit-section.png)

![Corner left large angled fit](corner-edge-coupler-left-large-fit-detail.png)

## Large right

![Corner right large](corner-edge-coupler-right-large.png)

![Corner right large rear fit](corner-edge-coupler-right-large-rear-fit-section.png)

![Corner right large angled fit](corner-edge-coupler-right-large-fit-detail.png)
EOF
