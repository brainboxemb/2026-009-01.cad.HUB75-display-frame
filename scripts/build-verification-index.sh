#!/usr/bin/env bash
set -euo pipefail

OUT_DIR="vrf/out"
mkdir -p "${OUT_DIR}"

cat > "${OUT_DIR}/README.md" <<'EOF'
# HUB75 display-frame verification

Verification evidence is deliberately separate from normal build output.

The build branch answers **what is built**. This verification branch answers
**whether the middle coupler fits the HUB75 panel geometry as intended**.

## Middle coupler

### Rear fit section

This is the primary rear-fit evidence. It follows the useful verification
concept from the earlier project, but is rebuilt from the current two-panel
fixture and current object-based coupler.

The section plane is **5 mm forward from the HUB75 rear mounting plane**.

- grey = real HUB75 rear structural geometry;
- red = only coupler material that penetrates into the same retained volume.

![Rear fit section](middle-coupler/rear-fit-section.png)

### XY seam section

A true XY slice below the horizontal rear crossbar. It shows the panel depth,
vertical seam, seam locator and coupler engagement without the horizontal rib
hiding the interface.

![XY seam section](middle-coupler/xy-seam-section.png)

### Angled fit detail

A cropped two-panel rear context view for checking the complete local assembly,
including mounting holes, reinforcement locators, guide walls and seam locator.

![Angled fit detail](middle-coupler/fit-detail.png)

## Acceptance

These images are verification evidence, not proof of a physical print fit.
After the geometry looks correct here, the standalone coupler STL from the
build branch should be printed and checked against the real panels.
EOF
