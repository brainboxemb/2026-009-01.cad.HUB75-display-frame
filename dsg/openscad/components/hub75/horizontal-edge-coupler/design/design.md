# HUB75 horizontal-edge coupler — design

<!-- scad-render-defaults
engine: openscad
source: hub75_horizontal_edge_coupler_render.scad
module: hub75_horizontal_edge_coupler_design
vpr: [68, 0, 35]
vpt: [0, 0, -20]
vpd: 220
-->

## Purpose of this document

This document explains **how the horizontal-edge coupler is constructed
geometrically**. The intended reading order is the same as for the middle
coupler:

```text
physical feature or constraint
    ↓
geometric construction or change
    ↓
image that makes that change visible
    ↓
production helper/module that implements it
```

Documentation-only intermediate shapes are allowed when they make the design
easier to understand. Where that happens, the text says so explicitly and then
points to the production helper that creates the equivalent final geometry.

## Physical purpose

The horizontal-edge coupler joins two adjacent portrait HUB75 panels where their
vertical seam reaches the **top or bottom display edge**.

The production geometry is modelled once in top-edge orientation. Rotating the
part 180 degrees gives the bottom-edge use.

```text
X = 0   nominal seam between the two panels
Y = 0   HUB75 rear mounting plane
Z = 0   nominal 320 mm panel edge
```

The base extends toward positive Y. Guides and locators extend toward negative
Y into matching rear-panel geometry.

The reusable `lib.scad.hub75` model remains the authority for physical panel
rails, gaps, mounting hardware, taper and locating features. The coupler owns
only printable choices such as wall thickness, clearances and base thickness.

## Construction overview

```text
A. construct the edge T
   physical rear end rail + seam rails
       ↓
   horizontal edge arm
       ↓
   vertical seam stem
       ↓
   raw cross
       ↓
   rounded cross
       ↓
   clip away the unsupported outside stem -> T
       ↓
   extrude base

B. fit panel hardware
   screw bores
       ↓
   mounting-tube pockets
       ↓
   conditional locator-pin clearance

C. construct the guides
   physical panel keep-out
       ↓
   raw guide shell
       ↓
   soften exposed ends
       ↓
   split inward guide / outside ridge
       ↓
   taper only the panel-facing ridge edge; keep the outside wall straight
       ↓
   reinforcement reliefs
       ↓
   finished guide system
       ↓
   reinforcement pad/pin locators
       ↓
   tapered seam locator

D. finish the visible surface
   functional coupler
       ↓
   blind reference pockets
       ↓
   centre + and distance ticks
       ↓
   complete coupler
```

## Family dimensions

The same named presets are used throughout the connector family:

```text
small    profile  60 mm   wall 2 mm   guide  4 mm   base 2 mm
medium   profile  80 mm   wall 4 mm   guide  6 mm   base 3 mm
large    profile 100 mm   wall 6 mm   guide 10 mm   base 4 mm
```

The medium part remains the default design-documentation size unless a physical
feature is only visible on another preset.

## 1. Establish the physical edge reference

At the panel edge the coupler must fit around two different rear structures:

```text
horizontal
    the real HUB75 rear end rail

vertical
    left side rail
    + physical seam gap
    + right side rail
```

The nominal display edge at Z=0 is **not** the same line as the physical rear
end rail. The rear rail lies slightly inward because the real panel outline and
rear taper are not identical to the nominal 160 × 320 mm envelope.

The gray shape is the physical keep-out. Red is the same geometry expanded by
`fit_clearance`.

<!-- scad-render
view: mating-reference
vpr: [0, 0, 0]
vpt: [0, 0, -15]
-->

The production keep-out is built by:

```scad
_hub75_horizontal_edge_coupler_panel_keepout_2d(coupler)
```

The important rounded transition between the end rail and the seam rails uses
the panel-derived rear-opening radius; it is not replaced by a rectangular
approximation.

## 2. Build the horizontal edge arm

