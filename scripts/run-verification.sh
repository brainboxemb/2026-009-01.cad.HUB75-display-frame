#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

EXPECTED_GIT_TOOL_SHA="9879da589101f41b2b0e634d196ddcc51e1a6102"
EXPECTED_SCAD_TOOL_SHA="6cf0ed9c35379143f5c99bb7d49276d19a0fe832"
EXPECTED_DIRECT_UTIL_SHA="604970732671b3889f072f5fc744ca872326e69c"
EXPECTED_DIRECT_FORGE_SHA="12a62580f4d24a8ebd80b061dc2a8e368a838ace"
EXPECTED_MECHINT_SHA="a3ec45dda7a58376b35c1a121f41242797e55e6e"
EXPECTED_MECHINT_FORGE_SHA="12a62580f4d24a8ebd80b061dc2a8e368a838ace"
EXPECTED_DIRECT_UTIL_REF="v0.4.0"
EXPECTED_DIRECT_FORGE_REF="v0.2.1"
EXPECTED_MECHINT_REF="v0.2.3"

gitlink_sha() {
  local repo_root="$1"
  local path="$2"
  git -C "$repo_root" ls-files --stage -- "$path" | awk '$1 == "160000" { print $2; exit }'
}

require_gitlink() {
  local repo_root="$1"
  local path="$2"
  local expected="$3"
  local actual
  actual="$(gitlink_sha "$repo_root" "$path")"
  if [[ "$actual" != "$expected" ]]; then
    echo "ERROR: $path gitlink is '$actual', expected '$expected'" >&2
    exit 1
  fi
}

require_checkout() {
  local path="$1"
  local expected="$2"
  local actual
  actual="$(git -C "$path" rev-parse HEAD 2>/dev/null || true)"
  if [[ "$actual" != "$expected" ]]; then
    echo "ERROR: checkout $path is '$actual', expected '$expected'" >&2
    exit 1
  fi
}

require_uninitialized_nested_tooling() {
  local owner="$1"
  local nested="$2"
  local status
  status="$(git -C "$owner" submodule status -- "$nested" 2>/dev/null || true)"
  if [[ -z "$status" || "$status" != -* ]]; then
    echo "ERROR: $owner/$nested must remain an uninitialized owner-local tooling gitlink; status='$status'" >&2
    exit 1
  fi
}

verify_dependency_ownership() {
  local mechint="$ROOT_DIR/dsg/openscad/ext/lib.scad.mechint"
  local direct_util="$ROOT_DIR/dsg/openscad/ext/lib.scad.util"
  local direct_forge="$ROOT_DIR/dsg/openscad/ext/lib.scad.forge"
  local nested_forge="$mechint/ext/lib.scad.forge"

  require_gitlink "$ROOT_DIR" "tools/tool.git-project" "$EXPECTED_GIT_TOOL_SHA"
  require_gitlink "$ROOT_DIR" "tools/tool.scad-project" "$EXPECTED_SCAD_TOOL_SHA"
  require_gitlink "$ROOT_DIR" "dsg/openscad/ext/lib.scad.util" "$EXPECTED_DIRECT_UTIL_SHA"
  require_gitlink "$ROOT_DIR" "dsg/openscad/ext/lib.scad.forge" "$EXPECTED_DIRECT_FORGE_SHA"
  require_gitlink "$ROOT_DIR" "dsg/openscad/ext/lib.scad.mechint" "$EXPECTED_MECHINT_SHA"

  require_checkout "$ROOT_DIR/tools/tool.git-project" "$EXPECTED_GIT_TOOL_SHA"
  require_checkout "$ROOT_DIR/tools/tool.scad-project" "$EXPECTED_SCAD_TOOL_SHA"
  require_checkout "$direct_util" "$EXPECTED_DIRECT_UTIL_SHA"
  require_checkout "$direct_forge" "$EXPECTED_DIRECT_FORGE_SHA"
  require_checkout "$mechint" "$EXPECTED_MECHINT_SHA"

  grep -Fq "ref: $EXPECTED_DIRECT_UTIL_REF" "$ROOT_DIR/project.yml" || {
    echo "ERROR: project.yml must retain lib.scad.util $EXPECTED_DIRECT_UTIL_REF" >&2
    exit 1
  }
  grep -Fq "ref: $EXPECTED_DIRECT_FORGE_REF" "$ROOT_DIR/project.yml" || {
    echo "ERROR: project.yml must retain lib.scad.forge $EXPECTED_DIRECT_FORGE_REF" >&2
    exit 1
  }
  grep -Fq "ref: $EXPECTED_MECHINT_REF" "$ROOT_DIR/project.yml" || {
    echo "ERROR: project.yml must retain lib.scad.mechint $EXPECTED_MECHINT_REF" >&2
    exit 1
  }

  require_gitlink "$mechint" "ext/lib.scad.forge" "$EXPECTED_MECHINT_FORGE_SHA"
  require_checkout "$nested_forge" "$EXPECTED_MECHINT_FORGE_SHA"

  require_uninitialized_nested_tooling "$mechint" "tools/tool.git-project"
  require_uninitialized_nested_tooling "$mechint" "tools/tool.scad-project"

  echo "Dependency ownership: root util v0.4.0 owns inspection; root Forge v0.2.1 owns project transforms; mechint v0.2.3 owns an independent Forge v0.2.1 checkout"
}
OUT_DIR="${ROOT_DIR}/vrf/out"
PNG_DIR="${OUT_DIR}/png"

