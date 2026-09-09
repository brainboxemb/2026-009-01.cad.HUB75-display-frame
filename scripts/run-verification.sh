#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

OUT_DIR="${ROOT_DIR}/vrf/out"
PNG_DIR="${OUT_DIR}/png"
STL_DIR="${OUT_DIR}/stl"

rm -rf "${PNG_DIR}" "${STL_DIR}"
mkdir -p "${PNG_DIR}" "${STL_DIR}"

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

verify_middle_coupler() {
  local size="$1"

  render_png     "Middle coupler ${size} standalone"     "${size}"     "${ROOT_DIR}/dsg/openscad/render/middle-coupler.scad"     "${PNG_DIR}/middle-coupler-${size}.png"

  export_stl     "Middle coupler ${size} STL"     "${size}"     "${ROOT_DIR}/dsg/openscad/export/middle-coupler.scad"     "${STL_DIR}/middle-coupler-${size}.stl"

  render_png     "Middle coupler ${size} angled fit detail"     "${size}"     "${ROOT_DIR}/vrf/openscad/middle-coupler-fit-detail.scad"     "${PNG_DIR}/middle-coupler-${size}-fit-detail.png"

  render_png     "Middle coupler ${size} rear fit section"     "${size}"     "${ROOT_DIR}/vrf/openscad/middle-coupler-rear-fit-section.scad"     "${PNG_DIR}/middle-coupler-${size}-rear-fit-section.png"

  render_png     "Middle coupler ${size} XY seam section"     "${size}"     "${ROOT_DIR}/vrf/openscad/middle-coupler-xy-seam-section.scad"     "${PNG_DIR}/middle-coupler-${size}-xy-seam-section.png"
}

verify_horizontal_edge_coupler() {
  local size="$1"

  render_png     "Horizontal-edge coupler ${size} standalone"     "${size}"     "${ROOT_DIR}/dsg/openscad/render/horizontal-edge-coupler.scad"     "${PNG_DIR}/horizontal-edge-coupler-${size}.png"

  export_stl     "Horizontal-edge coupler ${size} STL"     "${size}"     "${ROOT_DIR}/dsg/openscad/export/horizontal-edge-coupler.scad"     "${STL_DIR}/horizontal-edge-coupler-${size}.stl"

  render_png     "Horizontal-edge coupler ${size} angled fit detail"     "${size}"     "${ROOT_DIR}/vrf/openscad/horizontal-edge-coupler-fit-detail.scad"     "${PNG_DIR}/horizontal-edge-coupler-${size}-fit-detail.png"

  render_png     "Horizontal-edge coupler ${size} rear fit section"     "${size}"     "${ROOT_DIR}/vrf/openscad/horizontal-edge-coupler-rear-fit-section.scad"     "${PNG_DIR}/horizontal-edge-coupler-${size}-rear-fit-section.png"

  render_png     "Horizontal-edge coupler ${size} YZ edge section"     "${size}"     "${ROOT_DIR}/vrf/openscad/horizontal-edge-coupler-yz-edge-section.scad"     "${PNG_DIR}/horizontal-edge-coupler-${size}-yz-edge-section.png"
}

for size in small medium large; do
  verify_middle_coupler "${size}"
  verify_horizontal_edge_coupler "${size}"
done

echo "Verification output written to ${OUT_DIR}"
