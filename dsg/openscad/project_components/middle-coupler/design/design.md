# HUB75 middle coupler — design

<!-- scad-render-defaults
engine: openscad
source: hub75_middle_coupler_render.scad
module: hub75_middle_coupler_design
vpr: [68, 0, 35]
-->

## Purpose of this document

This document explains **how the middle coupler is constructed geometrically**.
It is intentionally written so the physical design can be followed without
already knowing OpenSCAD.

The order used here is therefore:

```text
physical interface
    ↓
geometry needed around that interface
    ↓
visible construction step
    ↓
relevant implementation detail
```

The production source does not always use the same primitive-by-primitive
sequence shown in the explanatory images. For example, the rounded PLUS outline
is generated directly as one polygon because that is robust and efficient. The
design views first show the simpler rectangles and rounding concept because that
makes the physical shape understandable.

## Physical purpose

The middle coupler joins **two portrait HUB75 panels at their vertical seam** on
the middle mounting-hole row.

The local component origin is physical and explicit:

```text
X = 0
    nominal vertical seam between the two panels

Y = 0
    panel-facing surface of the coupler base
    and therefore the HUB75 rear mounting plane when assembled

Z = 0
    middle HUB75 mounting-hole row
```

The base plate extends toward positive Y, away from the panel. Guides and
locators extend toward negative Y, into matching features on the rear of the
panels.

The reusable `lib.scad.hub75` model is the authority for the panel geometry. The
coupler owns only printable choices such as wall thickness, clearance and base
thickness.

## Construction overview

The complete middle coupler can be understood as four layers of design work:

```text
A. establish the printable PLUS body
   physical rear rib cross
       ↓
   horizontal arm
       ↓
   vertical arm
       ↓
   raw PLUS
       ↓
   rounded PLUS
       ↓
   extruded base

B. make the base fit the panel hardware
   screw bores
       ↓
   shallow screw reliefs
       ↓
   mounting-tube pockets

C. add positive panel-location geometry
   rib keep-out
       ↓
   raw guide shell
       ↓
   rounded guide ends
       ↓
   reinforcement reliefs
       ↓
   raised guides
       ↓
   reinforcement pad/pin locators
       ↓
   tapered seam locator

D. add non-mating reference detail
   blind reference pockets
       ↓
   centre + and distance marks
       ↓
   complete coupler
```

The design images follow this order.

## Main printable choices

The current medium coupler uses:

```text
profile size        80 mm
wall thickness       4 mm
fit clearance      0.25 mm per side
base thickness       3 mm
guide height         6 mm
inside radius       10 mm
outside radius       6 mm
guide end rounding  1.5 mm
seam locator radius  1.0 mm
render resolution   192 facets per full circle
```

Panel-derived dimensions are deliberately not copied into the project as fixed
constants.

With the current HUB75 panel definition they produce approximately:

```text
horizontal PLUS arm   28.482 mm
vertical PLUS arm     33.800 mm
screw centres         -8 / +8 mm
rear seam gap          2.795 mm
rear seam locator      2.295 mm before depth taper
```

Those values are consequences of the panel mating API plus the configured print
clearance and wall thickness.

## 1. The physical rear-rib reference

Before making any printable geometry, the coupler needs to know what it must fit
around.

At the middle seam the two panels present a cross-shaped rear structure:

```text
horizontal part
    HUB75 rear crossbar at the middle mounting row

vertical part
    left panel side rail
    + physical gap between panels
    + right panel side rail
```

The gray shape in the image is this real panel keep-out. The red shape is the
same keep-out expanded by the configured `fit_clearance`.

<!-- scad-render
view: mating-reference
vpr: [0, 0, 0]
-->

The rounded regions at the four internal corners are important. The HUB75 rear
bays are not sharp rectangles, so the keep-out includes the real rounded
rib-to-bay transition from `lib.scad.hub75`.

The relevant production helper is:

```scad
_hub75_middle_coupler_rib_cross_keepout_2d(coupler)
```

and printable clearance is applied geometrically with:

```scad
offset(delta = coupler.fit_clearance)
```

