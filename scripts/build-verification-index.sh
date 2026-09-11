#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="${ROOT_DIR}/vrf/out"
PNG_DIR="${OUT_DIR}/png"
TEMPLATE_DIR="${ROOT_DIR}/vrf/templates"

mkdir -p "${PNG_DIR}" "${OUT_DIR}/stl"

copy_template() {
  local source="$1"
  local target="$2"

  if [[ ! -f "${source}" ]]; then
    echo "ERROR: verification README template not found: ${source}" >&2
    exit 1
  fi

  cp "${source}" "${target}"
}

copy_template \
  "${TEMPLATE_DIR}/README.md" \
  "${OUT_DIR}/README.md"

copy_template \
  "${TEMPLATE_DIR}/png/README.md" \
  "${PNG_DIR}/README.md"
