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
digitally build/fit verified. Their physical acceptance is not ready to close
yet, because the underlying `lib.scad.hub75` panel model still has unfinished
physical verification against real HUB75 hardware.

That changes the sequencing. Physical panel/coupler acceptance remains a hard
gate before the panel-facing coupler interface can be frozen, but it does not
need to block independent research into a detachable reinforcement attachment.

The next structural layer has one important design direction already identified:
the old frame proved the useful function of clips around the horizontal aluminium
reinforcement tube, but those clips were integrated into the couplers and were
therefore awkward to print. The new design should keep the tube-retention
function while making the clips separate, replaceable parts that attach to the
couplers.

OpenGrid is a design reference for the detachable interface principle, not a
geometry to copy blindly. Initial source inspection now puts
`AndyLevesque/QuackWorks` first for this PoP: its
`openGrid/opengrid-snap.scad` is a dedicated 24.8 mm removable OpenGrid snap
with compliant click geometry and optional directional retention, while
`openGrid/openGrid.scad` provides the fixed receiving board geometry. That
fixed-side/removable-side split is much closer to the intended HUB75 attachment
problem than tile-to-tile connectors.

`jp-embedded/opengrid` remains a useful comparison source for alternative
snap/socket and lock mechanisms. `dnnsmnstrr/connector-foundry` is also a
valuable verification reference because it wraps the QuackWorks OpenGrid board
and snap as externally sourced parts and checks reference shape/fit behaviour.

QuackWorks is licensed CC BY-NC-SA 4.0 at repository level and its snap source
contains additional licensing wording. The PoP must therefore keep source
provenance and licensing explicit and distinguish studying/qualifying the
mechanical principle from directly copying that implementation into production.

The coordination plan/handoff prerequisite was merged in PR #40. **Step 1 is
complete in PR #31** and **Step 2 is digitally accepted in PR #41**. Step 3 is
prepared but waiting on the physical panel-verification baseline. In parallel,
Step 5 may now establish the detachable-attachment PoP. Production integration
of that result remains blocked until Steps 3 and 4 are complete.

## Parallel work model

Two project tracks may now progress independently:

```text
Track A — physical core acceptance
    lib.scad.hub75 physical panel verification
        -> Step 3 physical coupler fit
        -> Step 4 core-interface freeze

Track B — detachable reinforcement research
    Step 5 PoP environment
        -> Step 6 principle / requirement analysis
        -> Step 7 detachable clip qualification

Integration gate
    Step 4 complete
    AND
    Step 7 qualified
        -> Step 8 production coupler integration
```

Track B must use neutral or surrogate attachment geometry while Track A is open.
It may qualify insertion, retention, printability, flexure, tolerances and the
tube-clamp concept, but it must not silently redefine the still-unfrozen
panel-facing HUB75 mating geometry.

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
reinforcement layer.

**Work**

- confirm which dimensions/interfaces are now treated as the core baseline;
- ensure design documentation describes the accepted geometry;
- keep any optional cosmetic refinements separate from structural prerequisites.

**Exit criteria**

The project has a documented, digitally and physically accepted core connector
baseline from which reinforcement can be designed without reopening basic
panel-fit geometry by accident.

## Step 5 — Establish the detachable-attachment PoP environment

**Status:** active in parallel with Track A preparation; tracked by issue #44.

**Goal**

Create a controlled experiment environment for the removable coupler/clip
interface without depending on unresolved HUB75 panel-fit geometry.

**Repository model**

Use three separate repository roles:

1. external-source fork — retained OpenGrid/OpenSCAD source and upstream
   provenance;
2. dedicated experiment/PoP repository — neutral fixtures, adapters, candidate
   attachment geometry, testcases and evidence;
3. this HUB75 project — production owner that consumes only a qualified design
   decision later.

The fork is not the experiment repository, and this project should not develop
the PoP directly in production coupler source.

**External-source candidates**

Primary mechanism reference after inspection:

```text
upstream: AndyLevesque/QuackWorks
baseline: e0c1cb7ec78dd9e9a8476ed739bd3402074354f3
files:
  openGrid/openGrid.scad
  openGrid/opengrid-snap.scad
repository license: CC BY-NC-SA 4.0
```

Why it is first:

- the board/cell is the fixed receiver and `openGridSnap()` is the removable
  part;
- the snap is a compact 24.8 mm square insert rather than a whole tile;
- retention comes from small perimeter nubs plus compliant click-hole regions;
- a directional mode demonstrates asymmetric retention without changing the
  overall fixed receiver;
