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
- [PNG renders](../../tree/build/png)
- [STL verification model](../../blob/build/stl/panels-assembly.stl)

## Current milestone

Milestone 1 contains only the five physical HUB75 panels.

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
    │   └── panels_assembly.scad
    ├── ext/
    │   └── lib.scad.hub75
    ├── render/
    │   ├── front.scad
    │   ├── front-angled.scad
    │   ├── rear.scad
    │   └── rear-angled.scad
    ├── export/
    │   └── panels-assembly.scad
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

Do not add frame parts, couplers or reinforcement geometry until the five-panel
assembly and its nominal placement are confirmed.

The model and documentation were developed with the assistance of ChatGPT.
