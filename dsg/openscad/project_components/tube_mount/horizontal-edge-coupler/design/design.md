# HUB75 tube horizontal-edge coupler — design

<!-- scad-render-defaults
engine: openscad
source: hub75_tube_horizontal_edge_coupler_render.scad
module: hub75_tube_horizontal_edge_coupler_design
vpr: [90, 0, 0]
vpt: [0, 0, 7]
vpd: 145
-->

## Purpose

This component adds the aluminium-tube interface **around** the accepted
HUB75 horizontal-edge coupler.  The panel-facing core coupler remains a separate
component under `components/hub75/`.

The tube-aware component is deliberately constructed in functional order:

```text
accepted HUB75 core coupler
    ↓
make room for the aluminium tube
    ↓
derive where the clamps belong
    ↓
add load-carrying rear carriers
    ↓
cut top-entry female dovetails
    ↓
assemble detachable clamps + tube
```

The tube and clamp fit are different interfaces.  The tube itself is nominally
Ø10.0 mm.  The coupler keep-out is a non-clamping clearance volume; the
detachable clamp separately uses Ø10.0 mm functional geometry and a Ø9.6 mm
tension bore.

## 1. Start from the accepted HUB75 edge coupler

The base component already owns all panel-facing mating geometry, screws,
locators and guide walls.  Reinforcement work must not silently reshape those
interfaces.

<!-- scad-render
view: core
-->

Production starts from:

```scad
hub75_horizontal_edge_coupler_build(coupler);
```

## 2. Make continuous space for the Ø10 aluminium tube

The aluminium tube runs along project X and has its historical centre at:

```text
Y = -7 mm
Z = +10 mm
```

Before adding any clamp mount, one continuous cylindrical keep-out is subtracted
through the complete horizontal-edge component.  The radial keep-out clearance
uses the core coupler's existing printable `fit_clearance` (0.25 mm for the
current presets), so the default keep-out is Ø10.5 mm.

This Ø10.5 value is **not** a clamp bore and does not create clamp tension.

<!-- scad-render
view: tube-keepout
-->

Production helper:

```scad
_hub75_tube_horizontal_edge_keepout_cutter(coupler, clamp);
```

## 3. Derive clamp positions from the available edge structure

The old tube-mount experiment used fixed 18 / 25 mm offsets.  The new component
does not preserve those values as unexplained project constants.

Carrier width is derived from the clearanced female dovetail root plus 2 mm
of material on each side. With the current 12 / 2 / 30° interface this is
about 16.6 mm. The carrier is kept 4 mm inside the outer end of the horizontal
core profile:

```text
offset =
    profile_size / 2
    - carrier_width / 2
    - edge_margin
```

with a lower bound of half the carrier width.

That gives approximately:

```text
small   profile  60 mm → clamp centres ±17.7 mm
medium  profile  80 mm → clamp centres ±27.7 mm
large   profile 100 mm → clamp centres ±37.7 mm
```

The red markers below show those derived load-path positions relative to the
real tube and the existing coupler.

<!-- scad-render
view: carrier-position
-->

Public accessor:

```scad
hub75_tube_horizontal_edge_clamp_positions(coupler)
```

## 4. Add rear carriers before adding the dovetail

Only after the tube path and clamp locations are known are the carrier solids
added.  They overlap the accepted core plate and provide rear material for the
female mechanical interface.

The carrier now encloses only the actual female channel. It adds 2 mm below
the clearanced 16 mm channel and a 2 mm lip above it. The 16 mm straight
entry-slot continues upward through free space instead of being surrounded by
a tall carrier. This keeps the carrier local to the load path and prevents the
entry approach from becoming a tunnel.

<!-- scad-render
view: carriers
-->

Production helper:

```scad
_hub75_tube_horizontal_edge_carriers(coupler);
```

## 5. Cut the dovetail for top-down insertion

The reusable `lib.scad.mechint` dovetail is rotated 90 degrees relative to the
earlier experiment:

```text
tube axis       = X
profile depth   = Y
dovetail slide  = Z
entry direction = +Z  (from above in top-edge orientation)
```

The native `-X` entry side from the library is transformed into project
`+Z`. The existing 16 mm female entry slot therefore becomes a straight
vertical approach above the mating channel. The 2 mm profile mouth is shifted
to project Y = -1 mm: small ends the 0.8 mm tongue at its free 2 mm rear face,
while medium/large open 1 mm and 2 mm flex cavities behind it.

<!-- scad-render
view: dovetail
-->

Shared project adapter:

```scad
hub75_tube_mount_dovetail_female_cutter(...)
```

## 6. Assemble the detachable clamp

The clamp no longer has a separate mounting spine. The clamp body and male
dovetail are both 12 mm wide. The 16 mm male slide is centred on the same Z
datum as the Ø10 tube/ring and its 2 mm profile sits directly beside the compact
2 mm clamp transition. The existing 0.01 mm `extra` remains only a deliberate
Boolean overlap.

In the exploded view the two clamps move upward in Z, matching the intended
installation direction.

<!-- scad-render
view: assembled
vpr: [68, 0, 35]
vpt: [0, -2, 7]
vpd: 155
-->

The physical subassembly is:

```scad
assemblies/sub/hub75_tube_horizontal_edge_assembly.scad
```

## Current status

This is a **design iteration**, not physical fit acceptance.  The next review
should focus on the carrier outline, the clamp/dovetail transition, access for
top-down insertion and whether the tube keep-out removes the collision visible
in the previous assembly.
