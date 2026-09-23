# HUB75 display-frame verification

This document defines repository-level verification strategy and current
acceptance state. Generated `vrf/out/` content is evidence, not source authority.

## Digital verification

`vrf/openscad/` contains focused fit/section views for core couplers and WIP
tube-mount interfaces. Digital evidence can establish geometry relationships,
clearances and regressions; it does not establish printer/material fit or prove
that the underlying panel model matches a particular physical panel.

## Physical core-coupler verification

PF-01 through PF-04 are prepared for the medium middle, horizontal-edge, left
corner and right corner couplers.

Current status:
- PR #42 is merged and the procedures are defined;
- issue #43 tracks execution;
- the cases have **not** been physically executed;
- execution remains downstream of relevant real-panel validation in `lib.scad.hub75`;
- frozen STL/source/blob identities in `vrf/physical/README.md` remain the fixture authority.

Do not silently regenerate, scale, sand or otherwise alter mating geometry and
call it the same fixture revision. Physical states remain `agrees`, `investigate`
or `not checked`; all four core cases must reach accepted results before freeze.

## WIP tube-mount verification

Current tube-mount/dovetail renders and sections are **digital WIP evidence**.
They do not physically accept the detachable interface. Later physical
qualification must cover insertion/removal force, printer/material sensitivity,
lock engagement/release, clamp force, print orientation and repeated serviceability.

## Evidence and publication

`scripts/build-verification-index.sh` assembles the human verification index.
The generated snapshot includes a copy of this strategy document so PR and
production Verification branches are self-contained.

Do not freeze 'CI is green' here. Inspect exact live Actions and corresponding
`prod/bld/publication-info.txt` / `prod/vrf/publication-info.txt` for current health.

## Acceptance boundaries

A green workflow is not visual acceptance, and digital model fit is not physical fit.
Visual evidence must be inspected where relevant; physical gates close only
from retained real-hardware observations according to the owning testcase.