The printable horizontal arm surrounds the physical end rail.

Its height is:

```text
rear end rail width
+ fit clearance on both sides
+ printed wall on both sides
```

or:

```scad
coupler.rear_end_rail_width
+ 2 * (coupler.wall_thickness + coupler.fit_clearance)
```

The gray strip is the real rear end rail. The red strip is the printable arm
built around it.

<!-- scad-render
view: profile-horizontal-arm
vpr: [0, 0, 0]
vpt: [0, 0, -5]
-->

The production accessor is:

```scad
hub75_horizontal_edge_coupler_horizontal_arm_height(coupler)
```

The arm centre is also panel-derived:

```scad
hub75_horizontal_edge_coupler_rear_rail_center_z(coupler)
```

That second value is why the arm is visibly offset from nominal Z=0.

## 3. Build the vertical seam stem

The vertical stem surrounds the combined seam-side rear structure:

```text
left side rail
+ rear seam gap
+ right side rail
+ clearance on both outer faces
+ printed wall on both outer faces
```

The physical portion is exposed by:

```scad
hub75_horizontal_edge_coupler_seam_keepout_width(coupler)
```

and the complete printable width by:

```scad
hub75_horizontal_edge_coupler_vertical_arm_width(coupler)
```

The gray geometry is the horizontal arm already established in step 2. The red
rectangle is the newly added seam stem.

<!-- scad-render
view: profile-vertical-arm
vpr: [0, 0, 0]
vpt: [0, 0, -10]
-->

This is a documentation-only primitive. The production code does not create a
separate rectangle for the stem; it directly generates the rounded cross in
step 5 from the same derived dimensions.

## 4. Form the raw cross

Before rounding and before clipping to an edge T, the shape is easiest to
understand as:

```text
horizontal edge arm
UNION
vertical seam stem
=
raw cross
```

<!-- scad-render
view: profile-raw-cross
vpr: [0, 0, 0]
vpt: [0, 0, -10]
-->

This is deliberately an explanatory intermediate state. It has no dedicated
production module. The values used here are the same values consumed by:

```scad
_hub75_horizontal_edge_coupler_plus_profile_2d(coupler)
```

## 5. Round the complete cross

The connector family uses two radii for two different jobs:

```text
inside concave transitions   R10
free convex arm ends         R6
```

The gray shape is the raw cross from step 4. Red is the directly generated
rounded cross.

<!-- scad-render
view: profile-rounded-cross
vpr: [0, 0, 0]
vpt: [0, 0, -10]
-->

Production creates this shape as one polygon with explicit straight runs and
quarter-circle transitions:

```scad
_hub75_horizontal_edge_coupler_plus_profile_2d(coupler)
```

As with the middle coupler, the documentation decomposition is conceptual; the
production polygon is the robust implementation.

## 6. Clip the rounded cross into the top-edge T

A horizontal-edge part must not retain the outside half of the vertical stem.
The rounded cross is therefore intersected with a top-edge window that preserves:

```text
the complete horizontal arm
+
the inward vertical stem
```

while removing the unsupported outside stem.

Gray is the complete rounded cross. Red is the final printable T profile.

<!-- scad-render
view: profile-t
vpr: [0, 0, 0]
vpt: [0, 0, -10]
-->

The production operation is explicit in:

```scad
_hub75_horizontal_edge_coupler_profile_2d(coupler)
```

That module intersects `_plus_profile_2d()` with a top-edge clipping rectangle.
The outside limit of the horizontal arm itself remains derived from the real
rear rail through:

```scad
hub75_horizontal_edge_coupler_outer_projection(coupler)
```

## 7. Preserve structural material around the reinforcement clearances

The small preset uses a thinner T arm, while the physical reinforcement
bushings keep the same diameter. If the base and later guide shell are clipped
only by the nominal T, the circular bushing clearance can consume most of the
available wall.

The structural profile therefore starts with the normal T and unions a local
support envelope at each reinforcement position. Its diameter is derived from
the real clearance plus one configured wall thickness on every side:

