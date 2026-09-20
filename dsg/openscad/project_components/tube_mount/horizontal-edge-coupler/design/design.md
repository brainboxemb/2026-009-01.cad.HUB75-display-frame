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

This component adds the aluminium-tube interface **to** the accepted
HUB75 horizontal-edge coupler. The panel-facing core coupler remains a separate
component under `components/hub75/`, and its exterior shape is retained.

The tube-aware component is deliberately constructed only by subtraction:

```text
accepted HUB75 core coupler
    ↓
make room for the aluminium tube
    ↓
derive where the clamps belong
    ↓
cut top-entry female dovetails into the existing edge structure
    ↓
assemble detachable clamps + tube
```

No rounded carrier or other positive tube-mount body is added.

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

The aluminium tube runs along project X. Its current datum is:

```text
global Y = 6.0 mm
local  Y = -8.5 mm from the 14.5 mm rear mounting plane
Z = +10 mm
```

With Ø10 mm tube diameter, the tube therefore starts exactly 1.0 mm behind the
panel front face.

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

The placement envelope is derived from the clearanced female dovetail root plus
2 mm of existing material on each side. With the current 12 / 2 / 30° interface
this is about 16.6 mm. That envelope is kept 4 mm inside the outer end of the
horizontal core profile:

```text
offset =
    profile_size / 2
    - interface_width / 2
    - edge_margin
```

with a lower bound of half the interface width. This controls placement only;
it does not create a new solid.

That gives approximately:

```text
small   profile  60 mm → clamp centres ±17.7 mm
medium  profile  80 mm → clamp centres ±27.7 mm
large   profile 100 mm → clamp centres ±37.7 mm
```

The red markers below show those derived load-path positions relative to the
real tube and the existing coupler.

<!-- scad-render
view: interface-position
-->

Public accessor:

```scad
hub75_tube_horizontal_edge_clamp_positions(coupler)
```

## 4. Cut the dovetail directly into the existing edge connector

No carrier solid is added. The same accepted edge-connector geometry shown in
step 1 is kept as the outside shape. After the tube keep-out has been removed,
the two female dovetails are simply subtracted at the positions from step 3.

At these positions the existing core already supplies the required material:
the rear base occupies Y >= 0 and the panel-facing guide / outer-edge geometry
occupies the front side. The mouth at local Y = -1.5 mm therefore cuts into
existing material instead of requiring a second rounded mounting body.

This is the same modelling principle used by the tube keep-out: the tube-aware
variant changes the core locally by subtraction without changing its exterior
outline.

## 5. Female dovetail for top-down insertion

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
vertical approach above the mating channel. The 2 mm profile uses a 0.5 mm
straight mouth land, 1.0 mm of 30° flank and a 0.5 mm straight root land. Its
mouth is shifted to project Y = -1.5 mm: small / medium / large retain
0.5 / 1.5 / 2.5 mm rear-open flex cavities behind the 0.8 mm tongue.

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
1 mm clamp transition. The Ø10 tube starts 1.0 mm behind the panel front face,
placing its centre at global Y = 6.0 mm / local Y = -8.5 mm. The complete clamp
moves with that datum, so the Ø14 clamp tangent and male mouth both land at local
Y = -1.5 mm. Before unioning the male, the shared mechint
`male_relief_cutter` trims that transition back to the actual dovetail contour,
so both mating flanks remain exposed. HUB75 then applies one project-local
finishing wedge immediately in front of the male mouth. Its lateral step is
derived from half the difference between the 12 mm clamp width and the male
mouth width, while its depth is derived from that step and the same 30° flank
angle as the dovetail. With the current 12 / 2 / 30° / 0.5 mm mouth + 0.5 mm
root-land profile this gives a 0.577 mm lateral step over 1.0 mm depth, so the
finishing cut continues the dovetail's 30° visual direction instead of adding
a second 45° angle. The existing 0.01 mm `extra`
remains only a deliberate Boolean overlap.

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

This is a **design iteration**, not physical fit acceptance. The next review
should focus on the direct female cut in the unchanged edge-connector outline,
the clamp/dovetail transition, top-down insertion access and whether the tube
keep-out removes the previous collision.
