#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

OUT_DIR="${ROOT_DIR}/vrf/out/middle-coupler"
mkdir -p "${OUT_DIR}"

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

render_verification_png() {
  local label="$1"
  local source="$2"
  local output="$3"

  run_checked     "${label}"     xvfb-run -a       openscad         --enable=object-function         --render         --projection=o         --imgsize=2560,1440         -o "${output}"         "${source}"

  if [[ ! -s "${output}" ]]; then
    echo "ERROR: ${label} did not create a non-empty PNG" >&2
    exit 1
  fi
}

render_verification_png   "Middle coupler angled fit detail"   "${ROOT_DIR}/vrf/openscad/middle-coupler-fit-detail.scad"   "${OUT_DIR}/fit-detail.png"

render_verification_png   "Middle coupler rear fit section"   "${ROOT_DIR}/vrf/openscad/middle-coupler-rear-fit-section.scad"   "${OUT_DIR}/rear-fit-section.png"

render_verification_png   "Middle coupler XY seam section"   "${ROOT_DIR}/vrf/openscad/middle-coupler-xy-seam-section.scad"   "${OUT_DIR}/xy-seam-section.png"

echo "Verification output written to ${OUT_DIR}"
