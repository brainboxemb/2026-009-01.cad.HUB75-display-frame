# Interactive OpenSCAD entrypoint

Open [`main.scad`](main.scad) when working with the project directly in OpenSCAD.
It is the human-facing development controller; production geometry remains in the
assembly and component files.

The OpenSCAD Customizer exposes:

- **View** — complete assembly, exploded assembly, panels-only, couplers-only,
  each printable coupler, and the local middle/horizontal/corner fit fixtures.
- **Coupler profile** — `small`, `medium`, `large`, or `custom`.
- **Custom coupler dimensions** — shared profile dimensions used only by the
  `custom` selection. The defaults intentionally reproduce the medium family.
- **Visibility** — panels and each coupler family can be enabled or disabled
  independently in the assembly/exploded views.
- **Exploded view** — controls the Y separation between the physical panel layer
  and the printable coupler layer.

The three standard sizes are always created through the production
`*_create_for_size()` functions. `main.scad` does not duplicate their dimensions.
Only the `custom` selection constructs explicit production objects from the values
shown in the Customizer.

Generated build output remains separate from this interactive entrypoint. The
normal build gallery includes the established front/rear views plus dedicated
rear-angled exploded and couplers-only overviews. Size-specific standalone
coupler renders remain generated for small, medium, and large.