## 2. Build the horizontal arm

The first printable part is the horizontal arm around the panel crossbar.

Its height is not an arbitrary PLUS dimension. It is exactly:

```text
physical rear crossbar width
+ fit clearance above
+ printed wall above
+ fit clearance below
+ printed wall below
```

or:

```scad
coupler.rear_crossbar_width
+ 2 * (coupler.fit_clearance + coupler.wall_thickness)
```

The arm extends across the selected `profile_size` in X.

In the image the gray strip is the actual crossbar thickness and the red strip
is the printable horizontal arm built around it.

<!-- scad-render
view: profile-horizontal-arm
vpr: [0, 0, 0]
-->

The public derived-dimension accessor is:

```scad
hub75_middle_coupler_horizontal_arm_height(coupler)
```

For the current medium part this yields approximately `28.482 mm`.

## 3. Build the vertical arm

The vertical arm surrounds the meeting side rails and the seam between the two
panels.

First define the physical width that may not be occupied by the guide wall:

```text
left rear side rail
+ rear seam gap
+ right rear side rail
```

The source exposes that combined physical keep-out as:

```scad
hub75_middle_coupler_seam_keepout_width(coupler)
```

The printable vertical arm adds clearance and wall material on both outside
faces:

```text
physical seam keep-out
+ 2 × fit clearance
+ 2 × wall thickness
```

or:

```scad
hub75_middle_coupler_seam_keepout_width(coupler)
+ 2 * (coupler.fit_clearance + coupler.wall_thickness)
```

The gray geometry in the image is the already established horizontal arm. The
red rectangle is the new vertical arm.

<!-- scad-render
view: profile-vertical-arm
vpr: [0, 0, 0]
-->

For the current medium part the vertical arm is approximately `33.800 mm` wide.

## 4. The raw PLUS

Combining the two arms gives the simplest possible coupler outline:

```text
horizontal rectangle
UNION
vertical rectangle
=
raw PLUS
```

<!-- scad-render
view: profile-raw-plus
vpr: [0, 0, 0]
-->

This raw shape already has the correct physical arm thicknesses. What it does
not yet have is the approved rounded connector language.

It is useful to separate these concerns:

```text
arm dimensions   -> come from panel geometry + print wall/clearance
corner radii     -> are printable coupler design choices
```

## 5. Round the PLUS profile

Two different kinds of corners are rounded for different reasons.

### Concave arm transitions

Where the horizontal and vertical arms meet, the four inward corners receive the
configured `inside_corner_radius`, currently `10 mm`.

These broad internal transitions reduce the abrupt notch of a sharp PLUS and
match the approved coupler form.

### Convex free ends

The eight outside corners at the four arm ends use the smaller
`outside_corner_radius`, currently `6 mm`.

The gray shape below is the raw PLUS. The red shape is the final rounded 2D
profile. Gray remnants therefore show material removed by the rounding.

<!-- scad-render
view: profile-rounded
vpr: [0, 0, 0]
-->

The production source does **not** create two rectangles and then run a generic
rounding operation. It generates the final outline directly as a polygon made
from straight segments and twelve quarter-circle transitions:

```scad
_hub75_middle_coupler_profile_2d(coupler)
```

That implementation keeps the inside and outside radii independently
controlled. Its arc segment count is derived from `coupler.render_fn`; with the
default `192`, each quarter circle uses 48 segments.

The conceptual rectangle sequence and the production polygon therefore describe
the same shape at different levels:

```text
design explanation    two orthogonal arms + two classes of rounding
production geometry   one explicitly generated high-resolution polygon
```

## 6. Extrude the 2D profile into the base plate

The completed 2D PLUS is now given thickness.

The local panel-facing surface is Y=0. The base extends away from the panels to
positive Y:

```text
Y = 0                 panel-facing surface
Y = base_thickness    visible rear surface
```

For the medium part the extrusion is therefore 3 mm.

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

At this stage the part is one solid plate with no holes, pockets, guides or
locators.

## 7. Derive and cut the two screw bores