run_checked() {
  local label="$1"
  shift

  local log_file
  log_file="$(mktemp)"

  echo "-- ${label}"

  set +e
  "$@" 2>&1 | tee "${log_file}"
  local status=${PIPESTATUS[0]}
  set -e

  if [[ ${status} -ne 0 ]]; then
    echo "ERROR: ${label} failed with exit code ${status}" >&2
    rm -f "${log_file}"
    exit "${status}"
  fi

  if grep -qE '(^|[[:space:]])ERROR:' "${log_file}"; then
    echo "ERROR: ${label} emitted an OpenSCAD error" >&2
    rm -f "${log_file}"
    exit 1
  fi

  rm -f "${log_file}"
}

verify_interactive_main() {
  local tmp_dir
  tmp_dir="$(mktemp -d)"

  run_checked \
    "Interactive main default assembly" \
    xvfb-run -a \
      openscad \
        --enable=object-function \
        --render \
        --projection=o \
        --imgsize=1000,600 \
        -o "${tmp_dir}/main-default.png" \
        "${ROOT_DIR}/dsg/openscad/main.scad"

  if [[ ! -s "${tmp_dir}/main-default.png" ]]; then
    echo "ERROR: interactive main default did not create a non-empty PNG" >&2
    rm -rf "${tmp_dir}"
    exit 1
  fi

  run_checked \
    "Interactive main custom couplers view" \
    xvfb-run -a \
      openscad \
        --enable=object-function \
        --render \
        --projection=o \
        --imgsize=1000,600 \
        -D 'view_mode="couplers"' \
        -D 'coupler_profile="custom"' \
        -D 'profile_size=88' \
        -D 'wall_thickness=4' \
        -D 'guide_height=6' \
        -D 'base_thickness=3' \
        -o "${tmp_dir}/main-custom.png" \
        "${ROOT_DIR}/dsg/openscad/main.scad"

  if [[ ! -s "${tmp_dir}/main-custom.png" ]]; then
    echo "ERROR: interactive main custom view did not create a non-empty PNG" >&2
    rm -rf "${tmp_dir}"
    exit 1
  fi

  rm -rf "${tmp_dir}"
}

require_png() {
  local filename="$1"
  local path="${PNG_DIR}/${filename}"

  if [[ ! -s "${path}" ]]; then
    echo "ERROR: expected verification render is missing or empty: ${path}" >&2
    exit 1
  fi
}

verify_dependency_ownership
verify_interactive_main

for size in small medium large; do
  require_png "middle-coupler-${size}-fit-detail.png"
  require_png "middle-coupler-${size}-rear-fit-section.png"
  require_png "middle-coupler-${size}-xy-seam-section.png"

  require_png "horizontal-edge-coupler-${size}-fit-detail.png"
  require_png "horizontal-edge-coupler-${size}-rear-fit-section.png"
  require_png "horizontal-edge-coupler-${size}-yz-edge-section.png"
  require_png "horizontal-edge-coupler-${size}-xy-seam-section.png"

  for side in left right; do
    require_png "corner-edge-coupler-${side}-${size}-fit-detail.png"
    require_png "corner-edge-coupler-${side}-${size}-rear-fit-section.png"
    require_png "corner-edge-coupler-${side}-${size}-yz-top-edge-section.png"
    require_png "corner-edge-coupler-${side}-${size}-xy-side-edge-section.png"
  done

  require_png "corner-edge-coupler-${size}-horizontal-profile-section.png"
  require_png "corner-edge-coupler-${size}-vertical-profile-section.png"
done

echo "Verification evidence and interactive main smoke checks: OK"
