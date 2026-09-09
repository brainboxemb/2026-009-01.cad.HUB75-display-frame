# 2026-009-01.cad.HUB75-display-frame

Structured OpenSCAD project for a modular HUB75 display frame using reusable
libraries, design documentation and automated verification.

This repository is a clean restart of the display-frame design. It deliberately
does not copy the old frame/coupler implementation. Complexity is added only
after each smaller assembly is understood and verified.

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
    │   └── panels-assembly.scad
    └── main.scad

tools/
└── tool.scad-project
```

## Tooling

The project pins:

```text
tool.scad-project v0.6.0
docker.scad-toolchain v0.4.0 (through the reusable workflow)
lib.scad.hub75 main, locked by the project gitlink
```

The configured PNG build uses a 2560x1440 render and the generic watermark path:

```text
© 2026 brainboxemb
```

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