The screw centres come from the actual panel mounting-hole coordinates, not from
a project-owned `±8 mm` constant.

Conceptually the two panels are placed at their nominal pitch on either side of
the seam. The seam-side mounting hole of each panel then becomes a local coupler
coordinate:

```text
left panel seam-side screw   -> X ≈ -8 mm
right panel seam-side screw  -> X ≈ +8 mm
Z = 0 for both
```

The helper that performs this coordinate derivation is:

```scad
_hub75_middle_coupler_seam_screw_x_positions(panel)
```

The nominal through bore is Ø3.4 mm.

The same cutter also includes a shallow anti-elephant-foot relief at both plate
faces:

```text
through bore          Ø3.40 mm
relief widening       +0.40 mm radially
relief diameter       Ø4.20 mm
relief depth           0.20 mm
```

This is a short cylindrical widening only. It is not a countersink and it does
not change the functional screw bore.

The red geometry below is the complete subtraction volume.

<!-- scad-render
view: screw-holes
-->

## 8. Add blind mounting-tube pockets

The panel has a cylindrical mounting tube around each screw hole. The tube
projects beyond the HUB75 rear mounting plane, so a flat coupler base would hit
it before seating.

A shallow pocket is therefore cut into the **panel-facing side** of the base.

Its diameter is:

```text
physical tube outside diameter
+ radial print clearance on both sides
```

and its depth is:

```text
physical tube projection
+ axial print clearance
```

Both physical dimensions come from `lib.scad.hub75`.

```scad
hub75_middle_coupler_mounting_tube_pocket_diameter(coupler)
hub75_middle_coupler_mounting_tube_pocket_depth(coupler)
```

<!-- scad-render
view: tube-pockets
-->

The pocket must remain blind. The build asserts that its depth is smaller than
the base thickness.

## 9. Define the guide keep-out

The raised guides must enter the open spaces beside the panel ribs; they must
not sit on top of the rear rib cross.

The guide construction therefore starts with two areas:

```text
printable area
    = rounded PLUS profile

forbidden area
    = real HUB75 rear rib cross
      expanded by fit_clearance
```

The gray shape is the available PLUS footprint. The red shape is the forbidden
clearance envelope that must be removed from it.

<!-- scad-render
view: guide-keepout
vpr: [0, 0, 0]
-->

This step is important because it makes the guide geometry traceable directly to
the panel model. If the HUB75 rib dimensions or bay-corner radius change, the
keep-out changes with them.

## 10. Subtract the keep-out to make the raw guide shell

The first guide outline is simply:

```text
rounded PLUS profile
MINUS
(clearance-expanded physical rib cross)
=
raw guide shell
```

In source form:

```scad
module _hub75_middle_coupler_raw_guide_shell_2d(coupler) {
    difference() {
        _hub75_middle_coupler_profile_2d(coupler);

        offset(delta = coupler.fit_clearance)
            _hub75_middle_coupler_rib_cross_keepout_2d(coupler);
    }
}
```

<!-- scad-render
view: guide-raw-shell
vpr: [0, 0, 0]
-->

This creates printed material beside the physical ribs. At the free ends of the
PLUS arms, however, the intersection between rounded outer profile and keep-out
can still leave pointed guide tips.

## 11. Soften the exposed guide ends

The raw guide shell receives a small 2D morphological opening:

```text
shrink by guide_end_rounding
then
grow by the same amount
```

In OpenSCAD:

```scad
offset(r = effective_rounding)
    offset(delta = -effective_rounding)
        _hub75_middle_coupler_raw_guide_shell_2d(coupler);
```

This removes tiny pointed ends without changing the basic wall placement.

The configured medium/large value is `1.5 mm`, but the effective radius is
limited so it can never consume an entire thin guide wall. That matters for the
small preset with only 2 mm wall thickness.

The gray shell is the raw result. The red shell is the softened version.

<!-- scad-render
view: guide-rounded-shell
vpr: [0, 0, 0]
-->

## 12. Reserve space around the reinforcement features

Two circular reinforcement features on the panel occupy regions that overlap the
raised guide area.

