#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

OUT_DIR="${ROOT_DIR}/vrf/out"
PNG_DIR="${OUT_DIR}/png"
STL_DIR="${OUT_DIR}/stl"

WATERMARK_TEXT="$(
  python3 - <<'PY'
from pathlib import Path
import yaml

config = yaml.safe_load(Path("project.yml").read_text(encoding="utf-8")) or {}
rendering = config.get("rendering", {}) or {}
watermark = rendering.get("watermark", {}) or {}
print(watermark.get("text", "") or "")
PY
)"

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
  local raw_output="${output%.png}.unwatermarked.png"

  rm -f "${raw_output}" "${output}"

  run_checked \
    "${label}" \
    xvfb-run -a \
      openscad \
        --enable=object-function \
        --render \
        --projection=o \
        --imgsize=2560,1440 \
        -D "size=\"${size}\"" \
        -o "${raw_output}" \
        "${source}"

  if [[ ! -s "${raw_output}" ]]; then
    echo "ERROR: ${label} did not create a non-empty raw PNG" >&2
    exit 1
  fi

  if [[ -n "${WATERMARK_TEXT}" ]]; then
    run_checked \
      "${label} watermark" \
      scad-image-watermark \
        "${raw_output}" \
        "${output}" \
        --text "${WATERMARK_TEXT}"
    rm -f "${raw_output}"
  else
    mv "${raw_output}" "${output}"
  fi

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

  run_checked \
    "${label}" \
    openscad \
      --enable=object-function \
      -D "size=\"${size}\"" \
      -o "${output}" \
      "${source}"

  if [[ ! -s "${output}" ]]; then
    echo "ERROR: ${label} did not create a non-empty STL" >&2
    exit 1
  fi
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

verify_middle_coupler() {
  local size="$1"

  render_png \
    "Middle coupler ${size} standalone" \
    "${size}" \
    "${ROOT_DIR}/dsg/openscad/render/middle-coupler.scad" \
    "${PNG_DIR}/middle-coupler-${size}.png"

  export_stl \
    "Middle coupler ${size} STL" \
    "${size}" \
    "${ROOT_DIR}/dsg/openscad/export/middle-coupler.scad" \
    "${STL_DIR}/middle-coupler-${size}.stl"

  render_png \
    "Middle coupler ${size} angled fit detail" \
    "${size}" \
    "${ROOT_DIR}/vrf/openscad/middle-coupler-fit-detail.scad" \
    "${PNG_DIR}/middle-coupler-${size}-fit-detail.png"

  render_png \
    "Middle coupler ${size} rear fit section" \
    "${size}" \
    "${ROOT_DIR}/vrf/openscad/middle-coupler-rear-fit-section.scad" \
    "${PNG_DIR}/middle-coupler-${size}-rear-fit-section.png"

  render_png \
    "Middle coupler ${size} XY seam section" \
    "${size}" \
    "${ROOT_DIR}/vrf/openscad/middle-coupler-xy-seam-section.scad" \
    "${PNG_DIR}/middle-coupler-${size}-xy-seam-section.png"
}

