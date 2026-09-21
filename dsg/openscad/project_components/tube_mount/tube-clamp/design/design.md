# HUB75 tube clamp — design

<!-- scad-render-defaults
engine: openscad
source: hub75_tube_clamp_render.scad
module: hub75_tube_clamp_design
vpr: [74, 0, 35]
vpt: [0, -3.5, 10]
vpd: 90
-->

## Purpose of this document

This document is the geometric source of truth for the **project-owned HUB75
tube clamp adapter**.

The reusable snap clip itself already has a worked-out design in
`lib.scad.clamps/openscad/tube-clamp/design/design.md`. The missing piece was
the HUB75-specific adapter that combines that reusable clip with the
size-matched sliding dovetail.

That omission made later changes unnecessarily expensive: the coordinate
transform, print orientation, ownership boundary and construction order had to
be reconstructed from the OpenSCAD code during every small correction.

The rule from this point onward is:

> do not reshape the accepted base clamp while solving a local HUB75 adapter
> detail.

The baseline shape shown below is the shape to preserve unless a requirement
explicitly says otherwise.

<!-- scad-render
view: baseline
-->

## Ownership boundary

Three layers participate in this component.

### `lib.scad.clamps`

Owns the reusable tube clip:

- circular outside;
- functional/tension bore semantics;
- snap opening;
- compact flat base;
- compact transition from that base into the ring.

HUB75 must not silently redesign that geometry.

### `lib.scad.mechint`

Owns the reusable sliding-dovetail profile:

- 30 degree flank;
- mouth/root lands;
- fit and axial clearance;
- entry travel;
- lock/release geometry;
- generic male relief cutter.

### HUB75 project component

`hub75_tube_clamp.scad` owns only the adaptation between those two reusable
components:

- project coordinate transform;
- fixed tube datum;
- size/profile selection;
- compact clamp-to-dovetail overlap;
- the project-local finishing transition;
- any small print-driven relief that cannot sensibly live in either library.

## Coordinate system

Project coordinates are:

```text
X = aluminium tube axis
Y = panel front -> rear
Z = display-edge outward / dovetail insertion direction
```

The reusable clamp has a different native frame. The production transform maps:

```text
lib clamp Z  -> project X
lib clamp X  -> project -Y
lib clamp Y  -> project -Z
```

That transform is not just an implementation detail. It determines which way a
subtraction is oriented physically.

## Print coordinate system — critical

The clamp is **side-printed**.

In that print orientation the 12 mm clamp side is placed on the bed, therefore:

```text
project X / tube axis = printer Z / build direction
```

This is the important distinction that was previously undocumented.

A cutter described as **vertical for printing** must therefore have its axis
along **project X**.

A cylinder whose axis runs along project Z may look vertical in one model view,
but it is horizontal in the actual print orientation and creates the wrong kind
of concave overhang.

The green reference axis below documents the required print-vertical direction.
It is documentation-only; it does not define the final position of a relief.

<!-- scad-render
view: print-axis
-->

## Fixed tube and clamp dimensions

All sizes retain the same actual tube clip:

```text
tube functional diameter  = 10.0 mm
tube tension diameter     =  9.6 mm
wall thickness            =  2.0 mm
clamp width               = 12.0 mm
nominal outside diameter  = 14.0 mm
```

The tube datum also remains fixed. Selecting small / medium / large must not
move or resize the circular snap ring.

The size-dependent part is the interface toward the coupler.

## Size mapping

The selected coupler profile and clamp interface belong together.

| Coupler profile | Host depth | Dovetail height | Derived transition depth |
| --- | ---: | ---: | ---: |
| small | 2.0 mm | 2.0 mm | 1.0 mm |
| medium | 3.0 mm | 2.5 mm | 1.5 mm |
| large | 4.0 mm | 3.0 mm | 2.0 mm |

The interactive `tube-clamp` and `tube-clamp-dov` views must use the selected
`coupler_profile`. A custom profile derives the interface from its configured
`base_thickness`.

## Construction order

The production component is built in this order:

```text
1. create reusable lib.scad.clamps body
2. transform it into HUB75 project coordinates
3. trim consumer material with mechint male-relief cutter
4. apply the existing local 30 degree finishing wedge
5. union the size-matched male dovetail
6. only then consider a tiny local print relief if required
```

Step 6 is deliberately last. A print-relief correction must not be allowed to
turn into a new global clamp profile.

## Accepted baseline

The complete clamp below is the accepted base form for the current correction.

It may have one visually sharp local edge near the clamp/dovetail transition.
That local edge is the problem; the overall silhouette is not.

The following are **not** acceptable ways to solve that edge:

- narrowing the whole clamp into an hourglass;
- cutting a broad cylindrical scoop through the ring;
- introducing a rectangular step/notch;
- changing the 30 degree dovetail transition globally;
- using a project-Z cylinder merely because it looks vertical in a viewport.

<!-- scad-render
view: baseline
vpr: [65, 0, 25]
vpt: [0, -3.5, 10]
vpd: 72
-->

## Local edge-relief requirement

The requested correction is intentionally small:

```text
baseline geometry
    +
remove only the sharp local corner
    +
keep the cutter print-vertical
```

Current design intent:

- use a small cylindrical subtraction;
- cylinder axis = **project X / printer Z**;
- nominal radius around 10 mm is acceptable when it is positioned almost
  tangent to the target edge;
- maximum bite is about 1 mm;
- the subtraction must remain visually local;
- the same profile must be present on the opposite clamp side;
- the ring bore, ring outside, dovetail fit and size mapping do not change.

The exact cutter centre is a feature coordinate and must be validated from a
dedicated close-up design view before it is returned to production geometry.

Until that position is validated, the production model stays on the accepted
baseline instead of carrying a speculative relief.

## Validation checklist

A candidate local relief is valid only when all of the following are true:

1. the baseline silhouette is still recognizable immediately;
2. only the intended sharp corner changes;
3. the relief axis is project X / printer Z;
4. no horizontal concave tunnel is introduced in the side-print orientation;
5. small / medium / large retain their matching dovetails;
6. functional and tension bore dimensions stay unchanged;
7. generated STL remains manifold;
8. the close-up render makes the before/after change obvious without needing
   to reconstruct the coordinate transform from source code.

## Production files

Implementation:

```text
hub75_tube_clamp.scad
```

Design-render adapter:

```text
hub75_tube_clamp_render.scad
```

Reusable base-clip design:

```text
lib.scad.clamps/openscad/tube-clamp/design/design.md
```

Reusable sliding-dovetail owner:

```text
lib.scad.mechint/openscad/sliding-dovetail/
```
