# HUB75 middle coupler — design

<!-- scad-render-defaults
engine: openscad
source: hub75_middle_coupler_render.scad
module: hub75_middle_coupler_design
vpr: [68, 0, 35]
-->

## Physical purpose

The middle coupler joins **two portrait HUB75 panels at their vertical seam**.

It is deliberately the first frame component reintroduced in the clean project.
The goal is to understand and verify one panel-to-panel interface before adding
edge or corner couplers.

The local component origin is physical and explicit:

```text
X = 0
    nominal vertical seam between the two panels

Y = 0
    panel-facing surface of the coupler base

Z = 0
    middle HUB75 mounting-hole row
```

When assembled, this local Y=0 plane is translated to the HUB75 rear mounting
plane.

## What this first version contains

Functional geometry only:

```text
PLUS base plate
    ↓
two screw holes
    ↓
two shallow mounting-tube pockets
    ↓
raised guides beside the rear rib cross
    ↓
two reinforcement pad/pin locators
    ↓
tapered seam locator
    ↓
functional middle coupler
    ↓
Ø3 blind reference pockets
    ↓
centre + and 5/10 mm distance ticks
    ↓
complete middle coupler
```

Not yet included:

- edge/corner coupler variants;
- tube clamps and frame reinforcement;
- other future coupler-family features.

Those are intentionally deferred until this core part fits correctly.

## Object API

The component follows the same object-based OpenSCAD architecture as the
reusable libraries:

```scad
coupler = hub75_middle_coupler_create();

hub75_middle_coupler_build(coupler);
```

The object contains printable coupler choices plus mating dimensions captured
through the public `lib.scad.hub75` API.

Project code must not read HUB75 panel object internals directly.

## Starting dimensions

The approved rounded form from the supplied v120 design archive has now been
captured directly in this component. The current source and this design
document are the authority from this point forward; future work should not
depend on the old repository or archive code.

The retained printable starting values are:

```text
profile size        80 mm
wall thickness       4 mm
guide height         6 mm
base thickness       3 mm
inside radius       10 mm
outside radius        6 mm
guide end rounding  1.5 mm
reinforcement pad radial clearance  0.30 mm
reinforcement pad axial clearance   0.10 mm
reinforcement pin radial clearance  0.20 mm
reinforcement pin length             2.00 mm
seam locator radius                  1.00 mm
fit clearance                        0.25 mm per side
```

Panel-dependent dimensions are **not copied** from the old coupler.

With the current default HUB75 panel they derive to approximately:

```text
horizontal PLUS arm   28.482 mm
vertical PLUS arm     33.800 mm
screw centres         -8 / +8 mm
rear seam gap          2.795 mm
seam locator width     2.295 mm
```

These values are consequences of the HUB75 mating API, not independent project
constants.

## 1. PLUS profile

The base starts as one symmetric PLUS profile centred on the seam and middle
mounting row.

The horizontal arm is derived from the real rear crossbar plus printed material
on both sides:

```scad
hub75_middle_coupler_horizontal_arm_height(coupler)
```

The vertical arm is derived from:

```text
left panel rear side rail
+ rear seam gap
+ right panel rear side rail
+ printed material on both outside faces
```

The concave corners and free outside ends are rounded separately.

The current rounded form is intentional:

```text
concave arm transitions  10 mm radius
convex arm ends            6 mm radius
```

The PLUS outline is generated as a polygon. Its quarter-arc segment count is
derived directly from `coupler.render_fn`. With the default
`render_fn = 192`, each 90 degree arc uses 48 segments instead of the earlier
fixed 18.

The resolution is deliberately stored in the coupler object. This matters
because STL/export entrypoints load the component through `use <...>`;
top-level assignments such as `$fn = 192` are not imported by `use`.

Both public geometry modules therefore set:

```scad
$fn = coupler.render_fn;
```

before creating any cylinders, circles or rounded offsets. The actual STL thus
uses the same high-resolution geometry as the standalone preview and design
renders.

<!-- scad-render
view: profile
-->

## 2. Base plate

The PLUS profile is extruded from local Y=0 toward positive Y.

This is the part of the coupler that remains **behind** the HUB75 rear mounting
plane.

```scad
module _hub75_middle_coupler_base_solid(coupler) {
    _hub75_middle_coupler_extrude_xz_y(
        0,
        coupler.base_thickness
    )
        _hub75_middle_coupler_profile_2d(coupler);
}
```

<!-- scad-render
view: base
-->

## 3. Two mounting screw holes

The seam-side mounting hole of each panel is derived from the nominal 160 mm
placement pitch and the panel's own centred mounting-hole coordinates.

For the current panel this places the two screw centres at:

```text
X = -8 mm
X = +8 mm
Z =  0 mm
```

The nominal through bore remains cylindrical at Ø3.4 mm.

The original v1.2 print aid is also restored around both ends of each bore:

```text
relief depth      0.20 mm
radial widening   0.40 mm
relief diameter   Ø4.20 mm
```

Only that shallow first layer is widened. It is an anti-elephant-foot relief,
not a countersink, so the functional Ø3.4 mm screw bore is unchanged.

The red cylinders are the complete cutters through the base, including these
shallow relief rings.

<!-- scad-render
view: screw-holes
-->

## 4. Mounting-tube pockets

The HUB75 panel has a small mounting tube around each screw hole. That tube
protrudes beyond the rear mounting plane.

The coupler therefore receives a shallow **blind** pocket from its panel-facing
surface. Pocket diameter and depth are derived from the public panel mating
accessors plus printable clearance.

