#!/bin/bash

BUNDLE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
export NDGEOEFF_BUNDLE_ROOT="${BUNDLE_ROOT}"
export WORKDIR="${_CONDOR_JOB_IWD:-$PWD}"

source "${BUNDLE_ROOT}/scripts/env/setup_step2.sh" || { echo "Error loading ${BUNDLE_ROOT}/scripts/env/setup_step2.sh"; exit 1; }

export PYTHONPATH="${BUNDLE_ROOT}:${PYTHONPATH:-}"

if [ -d "${BUNDLE_ROOT}/python_env" ]; then
  export PYTHONPATH="${BUNDLE_ROOT}/python_env:${PYTHONPATH}"
fi

if [ -n "${NDGEOEFF_PYTHON_ENV:-}" ]; then
  if [ ! -d "${NDGEOEFF_PYTHON_ENV}" ]; then
    echo "Error, NDGEOEFF_PYTHON_ENV is not a directory: ${NDGEOEFF_PYTHON_ENV}"
    exit 1
  fi
  export PYTHONPATH="${NDGEOEFF_PYTHON_ENV}:${PYTHONPATH}"
fi