```text
support diameter
    reinforcement outside diameter
  + 2 × reinforcement clearance
  + 2 × wall thickness
```

The image intentionally uses the **small** preset. Gray is the unchanged family
T; red is only the extra area required by the support envelope. On a wider
preset the same rule naturally adds nothing where the normal T already contains
the envelope.

<!-- scad-render
view: reinforcement-support-profile
vpr: [0, 0, 0]
vpt: [0, 0, -12]
-->

The panel-derived dimensions are exposed by:

```scad
hub75_horizontal_edge_coupler_reinforcement_relief_diameter(coupler)
hub75_horizontal_edge_coupler_reinforcement_support_diameter(coupler)
```

and production constructs the load-bearing 2D footprint with:

```scad
_hub75_horizontal_edge_coupler_reinforcement_support_envelope_2d(coupler)
_hub75_horizontal_edge_coupler_structural_profile_2d(coupler)
```

That structural profile is then extruded into the base plate:

```scad
_hub75_horizontal_edge_coupler_base_solid(coupler)
```

The normal `_hub75_horizontal_edge_coupler_profile_2d()` remains the visible
family reference shape and still clips the reference markings. The local
structural extension exists only where the physical reinforcement clearance
requires more material.

## 8. Cut the two mounting screw bores

The two seam-side screw positions are derived from the real panel mounting-hole
coordinates. At the top edge the row lands nominally 8 mm inward from Z=0.

Each Ø3.4 bore also receives the same shallow anti-elephant-foot relief used by
the middle coupler:

```text
relief depth       0.20 mm
radial widening    0.40 mm
```

<!-- scad-render
view: screw-holes
-->

The position accessor and cutter are:

```scad
hub75_horizontal_edge_coupler_screw_x_positions(coupler)
_hub75_horizontal_edge_coupler_screw_cutters(coupler)
```

The next construction state is retained explicitly as:

```scad
_hub75_horizontal_edge_coupler_base_after_screw_holes(coupler)
```

## 9. Add the blind mounting-tube pockets

The physical HUB75 mounting tubes project through the rear mounting plane. The
base therefore needs shallow panel-facing pockets around the screw bores.

Their fitted dimensions are derived as:

```scad
hub75_horizontal_edge_coupler_mounting_tube_pocket_diameter(coupler)
hub75_horizontal_edge_coupler_mounting_tube_pocket_depth(coupler)
```

<!-- scad-render
view: tube-pockets
-->

The subtraction itself is:

```scad
_hub75_horizontal_edge_coupler_mounting_tube_pocket_cutters(coupler)
```

and the resulting base state is:

```scad
_hub75_horizontal_edge_coupler_base_after_pockets(coupler)
```

The pockets remain blind; they do not replace the screw bores.

## 10. Clear the physical locator pin when the body reaches it

A real Ø3 panel locating pin lies farther inward from the top edge.

Its position and required clearance are exposed by:

```scad
hub75_horizontal_edge_coupler_locator_pin_position(coupler)
hub75_horizontal_edge_coupler_locator_pin_clearance_diameter(coupler)
```

For small and medium the T does not reach the pin, so the cutter has no effect.
The **image intentionally uses the large preset** because that is the first
preset where the body actually overlaps the physical pin. Dark gray is the
panel pin, pale gray is the base before this cut and red is the clearance cutter.

<!-- scad-render
view: locator-pin-clearance
-->

The production cutter is:

```scad
_hub75_horizontal_edge_coupler_locator_pin_clearance_cutter(coupler)
```

and the complete fitted base after all hardware clearances is:

```scad
_hub75_horizontal_edge_coupler_base_after_functional_cutters(coupler)
```

## 11. Define the guide keep-out

The raised guides must occupy the free bay around the rear rails, not the rails
themselves.

The guide subtraction therefore starts from:

```text
printable area
    final T profile

forbidden area
    real end-rail + seam-rail keep-out
    expanded by fit_clearance
```