Before the guide can be finalised, cylindrical reliefs are therefore removed
around those physical footprints.

The relief diameter is:

```text
panel reinforcement outside diameter
+ 2 × reinforcement clearance
```

First keep the normal **coupler construction view**. The gray volume is the
still-unrelieved guide shell; the two red cylinders are the material-removal
volumes used at the two reinforcement positions.

<!-- scad-render
view: guide-reinforcement-reliefs
alt: Full coupler guide reinforcement relief construction
-->

That overview shows *what changes on the coupler*, but by itself it does not
explain *why those two circular cuts are needed*. The second image therefore
zooms into one of the two identical physical interfaces.

In the close-up:

```text
dark gray        physical HUB75 side-rail reinforcement
light gray       guide before the relief is cut
transparent red  required clearance around the reinforcement
bright red       guide material that intrudes into that clearance
```

The panel fragment is reconstructed only from dimensions already captured from
`lib.scad.hub75`; it introduces no duplicate panel measurements. The same relief
operation is applied at the mirrored reinforcement position on the other panel.

<!-- scad-render
view: guide-reinforcement-detail
alt: HUB75 reinforcement and guide clearance detail
size: [480, 360]
-->

The two images intentionally answer two different questions: the first preserves
the step-by-step coupler construction sequence, while the second makes the
physical reason for the operation understandable before reading the surrounding
text.

## 13. Extrude the finished raised guides

The final 2D guide shell is extruded from the mounting plane toward the panel:

```text
Y = 0
    ↓
Y = -guide_height
```

For the medium coupler that is 6 mm into the rear panel geometry.

The reinforcement relief cylinders are subtracted from this extrusion.

```scad
module _hub75_middle_coupler_guide_walls(coupler) {
    difference() {
        _hub75_middle_coupler_extrude_xz_y(
            -coupler.guide_height,
             _HUB75_MIDDLE_COUPLER_EPS
        )
            _hub75_middle_coupler_guide_shell_2d(coupler);

        _hub75_middle_coupler_reinforcement_relief_cutters(coupler);
    }
}
```

<!-- scad-render
view: guides
-->

These large guide walls deliberately remain straight through their insertion
depth. Their mating bay/crossbar boundaries are vertical in Y. Although the
panel outside wall widens toward the front, the adjacent seam narrows by the
same amount, so the combined side-rail/seam keep-out seen by these guides stays
constant.

## 14. Add the reinforcement pad/pin locators

The guide reliefs created empty circular areas around two panel reinforcement
features. Inside those clear areas the coupler now adds positive locating
geometry.

Each panel feature contains:

```text
large circular recess   Ø10.0 mm × 2.5 mm deep
small blind centre hole Ø2.5 mm
```

The coupler creates a two-stage mating locator after printable clearance:

```text
large pad
    Ø9.4 mm × 2.4 mm

small pin
    Ø2.1 mm × 2.0 mm
```

The pad gives broad radial location. The smaller pin then enters the blind centre
hole.

<!-- scad-render
view: reinforcement-locators
-->

The physical panel dimensions come from the reusable HUB75 API. Only the radial
and axial clearances are coupler-owned design choices.

## 15. Add the seam locator

The central seam is a different mating interface from the large rib guides.

A narrow locator enters the actual gap between the two panels. At the rear
mounting plane its width is:

```text
rear seam gap
- clearance on left
- clearance on right
```

or:

```scad
rear_seam_gap - 2 * fit_clearance
```

For the current panel and medium clearance this is approximately `2.295 mm`.

Unlike the large guides, this locator **must follow the panel X taper**. As the
locator moves toward the panel front, both adjacent panel side walls move toward
the seam.

Its available width at insertion depth is therefore:

```text
rear locator width
- taper shift from left panel
- taper shift from right panel
```

or:

```text
base width - 2 * panel_taper_shift_at_depth
```

The production geometry forms a hull between the wider rear section and the
narrower section at the end of the panel taper. If the configured locator is
deeper than the taper region, the remaining depth continues at the final narrow
width.

<!-- scad-render
view: seam-locator
-->

