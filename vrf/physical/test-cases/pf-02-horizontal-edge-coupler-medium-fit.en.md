# PF-02 — Fit the medium horizontal-edge coupler

**Question**

Does the printed medium horizontal-edge coupler seat naturally and repeatably at the intended panel seam and outside edge, including the connector-heavy seam, without forcing, rocking or connector interference?

This testcase checks only this physical fit question. A green CI run or digital
render is not a physical result.

**Status**

`ready to execute` — not yet physically executed.

**Exact fixture**

- STL: [`horizontal-edge-coupler-medium.stl`](https://github.com/brainboxemb/2026-009-01.cad.HUB75-display-frame/blob/prod/bld/stl/horizontal-edge-coupler-medium.stl)
- functional source commit: `a85c3f31b508a3d761011328768d6ca99f6f3a33`
- production run: `35330842746`
- Git blob: `839436b628a68485c66ee099b6ad7cdec9c23a34`
- digital placement reference: [fit detail](https://github.com/brainboxemb/2026-009-01.cad.HUB75-display-frame/blob/prod/vrf/png/horizontal-edge-coupler-medium-fit-detail.png)

**Needed**

- two physical P5 64 × 32 panels with sample IDs;
- one print of the exact PF-02 STL;
- matching loose mounting screws, when available;
- phone or camera.

**Before**

Put the panels rear-side up. For the first placement use the strong seam parity from the digital fixture: left panel native, right panel rotated 180° in the panel plane, so both panels present their seam-side data connectors at the shared seam. Test the top edge first.

Print the STL at 100% scale. Remove only normal brim/support where that does not
change mating geometry. Do not sand or enlarge mating faces, guides, locators or
holes before the first test.

| # | Action | Expected |
| ---: | --- | --- |
| 1 | Place the coupler without screws on the top-edge seam using light hand pressure. | The seam locator, guide wall, reinforcement locators and locator-pin clearance find their positions without force. |
| 2 | Inspect seating on both rear mounting planes and along the outside edge. | The base sits evenly and the exposed outer guide follows the panel edge without rocking or binding. |
| 3 | Explicitly inspect the data connectors and surrounding housings at the seam. | The coupler does not touch or load the connectors. |
| 4 | Check mounting-tube pockets and screw bores; insert available screws loosely only. | Holes start freely and screws are not needed to pull the coupler into place. |
| 5 | Remove and reseat the coupler three times at the same top-edge seam. | The same position and seating are repeatable. |
| 6 | Rotate the same printable coupler 180° about Y and check its corresponding bottom-edge use. | The same part also fits in the documented bottom-edge orientation without new interference. |
| 7 | Take a photo of the seated top-edge test and record stress, rocking or snagging. | No blocking issue; evidence shows seam, outside edge and connector clearance. |

**Note**

PF-02 deliberately starts with the connector-heavy seam. If that produces `investigate`, do not substitute an easier seam as acceptance; record the collision first.

**Record**

- Panel sample(s): `...`
- Date: `...`
- STL / Git blob: `horizontal-edge-coupler-medium.stl` / `839436b628a68485c66ee099b6ad7cdec9c23a34`
- Printer / material / print profile: `...`
- Result: `agrees` / `investigate` / `not checked`
- Observed: `...`
- Evidence (photo/link): `...`
- Follow-up: `...`
