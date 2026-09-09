# 2026-009-01.cad.HUB75-display-frame

Structured OpenSCAD project for a modular HUB75 display frame using reusable
libraries, design documentation and automated verification.

This repository is a clean restart of the display-frame design. It deliberately
does not copy the old frame/coupler implementation. Complexity is added only
after each smaller assembly is understood and verified.

## Preview

### Front angled

[![Front angled view](../../raw/build/png/front-angled.png)](../../blob/build/png/front-angled.png)

### Rear angled

[![Rear angled view](../../raw/build/png/rear-angled.png)](../../blob/build/png/rear-angled.png)

These images are generated from the current `build` branch.

## Quick links

- [Changelog](CHANGELOG.md)
- [Generated build branch](../../tree/build)
- [Build overview](../../blob/build/README.md)
- [Build provenance](../../blob/build/publication-info.txt)
- [Generated design documentation](../../blob/build/design/README.md)
- [Middle coupler design source](dsg/openscad/project_components/middle-coupler/design/design.md)
- [Horizontal-edge coupler design source](dsg/openscad/project_components/horizontal-edge-coupler/design/design.md)
- [Generated middle coupler design](../../blob/build/design/project/openscad/project_components/middle-coupler/design/design.md)
- [Generated horizontal-edge coupler design](../../blob/build/design/project/openscad/project_components/horizontal-edge-coupler/design/design.md)
- [Verification branch](../../tree/verification)
- [Verification overview](../../blob/verification/README.md)
- [Verification PNG gallery](../../blob/verification/png/README.md)
- [Middle medium rear fit section](../../blob/verification/png/middle-coupler-medium-rear-fit-section.png)
- [Horizontal-edge medium fit detail](../../blob/verification/png/horizontal-edge-coupler-medium-fit-detail.png)
- [Horizontal-edge medium rear fit section](../../blob/verification/png/horizontal-edge-coupler-medium-rear-fit-section.png)
- [PNG renders](../../tree/build/png)
- [Five-panel STL](../../blob/build/stl/panels-assembly.stl)
- [Connector STLs](../../tree/build/stl)

## Current milestone

### Milestone 1 — five-panel assembly

The five-panel portrait assembly is established and build-verified.

The display uses five P5 64x32 panels in **portrait orientation**, side by side:

```text
one panel
    nominal 160 mm wide x 320 mm high
    32 x 64 pixels in portrait orientation

five panels
    nominal 800 mm wide x 320 mm high
    160 x 64 pixels total
```

Expressed height-first, this is the intended **320 x 800 mm / 64 x 160 pixel**
display.

No panel is rotated 90 degrees by this project. The reusable library already
models the panel in portrait orientation.

### Milestone 2 — middle coupler core

The first project-specific frame component is now the **middle coupler** joining
two adjacent panels at their vertical seam.

This first version intentionally contains functional geometry only:

```text
80 mm PLUS base
two seam-side mounting holes
two shallow mounting-tube pockets
raised fitted guides around the rear rib cross
two reinforcement pad/pin locators
tapered seam locator
Ø3 blind reference pockets
centre + and 5/10 mm distance ticks
```

The old medium profile supplies only the printable starting values:

```text
profile size        80 mm
wall thickness       4 mm
guide height         6 mm
base thickness       3 mm
fit clearance     0.25 mm per side
```

Panel-dependent dimensions come from the public `lib.scad.hub75` mating API.

The rounded component form is now captured directly in the current source from
the approved v120 design reference. The old repository is not a geometry
authority for this component.

The component defaults to `render_fn = 192`. Resolution is stored in the
coupler object and enforced inside its public build/render modules. This avoids
OpenSCAD's `use <...>` behaviour dropping a top-level `$fn` assignment during
STL export. Screw holes, pockets, rounded offsets and the hand-built PLUS arcs
therefore all use the same high-resolution tessellation.

Current derived default values include:

