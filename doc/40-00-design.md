# HUB75 display-frame design

This document describes the **application-level architecture** used to realise
[30-00-specification.md](30-00-specification.md).

## Layered model

```text
shared libraries
    panel / clamp / dovetail / inspection / Forge
        ↓
project core couplers
    middle / horizontal edge / corner
        ↓
WIP reinforcement layer
    aluminium tubes + tube-aware wrappers + detachable clamp
        ↓
assemblies
        ↓
render / export / verification
```

## External-library ownership

Project source consumes public APIs from pinned direct dependencies. Exact
versions are configuration/provenance, not architecture; read `project.yml`
and committed gitlinks for current revisions. Native OpenSCAD remains valid
where clearer; Forge is used when it clarifies project-owned modeling intent.

## Core couplers

The middle, horizontal-edge and corner families own project-specific printable
geometry around reusable HUB75 mating datums. They are digitally accepted
against the current panel model; physical acceptance remains open.
Each substantial component keeps detailed visual construction in its own
`design/design.md`, which this architecture document does not duplicate.

## WIP tube-mount layer

Two continuous horizontal Ø10 tubes provide reinforcement context. Tube-aware
couplers wrap/extend accepted core components rather than redefining panel-facing
geometry. The detachable clamp combines the shared clamp body with the pinned
shared sliding-dovetail interface. Dedicated views/exports exist, but standard
core couplers remain the default until physical gates close.

## Assemblies and coordinates

Project axes are X horizontal, Y panel front→rear with front at 0, and Z vertical.
Five panel cells sit nominally at X = -320, -160, 0, +160, +320 mm.
Alternating orientation follows the rear-view data-chain order.

`dsg/openscad/assemblies/` contains real project assemblies; focused diagnostic
fixtures belong in verification-oriented areas rather than becoming production assemblies.

## Output architecture

Normal render/export entrypoints live under `dsg/openscad/render/` and
`dsg/openscad/export/`. Presentation orientation and printable/export orientation
are separate concerns; component STL exports own qualified print orientation.
SCons tracks dependencies behind the shared `scad-project` interface.

## Detailed design index

- [Middle coupler](../dsg/openscad/components/hub75/middle-coupler/design/design.md)
- [Horizontal-edge coupler](../dsg/openscad/components/hub75/horizontal-edge-coupler/design/design.md)
- [Corner-edge coupler](../dsg/openscad/components/hub75/corner-edge-coupler/design/design.md)
- [Tube-mount horizontal-edge coupler](../dsg/openscad/project_components/tube_mount/horizontal-edge-coupler/design/design.md)
- [Detachable tube clamp](../dsg/openscad/project_components/tube_mount/tube-clamp/design/design.md)

## Verification architecture

`vrf/openscad/` owns generated digital fit/section targets; `vrf/physical/`
owns executable physical acceptance procedures; [50-00-verification.md](50-00-verification.md)
owns repository-level strategy and current acceptance state.
