#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

EXPECTED_GIT_TOOL_SHA="9879da589101f41b2b0e634d196ddcc51e1a6102"
EXPECTED_SCAD_TOOL_SHA="70fd4162731484a949dc390e942dde8b8d811f10"
EXPECTED_DIRECT_UTIL_SHA="da1892a201c3bfc78a65e10df84d4a8d142ae8f6"
EXPECTED_MECHINT_SHA="a306b7ed3e8d504058c55140b3241507c3a1331b"
EXPECTED_MECHINT_UTIL_SHA="5c88cd9b6b118d376825927ed67e26aff6eaee2d"

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
  local nested_util="$mechint/ext/lib.scad.util"

  require_gitlink "$ROOT_DIR" "tools/tool.git-project" "$EXPECTED_GIT_TOOL_SHA"
  require_gitlink "$ROOT_DIR" "tools/tool.scad-project" "$EXPECTED_SCAD_TOOL_SHA"
  require_gitlink "$ROOT_DIR" "dsg/openscad/ext/lib.scad.util" "$EXPECTED_DIRECT_UTIL_SHA"
  require_gitlink "$ROOT_DIR" "dsg/openscad/ext/lib.scad.mechint" "$EXPECTED_MECHINT_SHA"

  require_checkout "$ROOT_DIR/tools/tool.git-project" "$EXPECTED_GIT_TOOL_SHA"
  require_checkout "$ROOT_DIR/tools/tool.scad-project" "$EXPECTED_SCAD_TOOL_SHA"
  require_checkout "$direct_util" "$EXPECTED_DIRECT_UTIL_SHA"
  require_checkout "$mechint" "$EXPECTED_MECHINT_SHA"

  require_gitlink "$mechint" "ext/lib.scad.util" "$EXPECTED_MECHINT_UTIL_SHA"
  require_checkout "$nested_util" "$EXPECTED_MECHINT_UTIL_SHA"

  require_uninitialized_nested_tooling "$mechint" "tools/tool.git-project"
  require_uninitialized_nested_tooling "$mechint" "tools/tool.scad-project"

  echo "Dependency ownership: root util v0.2.0 and mechint-owned util v0.1.0 coexist correctly"
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
