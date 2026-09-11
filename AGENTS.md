# Repository agent guidance

Persistent guidance for automated coding agents working in
`2026-009-01.cad.HUB75-display-frame`.

## Project purpose

This repository is the clean restart of the HUB75 display-frame project. The
older display-frame repository is not a geometry authority. Historical material
may be used once to recover an explicitly approved decision, but that decision
must then be captured in current source/design documentation.

Develop through small, verifiable assemblies. Do not mix new reinforcement or
mounting layers into unresolved basic panel-fit geometry.

## Sources of truth

Use these in order:

```text
current component source + generated design evidence
lib.scad.hub75 public geometry/mating API
project.yml for tooling/build/publication policy
CHANGELOG.md for completed milestone history
```

Do not duplicate volatile tool versions in this file. `project.yml`, gitlinks
and reusable workflow refs define the active tooling release.

## Panel orientation and coordinate system

The library panel is already portrait in this project:

```text
one panel
    X = nominal 160 mm
    Z = nominal 320 mm
    32 x 64 pixels

five side by side
    X = nominal 800 mm
    Z = nominal 320 mm
    160 x 64 pixels
```

Do not rotate the panel 90 degrees to obtain this orientation.

Project coordinates preserve the native library datum:

```text
X = 0    centre of complete display width
Y = 0    HUB75 front face
Z = 0    centre of panel/display height
```

The panel is not symmetric in Y. Use explicit mechanical accessors such as the
rear mounting plane; never substitute the geometric depth midpoint.

Expected five-panel X placement is nominally:

```text
-320, -160, 0, +160, +320 mm
```

Placement must use nominal-size accessors from `lib.scad.hub75`, not duplicated
project constants.

## Geometry authority

`lib.scad.hub75` is the sole reusable authority for physical panel geometry and
mating dimensions. Consume its public object/accessor API. Do not copy panel
measurements into connector source unless the value is genuinely project-owned.

OpenSCAD cross-file interfaces use public names without a leading underscore.
Private implementation helpers use a leading underscore, including nested
helpers.

## Assembly source layout

Keep `dsg/openscad/assemblies/` reserved for meaningful top-level project
assemblies. Small diagnostic fixtures and shared visual aids must not accumulate
in the assembly root.

Use the assembly subdirectories by meaning:

```text
assemblies/
    <top-level project assemblies>
    verification/   focused fit, section and diagnostic assemblies
    helpers/        shared assembly-only visual or construction helpers
    sub/            genuine physical subassemblies, when the project has them
```

`assemblies/verification/` is for deliberately small development fixtures used
to inspect fit, alignment, sections or other local interfaces. These are not
production assemblies even when they combine real production components.

`assemblies/helpers/` contains geometry used to explain or construct assemblies
but which is neither a product component nor an assembly itself. The visual
verification datum pin belongs here.

Use `assemblies/sub/` only for a real physical subassembly that forms part of a
larger assembly. Do not classify a small verification view as a subassembly just
because it contains fewer parts.

## Connector design discipline

The middle, horizontal-edge and corner-edge families are developed as separate
components with small/medium/large build evidence and focused fit verification.

The previously approved rounded middle-coupler form is now encoded in current
source and design documentation. Future changes must compare against current
source/evidence, not an old archive or old repository code.

Surface resolution is part of the connector object where required. Public
build/render modules must not depend on ambient top-level variables that are
lost across `use <...>` boundaries.

Any hand-built curved helper must derive tessellation from the component's
configured render resolution; do not use a small fixed segment count that can
produce faceted STL geometry or polygonal screw holes.

## Design documentation policy

Design documentation must explain enough geometric construction that a reader
who does not know OpenSCAD can understand how the part is formed and can use the
documentation to spot modelling errors.

Explain each meaningful construction step in this order:

```text
physical feature or constraint
    ↓
geometric construction or change
    ↓
image that makes that change visible
    ↓
relevant code/helper only after the geometry is understood
```

