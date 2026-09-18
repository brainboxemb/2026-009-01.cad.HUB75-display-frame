# 2026-009-01.cad.HUB75-display-frame

Structured OpenSCAD project for a modular HUB75 display frame using reusable
libraries, design documentation and automated verification.

This repository is a clean restart of the display-frame design. It deliberately
does not copy the old frame/coupler implementation. Complexity is added only
after each smaller assembly is understood and verified.

## Preview

### Front angled

[![Front angled view](../../raw/prod/bld/png/front-angled.png)](../../blob/prod/bld/png/front-angled.png)

### Rear angled

**Panels only**

[![Rear angled panel view](../../raw/prod/bld/png/rear-angled.png)](../../blob/prod/bld/png/rear-angled.png)

**With couplers**

[![Rear angled view with couplers](../../raw/prod/bld/png/rear-angled-couplers.png)](../../blob/prod/bld/png/rear-angled-couplers.png)

These images are generated from the current `prod/bld` branch.

## Quick links

- [Changelog](CHANGELOG.md)
- [Project plan](docs/01-project-plan.md)
- [New-chat / agent handoff](docs/00-new-chat-handoff.md)
- [Project releases](../../releases)
- [Generated build branch](../../tree/prod/bld)
- [Build overview](../../blob/prod/bld/README.md)
- [Build PNG gallery](../../blob/prod/bld/png/README.md)
- [Build provenance](../../blob/prod/bld/publication-info.txt)
- [Generated design documentation](../../blob/prod/bld/design/README.md)
- [Middle coupler design source](dsg/openscad/project_components/middle-coupler/design/design.md)
- [Horizontal-edge coupler design source](dsg/openscad/project_components/horizontal-edge-coupler/design/design.md)
- [Corner-edge coupler design source](dsg/openscad/project_components/corner-edge-coupler/design/design.md)
- [Generated middle coupler design](../../blob/prod/bld/design/project/openscad/project_components/middle-coupler/design/design.md)
- [Generated horizontal-edge coupler design](../../blob/prod/bld/design/project/openscad/project_components/horizontal-edge-coupler/design/design.md)
- [Generated corner-edge coupler design](../../blob/prod/bld/design/project/openscad/project_components/corner-edge-coupler/design/design.md)
- [Verification branch](../../tree/prod/vrf)
- [Verification overview](../../blob/prod/vrf/README.md)
- [Verification PNG gallery](../../blob/prod/vrf/png/README.md)
- [Middle medium rear fit section](../../blob/prod/vrf/png/middle-coupler-medium-rear-fit-section.png)
- [Horizontal-edge medium fit detail](../../blob/prod/vrf/png/horizontal-edge-coupler-medium-fit-detail.png)
- [Horizontal-edge medium rear fit section](../../blob/prod/vrf/png/horizontal-edge-coupler-medium-rear-fit-section.png)
- [PNG renders](../../tree/prod/bld/png)
- [Five-panel STL](../../blob/prod/bld/stl/panels-assembly.stl)
- [Connector STLs](../../tree/prod/bld/stl)

## Project status