verify_horizontal_edge_coupler() {
  local size="$1"

  render_png \
    "Horizontal-edge coupler ${size} standalone" \
    "${size}" \
    "${ROOT_DIR}/dsg/openscad/render/horizontal-edge-coupler.scad" \
    "${PNG_DIR}/horizontal-edge-coupler-${size}.png"

  export_stl \
    "Horizontal-edge coupler ${size} STL" \
    "${size}" \
    "${ROOT_DIR}/dsg/openscad/export/horizontal-edge-coupler.scad" \
    "${STL_DIR}/horizontal-edge-coupler-${size}.stl"

  render_png \
    "Horizontal-edge coupler ${size} angled fit detail" \
    "${size}" \
    "${ROOT_DIR}/vrf/openscad/horizontal-edge-coupler-fit-detail.scad" \
    "${PNG_DIR}/horizontal-edge-coupler-${size}-fit-detail.png"

  render_png \
    "Horizontal-edge coupler ${size} rear fit section" \
    "${size}" \
    "${ROOT_DIR}/vrf/openscad/horizontal-edge-coupler-rear-fit-section.scad" \
    "${PNG_DIR}/horizontal-edge-coupler-${size}-rear-fit-section.png"

  render_png \
    "Horizontal-edge coupler ${size} YZ edge section" \
    "${size}" \
    "${ROOT_DIR}/vrf/openscad/horizontal-edge-coupler-yz-edge-section.scad" \
    "${PNG_DIR}/horizontal-edge-coupler-${size}-yz-edge-section.png"

  render_png \
    "Horizontal-edge coupler ${size} XY seam section" \
    "${size}" \
    "${ROOT_DIR}/vrf/openscad/horizontal-edge-coupler-xy-seam-section.scad" \
    "${PNG_DIR}/horizontal-edge-coupler-${size}-xy-seam-section.png"
}

verify_corner_edge_coupler() {
  local side="$1"
  local size="$2"

  render_png \
    "Corner-edge ${side} coupler ${size} standalone" \
    "${size}" \
    "${ROOT_DIR}/dsg/openscad/render/corner-edge-coupler-${side}.scad" \
    "${PNG_DIR}/corner-edge-coupler-${side}-${size}.png"

  export_stl \
    "Corner-edge ${side} coupler ${size} STL" \
    "${size}" \
    "${ROOT_DIR}/dsg/openscad/export/corner-edge-coupler-${side}.scad" \
    "${STL_DIR}/corner-edge-coupler-${side}-${size}.stl"

  render_png \
    "Corner-edge ${side} coupler ${size} angled fit detail" \
    "${size}" \
    "${ROOT_DIR}/vrf/openscad/corner-edge-coupler-${side}-fit-detail.scad" \
    "${PNG_DIR}/corner-edge-coupler-${side}-${size}-fit-detail.png"

  render_png \
    "Corner-edge ${side} coupler ${size} rear fit section" \
    "${size}" \
    "${ROOT_DIR}/vrf/openscad/corner-edge-coupler-${side}-rear-fit-section.scad" \
    "${PNG_DIR}/corner-edge-coupler-${side}-${size}-rear-fit-section.png"

  render_png \
    "Corner-edge ${side} coupler ${size} YZ top-edge section" \
    "${size}" \
    "${ROOT_DIR}/vrf/openscad/corner-edge-coupler-${side}-yz-top-edge-section.scad" \
    "${PNG_DIR}/corner-edge-coupler-${side}-${size}-yz-top-edge-section.png"

  render_png \
    "Corner-edge ${side} coupler ${size} XY side-edge section" \
    "${size}" \
    "${ROOT_DIR}/vrf/openscad/corner-edge-coupler-${side}-xy-side-edge-section.scad" \
    "${PNG_DIR}/corner-edge-coupler-${side}-${size}-xy-side-edge-section.png"
}

verify_corner_edge_profile_sections() {
  local size="$1"

  render_png \
    "Corner-edge coupler ${size} horizontal profile section" \
    "${size}" \
    "${ROOT_DIR}/vrf/openscad/corner-edge-coupler-horizontal-profile-section.scad" \
    "${PNG_DIR}/corner-edge-coupler-${size}-horizontal-profile-section.png"

  render_png \
    "Corner-edge coupler ${size} vertical profile section" \
    "${size}" \
    "${ROOT_DIR}/vrf/openscad/corner-edge-coupler-vertical-profile-section.scad" \
    "${PNG_DIR}/corner-edge-coupler-${size}-vertical-profile-section.png"
}

verify_interactive_main

for size in small medium large; do
  verify_middle_coupler "${size}"
  verify_horizontal_edge_coupler "${size}"
  verify_corner_edge_coupler "left" "${size}"
  verify_corner_edge_coupler "right" "${size}"
  verify_corner_edge_profile_sections "${size}"
done

echo "Verification output written to ${OUT_DIR}"
