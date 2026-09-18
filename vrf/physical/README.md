# Physical core-coupler verification

This directory contains the physical acceptance procedures for project-plan
Step 3.

Digital verification and physical verification answer different questions:

- `vrf/openscad` and `prod/vrf` show whether the CAD fits the authoritative
  HUB75 panel model;
- these physical cases check whether the printed medium couplers actually seat
  on identified real HUB75 panels without forcing, rocking or interference.

The procedures follow the compact physical-verification style already used by
`lib.scad.hub75`: one physical question per testcase, separate Dutch and
English files, an exact fixture revision and a recorded observation/evidence
result. That library is a project-family reference; generic repository/tooling
behaviour remains owned by `brainboxemb.meta` and the tool owners.

## Status

**Ready to execute after PR #42 merges.**

Physical execution is tracked in
[issue #43](https://github.com/brainboxemb/2026-009-01.cad.HUB75-display-frame/issues/43).

## Fixture baseline

Use the existing production STL files generated from functional source commit:

```text
a85c3f31b508a3d761011328768d6ca99f6f3a33
```

Production run:

```text
35330842746
```

| Case | Production STL | Git blob |
| --- | --- | --- |
| PF-01 | [middle-coupler-medium.stl](https://github.com/brainboxemb/2026-009-01.cad.HUB75-display-frame/blob/prod/bld/stl/middle-coupler-medium.stl) | `39f1b4c5b334410c8013cdb38d37d6148b39b218` |
| PF-02 | [horizontal-edge-coupler-medium.stl](https://github.com/brainboxemb/2026-009-01.cad.HUB75-display-frame/blob/prod/bld/stl/horizontal-edge-coupler-medium.stl) | `839436b628a68485c66ee099b6ad7cdec9c23a34` |
| PF-03 | [corner-edge-coupler-left-medium.stl](https://github.com/brainboxemb/2026-009-01.cad.HUB75-display-frame/blob/prod/bld/stl/corner-edge-coupler-left-medium.stl) | `f07e565d54686e3d65f9ce1e0879c401dae7629d` |
| PF-04 | [corner-edge-coupler-right-medium.stl](https://github.com/brainboxemb/2026-009-01.cad.HUB75-display-frame/blob/prod/bld/stl/corner-edge-coupler-right-medium.stl) | `2dd42802edd303d2b42edb4ab547ca369244cedd` |

Do not silently regenerate, scale, sand or otherwise change mating geometry and
still call it the same fixture revision. If a fixture changes, record the new
source/output identity before retesting.

## Testcases

| Case | Nederlands | English |
| --- | --- | --- |
| PF-01 | [Medium middle coupler passen](test-cases/pf-01-middle-coupler-medium-fit.nl.md) | [Fit the medium middle coupler](test-cases/pf-01-middle-coupler-medium-fit.en.md) |
| PF-02 | [Medium horizontal-edge coupler passen](test-cases/pf-02-horizontal-edge-coupler-medium-fit.nl.md) | [Fit the medium horizontal-edge coupler](test-cases/pf-02-horizontal-edge-coupler-medium-fit.en.md) |
| PF-03 | [Medium linker corner coupler passen](test-cases/pf-03-left-corner-medium-fit.nl.md) | [Fit the medium left corner coupler](test-cases/pf-03-left-corner-medium-fit.en.md) |
| PF-04 | [Medium rechter corner coupler passen](test-cases/pf-04-right-corner-medium-fit.nl.md) | [Fit the medium right corner coupler](test-cases/pf-04-right-corner-medium-fit.en.md) |

## Recording rule

Use one result per case:

- `agrees` — the intended physical fit is repeatable and no blocking
  interference is observed;
- `investigate` — fit is forced, ambiguous, rocking, stressed or otherwise
  needs follow-up;
- `not checked` — the case was not actually executed.

A photo/evidence reference and concrete observation belong with every executed
result. Four `agrees` results are required before Step 3 can close.
