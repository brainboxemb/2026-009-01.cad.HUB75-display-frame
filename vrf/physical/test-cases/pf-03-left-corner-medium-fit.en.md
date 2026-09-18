# PF-03 — Fit the medium left corner coupler

**Question**

Does the printed medium left corner coupler seat naturally and repeatably in both intended chiral positions — top-left and, after a 180° Y rotation, bottom-right — without forcing, rocking or locator interference?

This testcase checks only this physical fit question. A green CI run or digital
render is not a physical result.

**Status**

`ready to execute` — not yet physically executed.

**Exact fixture**

- STL: [`corner-edge-coupler-left-medium.stl`](https://github.com/brainboxemb/2026-009-01.cad.HUB75-display-frame/blob/prod/bld/stl/corner-edge-coupler-left-medium.stl)
- functional source commit: `a85c3f31b508a3d761011328768d6ca99f6f3a33`
- production run: `35330842746`
- Git blob: `f07e565d54686e3d65f9ce1e0879c401dae7629d`
- digital placement reference: [fit detail](https://github.com/brainboxemb/2026-009-01.cad.HUB75-display-frame/blob/prod/vrf/png/corner-edge-coupler-left-medium-fit-detail.png)

**Needed**

- one physical P5 64 × 32 panel with sample ID;
- one print of the exact PF-03 STL;
- one matching loose mounting screw, when available;
- phone or camera.

**Before**

Place the panel rear-side up and start at the physical top-left corner. This left variant contains the locator-pin clearance that belongs to this corner.

Print the STL at 100% scale. Remove only normal brim/support where that does not
change mating geometry. Do not sand or enlarge mating faces, guides, locators or
holes before the first test.

| # | Action | Expected |
| ---: | --- | --- |
| 1 | Place the coupler without a screw at top-left using light hand pressure. | Top and side guides, reinforcement locator and locator-pin clearance find their features without force. |
| 2 | Inspect the base, both outside edges and the 19.5 mm outside projection visually. | The base sits flat, both ridges follow the panel edges and nothing pulls the part out of square. |
| 3 | Check screw/tube/reinforcement/locator interfaces and insert an available screw loosely only. | The physical locator pin moves freely in its clearance and the screw starts without pulling the part into place. |
| 4 | Remove and reseat the coupler three times at top-left. | The same natural seating is repeatable without snagging or rocking. |
| 5 | Rotate the coupler 180° about Y and place the same part at bottom-right. | The documented second chiral position also seats naturally and the locator interface meets the corresponding physical feature. |
| 6 | Take one clear photo of at least the top-left seating and record any marks/stress. | No visible damage or stress; evidence shows seating and the locator area. |

**Record**

- Panel sample(s): `...`
- Date: `...`
- STL / Git blob: `corner-edge-coupler-left-medium.stl` / `f07e565d54686e3d65f9ce1e0879c401dae7629d`
- Printer / material / print profile: `...`
- Result: `agrees` / `investigate` / `not checked`
- Observed: `...`
- Evidence (photo/link): `...`
- Follow-up: `...`
