# STL export orientation

Printable STL orientation is owned by the HUB75 **export/manufacturing layer**.
The component `*_build()` APIs stay in their normal design/project coordinate
systems so assembly and render geometry are not coupled to a slicer choice.

The export boundary distinguishes:

- **design orientation** — native component/library modeling frame;
- **project orientation** — geometry placed in the HUB75 project frame;
- **print orientation** — final STL frame, where printer build direction is +Z.

## Current component exports

| Export family | Print face / build direction | Export mapping | Decision source |
| --- | --- | --- | --- |
| middle coupler | rear face down | project -Y -> printer +Z | flat rear base; guides build away from rear face |
| horizontal-edge coupler | rear face down | project -Y -> printer +Z | flat rear base |
| corner-edge coupler, left/right | rear face down | project -Y -> printer +Z | flat rear base |
| horizontal-edge tube-mount coupler | rear face down | project -Y -> printer +Z | design explicitly preserves rear-face-down print surface |
| corner-edge tube-mount coupler, left/right | rear face down | project -Y -> printer +Z | source explicitly opens clamp access to the rear print face for rear-face-down printing |
| detachable dovetail tube clamp | 12 mm side down | project +X / tube axis -> printer +Z | qualified component-lab print mapping and current clamp design document |

For rear-face-down couplers the flat rear face is at
`project Y = base_thickness`. The export transform maps that plane to
`printer Z = 0` and lower project-Y geometry builds upward.

The clamp mapping is the qualified lab mapping:

```text
project X -> printer +Z
project Y -> printer +Y
project Z -> printer -X
```

The clamp is centred across its 12 mm project-X width, so the export adds half
that width in printer Z to place the selected side face on the bed.

## Non-printable/reference exports

`panels-assembly.scad` and `tube-mount-display-2-panel.scad` are assembly /
inspection exports. They intentionally remain in project orientation and do not
receive a manufacturing transform.

## Ownership rule

Do not add a print-orientation API to a reusable component merely because an STL
needs a different slicer orientation. Add or change component-level orientation
API only when the orientation is genuinely intrinsic to that component across
consumers. Otherwise keep the transform here at the export boundary.
