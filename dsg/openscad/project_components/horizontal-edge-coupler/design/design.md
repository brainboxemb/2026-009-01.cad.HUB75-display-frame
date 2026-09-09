# HUB75 horizontal-edge coupler — design

<!-- scad-render-defaults
engine: openscad
source: hub75_horizontal_edge_coupler_render.scad
module: hub75_horizontal_edge_coupler_design
vpr: [68, 0, 35]
vpt: [0, 0, -20]
vpd: 220
-->

## Physical purpose

The horizontal-edge coupler joins two adjacent portrait HUB75 panels where
their vertical seam reaches the **top or bottom display edge**.

This is the next member of the same connector family as the middle coupler.
The first implementation deliberately contains **no aluminium-tube clip**.
Panel fit and the T-shaped body are established first.

The printable geometry is modelled once in top-edge orientation. The same part
can be rotated 180 degrees for the bottom edge.

## Coordinate system

```text
X = 0   vertical seam between the two panels
Y = 0   HUB75 rear mounting plane
Z = 0   nominal 320 mm panel edge
```

The small engraved `+` is therefore not decoration: it marks the exact
intersection of the nominal panel edge and panel seam.

The 5/10 mm ticks are retained from the middle coupler because they provide a
visible scale for judging connector proportions during development.

## Family dimensions

The horizontal edge uses the same named presets as the middle coupler:

```text
small    profile 60 mm   wall 2 mm   guide 4 mm   base 2 mm
medium   profile 80 mm   wall 4 mm   guide 6 mm   base 3 mm
large   profile 100 mm   wall 6 mm   guide 10 mm  base 4 mm
```

The same R10 concave corners, R6 free ends, screw-hole relief, tapered
reference pockets and reinforcement locator clearances are retained.

## 1. T profile

The horizontal rail follows the **real HUB75 rear end rail**, while the
vertical stem follows the meeting side rails at the panel seam.

The arm widths are not copied constants:

```text
horizontal arm
    = rear end rail
    + wall + clearance on both sides

vertical stem
    = left side rail
    + rear seam gap
    + right side rail
    + wall + clearance on both sides
```

The nominal edge is Z=0, while the physical rear rail lies slightly inward.
That intentional offset is visible in the reference marks.

<!-- scad-render
view: profile
-->

## 2. Base

The T profile is extruded behind the mounting plane. The inward stem reaches
half the selected profile size from the nominal panel edge.

<!-- scad-render
view: base
-->

## 3. Mounting holes

The same seam-side screw pair used by the middle coupler is used here. At the
top edge the screw row is exactly **8 mm inward from Z=0**.

The Ø3.4 through bores retain the shallow 0.20 mm anti-elephant-foot relief
with 0.40 mm radial widening.

<!-- scad-render
view: screw-holes
-->

## 4. Mounting-tube pockets

The panel's Ø8.5 mounting tubes protrude through the rear mounting plane, so
the base receives the same shallow fitted pockets as the middle coupler.

<!-- scad-render
view: tube-pockets
-->

## 5. Physical locator-pin clearance

A real Ø3 locating pin exists farther inward from the top edge. The coupler
uses the public HUB75 mating API for its diameter and position.

For small and medium the pin lies beyond the T stem and the cutter has no
effect. The large profile reaches the pin area, so the same model
automatically creates the required clearance there.

<!-- scad-render
view: locator-pin-clearance
-->

## 6. Fitted guides

The raised guide is built around a T-shaped keep-out made from the actual rear
end rail and the two side rails meeting at the seam.

The normal tall guide exists on the panel side of the outer rail. The material
outside the physical rear edge is rebuilt as a low tapered ridge. This keeps
the edge treatment print-friendly without introducing the future tube clip yet.

<!-- scad-render
view: guides
-->

## 7. Reinforcement locators

The two top-row reinforcement circles lie inward from the screw row. The same
Ø9.4 pad + Ø2.1 pin locator geometry used by the middle coupler is reused.

<!-- scad-render
view: reinforcement-locators
-->

## 8. Seam locator

A tapered locator follows the vertical seam from the nominal display edge
inward through the T stem. Its width is derived from the actual rear panel gap
minus print clearance.

<!-- scad-render
view: seam-locator
-->

## 9. Reference pockets

The same Ø3 blind visual pockets are retained. Their final 0.5 mm tapers to
Ø2 mm and the minimum back wall remains 0.7 mm.

The horizontal pocket row is generated from a symmetric virtual reference
cross and then clipped by the real asymmetric edge T. This makes the pattern
useful for visually checking the T proportions rather than hiding them.

<!-- scad-render
view: reference-pockets
vpr: [68, 0, 215]
-->

## 10. Centre and distance marks

The `+` at Z=0 marks the nominal panel edge. Ticks continue every 5 mm and
full centimetres use the longer marks.

Only marks supported by the real T remain after clipping. This deliberately
makes the asymmetric relationship between the nominal edge and physical rear
rail visible.

<!-- scad-render
view: center-marks
vpr: [68, 0, 215]
-->

## 11. Complete horizontal-edge coupler

<!-- scad-render
view: final
-->

## Deferred

The aluminium reinforcement tube and its C-clips are intentionally not part of
this milestone step. A tube system will be introduced only after the T body and
panel fit have their own verification evidence.
