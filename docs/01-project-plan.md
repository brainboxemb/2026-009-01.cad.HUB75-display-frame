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

This coordination plan is being introduced by issue/PR #40. While that change is
open, it is the coordination prerequisite. After it merges, **Step 1** is the
first project-design step unless current repository evidence shows a new blocker.

## Step 0 — Establish project handoff and forward plan

**Status:** active only while #40 is open.

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

**Tracking:** issue
[#31](https://github.com/brainboxemb/2026-009-01.cad.HUB75-display-frame/issues/31)

**Goal**

Represent the intended real display arrangement in which adjacent HUB75 panels
alternate orientation, instead of rendering all five with the same orientation.

**Before implementation**

- confirm the intended physical alternation using current panel geometry/API;
- identify which panel-local features change side/orientation and which assembly
  datums must remain fixed;
- check the effect on existing middle, edge and corner coupler placement rather
  than treating this as a presentation-only rotation.

**Required evidence**

- front/rear complete-display renders show the intended alternating pattern;
- coupler assembly views remain mechanically coherent;
- affected fit/section verification remains valid or is deliberately updated;
- Build and Verification are green for the changed dependency graph.

**Exit criteria**

Issue #31 is resolved and the complete display plus coupler evidence represents
the intended alternating physical layout.

## Step 2 — Digital acceptance of the core coupler family

**Goal**

Finish the digital review of the panel-facing connector geometry before adding a
new structural layer.

**Review**

- middle, horizontal-edge and corner families at small/medium/large sizes;
- engraved datum `+` positions against the panel geometry;
- seam, rear-fit and outside-edge sections;
- left/right corner chirality and locator-pin clearance;
- standalone printable STL geometry and the project-wide projection constraints.

**Exit criteria**

Any discovered digital geometry defects are resolved, generated design/build/
verification evidence is understandable, and there is no known digital panel-fit
blocker for the core connector family.

## Step 3 — Physical fit acceptance of the core couplers

**Goal**

Validate the core panel/coupler interfaces against real HUB75 hardware before
their geometry becomes the foundation for reinforcement.

**Minimum useful physical set**

- medium middle coupler;
- medium horizontal-edge coupler;
- medium left corner;
- medium right corner.

Additional sizes should only be printed when the medium parts or a specific
design question make them useful.

**Check**

- insertion and removal;
- panel seam/edge seating;
- screw and mounting features;
- locator/reinforcement clearances;
- corner chirality;
- unwanted stress, rocking or interference.

**Exit criteria**

Physical observations are recorded, required geometry corrections are merged and
the four core medium variants are accepted against real panels.

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

## Step 5 — Define aluminium reinforcement-tube architecture

**Status:** provisional until Steps 1–4 are complete.

**Goal**

Define how the reinforcement tube relates to the accepted couplers and full
five-panel assembly before designing attachment details.

**Questions**

- tube section and project-owned dimensions;
- tube datum/location relative to panel rear mounting geometry;
- which couplers locate/support the tube;
- assembly/service clearance;
- allowable projection and print/build constraints.

**Exit criteria**

A minimal tube-plus-core-coupler assembly and focused verification views prove
the intended structural interface without yet depending on a complex clip
system.

## Step 6 — Develop tube attachment / clip system

**Status:** provisional.

**Goal**

Add the smallest printable attachment mechanism needed to retain the
reinforcement tube.

Develop attachment geometry independently enough that tube retention can be
verified without obscuring the already accepted panel-fit interfaces.

**Exit criteria**

The attachment mechanism is printable, inspectable, does not regress core fit
and has focused digital verification plus physical checking where the interface
requires it.

## Step 7 — Complete reinforced display-frame assembly

**Status:** provisional.

**Goal**

Integrate all accepted connector, tube and attachment parts into the full
five-panel frame.

**Check**

- complete assembly consistency;
- service/access clearances;
- repeated-part orientation and chirality;
- useful STL/export set;
- full-display documentation and verification views.

**Exit criteria**

The complete reinforced assembly is digitally coherent and no local interface is
being justified only by the full assembly render.

## Step 8 — Full physical prototype and release candidate

**Status:** provisional.

**Goal**

Build the intended physical frame, feed findings back into the smallest owning
component and create a release candidate only after real assembly evidence is
satisfactory.

**Exit criteria**

- required physical corrections are incorporated;
- current design/build/verification documentation matches the physical baseline;
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
