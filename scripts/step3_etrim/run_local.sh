#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
APP="${1:-NtupleOutVetoAndTrimE_AssumeEqualEffAtAllOA_NOOscSpectrumNOCAFAna_FDRateAtND}"
shift || true

BIN_DIR="${STEP3_BIN_DIR:-${REPO_ROOT}/build/bin}"
if [ ! -x "${BIN_DIR}/${APP}" ] && [ -x "${REPO_ROOT}/apps/step3_etrim_analysis/${APP}" ]; then
  BIN_DIR="${REPO_ROOT}/apps/step3_etrim_analysis"
fi
if [ ! -x "${BIN_DIR}/${APP}" ]; then
  echo "Executable not found: ${BIN_DIR}/${APP}" >&2
  echo "Build step 3 first, or set STEP3_BIN_DIR." >&2
  exit 1
fi

cd "${REPO_ROOT}/data/step3"
exec "${BIN_DIR}/${APP}" "$@"