The gray outline is the printable T. Red is only the portion of the forbidden
clearance envelope that intersects that T.

<!-- scad-render
view: guide-keepout
vpr: [0, 0, 0]
vpt: [0, 0, -15]
-->

The physical keep-out comes from:

```scad
_hub75_horizontal_edge_coupler_panel_keepout_2d(coupler)
```

and the printable expansion is the same geometric rule as elsewhere:

```scad
offset(delta = coupler.fit_clearance)
```

## 12. Subtract the keep-out to make the raw guide shell

The first guide shell is simply:

```text
final T profile
MINUS
clearance-expanded physical panel keep-out
```

<!-- scad-render
view: guide-raw-shell
vpr: [0, 0, 0]
vpt: [0, 0, -15]
-->

The production module is:

```scad
module _hub75_horizontal_edge_coupler_raw_guide_shell_2d(coupler) {
    difference() {
        _hub75_horizontal_edge_coupler_profile_2d(coupler);

        offset(delta = coupler.fit_clearance)
            _hub75_horizontal_edge_coupler_panel_keepout_2d(coupler);
    }
}
```

## 13. Soften the exposed guide ends

The raw shell can leave pointed tips where the fitted wall reaches a rounded free
end. The same small morphological opening used by the middle family removes
those points without changing the basic fitted wall location.

```text
shrink by effective guide rounding
then grow by the same amount
```

Gray is the raw shell; red is the softened shell.

<!-- scad-render
view: guide-rounded-shell
vpr: [0, 0, 0]
vpt: [0, 0, -15]
-->

The production wrapper is:

```scad
_hub75_horizontal_edge_coupler_guide_shell_2d(coupler)
```

The effective rounding is bounded by half the wall thickness so the small 2 mm
preset cannot lose its complete guide wall.

## 14. Split the guide into an inward wall and an outside ridge

The shell crosses the physical outer edge of the panel, but the two regions do
not behave identically in depth.

The production source therefore splits it at the panel-derived rear outer edge:

```text
inside-panel part   -> tall guide
outside part        -> outer ridge
```

Gray is the inward guide region. Red is the outside ridge region.

<!-- scad-render
view: guide-zones
vpr: [0, 0, 0]
vpt: [0, 0, -15]
-->

The split is represented by:

```scad
_hub75_horizontal_edge_coupler_outer_zone_2d(coupler)
_hub75_horizontal_edge_coupler_tall_guide_2d(coupler)
_hub75_horizontal_edge_coupler_outer_ridge_2d(coupler)
```

This distinction is important because only the **panel-facing edge** of the
outside ridge must follow the sloped outer panel wall.

## 15. Taper the panel-facing ridge edge while keeping the outside wall straight

The physical HUB75 outside wall moves outward in Z as Y advances from the rear
mounting plane toward the front. The printable ridge therefore needs a matching
movement on its **inside mating face**.

The exposed outside face of the coupler has no physical reason to move with that
panel taper. It remains at the fixed T-profile contour. Consequently the ridge
gets slightly thinner toward the front instead of translating as one rigid
cross-section.

```text
rear mounting plane
    fixed outside edge
    panel-facing edge at rear-panel position

front of physical taper
    same fixed outside edge
    panel-facing edge shifted outward by real HUB75 taper
```

Gray is the ridge section at the rear mounting plane. Red is the section at the
end of the physical taper. The outside contour coincides; only the panel-facing
edge has moved.

<!-- scad-render
view: guide-outer-taper
vpr: [72, 0, 35]
vpt: [0, -2, 0]
vpd: 150
-->

The physical shift is computed with:

```scad
hub75_panel_taper_shift_at_depth(
    taper_h,
    coupler.panel_taper_depth,
    coupler.panel_rear_outer_inset_z
)
```

Production applies that shift to the lower boundary of the outside-zone cutter:

```scad
_hub75_horizontal_edge_coupler_outer_ridge_2d(
    coupler,
    panel_shift_z
)
```

