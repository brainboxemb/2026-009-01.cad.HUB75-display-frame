# HUB75 display-frame project plan

This is the forward-looking plan for the HUB75 display-frame design. It records
open design work, ordering and acceptance criteria. Completed functional history
belongs in [`CHANGELOG.md`](../CHANGELOG.md), not here.

Shared brainboxemb project/tooling behaviour is owned by
[`brainboxemb/brainboxemb.meta`](https://github.com/brainboxemb/brainboxemb.meta)
and the relevant tool repositories. This plan contains only project-specific
work.

## How to use this plan

Before starting a step:

1. inspect current source, open issues/PRs, CI and generated evidence;
2. check that the step is still the smallest sensible next step;
3. correct this plan first if a prerequisite, assumption or verification need
   has changed;
4. independent digital design may continue around an unresolved physical
   interface, but do not start dependent physical qualification or final
   integration until that earlier interface is accepted.

A step is complete only when its stated exit criteria are met. A green workflow
alone is not visual or physical acceptance.

## Current position

The core middle, horizontal-edge and corner-edge coupler families exist and are
digitally build/fit verified. Their physical panel-fit acceptance remains open
because the underlying `lib.scad.hub75` panel model still has unfinished
physical verification against real HUB75 hardware.

That does not block independent tube-mount design work as long as the panel-facing
core geometry is not silently changed. The tube-mount layer is therefore
implemented as wrappers around the existing couplers.

The older `2026-006-01.cad.HUB75-display-frame` remains historical evidence for
four useful product decisions only:

- a visible full-display debug/reference envelope;
- two continuous horizontal aluminium reinforcement tubes;
- clip positions associated with the horizontal-edge and corner couplers;
- separate tube retention as the structural function to preserve;
- rear-view data-chain presentation: panel 1 starts at the visual left in its
  default orientation, with optional panel numbering and IN/OUT annotations.

The old integrated clip geometry is not copied. The new clip consumes the base
`tube_clamp_build()` from `lib.scad.clamps` and is separately printable.

Experiment 005 investigated an OpenGrid-inspired compliant snap, but it was
stopped early because that mechanism was a poor match for the intended
side-printed clip and layer direction. It is historical evidence, not a
production prerequisite. The current product direction is the released
`lib.scad.mechint` sliding dovetail with its integral lock enabled; HUB75 owns
only placement, orientation and local carrier geometry.

`lib.scad.util` is also consumed directly. `util_section_inspect()` is the
standard helper for ordinary X/Y/Z inspection slabs in interactive and
verification views.

The current implementation track is PR #45.

## Parallel work model

```text
Track A — physical core acceptance
    lib.scad.hub75 physical panel verification
        -> Step 3 physical coupler fit
        -> Step 4 core-interface freeze

Track B — tube-mount product design
    recover old structural decisions
        -> integrate shared clamp + dovetail
        -> digital tube-mount design complete

Physical qualification gate
    core panel-fit accepted / Step 4 frozen
    AND
    tube-mount CAD is printable
        -> dovetail/clip print-fit qualification

Final integration
    core panel-fit accepted
    AND
    dovetail/clip fit accepted
        -> tube-mounted frame prototype
```

Track B may add project-owned geometry only on the rear/outside reinforcement
side of the couplers. It must not redefine the still-unfrozen HUB75 mating
surfaces.

## Step 0 — Establish project handoff and forward plan

**Status:** complete — PR #40 merged.

**Goal**

Make a fresh work session able to derive the next HUB75 project step from the
repository itself.

**Scope**

- add the project-local new-chat handoff;
- add this forward plan;
- point README/AGENTS at them;
- remove duplicated forward planning from the README.

**Exit criteria**

- #40 is merged;
- README and AGENTS make the project-plan/handoff discoverable;
- generic behaviour remains referenced from meta/tool owners rather than copied
  here.

## Step 1 — Correct alternating HUB75 panel orientation

**Status:** complete in PR #31.

**Tracking:** issue / draft PR
[#31](https://github.com/brainboxemb/2026-009-01.cad.HUB75-display-frame/pull/31)

**Goal**

Represent the intended real display arrangement in which adjacent HUB75 panels
alternate orientation, instead of rendering all five with the same orientation.

**Before implementation**

- confirm the intended physical alternation using current panel geometry/API;
- identify which panel-local features change side/orientation and which assembly
  datums must remain fixed;
- check the effect on existing middle, edge and corner coupler placement rather
  than treating this as a presentation-only rotation.

**Acceptance evidence**

- final functional PR run `35329401938` is green;
- Build and Verification publication both identify PR head
  `c953aae6ce9668c6aa4f6634d8f9fcebebfaad04`;
- `rear.png` changes only in the two alternating-panel regions: 18,828 of
  3,686,400 pixels (0.51%), with no change outside the panel area;
- front/front-angled renders remain byte-identical, as expected for the
  symmetric front face;
- middle and horizontal-edge fit-detail renders change where panel-local rear
  features move, while geometry-only mating sections remain identical where the
  global mating cross-section is preserved;
- the horizontal-edge fixture explicitly exercises the connector-heavy seam
  parity.

**Exit criteria**

PR #31 is merged and the complete display plus coupler evidence represents the
intended alternating physical layout.

## Step 2 — Digital acceptance of the core coupler family

**Status:** complete in PR #41.

**Acceptance record:** [Core coupler digital acceptance](02-core-coupler-digital-acceptance.md)

**Goal**

Finish the digital review of the panel-facing connector geometry before adding a
new structural layer.

**Reviewed**

- middle, horizontal-edge and corner families at small/medium/large sizes;
- engraved datum `+` positions against the panel geometry;
- seam, rear-fit and outside-edge sections;
- left/right corner chirality and locator-pin clearance;
- standalone printable STL geometry and the project-wide projection constraints.

**Acceptance evidence**

- production run `35330842746` is green on main commit
  `a85c3f31b508a3d761011328768d6ca99f6f3a33`;
- Build contains 12 non-empty core coupler STLs;
- Verification contains all 51 configured fit/section PNG targets;
- current OpenSCAD/CGAL output reports manifold top-level 3D objects and no
  non-manifold geometry warning was found;
- datum marks, chirality, locator clearance and projection constraints are
  traceable to current source and verification fixtures;
- no known digital panel-fit blocker remains.

**Exit criteria**

Met. The detailed evidence is kept in the acceptance record above. This does not
replace physical print-fit acceptance in Step 3.

## Step 3 — Physical fit acceptance of the core couplers

**Status:** prepared / waiting — procedures were prepared in PR #42 and physical
execution is tracked in issue
[#43](https://github.com/brainboxemb/2026-009-01.cad.HUB75-display-frame/issues/43).
Execution remains downstream of the relevant physical panel verification in
`lib.scad.hub75`.

**Procedures:** [Physical core-coupler verification](../vrf/physical/README.md)

**Goal**

Validate the core panel/coupler interfaces against real HUB75 hardware before
their geometry becomes the foundation for reinforcement.

**Minimum physical set**

- PF-01 — medium middle coupler;
- PF-02 — medium horizontal-edge coupler;
- PF-03 — medium left corner;
- PF-04 — medium right corner.

The four cases use exact existing production STL revisions and ask one physical
fit question each. Additional sizes should only be printed when a medium result
or a specific design question makes them useful.

**Check**

- insertion and removal;
- panel seam/edge seating;
- screw and mounting features;
- locator/reinforcement clearances;
- corner chirality;
- unwanted stress, rocking or interference.

**Exit criteria**

All four PF cases are executed on identified real panel samples and record
`agrees`. Any `investigate` result is resolved by a focused correction and
retest. Only then may Step 4 freeze the core interface baseline.

## Step 4 — Freeze the core coupler interface baseline

**Goal**

Create a clear boundary between accepted panel-fit geometry and the next
tube-mount layer.

**Work**

- confirm which dimensions/interfaces are now treated as the core baseline;
- ensure design documentation describes the accepted geometry;
- keep any optional cosmetic refinements separate from structural prerequisites.

**Exit criteria**

The project has a documented, digitally and physically accepted core connector
baseline from which reinforcement can be designed without reopening basic
panel-fit geometry by accident.

## Step 5 — Restore reinforcement context and shared utilities

**Status:** active in PR #45.

**Goal**

Recover only the useful structural decisions from the old frame and establish
the reusable dependencies needed by the new design.

**Work**

- restore the 840 x 360 mm debug/reference envelope around the five-panel display;
- restore the two continuous Ø10 x 1 mm-wall aluminium tubes using the
  historical structural datums explicitly:
  - tube length = 840 mm, spanning X = -420 .. +420 mm;
  - tube centres = Z = -170 mm and +170 mm (340 mm centre spacing);
  - current tube centre = 8.5 mm in front of the HUB75 rear mounting plane,
    moved 1.5 mm forward from the historical 7.0 mm datum;
  - this Ø10 placement puts the tube centre at global Y = 6.0 mm and leaves
    exactly 1.0 mm between the tube front and the panel front face;
  - tube-clip offset from a seam/corner datum = 18 mm for the small profile and
    25 mm for medium/large;
- add `lib.scad.clamps` as the source of the basic tube-clamp geometry;
- add `lib.scad.mechint v0.1.5` as the source of the sliding-dovetail mating
  profile, fit clearance and integral lock/release geometry;
- add `lib.scad.util` and use `util_section_inspect()` as the normal
  axis-aligned section mechanism;
- migrate existing verification slabs that merely duplicate that utility.

**Exit criteria**

The current assembly can independently show/hide the debug envelope, tubes and
tube-mount parts, and ordinary section views no longer need local giant-cube
slab implementations.

## Step 6 — Integrate the detachable dovetail tube clip

**Status:** active in PR #45.

**Goal**

Make the tube clip a separate printable part and attach it to the coupler with
the standard locked `lib.scad.mechint` sliding dovetail while respecting both
intended print orientations.

**Design direction**

- couplers print upside down / rear-face-down;
- the horizontal-edge tube-mount variant retains two local rounded carriers,
  one for each tube clamp;
- the corner-edge tube-mount variant keeps the accepted outer form and uses one
  subtractive interface position in the existing corner structure; no separate
  rounded mounting solid is added there. Its X datum is the existing vertical
  side-rail centre. The clamp-body keep-out is the fit-clearanced real clamp
  body swept over the same 16 mm +Z entry travel as the female entry slot, so
  the clamp can physically slide into the direct-cut female channel;
- each interface position contains one short female dovetail with project-Z slide
  direction and local +Z top entry; `lib.scad.mechint v0.1.5` supplies the
  16 mm straight female entry slot before the channel, so the complete clamp
  can park above the channel before insertion; there is no long groove through
  the coupler arm;
- the mating mechanism remains `lib.scad.mechint v0.1.5` and now uses its
  centered two-sided hinge relief. HUB75 keeps the 12 mm root / 30° profile with
  0.5 mm straight mouth and root lands plus the library's 0.20 mm fit and
  0.25 mm axial clearances. Small / medium / large use 2.0 / 2.5 / 3.0 mm
  heights, and the mouth plane is local Y = -2.0 mm. On the corner-edge variant the cutter uses
  already-existing corner guide / outer-edge material plus the rear base, so the
  full profile is formed without adding a separate carrier and the accepted
  outside form remains unchanged for all three size presets;
- integral locking and screwdriver release are enabled on the shared interface
  object now rather than being deferred as separate project-local geometry;
- the horizontal-edge variant retains its local carrier treatment; the
  corner-edge variant has no added backing lobe and uses the existing 2 / 3 /
  4 mm rear base as the host for small / medium / large;
- the integral female tongue follows the remaining host material behind the
  size-specific channel. With the mouth moved to local Y = -2.0 mm, the
  2 / 3 / 4 mm hosts retain about 1.8 / 2.3 / 2.8 mm total tongue thickness.
  The v0.1.5 opposing relief pockets leave a centered 0.8 mm flex web;
- the clamp family uses `tube_diameter = 10`, zero positive clearance,
  `tension_diameter = 9.6`, a 2.0 mm wall and 12 mm clamp width. Small /
  medium / large derive 1.0 / 1.5 / 2.0 mm transition depths from their
  2.0 / 2.5 / 3.0 mm dovetails;
  assembly/inspection renders use the nominal Ø10 bore while print geometry
  uses the Ø9.6 tension bore;
- the separate clamp is side-printed; each male dovetail keeps 0.5 mm straight
  mouth and root lands around its size-specific 30° flank. The library's
  male-relief cutter trims overlapping clamp-transition material away from the
  mating flanks. The Ø10 tube remains 1.0 mm behind the panel front face, with
  centre at global Y = 6.0 mm / local Y = -8.5 mm; the Ø14 clamp tangent stays
  at Y = -1.5 mm while the dovetail mouth overlaps 0.5 mm farther to Y = -2.0 mm;
- the actual snap clamp remains `tube_clamp_build()` from `lib.scad.clamps`;
- top/bottom placements reuse the same local top-entry clamp geometry through
  assembly rotation, while left/right corner variants reuse the same clamp and
  mechanical-interface profile.

Digital CAD clearance and section evidence may be developed now, but they are
not treated as printer/material fit acceptance.

**Exit criteria**

- horizontal-edge and corner tube-mount variants first create a continuous
  aluminium-tube keep-out without editing the panel-facing core component
  geometry;
- both variants expose local Z-axis dovetails entered from local +Z; the
  horizontal-edge variant has two structurally derived mounting positions and
  each corner variant has one;
- the clamp is independently exportable and uses the same top-entry interface;
- the complete display shows the clamp/tube load path without a core-coupler
  collision with the Ø10 tube;
- focused YZ fit and lock-section evidence makes both dovetail engagement and
  the integral retention mechanism readable;
- rear-face-down coupler and side-printed clamp orientations remain practical
  in CAD.

## Step 7 — Qualify dovetail and tube retention physically

**Status:** blocked until Step 4 core-interface freeze and Step 6 printable
output are both complete.

**Goal**

After the HUB75 panel/core interface is physically accepted, check the parts
that CAD alone cannot establish reliably: sliding fit, retention and
serviceability. Do not spend print iterations on this tube-mount interface
before that core gate is closed.

**Check**

- dovetail insertion/removal force;
- printer/material sensitivity and clearance;
- resistance to pulling the clip away from the coupler;
- integral spring-lock engagement and release with a small screwdriver;
- resistance to sliding back out of the groove while the lock is engaged;
- clamp snap force around the aluminium tube;
- side-print quality and layer direction of the separate clip;
- repeated removal without visible damage.

If the reusable lock needs tuning, adjust the smallest relevant interface
parameter and feed genuinely generic geometry changes back to
`lib.scad.mechint` rather than duplicating a project-local detent.

**Exit criteria**

A printed medium coupler/clip coupon or real coupler assembly demonstrates a
usable dovetail and tube clamp with recorded fit observations.

## Step 8 — Complete tube-mounted display-frame assembly

**Status:** follows Steps 4 and 7.

**Goal**

Combine the physically accepted core mating geometry with the qualified
tube-mount layer.

**Check**

- horizontal tube continuity and location;
- all horizontal-edge and corner clip positions;
- left/right and top/bottom transforms;
- access for installation/removal;
- useful STL/export set;
- debug/reference envelope remains presentation-only;
- full-display and local-section evidence agree.

**Exit criteria**

The complete five-panel tube-mounted assembly is digitally coherent and every
local interface is supported by focused evidence rather than only by a whole
assembly render.

## Step 9 — Full physical prototype and release candidate

**Status:** provisional.

**Goal**

Build the intended physical frame, feed findings back into the smallest owning
component and create a release candidate only after real assembly evidence is
satisfactory.

**Exit criteria**

- required physical corrections are incorporated;
- current design/build/verification documentation matches the physical baseline;
- the detachable clip system is physically usable and serviceable;
- the release scope is explicit and reproducible.

## Later ideas

Do not turn later ideas automatically into blockers. New work discovered while
executing a step should be classified as one of:

- blocker for the current interface;
- follow-up improvement;
- separate component/layer;
- cross-project tooling issue owned outside this repository.

That keeps the design sequence small and prevents reinforcement or presentation
work from hiding unresolved panel-fit problems.
