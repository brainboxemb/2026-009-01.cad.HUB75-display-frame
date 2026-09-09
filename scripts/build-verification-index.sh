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

The middle coupler joins two adjacent panels at the middle mounting row. Each
small/medium/large size publishes standalone geometry, an angled local fit
view, a rear-facing 5 mm fit section and an XY seam section.

### Horizontal-edge coupler

The horizontal-edge coupler joins the same panel seam at the top/bottom display
edge. The first implementation intentionally has no aluminium-tube clip.

Each small/medium/large size publishes:

- standalone PNG;
- standalone STL;
- angled top-edge fit detail;
- rear-facing 5 mm fit section;
- YZ section through the panel rear end rail.

## Rear fit sections

The section plane is **5 mm forward from the HUB75 rear mounting plane**.

- grey = real HUB75 rear structural geometry;
- red = only coupler material reaching into the same retained volume.

## Acceptance

These images and STLs are digital verification evidence, not proof of a
physical print fit. Production STLs still need a real-panel fit check before a
connector family milestone is considered physically accepted.
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
EOF