and constructs the 3D ridge with:

```scad
_hub75_horizontal_edge_coupler_outer_edge_ridge(coupler)
```

That module hulls the rear section and the thinner taper-end section. If the
configured guide extends beyond the physical taper depth, it continues with the
final thinner section while the outside wall remains straight. No arbitrary
`0.35 mm` shrink is used; the inside movement is entirely panel-derived.

## 16. Keep a full guide wall around the reinforcement features

Two panel reinforcement features overlap the inward raised guide. A simple
subtraction from the nominal T works for the broader presets, but in the small
preset that circular cut removes most of the raised edge.

The structural support envelope introduced in step 7 is therefore also the
starting boundary for the guide shell. The normal panel keep-out is still
subtracted first, so the locally widened guide cannot grow back into the rear
rail. The real reinforcement clearance is then removed from that supported
guide.

```text
outer support radius
    physical reinforcement radius
  + reinforcement clearance
  + wall thickness

inner cleared radius
    physical reinforcement radius
  + reinforcement clearance
```

This guarantees the requested wall thickness around the circular clearance
where free space exists. It is not a `small` special case: if a wider T already
contains the support envelope, the union leaves its outside contour unchanged.

The first image shows the production Boolean construction: gray is the
unrelieved supported guide and red is the pair of cylindrical removal volumes.

<!-- scad-render
view: guide-reinforcement-reliefs
alt: Horizontal-edge supported guide and reinforcement relief construction
-->

The second image explains the physical reason at one location. Dark gray is the
panel reinforcement, light gray the still-unrelieved supported guide,
transparent red the required clearance band and bright red the guide material
that must be removed.

<!-- scad-render
view: guide-reinforcement-detail
alt: Horizontal-edge HUB75 reinforcement and supported guide clearance detail
size: [480, 360]
-->

Production uses the shared relief diameter:

```scad
hub75_horizontal_edge_coupler_reinforcement_relief_diameter(coupler)
```

and performs the final cylindrical subtraction inside:

```scad
_hub75_horizontal_edge_coupler_guide_walls(coupler)
```

using panel-derived positions from:

```scad
_hub75_horizontal_edge_coupler_reinforcement_positions(coupler)
```

The documentation adapter retains a named explanatory cutter only to visualize
this embedded production Boolean.

## 17. Extrude the finished guide system

The inward guide is extruded straight to the configured `guide_height`. The
outside ridge uses the construction from step 15: its panel-facing edge follows
the physical taper while its exposed outside wall remains straight.

<!-- scad-render
view: guides
-->

The two production modules are:

```scad
_hub75_horizontal_edge_coupler_guide_walls(coupler)
_hub75_horizontal_edge_coupler_outer_edge_ridge(coupler)
```

The inward guide stays straight because its mating bay/crossbar boundaries are
vertical in Y. On the outside ridge only the mating face changes with depth;
there is no reason for the complete printed wall to lean outward with the panel.

## 18. Add the two reinforcement pad/pin locators

Inside the relieved areas the coupler adds positive two-stage locators. Their
sizes are derived from the physical panel recess and blind centre hole after
print clearance:

```scad
hub75_horizontal_edge_coupler_reinforcement_locator_pad_diameter(coupler)
hub75_horizontal_edge_coupler_reinforcement_locator_pad_height(coupler)
hub75_horizontal_edge_coupler_reinforcement_locator_pin_diameter(coupler)
```

<!-- scad-render
view: reinforcement-locators
-->

One pad/pin stack is built by:

```scad
_hub75_horizontal_edge_coupler_reinforcement_locator(coupler)
```

and both panel positions are populated by:

```scad
_hub75_horizontal_edge_coupler_reinforcement_locators(coupler)
```

## 19. Add the tapered seam locator

The central locator enters the real gap between the two panels.

At Y=0 its width is:

```scad
hub75_horizontal_edge_coupler_seam_locator_width(coupler)
```