Completed design milestones and their functional changes are recorded only in
[CHANGELOG.md](CHANGELOG.md), so the README does not maintain a second milestone
history that can drift out of sync. Tagged releases capture reproducible project
snapshots; milestone history remains the detailed design record. The current
design direction is described under [Next design step](#next-design-step).

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
    │   ├── display_frame_assembly.scad
    │   ├── middle_coupler_fit_assembly.scad
    │   ├── horizontal_edge_coupler_fit_assembly.scad
    │   ├── corner_edge_coupler_fit_assembly.scad
    │   └── verification_datum_pin.scad
    ├── project_components/
    │   ├── middle-coupler/
    │   │   ├── hub75_middle_coupler.scad
    │   │   ├── hub75_middle_coupler_render.scad
    │   │   └── design/design.md
    │   ├── horizontal-edge-coupler/
    │   │   ├── hub75_horizontal_edge_coupler.scad
    │   │   ├── hub75_horizontal_edge_coupler_render.scad
    │   │   └── design/design.md
    │   └── corner-edge-coupler/
    │       ├── hub75_corner_edge_coupler.scad
    │       ├── hub75_corner_edge_coupler_render.scad
    │       └── design/design.md
    ├── ext/
    │   └── lib.scad.hub75
    ├── render/
    │   ├── front.scad
    │   ├── front-angled.scad
    │   ├── rear.scad
    │   ├── rear-angled.scad
    │   ├── rear-angled-couplers.scad
    │   ├── middle-coupler.scad
    │   ├── horizontal-edge-coupler.scad
    │   ├── corner-edge-coupler-left.scad
    │   └── corner-edge-coupler-right.scad
    ├── export/
    │   ├── panels-assembly.scad
    │   ├── middle-coupler.scad
    │   ├── horizontal-edge-coupler.scad
    │   ├── corner-edge-coupler-left.scad
    │   └── corner-edge-coupler-right.scad
    └── main.scad

tools/
└── tool.scad-project

vrf/
├── openscad/
│   ├── middle-coupler-fit-detail.scad
│   ├── middle-coupler-rear-fit-section.scad
│   ├── middle-coupler-xy-seam-section.scad
│   ├── horizontal-edge-coupler-fit-detail.scad
│   ├── horizontal-edge-coupler-rear-fit-section.scad
│   ├── horizontal-edge-coupler-yz-edge-section.scad
│   ├── horizontal-edge-coupler-xy-seam-section.scad
│   ├── corner-edge-coupler-horizontal-profile-section.scad
│   ├── corner-edge-coupler-vertical-profile-section.scad
│   ├── corner-edge-coupler-left-fit-detail.scad
│   ├── corner-edge-coupler-left-rear-fit-section.scad
│   ├── corner-edge-coupler-left-yz-top-edge-section.scad
│   ├── corner-edge-coupler-left-xy-side-edge-section.scad
│   ├── corner-edge-coupler-right-fit-detail.scad
│   ├── corner-edge-coupler-right-rear-fit-section.scad
│   ├── corner-edge-coupler-right-yz-top-edge-section.scad
│   └── corner-edge-coupler-right-xy-side-edge-section.scad
└── templates/
    ├── README.md
    └── png/
        └── README.md
```

The verification README files are maintained as source templates under
`vrf/templates/`. `scripts/build-verification-index.sh` copies those templates
to the generated verification output instead of embedding long Markdown blocks
inside the shell script.

## Tooling

The project pins the Migration-005 shared execution architecture:

```text
tool.scad-project  v0.14.9 / a140b22858ac1899e7f2fa71b679639a70d819c3
tool.git-project   v0.2.8  / 7c43f37e7b07cfb57638a1d1dad2501de09ba7eb
SCAD toolchain     ghcr.io/brainboxemb/scad-toolchain-openscad:v0.5.0
lib.scad.hub75     v0.1.5  / e0432a9533a08a1c0d9e87225c22f3f66b632531
```

`project.yml` keeps the human-readable semantic versions while the tool and
library gitlinks plus reusable workflow callers resolve them to immutable source
commits. Reusable workflow callers use the same released semantic tool ref, while the committed tool gitlink records the exact source commit.

The root `moon.yml` selects the project capabilities `scad.docs`, `scad.build`
and `scad.verify` and owns only project-specific source-family impact boundaries.
`.moon/tasks/scad.yml` inherits the shared capability implementation from the
pinned `tool.scad-project`; this repository no longer carries its own duplicate
Build/Verify lifecycle graph.

This repository is OpenSCAD-only, so production selects the focused v0.5.0
OpenSCAD runtime. Normal Build and Verification both have configured SCons
targets, so their caches are transported independently. Moon determines which
capabilities are source-affected; the shared planner separately determines the
complete materialization scope needed for publication-safe Build/Verification
snapshots.

Normal project renders and exports are discovered from `dsg/openscad/render`
and `dsg/openscad/export`. The configured SCons build engine tracks their SCAD
dependencies and reuses compatible cached targets rather than blindly rebuilding
every output on every workflow run.

Production output from `main` is published to `prod/bld` and
`prod/vrf`. Version releases are coordinated by the Release workflow
and publish immutable snapshots under `rel/vX.Y.Z/bld` and
`rel/vX.Y.Z/vrf`.

The five configured full-display PNG renders use 2560x1440. Complete-display
presentation uses the library's `light_gray` colour scheme explicitly, rather
than the dark/original material colours used by the low-level panel
`build()` API. The fifth view, `rear-angled-couplers.png`, overlays the complete
medium connector family on the same rear-angled panel view.

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

The normal build contains size-specific renders for the current connector
family:

```text
bld/png/middle-coupler-<size>.png
bld/png/horizontal-edge-coupler-<size>.png
bld/png/corner-edge-coupler-left-<size>.png
bld/png/corner-edge-coupler-right-<size>.png
```

The shared tooling also generates `bld/png/README.md` as a browseable,
deterministically ordered gallery for the normal build PNGs. The generated
`bld/README.md` links directly to that gallery.

Fit evidence is intentionally published on the separate `prod/vrf`
branch:

```text
png/middle-coupler-<size>-fit-detail.png
png/middle-coupler-<size>-rear-fit-section.png
png/middle-coupler-<size>-xy-seam-section.png

png/horizontal-edge-coupler-<size>-fit-detail.png
png/horizontal-edge-coupler-<size>-rear-fit-section.png
png/horizontal-edge-coupler-<size>-yz-edge-section.png
png/horizontal-edge-coupler-<size>-xy-seam-section.png

png/corner-edge-coupler-<size>-horizontal-profile-section.png
png/corner-edge-coupler-<size>-vertical-profile-section.png
png/corner-edge-coupler-left-<size>-fit-detail.png
png/corner-edge-coupler-left-<size>-rear-fit-section.png
png/corner-edge-coupler-left-<size>-yz-top-edge-section.png
png/corner-edge-coupler-left-<size>-xy-side-edge-section.png
png/corner-edge-coupler-right-<size>-fit-detail.png
png/corner-edge-coupler-right-<size>-rear-fit-section.png
png/corner-edge-coupler-right-<size>-yz-top-edge-section.png
png/corner-edge-coupler-right-<size>-xy-side-edge-section.png
```

Rear-fit sections are cut inside the active guide: 3 mm for the 4 mm small
guide and 5 mm for medium/large. This keeps the same 5 mm reference where
possible while ensuring the small preset still shows meaningful fit evidence.

The build also contains one STL per connector and size:

```text
bld/stl/middle-coupler-<size>.stl
bld/stl/horizontal-edge-coupler-<size>.stl
bld/stl/corner-edge-coupler-left-<size>.stl
bld/stl/corner-edge-coupler-right-<size>.stl
```

The generated design walkthrough is published under the `prod/bld` branch's
`design/` tree.

Generated files are published to the mutable `prod/bld` and
`prod/vrf` branches and are not stored on `main`.

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

The forward-looking design sequence, current step and acceptance criteria now live
in the [project plan](docs/01-project-plan.md). Keeping that information in one
place avoids a second project backlog drifting inside this README.

The plan still preserves the key design boundary established here: core
panel/coupler interfaces must be digitally and physically accepted before the
aluminium reinforcement tube and attachment system are introduced.

The model and documentation were developed with the assistance of ChatGPT.