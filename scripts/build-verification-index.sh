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
**whether the middle coupler fits the HUB75 panel geometry as intended**.

## Contents

- [PNG verification gallery](png/README.md)
- [STL verification exports](stl/)

The middle coupler is checked in all three approved project sizes:

- small
- medium
- large

Each size publishes:

- a standalone PNG;
- a standalone STL;
- an angled two-panel fit detail;
- a rear-facing 5 mm fit section;
- an XY seam section.

## Rear fit section

The rear-fit section follows the useful verification concept from the earlier
project, but is rebuilt from the current two-panel fixture and current
object-based coupler.

The section plane is **5 mm forward from the HUB75 rear mounting plane**.

- grey = real HUB75 rear structural geometry;
- red = only coupler material that penetrates into the same retained volume.

## Acceptance

These images and STLs are verification evidence, not proof of a physical print
fit. After the geometry looks correct here, the production STL from the build
branch should still be printed and checked against the real panels.
EOF

cat > "${PNG_DIR}/README.md" <<'EOF'
# Middle-coupler verification renders

All verification renders use unique filenames so small, medium and large can
be compared directly without navigating through separate size directories.

## Small

![Small coupler](middle-coupler-small.png)

![Small rear fit section](middle-coupler-small-rear-fit-section.png)

![Small XY seam section](middle-coupler-small-xy-seam-section.png)

![Small angled fit detail](middle-coupler-small-fit-detail.png)

## Medium

![Medium coupler](middle-coupler-medium.png)

![Medium rear fit section](middle-coupler-medium-rear-fit-section.png)

![Medium XY seam section](middle-coupler-medium-xy-seam-section.png)

![Medium angled fit detail](middle-coupler-medium-fit-detail.png)

## Large

![Large coupler](middle-coupler-large.png)

![Large rear fit section](middle-coupler-large-rear-fit-section.png)

![Large XY seam section](middle-coupler-large-xy-seam-section.png)

![Large angled fit detail](middle-coupler-large-fit-detail.png)
EOF
