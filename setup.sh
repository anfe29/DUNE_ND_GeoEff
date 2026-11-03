#!/usr/bin/env bash
# Shared DUNE environment for building NDGeoEff and running all three stages.
# Override NDGEOEFF_PYTHON_VERSION if your DUNE release provides another Python 3.

source /cvmfs/dune.opensciencegrid.org/products/dune/setup_dune.sh

setup cmake v3_19_6
setup gcc v9_3_0
setup eigen v3_3_5
setup root v6_28_10b -q e20:p3915:prof
setup python "${NDGEOEFF_PYTHON_VERSION:-v3_9_15}"

_NDGEOEFF_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PYTHONPATH="${_NDGEOEFF_ROOT}/python:${_NDGEOEFF_ROOT}/lib:${PYTHONPATH:-}"

which gcc
which root
which python3
cmake --version
