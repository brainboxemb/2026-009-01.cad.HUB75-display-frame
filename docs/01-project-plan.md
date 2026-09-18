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
4. do not start a later layer while an earlier physical interface is unresolved.

A step is complete only when its stated exit criteria are met. A green workflow
alone is not visual or physical acceptance.

## Current position

The core middle, horizontal-edge and corner-edge coupler families exist and are
digitally build/fit verified. The current README deliberately postpones
reinforcement-tube and clip geometry until the core panel/coupler interfaces are
accepted.

The next structural layer has one important design direction already identified:
the old frame proved the useful function of clips around the horizontal aluminium
reinforcement tube, but those clips were integrated into the couplers and were
therefore awkward to print. The new design should keep the tube-retention
function while making the clips separate, replaceable parts that attach to the
couplers. OpenGrid is a design reference for the detachable interface principle,
not a geometry to copy blindly. The exact groove, snap, slide or locking geometry
is still an open design question.

The coordination plan/handoff prerequisite was merged in PR #40. **Step 1 is
complete in PR #31** and **Step 2 is digitally accepted in PR #41**. Step 3
physical fit acceptance is the next project step. Reinforcement work remains
blocked until the physical core coupler interfaces are accepted and frozen.

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

**Status:** active — procedures prepared in PR #42; physical execution tracked
in issue [#43](https://github.com/brainboxemb/2026-009-01.cad.HUB75-display-frame/issues/43).

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
reinforcement layer.

**Work**

- confirm which dimensions/interfaces are now treated as the core baseline;
- ensure design documentation describes the accepted geometry;
- keep any optional cosmetic refinements separate from structural prerequisites.

**Exit criteria**

The project has a documented, digitally and physically accepted core connector
baseline from which reinforcement can be designed without reopening basic
panel-fit geometry by accident.

## Step 5 — Recover the reinforcement functional baseline

**Status:** provisional until Steps 1–4 are complete.

**Goal**

Define what must be preserved from the older reinforced frame without treating
the old integrated clip geometry as design authority.

**Use the old design only to establish**

- the horizontal aluminium tube location and orientation;
- which coupler positions retained the tube;
- how many retention points were useful;
- required tube clearance and assembly access;
- the functional load path from tube to coupler.

The old integrated clip shape itself is not the target. Its main lesson is the
required function; the new solution should be easier to print and service.

**Exit criteria**

The project has a small reference sketch/assembly and written interface
requirements that describe the required tube/coupler relationship independently
of the old integrated clip geometry.

## Step 6 — Analyse OpenGrid and design the detachable coupler interface

**Status:** provisional.

**Goal**

Understand the OpenGrid attachment principle first and then translate the useful
mechanical idea to the HUB75 couplers.

This is a design step, not an implementation of a preselected shape.

**Questions to answer**

- what geometry in OpenGrid is fixed and what geometry belongs to the removable
  part;
- how the removable part is inserted, retained and removed;
- which surfaces carry load and which features merely locate the part;
- how print direction, flexure and tolerances influence the snap/slide behaviour;
- which parts of that principle are useful for a solid HUB75 coupler rather than
  an OpenGrid panel;
- whether the HUB75 coupler should expose one common attachment feature that can
  accept several clip variants;
- whether the interface should be snap-on, slide-on, keyed, latched, screwed, or
  a combination after comparing the simplest credible concepts.

**Design target**

Prefer a small, repeatable coupler-side interface that can be added to the
middle, horizontal-edge and corner families without rebuilding the complete
coupler around the clip. The separate clip should carry the tube-clamping
profile.

A useful concept should allow the same coupler to exist:

- without a reinforcement clip;
- with the normal tube clip;
- potentially with a later alternative clip using the same coupler interface.

**Required evidence**

- a simplified OpenGrid principle drawing or section based on the actual
  mechanism being referenced;
- at least two or three HUB75 interface concepts compared at the same scale;
- print orientation and expected flex/load direction shown explicitly;
- the aluminium tube shown in its real horizontal orientation relative to the
  coupler;
- no full-frame render used as a substitute for understanding the local
  attachment interface.

**Exit criteria**

One coupler-side attachment principle is selected for prototyping, with the
reasoning, load path, insertion/removal direction, printability assumptions and
critical tolerances documented. Selecting the principle does not yet freeze the
final clip dimensions.

## Step 7 — Develop the separate aluminium-tube clip

**Status:** provisional.

**Goal**

Turn the selected interface from Step 6 into a printable, removable clip that
retains the horizontal aluminium reinforcement tube.

**Work**

- reproduce the required tube-clamping function from the old design as a
  separate part;
- derive the clip-to-coupler attachment from the selected common interface;
- keep tube clamping and coupler attachment understandable as two distinct
  functions in the geometry;
- develop only the minimum variants needed to answer real design questions;
- add focused section/fit views before propagating the feature to every coupler
  family.

**Check**

- tube diameter/clearance and insertion;
- clip retention on the coupler;
- removal/serviceability without damaging the coupler;
- print orientation and support requirements;
- flexing/stress concentration around snap or locking features;
- whether the coupler-side interface remains compact when no clip is fitted.

**Exit criteria**

A representative coupler + detachable clip + horizontal tube assembly is
digitally verified and physically prototyped sufficiently to decide whether the
attachment concept is viable.

## Step 8 — Propagate the modular clip interface across the coupler family

**Status:** provisional.

**Goal**

Apply the accepted detachable interface only where reinforcement is required,
while preserving the already accepted panel-fit geometry.

**Check**

- middle, horizontal-edge and corner placement;
- left/right chirality where relevant;
- consistent insertion/removal access;
- no collision with panel features, screws or existing guides;
- common clip geometry where practical instead of unnecessary coupler-specific
  clip variants.

**Exit criteria**

The required coupler variants expose a consistent modular attachment interface
and use the smallest sensible set of detachable tube clips.

## Step 9 — Complete reinforced display-frame assembly

**Status:** provisional.

**Goal**

Integrate all accepted connector, tube and detachable-clip parts into the full
five-panel frame.

**Check**

- complete assembly consistency;
- horizontal tube continuity and location;
- service/access clearances;
- repeated-part orientation and chirality;
- useful STL/export set;
- full-display documentation and verification views.

**Exit criteria**

The complete reinforced assembly is digitally coherent and no local interface is
being justified only by the full assembly render.

## Step 10 — Full physical prototype and release candidate

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