At insertion depth the available width narrows by twice the panel-derived X
taper shift:

```scad
hub75_horizontal_edge_coupler_seam_locator_width_at_depth(
    coupler,
    depth
)
```

<!-- scad-render
view: seam-locator
-->

The 3D production geometry is:

```scad
_hub75_horizontal_edge_coupler_seam_locator(coupler)
```

It hulls the rear and taper-end sections and keeps the final narrow width beyond
the real taper region. The previous fixed `0.20 mm per side` lead-in is therefore
no longer part of the design.

## 20. The complete functional coupler

At this point every feature required for panel fit exists and no visual reference
engraving has yet been added.

<!-- scad-render
view: functional
-->

The explicit production composition is:

```scad
_hub75_horizontal_edge_coupler_functional_build(coupler)
```

It combines:

```scad
_hub75_horizontal_edge_coupler_base_after_functional_cutters(coupler)
_hub75_horizontal_edge_coupler_guide_walls(coupler)
_hub75_horizontal_edge_coupler_outer_edge_ridge(coupler)
_hub75_horizontal_edge_coupler_reinforcement_locators(coupler)
_hub75_horizontal_edge_coupler_seam_locator(coupler)
```

## 21. Add the blind reference pockets

The visible rear face receives the same family reference pockets:

```text
visible diameter      Ø3.0 mm
maximum depth          2.0 mm
minimum back wall      0.7 mm
final taper             0.5 mm
bottom diameter        Ø2.0 mm
pitch                  10.0 mm
```

The pattern starts from a symmetric virtual reference cross and is then clipped
by the real asymmetric T. That makes missing rows informative rather than hiding
the relationship between nominal edge and physical rear rail.

<!-- scad-render
view: reference-pockets
vpr: [68, 0, 215]
-->

The depth rules are exposed by:

```scad
hub75_horizontal_edge_coupler_reference_pocket_effective_depth(coupler)
hub75_horizontal_edge_coupler_reference_pocket_straight_depth(coupler)
```

The final subtraction is:

```scad
_hub75_horizontal_edge_coupler_reference_pocket_cutters(coupler)
```

## 22. Add the nominal-edge `+` and distance ticks

The `+` is exactly the nominal intersection:

```text
X = 0   panel seam
Z = 0   nominal display edge
```

Ticks are generated every 5 mm, with longer marks at complete centimetres. The
real T clips unsupported marks and screw keep-outs remove engraving near the
structural bores.

<!-- scad-render
view: center-marks
vpr: [68, 0, 215]
-->

The 2D mark construction is:

```scad
_hub75_horizontal_edge_coupler_center_marks_2d(coupler)
```

and the shallow 3D cutter is:

```scad
_hub75_horizontal_edge_coupler_center_mark_cutters(coupler)
```

The generated image intentionally shows the already-cut pockets as part of the
gray previous state; only the newly introduced marks are red.

## 23. Complete horizontal-edge coupler

The public build combines the functional geometry and both surface-detail
layers.

<!-- scad-render
view: final
-->

The public API is:

```scad
coupler = hub75_horizontal_edge_coupler_create();
hub75_horizontal_edge_coupler_build(coupler);
```

## Fit verification

The focused two-panel fixture is:

```text
dsg/openscad/assemblies/verification/horizontal_edge_coupler_fit_assembly.scad
```

Verification views cover the local fit, a **0.10 mm rear-facing slice** through
the selected insertion depth, and a Y/Z outer-edge section. The thin rear slice
cuts both sides of the section instead of retaining everything in front of one
plane; this makes the actual red/gray mating contours readable even where the
physical panel wall is sloped.

These views answer a different question from this document:

```text
design.md
    How is the T coupler constructed and why?

verification evidence
    Does that construction fit the authoritative HUB75 panel geometry?
```

## Deferred

The aluminium reinforcement tube and its C-clips remain intentionally outside
this stage. They should be added only after the T body and panel fit remain
understood and verified with the construction above.