```text
horizontal PLUS arm   28.482 mm
vertical PLUS arm     33.800 mm
screw centres         -8 / +8 mm
rear seam gap          2.795 mm
seam locator width     2.295 mm
reinforcement pad       Ø9.4 x 2.4 mm
reinforcement pin       Ø2.1 x 2.0 mm
reference pockets       Ø3.0, max 2.0 mm blind, final 0.5 mm taper to Ø2.0
reference tick pitch      5 mm minor / 10 mm major
centre reference +        6.0 mm
```

The component, detail design documentation, two-panel fit render, true XY fit
section and standalone STL all build successfully. The fit is **not yet treated
as physically approved** until the generated evidence or a print has been
checked.

### Milestone 3 — horizontal-edge coupler core

The second connector-family member is the **horizontal-edge coupler**. It joins
the same vertical panel seam where it reaches the top or bottom display edge.

The first version intentionally has **no aluminium-tube clip**. The T-shaped
body and HUB75 fit are verified as a separate step before the reinforcement
system is introduced.

The component keeps the same family language as the middle coupler:

```text
rounded T base
same small / medium / large presets
two seam-side mounting holes
anti-elephant-foot screw relief
shallow mounting-tube pockets
fitted guide around the rear end/seam rails
two reinforcement pad/pin locators
tapered seam locator
low tapered outer-edge ridge
Ø3 blind reference pockets with Ø3 -> Ø2 tapered bottoms
centre + at the nominal panel edge
5/10 mm distance ticks
```

Its local reference system deliberately puts the nominal **320 mm panel edge at
Z=0**. The engraved `+` therefore identifies the real seam/edge datum rather
than merely decorating the part. The ticks and pocket pattern make differences
between the T proportions of small, medium and large immediately visible.

The same printable connector is used at the top and bottom edge by rotating it
180 degrees.

## Dimension authority

Panel geometry and dimensions come from:

```text
lib.scad.hub75
└── openscad/p5-64x32-panel/hub75_p5_64x32_panel.scad
```

The physical panel is slightly undersized relative to its placement cell:

```text
physical
    159.70 x 319.71 mm

nominal placement cell
    160.00 x 320.00 mm
```

Assembly placement therefore uses the library's nominal accessors:

```text
hub75_p5_64x32_panel_nominal_width()
hub75_p5_64x32_panel_nominal_height()
```

The project does not duplicate 160/320 mm panel constants in its own
configuration.

## Project origin

The project uses the physical front face of the HUB75 panels as its Y datum:

```text
X = 0
    horizontal centre of the complete five-panel display

Y = 0
    front face of the HUB75 panels

Z = 0
    vertical centre of the panels
```

With the current 14.50 mm panel depth:

```text
front face          Y =  0.00 mm
rear mounting plane Y = 14.50 mm
```

This deliberately matches the native coordinate convention of
`lib.scad.hub75`. The panel is not symmetric front-to-rear, so the physical
front face is a clearer and more stable datum than the geometric midpoint of
its depth.

The five panel placement centres are:

```text
X = -320, -160, 0, +160, +320 mm
Z = 0
```

Future frame/coupler geometry should reference explicit mechanical datums such
as the front face and rear mounting plane instead of assuming symmetry in Y.

## OpenSCAD naming

Private implementation helpers use a leading `_`, including nested helpers.
Only the small cross-file project interface remains without an underscore. This
follows the same convention as BOSL2 and the reusable SCAD libraries.

## Structure

