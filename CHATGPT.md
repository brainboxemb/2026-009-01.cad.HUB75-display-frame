# ChatGPT project handoff

## Project purpose

`2026-009-01.cad.HUB75-display-frame` is the clean restart of the HUB75 display
frame project.

The old `2026-006-01.cad.HUB75-display-frame` repository may be inspected as
historical design reference, but its project structure and frame/coupler code
must not be copied wholesale into this repository.

The goal is controlled development through small, verifiable assemblies.

## Current milestone: five panels only

The first milestone contains exactly five HUB75 panels and no frame geometry.

Important orientation:

```text
library panel orientation
    portrait

one panel
    X = nominal 160 mm
    Z = nominal 320 mm
    32 x 64 pixels

five side by side
    X = nominal 800 mm
    Z = nominal 320 mm
    160 x 64 pixels
```

The user may describe the total size height-first as:

```text
320 x 800 mm
64 x 160 pixels
```

Do not rotate these panels 90 degrees. The library model is already portrait.

## Project coordinate system

Use the HUB75 front face as the Y datum:

```text
X = 0
    centre of complete display width

Y = 0
    HUB75 front face

Z = 0
    centre of panel/display height
```

This intentionally preserves the native `lib.scad.hub75` coordinate system.
The panel is not symmetric in Y, so do not use the geometric midpoint of the
panel depth as the primary mechanical datum.

Current default panel depth:

```text
front face          Y =  0.00 mm
rear mounting plane Y = 14.50 mm
```

Expected X/Z placement for the five-panel milestone:

```text
X = -320, -160, 0, +160, +320 mm
Z = 0
```

Future frame and coupler geometry should use explicit accessors for mechanical
Y datums such as the rear mounting plane.

Do not change camera targets to compensate for a coordinate-origin mismatch.
Keep the model origin correct first.

## Dimension authority

Use `lib.scad.hub75` as the only authority for physical panel geometry and
placement dimensions.

Public API:

```scad
panel = hub75_p5_64x32_panel_create();

hub75_p5_64x32_panel_build(panel);

hub75_p5_64x32_panel_nominal_width(panel);
hub75_p5_64x32_panel_nominal_height(panel);
hub75_p5_64x32_panel_width(panel);
hub75_p5_64x32_panel_height(panel);
```

Current library defaults:

```text
physical width        159.70 mm
physical height       319.71 mm
nominal width         160.00 mm
nominal height        320.00 mm
```

Placement must use nominal width/height accessors. Do not duplicate these
dimensions as project constants.

## Project architecture

```text
docker.scad-toolchain v0.4.0
    runtime capabilities

tool.scad-project v0.6.1
    configuration/build orchestration

lib.scad.hub75
    reusable panel geometry

this repository
    panel arrangement and future frame-specific design
```

Direct submodules only:

```text
tools/tool.scad-project
dsg/openscad/ext/lib.scad.hub75
```

Do not recursively initialize development dependencies inside those submodules.

## Render policy

Configured full-display renders:

```text
dsg/openscad/render/front.scad
    -> bld/png/front.png

dsg/openscad/render/front-angled.scad
    -> bld/png/front-angled.png

dsg/openscad/render/rear.scad
    -> bld/png/rear.png

dsg/openscad/render/rear-angled.scad
    -> bld/png/rear-angled.png
```

Use the same official whole-display cameras as the old project:

```text
front         $vpr=[90,0,0]    $vpd=1200
front angled  $vpr=[85,0,40]   $vpd=1050
rear          $vpr=[90,0,180]  $vpd=1200
rear angled   $vpr=[85,0,220]  $vpd=1050
```

These official documentation views must use orthographic OpenSCAD projection,
matching the classic HUB75 renderer:

```yaml
openscad:
  render_flags:
    - --render
    - --projection=o
```

Do not compensate for accidental perspective rendering by shifting `$vpt` or
changing the official camera angles.

Verification STL:

```text
dsg/openscad/export/panels-assembly.scad
    -> bld/stl/panels-assembly.stl
```

The STL is for interactive inspection/rotation and must represent the same
five-panel milestone assembly as the PNG renders.

Default build resolution:

```text
2560 x 1440
```

PNG build output uses:

```yaml
rendering:
  watermark:
    text: "© 2026 brainboxemb"
```

Watermark drawing belongs to `docker.scad-toolchain`; orchestration belongs to
`tool.scad-project`. Do not add project-local image-processing code.

## Development discipline

For each next component:

1. define the physical purpose and interfaces;
2. build the smallest useful geometry;
3. add a focused assembly or fit view;
4. verify it;
5. document the design reasoning;
6. only then add the next layer of complexity.

Prefer fewer view modes and explicit component toggles.

Do not add frame couplers, tube clamps, reinforcement or decorative features to
milestone 1.

Top-level project READMEs should follow the current SCAD-project convention with
a `Quick links` section near the top linking at least to generated build output,
generated design documentation, PNG renders and STL output when present.

The model and documentation were developed with the assistance of ChatGPT.
