# 2026-009-01.cad.HUB75-display-frame

Structured OpenSCAD project for a modular five-panel HUB75 display frame.

## Preview

### Front angled

[![Front angled view](../../raw/prod/bld/png/front-angled.png)](../../blob/prod/bld/png/front-angled.png)

### Rear angled

**Panels only**

[![Rear angled panel view](../../raw/prod/bld/png/rear-angled.png)](../../blob/prod/bld/png/rear-angled.png)

**With couplers and reinforcement**

[![Rear angled view with couplers](../../raw/prod/bld/png/rear-angled-couplers.png)](../../blob/prod/bld/png/rear-angled-couplers.png)

## Start here

- [Documentation index](doc/README.md) — route to the maintained project documentation.
- [Plan](doc/10-00-plan.md) — current gate, work sequence, information sources and roadmap.
- [Manuals](doc/20-00-manuals.md) — practical development and user guidance.
- [Specification](doc/30-00-specification.md) — why the frame exists and what the project should achieve.
- [Design](doc/40-00-design.md) — application architecture, ownership boundaries and coordinate model.
- [Verification](doc/50-00-verification.md) — digital versus physical verification and current acceptance status.
- [Changelog](CHANGELOG.md) — completed functional/repository history.
- [Generated design documentation](../../blob/prod/bld/design/README.md)
- [Latest Build](../../tree/prod/bld)
- [Latest Verification](../../tree/prod/vrf)

Detailed component construction remains beside source, including the
[middle coupler](dsg/openscad/components/hub75/middle-coupler/design/design.md),
[horizontal-edge coupler](dsg/openscad/components/hub75/horizontal-edge-coupler/design/design.md),
[corner-edge coupler](dsg/openscad/components/hub75/corner-edge-coupler/design/design.md),
[tube-mount edge coupler](dsg/openscad/project_components/tube_mount/horizontal-edge-coupler/design/design.md)
and [detachable tube clamp](dsg/openscad/project_components/tube_mount/tube-clamp/design/design.md).

## Current status

The v0.0.4 checkpoint is complete. Standard core couplers remain the default
full-display assembly. The detachable tube-mount/dovetail layer exists on main
as explicit WIP and is opt-in; it is not yet an accepted mechanical baseline.

The next physical gate is issue #43 and remains downstream of the relevant
real-panel verification in `lib.scad.hub75`. See the plan and verification
document for the precise state.

## Local setup

After cloning run `.\bootstrap.ps1`. A configured build can be run with
`.\tools\tool.scad-project\scad-project.ps1 build`. Open
`dsg/openscad/main.scad` for the interactive development entrypoint.

Current dependency/tool/runtime versions are intentionally not copied here.
Use `project.yml`, `project.scad.yml`, committed gitlinks, live Actions and
`prod/bld` / `prod/vrf` provenance for exact current state.
