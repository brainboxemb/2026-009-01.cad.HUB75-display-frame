# Project scripts

These scripts contain HUB75-display-frame-specific verification support. Shared repository/tooling alignment is owned and qualified by the pinned `tool.git-project` and `tool.scad-project` workflows; project scripts do not duplicate those checks by grepping workflow or Moon configuration text.

## `run-verification.sh`

Runs functional project verification after the configured verification renders have been produced.

It verifies:

- the interactive `dsg/openscad/main.scad` default assembly renders successfully;
- a custom coupler-profile view renders successfully;
- OpenSCAD output contains no reported `ERROR:` diagnostics;
- every expected small/medium/large middle, horizontal-edge and left/right corner verification PNG exists and is non-empty.

This script deliberately tests project/CAD behaviour only. Dependency refs, gitlinks, reusable-workflow pins, Moon capability inheritance, runtime selection and cache policy are integration contracts qualified by shared tooling and CI evidence.

## `build-verification-index.sh`

Materializes the human-readable verification index by copying the source templates:

- `vrf/templates/README.md` → `vrf/out/README.md`;
- `vrf/templates/png/README.md` → `vrf/out/png/README.md`.

Both scripts are invoked through the `verification.commands` list in `project.scad.yml`.
