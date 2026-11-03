#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BIN="${STEP1_BIN:-${REPO_ROOT}/build/bin/runGeoEffFDEvtSim}"
exec "${BIN}" "$@"