- the recent repository history includes fixes specifically for printable snap
  connectivity.

Comparison/reference sources:

```text
jp-embedded/opengrid
  alternative tile snap/socket + lock mechanisms
  GPL-3.0

dnnsmnstrr/connector-foundry
  wraps QuackWorks board/snap
  reference-shape + assembled-fit verification model
  own code MIT; OpenGrid wrapper retains upstream CC BY-NC-SA terms

openGrid-3D/openGrid-openSCAD
  official ecosystem/OpenGrid reference
  currently less complete for this particular removable-snap question
```

Step 5 should not lock the fork source until the QuackWorks licensing/provenance
and the exact snap/receiver dependency are recorded. If QuackWorks remains the
chosen source, the planned fork name under the proposed generic convention is
`brainboxemb/fork.andylevesque.quackworks`.

**Planned experiment repository**

```text
brainboxemb/exp.2026-005.scad-detachable-clip-interface
```

The experiment should pin the selected fork/source revision explicitly and keep
ordered supporting documents under `docs/00-...`, `docs/01-...`, and so on,
following the generic PoP model in `brainboxemb.meta`.

**Exit criteria**

- the source survey records why the selected OpenGrid implementation is the
  right mechanical reference;
- the external source fork exists with clear upstream provenance;
- the experiment repository exists with a minimal reproducible SCAD fixture;
- the exact upstream/fork revision and license are recorded;
- the PoP can render/export a neutral fixed-side + removable-side attachment
  coupon without importing HUB75 panel mating geometry.

## Step 6 — Recover requirements and analyse the detachable principle

**Status:** may start once Step 5 has a reproducible fixture.

**Goal**

Separate the *function* required by the HUB75 frame from the *mechanism*
demonstrated by OpenGrid before designing a production interface.

**Recover from the older HUB75 frame**

Use the old design only to establish:

- horizontal aluminium tube location and orientation;
- which coupler positions retained the tube;
- how many retention points were useful;
- required tube clearance and assembly access;
- functional load path from tube to coupler.

The old integrated clip shape itself is not design authority.

**Analyse from OpenGrid/OpenSCAD**

At minimum inspect the relevant snap/lock implementation and document:

- fixed-side versus removable-side geometry;
- insertion and removal direction;
- locating surfaces versus load-carrying surfaces;
- compliant/flexing regions;
- retention/locking features;
- print direction assumptions;
- nominal part gap / clearance strategy;
- behaviour that is essential to the principle versus geometry specific to the
  28 mm OpenGrid tile.

Do not copy a complete OpenGrid tile into the HUB75 design merely because it is
available.

**Concept comparison**

Use the PoP fixture to compare the smallest credible concepts only when a real
design question requires it, for example:

- direct snap-in;
- short slide/key + retention detent;
- keyed slide with separate lock;
- another concept only if the first principles expose a concrete need.

**Exit criteria**

One attachment principle is selected for prototyping, with its load path,
insertion/removal direction, expected flexure, tolerances, print orientation and
reasons documented independently of the HUB75 coupler body.

## Step 7 — Qualify the detachable aluminium-tube clip in the PoP

**Status:** provisional until Step 6 selects a principle.

**Goal**

Prove that the selected removable interface can carry a separate printable clip
for the horizontal aluminium reinforcement tube before touching production
couplers.

**PoP fixture**

Use a neutral coupler-side coupon plus a removable clip-side coupon. Add the real
tube diameter/orientation only after the attachment interface itself is readable
and testable.

Keep these functions distinct:

```text
fixed attachment interface
        +
removable attachment interface
        +
tube-clamping profile
```

**Check**

- insertion/removal direction and required access;
- retention under representative pull/shear directions;
- print orientation and support requirements;
- flexing/stress concentration around snap or locking features;
- dimensional/tolerance sensitivity;
- repeated attach/remove behaviour;
- whether the fixed-side feature remains compact when no clip is installed;
- tube insertion, retention and serviceability.

Digital evidence should use focused sections and local assemblies. Physical
coupon prints should be used where snap/flex/tolerance behaviour cannot be
established credibly from CAD alone.

**Exit criteria**

A neutral fixed-side interface + detachable clip + horizontal tube arrangement
is digitally qualified and physically prototyped enough to support a production
integration decision. The result defines an interface contract, not a finished
HUB75 coupler.

## Step 8 — Propagate the modular clip interface across the coupler family

**Status:** blocked until Step 4 core-interface freeze and Step 7 PoP
qualification are both complete.

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
