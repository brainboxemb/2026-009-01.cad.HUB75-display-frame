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

render_png() {
  local label="$1"
  local size="$2"
  local source="$3"
  local output="$4"

  run_checked     "${label}"     xvfb-run -a       openscad         --enable=object-function         --render         --projection=o         --imgsize=2560,1440         -D "size=\"${size}\""         -o "${output}"         "${source}"

  if [[ ! -s "${output}" ]]; then
    echo "ERROR: ${label} did not create a non-empty PNG" >&2
    exit 1
  fi
}

export_stl() {
  local label="$1"
  local size="$2"
  local source="$3"
  local output="$4"

  run_checked     "${label}"     openscad       --enable=object-function       -D "size=\"${size}\""       -o "${output}"       "${source}"

  if [[ ! -s "${output}" ]]; then
    echo "ERROR: ${label} did not create a non-empty STL" >&2
    exit 1
  fi
}

for size in small medium large; do
  size_dir="${OUT_DIR}/${size}"
  mkdir -p "${size_dir}"

  render_png     "Middle coupler ${size} standalone"     "${size}"     "${ROOT_DIR}/dsg/openscad/render/middle-coupler.scad"     "${size_dir}/middle-coupler.png"

  export_stl     "Middle coupler ${size} STL"     "${size}"     "${ROOT_DIR}/dsg/openscad/export/middle-coupler.scad"     "${size_dir}/middle-coupler.stl"

  render_png     "Middle coupler ${size} angled fit detail"     "${size}"     "${ROOT_DIR}/vrf/openscad/middle-coupler-fit-detail.scad"     "${size_dir}/fit-detail.png"

  render_png     "Middle coupler ${size} rear fit section"     "${size}"     "${ROOT_DIR}/vrf/openscad/middle-coupler-rear-fit-section.scad"     "${size_dir}/rear-fit-section.png"

  render_png     "Middle coupler ${size} XY seam section"     "${size}"     "${ROOT_DIR}/vrf/openscad/middle-coupler-xy-seam-section.scad"     "${size_dir}/xy-seam-section.png"
done

echo "Verification output written to ${OUT_DIR}"
