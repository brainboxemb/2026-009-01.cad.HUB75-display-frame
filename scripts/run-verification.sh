#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

OUT_DIR="${ROOT_DIR}/vrf/out"
PNG_DIR="${OUT_DIR}/png"

# Step 0.5 repository/tooling boundary checks. These deliberately run before
# the existing CAD evidence checks so a broken bootstrap/config migration cannot
# hide behind successful geometry renders.
if ! grep -Fq 'type: scad' project.yml || ! grep -Fq 'config: project.scad.yml' project.yml; then
  echo "ERROR: project.yml must declare project.scad.yml as the SCAD profile" >&2
  exit 1
fi

if grep -Fq 'name: tool.git-project' project.yml; then
  echo "ERROR: tool.git-project must be pinned directly by the parent gitlink, not managed recursively" >&2
  exit 1
fi

for path in tools/tool.git-project tools/tool.scad-project dsg/openscad/ext/lib.scad.hub75; do
  if ! git ls-files --stage -- "$path" | grep -q '^160000 '; then
    echo "ERROR: expected committed direct gitlink is missing: $path" >&2
    exit 1
  fi
done

TOOL_REF="$(awk '
  $1 == "-" && $2 == "name:" { in_tool = ($3 == "tool.scad-project"); next }
  in_tool && $1 == "ref:" { print $2; exit }
' project.yml)"
TOOL_SHA="$(git -C tools/tool.scad-project rev-parse HEAD)"
RESOLVED_REF_SHA="$(git -C tools/tool.scad-project rev-parse "${TOOL_REF}^{commit}" 2>/dev/null || true)"
if [[ -z "$TOOL_REF" || "$RESOLVED_REF_SHA" != "$TOOL_SHA" ]]; then
  echo "ERROR: project.yml tool.scad-project ref and gitlink are not aligned" >&2
  exit 1
fi

for mapping in \
  "build.yml:project-build" \
  "verify.yml:project-verify" \
  "release.yml:project-release" \
  "pr-cleanup.yml:project-pr-cleanup"; do
  caller="${mapping%%:*}"
  reusable="${mapping#*:}"
  expected="brainboxemb/tool.scad-project/.github/workflows/${reusable}.yml@${TOOL_SHA}"
  if ! grep -Fq "$expected" ".github/workflows/${caller}"; then
    echo "ERROR: .github/workflows/${caller} is not pinned to exact tooling commit ${TOOL_SHA}" >&2
    exit 1
  fi
done

if ! cmp -s bootstrap.sh tools/tool.git-project/bootstrap/consumer-bootstrap.sh; then
  echo "ERROR: bootstrap.sh differs from the pinned tool.git-project consumer bootstrap" >&2
  exit 1
fi
if ! cmp -s bootstrap.ps1 tools/tool.git-project/bootstrap/consumer-bootstrap.ps1; then
  echo "ERROR: bootstrap.ps1 differs from the pinned tool.git-project consumer bootstrap" >&2
  exit 1
fi
if ! cmp -s update-repo.sh tools/tool.scad-project/bootstrap/consumer-update.sh; then
  echo "ERROR: update-repo.sh differs from the pinned tool.scad-project SCAD update wrapper" >&2
  exit 1
fi
if ! cmp -s update-repo.ps1 tools/tool.scad-project/bootstrap/consumer-update.ps1; then
  echo "ERROR: update-repo.ps1 differs from the pinned tool.scad-project SCAD update wrapper" >&2
  exit 1
fi

echo "Repository bootstrap ownership: OK"

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
