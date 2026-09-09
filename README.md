# 2026-009-01.cad.HUB75-display-frame

Structured OpenSCAD project for a modular HUB75 display frame using reusable
libraries, design documentation and automated verification.

This repository is a clean restart of the display-frame design. It deliberately
does not copy the old frame/coupler implementation. Complexity is added only
after each smaller assembly is understood and verified.

## Quick links

- [Generated build branch](../../tree/build)
- [Build overview](../../blob/build/README.md)
- [Build provenance](../../blob/build/publication-info.txt)
- [Generated design documentation](../../blob/build/design/README.md)
- [Middle coupler design source](dsg/openscad/project_components/middle-coupler/design/design.md)
- [Generated middle coupler design](../../blob/build/design/project/openscad/project_components/middle-coupler/design/design.md)
- [Verification branch](../../tree/verification)
- [Verification overview](../../blob/verification/README.md)
- [Rear fit section](../../blob/verification/middle-coupler/rear-fit-section.png)
- [XY seam section](../../blob/verification/middle-coupler/xy-seam-section.png)
- [PNG renders](../../tree/build/png)
- [Five-panel STL](../../blob/build/stl/panels-assembly.stl)
- [Middle coupler STL](../../blob/build/stl/middle-coupler.stl)

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
```

The component, detail design documentation, two-panel fit render, true XY fit
section and standalone STL all build successfully. The fit is **not yet treated
as physically approved** until the generated evidence or a print has been
checked.

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
    │   └── middle_coupler_fit_assembly.scad
    ├── project_components/
    │   └── middle-coupler/
    │       ├── hub75_middle_coupler.scad
    │       ├── hub75_middle_coupler_render.scad
    │       └── design/
    │           └── design.md
    ├── ext/
    │   └── lib.scad.hub75
    ├── render/
    │   ├── front.scad
    │   ├── front-angled.scad
    │   ├── rear.scad
    │   ├── rear-angled.scad
    │   ├── middle-coupler.scad
    │   ├── middle-coupler-fit.scad
    │   └── middle-coupler-fit-section.scad
    ├── export/
    │   ├── panels-assembly.scad
    │   └── middle-coupler.scad
    └── main.scad

tools/
└── tool.scad-project
```

## Tooling

The project pins:

```text
tool.scad-project v0.6.1
docker.scad-toolchain v0.4.0 (through the reusable workflow)
lib.scad.hub75 main, locked by the project gitlink
```

The four configured full-display PNG renders use 2560x1440 and deliberately
reuse the official camera views from the old HUB75 display-frame project:

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

The normal build contains only the component render:

```text
bld/png/middle-coupler.png
```

Fit evidence is intentionally published on the separate `verification` branch:

```text
middle-coupler/fit-detail.png
middle-coupler/rear-fit-section.png
middle-coupler/xy-seam-section.png
```

The rear-fit section is cut 5 mm forward from the rear mounting plane and is
the primary visual check that the red coupler geometry actually enters the
intended grey HUB75 rear structure.

The build also contains one component STL:

```text
bld/stl/middle-coupler.stl
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

Inspect the middle-coupler evidence before expanding the family:

1. inspect the finished component render;
2. inspect the verification-branch rear fit section;
3. inspect the verification-branch true XY seam/locator section;
4. inspect the angled two-panel verification view;
5. rotate/zoom the standalone middle-coupler STL;
6. preferably print this core component and check the real fit.

Do not add decorative pockets, centre marks, horizontal-edge couplers or corner
couplers until the middle-coupler core fit is understood.

The model and documentation were developed with the assistance of ChatGPT.
