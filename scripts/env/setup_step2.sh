#!/usr/bin/env bash
# Step 2 needs Python 3 with numpy, scipy, torch, uproot, uproot3 and uproot4.
# Run from the repository root: source scripts/env/setup_step2.sh
source "$(dirname "${BASH_SOURCE[0]}")/../../setup.sh"
_NDGEOEFF_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
export PYTHONPATH="${_NDGEOEFF_ROOT}/python:${PYTHONPATH:-}"
