#!/bin/bash
set -e

BUNDLE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
export NDGEOEFF_BUNDLE_ROOT="${BUNDLE_ROOT}"
export WORKDIR="${_CONDOR_JOB_IWD:-$PWD}"

source "${BUNDLE_ROOT}/scripts/env/setup_step3.sh"

export PATH="${BUNDLE_ROOT}/bin:${PATH}"