```text
project.yml
dsg/
└── openscad/
    ├── assemblies/
    │   ├── panels_assembly.scad
    │   ├── middle_coupler_fit_assembly.scad
    │   └── horizontal_edge_coupler_fit_assembly.scad
    ├── project_components/
    │   ├── middle-coupler/
    │   │   ├── hub75_middle_coupler.scad
    │   │   ├── hub75_middle_coupler_render.scad
    │   │   └── design/design.md
    │   └── horizontal-edge-coupler/
    │       ├── hub75_horizontal_edge_coupler.scad
    │       ├── hub75_horizontal_edge_coupler_render.scad
    │       └── design/design.md
    ├── ext/
    │   └── lib.scad.hub75
    ├── render/
    │   ├── front.scad
    │   ├── front-angled.scad
    │   ├── rear.scad
    │   ├── rear-angled.scad
    │   ├── middle-coupler.scad
    │   └── horizontal-edge-coupler.scad
    ├── export/
    │   ├── panels-assembly.scad
    │   ├── middle-coupler.scad
    │   └── horizontal-edge-coupler.scad
    └── main.scad

tools/
└── tool.scad-project

vrf/
└── openscad/
    ├── middle-coupler-fit-detail.scad
    ├── middle-coupler-rear-fit-section.scad
    ├── middle-coupler-xy-seam-section.scad
    ├── horizontal-edge-coupler-fit-detail.scad
    ├── horizontal-edge-coupler-rear-fit-section.scad
    └── horizontal-edge-coupler-yz-edge-section.scad
```

## Tooling

The project pins:

```text
tool.scad-project v0.7.1
docker.scad-toolchain v0.4.0 (through the reusable workflow)
lib.scad.hub75 main, locked by the project gitlink
```

The four configured full-display PNG renders use 2560x1440. Complete-display
presentation uses the library's `light_gray` colour scheme explicitly, rather
than the dark/original material colours used by the low-level panel
`build()` API.

They deliberately reuse the official camera views from the old HUB75
display-frame project:

```text
front         [90, 0,   0]  distance 1200
front angled  [85, 0,  40]  distance 1050
rear          [90, 0, 180]  distance 1200
rear angled   [85, 0, 220]  distance 1050
```

They use the generic watermark path:

```text
© 2026 brainboxemb
```

The same assembly is also exported as `bld/stl/panels-assembly.stl`. This STL
is a verification model: it lets the complete five-panel arrangement be opened
in a 3D viewer and freely rotated/zoomed.

The normal build contains size-specific renders for both current connector
family members:

```text
bld/png/middle-coupler-<size>.png
bld/png/horizontal-edge-coupler-<size>.png
```

Fit evidence is intentionally published on the separate `verification` branch:

```text
png/middle-coupler-<size>-fit-detail.png
png/middle-coupler-<size>-rear-fit-section.png
png/middle-coupler-<size>-xy-seam-section.png

png/horizontal-edge-coupler-<size>-fit-detail.png
png/horizontal-edge-coupler-<size>-rear-fit-section.png
png/horizontal-edge-coupler-<size>-yz-edge-section.png
```

Rear-fit sections are cut inside the active guide: 3 mm for the 4 mm small
guide and 5 mm for medium/large. This keeps the same 5 mm reference where
possible while ensuring the small preset still shows meaningful fit evidence.

The build also contains one STL per connector and size:

```text
bld/stl/middle-coupler-<size>.stl
bld/stl/horizontal-edge-coupler-<size>.stl
```

The generated design walkthrough is published separately under the build
branch's `design/` tree.

Generated files are published to the mutable `build` branch and are not stored
on `main`.

## Local setup

After cloning:

```powershell
.\bootstrap.ps1
```

Then a local configured build can be run with:

```powershell
.\tools\tool.scad-project\scad-project.ps1 build
```

Open the development entrypoint in OpenSCAD:

```text
dsg/openscad/main.scad
```

## Next design step

Inspect the horizontal-edge evidence before expanding the family:

1. compare small, medium and large T proportions using the visible 5/10 mm marks;
2. inspect the angled two-panel top-edge fit view;
3. inspect the size-aware rear fit section;
4. inspect the YZ section through the rear end rail;
5. rotate/zoom the standalone STL;
6. preferably print the middle and horizontal-edge core parts against real panels.

After the T body is accepted, the next connector-family work is the left/right
corner geometry. The aluminium reinforcement tube and clips remain a separate
follow-up so panel-fit errors cannot be confused with tube-system geometry.

The model and documentation were developed with the assistance of ChatGPT.
