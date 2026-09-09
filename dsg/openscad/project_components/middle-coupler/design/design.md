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
tapered seam locator
    ↓
functional middle coupler
```

Not yet included:

- decorative 3 mm pockets;
- centimetre/centre reference marks;
- cosmetic guide-end refinements;
- edge/corner coupler variants.

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

The old project's medium profile is retained only as a controlled starting
point for printable coupler choices:

```text
profile size        80 mm
wall thickness       4 mm
guide height         6 mm
base thickness       3 mm
inside radius        8 mm
outside radius       4 mm
fit clearance     0.25 mm per side
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

The red cylinders are cutters through the base.

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

<!-- scad-render
view: guides
-->

## 6. Seam locator

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

## 7. Final core component

The public build combines the fitted base, guides and locator:

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

Generated project renders show:

- a cropped rear detail around the coupler;
- a true XY section through the vertical seam/locator region.

The standalone STL is also generated so the component can be inspected freely
in a 3D viewer before printing.
