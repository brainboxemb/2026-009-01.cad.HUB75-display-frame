# PF-01 — Fit the medium middle coupler

**Question**

Does the printed medium middle coupler seat naturally and repeatably on two adjacent real HUB75 panels at the vertical seam and middle mounting row, without forcing, rocking or visible interference?

This testcase checks only this physical fit question. A green CI run or digital
render is not a physical result.

**Status**

`ready to execute` — not yet physically executed.

**Exact fixture**

- STL: [`middle-coupler-medium.stl`](https://github.com/brainboxemb/2026-009-01.cad.HUB75-display-frame/blob/prod/bld/stl/middle-coupler-medium.stl)
- functional source commit: `a85c3f31b508a3d761011328768d6ca99f6f3a33`
- production run: `35330842746`
- Git blob: `39f1b4c5b334410c8013cdb38d37d6148b39b218`
- digital placement reference: [fit detail](https://github.com/brainboxemb/2026-009-01.cad.HUB75-display-frame/blob/prod/vrf/png/middle-coupler-medium-fit-detail.png)

**Needed**

- two physical P5 64 × 32 panels with sample IDs;
- one print of the exact PF-01 STL;
- matching loose mounting screws, when available;
- phone or camera.

**Before**

Put both panels rear-side up in the intended alternating orientation and bring the vertical seam together around the middle mounting row without clamping force.

Print the STL at 100% scale. Remove only normal brim/support where that does not
change mating geometry. Do not sand or enlarge mating faces, guides, locators or
holes before the first test.

| # | Action | Expected |
| ---: | --- | --- |
| 1 | Place the coupler without screws over the two seam-side mounting positions using light hand pressure only. | Guides, seam locator and reinforcement locators find their positions without bending or force. |
| 2 | Let the coupler seat fully and inspect both panel-facing surfaces. | The base sits evenly on both rear mounting planes, with no obvious gap or rocking. |
| 3 | Check mounting-tube pockets, screw bores and reinforcement/locator interfaces on both panels. | No visible collision; holes and locators naturally align with their physical features. |
| 4 | If matching screws are available, insert them loosely without using them to pull the coupler into place. | Both screws start freely and are not needed to correct a bad fit. |
| 5 | Remove and reseat the coupler three times. | The same natural position and seating can be found each time. |
| 6 | Inspect for stress whitening, damage or a repeatable snag and take one clear photo. | No visible stress/interference; the photo shows the fully seated coupler and seam. |

**Record**

- Panel sample(s): `...`
- Date: `...`
- STL / Git blob: `middle-coupler-medium.stl` / `39f1b4c5b334410c8013cdb38d37d6148b39b218`
- Printer / material / print profile: `...`
- Result: `agrees` / `investigate` / `not checked`
- Observed: `...`
- Evidence (photo/link): `...`
- Follow-up: `...`
