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

The pre-relief baseline below is the shape to preserve except for the small
lower transition-foot corners addressed later in this document.

<!-- scad-render
view: before-relief
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

| Coupler profile | Host depth | Dovetail height | Clamp body transition |
| --- | ---: | ---: | --- |
| small | 2.0 mm | 2.0 mm | fixed accepted baseline |
| medium | 3.0 mm | 2.5 mm | fixed accepted baseline |
| large | 4.0 mm | 3.0 mm | fixed accepted baseline |

Only the **dovetail interface height** changes with the selected coupler profile.
The receiving coupler material becomes correspondingly deeper/higher, but the
tube clip body itself must not be reshaped just because the dovetail height
changed.

The accepted clamp-body transition is therefore fixed across small / medium /
large. Its current baseline is the previously accepted medium connection:
approximately 10.27 mm transition width and 1.5 mm transition depth for the
normal 12 mm clamp width.

### Why the earlier size-dependent transition looked logical

The earlier implementation was not arbitrary. The dovetail root width stays
12 mm, but its **height** changes while the flank angle remains 30 degrees and
both straight lands remain 0.5 mm.

That means a taller dovetail also has a narrower mouth:

```text
mouth width
= 12
  - 2 × (dovetail height - 0.5 - 0.5) × tan(30°)
```

For the three profiles this gives approximately:

| Profile | Dovetail height | Dovetail mouth width |
| --- | ---: | ---: |
| small | 2.0 mm | 10.85 mm |
| medium | 2.5 mm | 10.27 mm |
| large | 3.0 mm | 9.69 mm |

If the clamp transition is then required to meet that mouth exactly while also
following the same 30 degree side angle, its depth must grow as the mouth moves
inward:

```text
transition depth
= ((12 - mouth width) / 2) / tan(30°)
```

which gives 1.0 / 1.5 / 2.0 mm.

So the previous behaviour had a clear geometric reason:

```text
taller dovetail
    -> narrower mouth
    -> farther inward from the 12 mm clamp face
    -> more transition depth needed to reach it at 30°
```

### Current decision: keep the clamp body fixed

For the current design we deliberately do **not** let that relationship reshape
the clamp body automatically.

The design intent is that changing coupler profile changes the available host
depth and therefore the dovetail height. The coupler/female side gets the extra
material needed for that deeper interface. The reusable tube-clip body remains
the same accepted shape.

The actual male dovetail profile and the local material relief needed so that
profile can enter its female channel may still differ by size. Those are
interface changes; they are not automatically clamp-body changes.

This is a design choice, not a claim that the earlier derived transition was
geometrically wrong. It may be reconsidered later if there is a good reason to
make the clamp transition track the active dovetail mouth again—for example
load transfer, a cleaner interface blend or print behaviour. If reconsidered,
compare small / medium / large side-by-side and treat the resulting silhouette
change as an explicit design decision rather than an incidental consequence of
the dovetail-height formula.

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

## Local transition-foot relief

The remaining sharp feature is **not** the upper point where the sloped
transition meets the circular ring. The target is the lower foot highlighted in
the design review: where the sloped transition leaves the flat
base / dovetail connection.

The current correction follows the original proposal: remove a little more
material locally so the point itself is no longer sharp.

The cutter is deliberately simple:

```text
radius = 10 mm
bite   = 1 mm
axis   = native clamp Z
       = project X
       = printer Z in the intended side-print orientation
```

In the reusable clamp's native 2D profile the target is the lower transition
vertex:

```text
x = base_thickness
y = +/- transition_width / 2
```

The R10 cutter is positioned just outside that vertex so the maximum radial bite
is about 1 mm. It is **not** centred at the upper ring/transition attach point;
that was the error in the previous iteration and produced the large missing
chunks visible in the ring.

The cutter is also shallow along its axis: 2 mm from the front face and 2 mm
from the back face. Together with the two profile sides this gives four small
local round bites instead of one through-width groove.

Its cylinder axis is native clamp Z, which maps to project X and therefore to
printer Z in the intended side-print orientation. So the round bite is vertical
for printing rather than a horizontal concave tunnel.

The tube bore, circular ring, snap opening, fixed clamp-body transition, tube
datum and dovetail geometry remain unchanged away from these four local reliefs.

The red geometry below shows only the material removed at the lower
transition-foot reliefs.

<!-- scad-render
view: relief-detail
vpr: [88, 0, 0]
vpt: [0, -4.5, 10]
vpd: 54
-->

The resulting complete clamp is:

<!-- scad-render
view: final
vpr: [65, 0, 25]
vpt: [0, -3.5, 10]
vpd: 72
-->

## Validation checklist

A candidate local relief is valid only when all of the following are true:

1. the baseline silhouette is still recognizable immediately;
2. only the lower transition-foot corners change; the upper ring attach remains
   untouched;
3. the relief-cylinder axis is native Z / project X / printer Z;
4. no horizontal concave tunnel is introduced in the side-print orientation;
5. small / medium / large retain their matching dovetails while the clamp-body
   transition remains identical;
6. functional and tension bore dimensions stay unchanged;
7. generated STL remains manifold;
8. the close-up render makes the before/after change obvious without needing
   to reconstruct the coordinate transform from source code.

## Production files

Implementation:

```text
hub75_tube_clamp.scad
```

Opening this file directly in OpenSCAD exposes standalone Customizer controls
for the coupler profile, complete/body preview, functional/tension bore and
preview resolution. This is intentionally separate from the richer design-review
adapter below.

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
