# PF-04 — Fit the medium right corner coupler

**Question**

Does the printed medium right corner coupler seat naturally and repeatably in both intended chiral positions — top-right and, after a 180° Y rotation, bottom-left — without forcing, rocking or interference?

This testcase checks only this physical fit question. A green CI run or digital
render is not a physical result.

**Status**

`ready to execute` — not yet physically executed.

**Exact fixture**

- STL: [`corner-edge-coupler-right-medium.stl`](https://github.com/brainboxemb/2026-009-01.cad.HUB75-display-frame/blob/prod/bld/stl/corner-edge-coupler-right-medium.stl)
- functional source commit: `a85c3f31b508a3d761011328768d6ca99f6f3a33`
- production run: `35330842746`
- Git blob: `2dd42802edd303d2b42edb4ab547ca369244cedd`
- digital placement reference: [fit detail](https://github.com/brainboxemb/2026-009-01.cad.HUB75-display-frame/blob/prod/vrf/png/corner-edge-coupler-right-medium-fit-detail.png)

**Needed**

- one physical P5 64 × 32 panel with sample ID;
- one print of the exact PF-04 STL;
- one matching loose mounting screw, when available;
- phone or camera.

**Before**

Place the panel rear-side up and start at the physical top-right corner. The current panel API has no locator-pin interface at this chiral corner, so this part must not depend on a locator that is not physically present.

Print the STL at 100% scale. Remove only normal brim/support where that does not
change mating geometry. Do not sand or enlarge mating faces, guides, locators or
holes before the first test.

| # | Action | Expected |
| ---: | --- | --- |
| 1 | Place the coupler without a screw at top-right using light hand pressure. | Top and side guides plus the reinforcement locator find their features without force. |
| 2 | Inspect the base, both outside edges and the 19.5 mm outside projection visually. | The base sits flat, both ridges follow the panel edges and nothing pulls the part out of square. |
| 3 | Check screw/tube/reinforcement interfaces and the area where the left variant has locator clearance; insert an available screw loosely only. | No unexpected locator collision; the screw starts without pulling the part into place. |
| 4 | Remove and reseat the coupler three times at top-right. | The same natural seating is repeatable without snagging or rocking. |
| 5 | Rotate the coupler 180° about Y and place the same part at bottom-left. | The documented second chiral position also seats naturally without new interference. |
| 6 | Take one clear photo of at least the top-right seating and record any marks/stress. | No visible damage or stress; evidence shows both outside edges and the reinforcement area. |

**Record**

- Panel sample(s): `...`
- Date: `...`
- STL / Git blob: `corner-edge-coupler-right-medium.stl` / `2dd42802edd303d2b42edb4ab547ca369244cedd`
- Printer / material / print profile: `...`
- Result: `agrees` / `investigate` / `not checked`
- Observed: `...`
- Evidence (photo/link): `...`
- Follow-up: `...`