<!-- scad-render
view: tube-pockets
-->

## 5. Raised rib guides

The guide walls extend from the coupler toward the panel.

They do not sit on top of the HUB75 rear ribs. Instead, the real rear rib cross
is treated as a keep-out and the printed material remains **beside** that
keep-out.

Conceptually:

```text
PLUS plate profile
minus
(real rear rib cross + 0.25 mm clearance)
=
guide walls
```

The rear bay corners are rounded in the panel model, so the keep-out includes
that rounded corner geometry rather than assuming a sharp PLUS.

Reliefs are also removed where the two nearby reinforcement bushings occupy the
guide region.

The fitted guide shell then receives a 1.5 mm 2D opening operation:

```text
offset(-1.5 mm)
then
offset(+1.5 mm)
```

This restores the softer v120 guide endpoints and removes the small pointed
tips that otherwise appear at the ends of the raised walls.

<!-- scad-render
view: guides
-->

## 6. Reinforcement pad/pin locators

The two circular reinforcement features beside the screw holes contain a large
Ø10 recess with a small blind Ø2.5 centre hole.

The guide wall already has a larger circular relief around each feature. Inside
that cleared area the coupler now adds a **positive two-stage locator**:

```text
panel recess Ø10.0 x 2.5 mm
    ↓ 0.30 mm radial / 0.10 mm axial clearance
coupler pad Ø9.4 x 2.4 mm

panel blind hole Ø2.5 mm
    ↓ 0.20 mm radial clearance
coupler pin Ø2.1 x 2.0 mm
```

The pad provides broad location in the circular recess. The smaller pin then
enters the blind centre hole. Both dimensions come from the public HUB75 mating
API; only printable clearances belong to the coupler.

<!-- scad-render
view: reinforcement-locators
-->

## 7. Seam locator

The narrow locator enters the actual rear gap between the two panels.

Its base width is:

```scad
rear_seam_gap - 2 * fit_clearance
```

The insertion end is slightly narrower on both sides, creating a simple lead-in
without moving the locator away from the nominal seam centre.

<!-- scad-render
view: seam-locator
-->

## 8. Functional coupler

Before any visible reference detail is cut, the complete mechanical coupler is
available as a separate design stage. This is deliberate: surface markings must
never become part of the mating logic.

<!-- scad-render
view: functional
-->

## 9. Ø3 blind reference pockets

The visible rear face receives the small circular reference-style pockets from
the approved v120 design language.

Default geometry:

```text
visible diameter      3.0 mm
total depth           2.5 mm
straight depth        2.0 mm
taper depth           0.5 mm
bottom diameter       2.0 mm
pitch                10.0 mm
stations             20 / 30 / 40 mm from the centre
lane offset           7.5 mm for the current middle coupler
```

The visible part stays cylindrical at Ø3 mm. Only the final 0.5 mm narrows to
Ø2 mm. This gives the blind pocket a short print-friendly tapered end without
turning the whole feature into a cone.

For thinner presets, the total blind depth is still limited so at least
0.2 mm of base material remains. The taper is retained and the straight section
becomes shorter as needed.

The lane offset is not hard-coded at 7.5 mm. It is derived from approximately
one quarter of the real arm thickness and snapped to a 2.5 mm reference grid.
For the current horizontal and vertical arm widths both derive to 7.5 mm.

Two symmetric lanes are used only when they geometrically fit in **both** PLUS
arms. This keeps the pattern symmetric when future profile dimensions change.

The pockets are blind. With the current 3 mm base and 2.5 mm pocket depth,
0.5 mm of material remains at the panel-facing side.

<!-- scad-render
view: reference-pockets
vpr: [68, 0, 215]
-->

## 10. Centre + and distance ticks

These marks are reference geometry rather than decoration.

At the local component origin a small `+` identifies:

```text
X = 0  nominal panel seam
Z = 0  middle mounting-hole row
```

Along both X and Z axes, ticks appear every 5 mm:

```text
5 mm   minor tick   2.2 mm long
10 mm  major tick   4.0 mm long
width               0.8 mm
depth               0.40 mm
centre +            6.0 mm
```

The marks are shallow, discontinuous recesses. This makes them useful for
measurement without creating one long structural groove through the coupler.

A keep-out is applied around both screw holes and the whole pattern is clipped
to an inset of the real rounded PLUS outline.

<!-- scad-render
view: center-marks
vpr: [68, 0, 215]
-->

## 11. Complete middle coupler

The public build now combines the verified functional geometry with the two
surface-reference layers:

```scad
hub75_middle_coupler_build(coupler);
```

<!-- scad-render
view: final
-->

## Fit verification

The component is not accepted only because it renders.

The project also contains a two-panel local fit assembly:

```text
dsg/openscad/assemblies/middle_coupler_fit_assembly.scad
```

Verification evidence is published separately from normal build output:

```text
verification/middle-coupler/
├── rear-fit-section.png
├── xy-seam-section.png
└── fit-detail.png
```

The primary **Rear fit section** is cut 5 mm forward from the rear mounting
plane. Grey shows only the HUB75 rear structure retained by that cut; red shows
only coupler geometry reaching into the same volume. This makes penetration,
clearance and accidental overlap readable at a glance.

The XY seam section remains useful for the seam locator, while the angled
detail gives overall local context.

The standalone STL remains a normal build artifact so the actual printable
component can be inspected freely in a 3D viewer before printing.