This replaces the older arbitrary `0.20 mm per side` taper with geometry derived
from the real HUB75 panel.

## 16. The complete functional coupler

At this point all geometry required for mechanical fit exists:

```text
base plate
+ raised rib guides
+ reinforcement pad/pin locators
+ tapered seam locator
-
mounting screw bores
-
mounting-tube pockets
```

No visible reference pattern has been added yet.

<!-- scad-render
view: functional
-->

Keeping this as an explicit design stage is intentional. It separates
**mechanical mating geometry** from markings that exist only to aid inspection
and measurement.

## 17. Add the blind reference pockets

The visible rear face receives the small circular pockets retained from the
approved coupler design language.

Default geometry:

```text
visible diameter      3.0 mm
maximum total depth   2.0 mm
minimum back wall     0.7 mm
taper depth           0.5 mm
bottom diameter       2.0 mm
pitch                10.0 mm
stations             20 / 30 / 40 mm from the centre
```

Only the final 0.5 mm tapers from Ø3 to Ø2. The visible portion therefore stays
cylindrical rather than becoming a cone.

The effective depth is limited by base thickness so at least the configured
minimum back wall remains:

```text
small   2.0 mm base -> 1.3 mm pocket -> 0.7 mm remains
medium  3.0 mm base -> 2.0 mm pocket -> 1.0 mm remains
large   4.0 mm base -> 2.0 mm pocket -> 2.0 mm remains
```

Pocket lanes are derived from approximately one quarter of the real arm
thickness and snapped to a 2.5 mm reference grid. Two symmetric lanes are used
only when they fit safely in both arms.

<!-- scad-render
view: reference-pockets
vpr: [68, 0, 215]
-->

## 18. Add the centre + and distance ticks

The final visible reference layer marks the component datum and gives a local
scale.

At the exact component origin a `+` identifies:

```text
X = 0   nominal panel seam
Z = 0   middle mounting-hole row
```

Ticks are placed every 5 mm:

```text
5 mm   minor tick   2.2 mm long
10 mm  major tick   4.0 mm long
width               0.8 mm
depth               0.40 mm
centre +            6.0 mm
```

The marks are clipped to an inset of the real rounded PLUS profile and a keep-out
is applied around the structural screw holes.

<!-- scad-render
view: center-marks
vpr: [68, 0, 215]
-->

## 19. Complete middle coupler

The public build combines the mechanical part and the two reference-detail
layers:

```scad
coupler = hub75_middle_coupler_create();
hub75_middle_coupler_build(coupler);
```

<!-- scad-render
view: final
-->

The public object contains both printable design choices and panel-derived mating
values captured through `lib.scad.hub75`. Project code must not read private
panel-object internals or duplicate those panel dimensions.

## Size presets

The same construction is used for all three approved presets:

```text
small    profile  60 mm   wall 2 mm   guide  4 mm   base 2 mm
medium   profile  80 mm   wall 4 mm   guide  6 mm   base 3 mm
large    profile 100 mm   wall 6 mm   guide 10 mm   base 4 mm
```

Only the selected printable dimensions change. The relationship to the actual
HUB75 mating geometry remains derived from the same panel object.

## Fit verification

A component is not accepted merely because the standalone geometry looks
correct.

The focused two-panel development fixture is located at:

```text
dsg/openscad/assemblies/verification/middle_coupler_fit_assembly.scad
```

The verification entrypoints produce three complementary views:

```text
rear-fit-section
    primary interference/clearance check through real panel rear structure

xy-seam-section
    true section through the seam locator and panel depth

fit-detail
    angled local context around the two-panel seam
```

In the rear-fit section, neutral gray is real HUB75 panel structure and red is
coupler material entering the same retained volume. The blue datum pin passes
through the engraved `+` so the nominal seam/mounting-row origin remains visible
through the section.

The verification layer therefore answers a different question from this design
document:

```text
design.md
    How is the coupler constructed and why?

verification evidence
    Does that construction actually fit the authoritative panel geometry?
```

Both are required before the component is treated as physically understood.