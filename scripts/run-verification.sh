#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

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
