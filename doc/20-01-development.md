# HUB75 display-frame development manual

## Start

1. read [../AGENTS.md](../AGENTS.md);
2. read [10-00-plan.md](10-00-plan.md);
3. use [README.md](README.md) for specification/design/verification routing;
4. read the affected component-local design before changing geometry.

## Repository entrypoints

Use the managed root launchers:

```text
bootstrap.ps1 / bootstrap.sh
update.ps1 / update.sh
```

Repository-owned workflows are `self-ci.yml`, `self-release.yml` and
`self-pr-cleanup.yml`; shared orchestration stays in the released reusable
tool workflows.

## Build and verification

The interactive entrypoint is `dsg/openscad/main.scad`. Normal build/export
entrypoints live under `dsg/openscad/render/` and `dsg/openscad/export/`.
Focused digital verification lives under `vrf/openscad/`; generated evidence
is published through `vrf/out`.

A green digital workflow does not close a physical gate. Issue #43 and the
procedures under `vrf/physical/` remain the authority for physical core-coupler
acceptance.

## Dependency updates

Update released dependencies through `project.yml`, exact committed gitlinks
and the managed root update launcher. Do not edit pinned dependency source in
place.

## Release

Release only an exact qualified main commit through `self-release.yml`. Inspect
live Actions plus production Build/Verification provenance before creating the
release request.