Treat every numbered construction step that corresponds to production geometry
as incomplete until all four layers above are present. The implementation layer
does not need to reproduce a long module verbatim: a helper/module signature,
the key derived formula and a short explanation of how that helper participates
in the build are sufficient. If a view is deliberately a documentation-only
intermediate state with no one-to-one production helper, state that explicitly
and point to the production helper that creates the equivalent final geometry.

Before considering a component `design.md` complete, audit the numbered steps
from first to last. Do not let later sections degrade into explanation + image
only after earlier sections established a stronger pattern. Check especially
that every physical subtraction, positive locator, taper, surface detail and
final composition can be traced back to the source helper/module that implements
it.

Do not collapse an important shape into a single high-level step merely because
the production implementation generates it efficiently as one polygon or one
Boolean expression. Documentation-only construction views may decompose the
same final geometry into simpler explanatory primitives without changing the
production model.

For sequential design images, use neutral grey for the established/reference
state and red for the current operation or newly introduced geometry. The image
must make both roles visually readable. Do not place an opaque red shape over a
grey reference when that makes the referenced geometry disappear; change layer
order, use a contour, clip the current operation, or choose another view.

Choose the camera for the geometry being explained rather than applying one
camera mechanically to every step. Prefer face-on/orthographic views for planar
profiles and offsets, oblique views where depth or protrusion matters, and
sections where internal fit is the point being explained.

A successful render is **not** sufficient design-documentation verification.
After changing design views, inspect the actual generated images from the current
CI build artifact. Check that the claimed grey/red geometry is visible, the
camera exposes the intended feature, consecutive steps are understandable, and
the image agrees with the accompanying text. Tune and rebuild until the images
are explanatory, not merely technically valid.

## Build architecture

Normal output is discovered from:

```text
dsg/openscad/render/
dsg/openscad/export/
```

Special multi-size behavior belongs in adjacent `render.yml` / `export.yml`
profiles. Do not reintroduce a long explicit `builds:` list for normal targets.

The project uses the SCons backend through `tool.scad-project`. Dependency-aware
selection must remain correct: unchanged targets may be restored/current, but a
changed SCAD dependency must rebuild only the affected target graph. Do not
replace dependency checking with a broad unconditional cache hit.

Generated design documentation has its own cache and is separate from normal
per-target SCons selection.

Direct project submodules are the project tool and `lib.scad.hub75`. Normal
checkout is direct-only; do not recursively initialize development dependencies
owned by those submodules.

## Render and verification policy

Whole-display documentation renders use the public HUB75 render path with the
project's light-grey color scheme so detail and assembly views stay consistent.
Do not switch whole-display documentation back to the library's dark/default
appearance.

Official full-display cameras and orthographic projection are part of the
project's documentation contract. Do not compensate for coordinate mistakes by
changing camera targets or projection.

Default build PNGs use the watermark configured in `project.yml`. Image
post-processing belongs to `docker.scad-toolchain`; orchestration belongs to
`tool.scad-project`; do not add project-local watermark code.

Fit evidence belongs on the configured verification publication branch. Rear-fit
sections are the primary passing check: neutral panel structure, contrasting
coupler material, and the nominal verification datum. Fixtures should stay
small enough to diagnose the relevant interface.

## Publication

Branch names and release behavior are defined in `project.yml` and reusable
workflows. Do not duplicate changing branch/version details here.

Source stays on `main`; production/development generated snapshots and immutable
release snapshots are created by the shared publication lifecycle. Do not create
a project version tag merely because release infrastructure exists.

## Development sequence

For each new component or layer:

1. define physical purpose and interfaces;
2. build the smallest useful geometry;
3. add a focused assembly or fit view;
4. verify it;
5. document the design reasoning;
6. only then add the next layer.

Prefer fewer view modes and explicit component toggles.

Top-level README documentation should keep the current SCAD-project quick-link
convention and expose generated design, renders, STL output and verification as
appropriate.

The model and documentation were developed with the assistance of ChatGPT.
