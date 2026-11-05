# DUNE ND Geometric Efficiency and Etrim/PRISM Analysis

This repository contains the three-stage DUNE ND geometric-efficiency workflow:

1. **Step 1 — hadron geometric efficiency** (`apps/step1_hadron_geoeff/`)
2. **Step 2 — muon/combined efficiency** (`python/ndgeoeff/step2_muon/`)
3. **Step 3 — Etrim/PRISM event-rate analysis** (`apps/step3_etrim_analysis/`)

The layout is language-oriented. C++ sources live under `src/`, `include/`, and
`apps/`; Python code lives under `python/ndgeoeff/`; ROOT macros live under
`macros/`; operational scripts live under `scripts/`; and step 3 data lives under
`data/step3/`.

## Environment

For steps 1 and 2, from the repository root:

```bash
source setup.sh
```

This sets up CMake, GCC, Eigen, ROOT 6.28, and Python 3. Set
`NDGEOEFF_PYTHON_VERSION` before sourcing if your DUNE release needs a different
Python 3 version.

For step 3, use the ROOT 6.28 + OscLib environment instead:

```bash
source scripts/env/setup_step3.sh
```

## Build

Steps 1 and 2 (library and hadron-efficiency apps):

```bash
cmake -S . -B build -DNDGEOEFF_BUILD_STEP3=OFF
cmake --build build -j
```

The executables are placed in `build/bin/` and the libraries in `build/lib/`.

The optional `pyGeoEff` Python bindings are disabled by default. Enable them with
`-DNDGEOEFF_BUILD_PYTHON=ON`; this requires a pybind11 version that supports your
Python (pybind11 >= 2.10 for Python >= 3.11).

Step 3 (requires ROOT and OscLib):

```bash
source scripts/env/setup_step3.sh
cmake -S . -B build-step3 \
  -DNDGEOEFF_BUILD_STEP1=OFF \
  -DNDGEOEFF_BUILD_STEP3=ON \
  -DNDGEOEFF_BUILD_PYTHON=OFF
cmake --build build-step3 -j
```

The original `apps/step3_etrim_analysis/Makefile` is kept as a fallback.

## Step 1 — hadron geometric efficiency

```bash
source setup.sh
cmake -S . -B build -DNDGEOEFF_BUILD_STEP3=OFF
cmake --build build --target runGeoEffFDEvtSim -j

build/bin/runGeoEffFDEvtSim /path/to/inputFDntuple.root
```

This writes `Output_FDGeoEff.root` in the current directory.

To calculate the FD hadron containment efficiency from that output:

```bash
root -l -b -q macros/step1_hadron/FDEffCalc.C
```

Grid submission scripts can be found [here](scripts/step1_hadron/).

## Step 2 — muon/combined efficiency

Install the Python dependencies if needed (`numpy`, `scipy`, `torch`, `uproot`,
`uproot3`, `uproot4`), or use the grid setup scripts. From the repository root:

```bash
source scripts/env/setup_step2.sh

PYTHONPATH=python python3 -m ndgeoeff.step2_muon.make_tree_nd /path/to/ND.CAF.root
PYTHONPATH=python python3 -m ndgeoeff.step2_muon.make_tree_fd /path/to/FD.CAF.root
```

The ND script writes `Output_NDGeoEff.root`; the FD script writes
`Output_FDGeoEff.root`. The trained network is bundled at
`python/ndgeoeff/step2_muon/assets/muonEff30.nn`.

Grid and Slurm scripts are located [here](scripts/step2_muon/).

## Step 3 — Etrim/PRISM analysis

Step 3 reads and writes several files by relative name. Run it from
`data/step3/`, or use the wrapper, which changes into that directory:

```bash
source scripts/env/setup_step3.sh
cmake -S . -B build-step3 \
  -DNDGEOEFF_BUILD_STEP1=OFF \
  -DNDGEOEFF_BUILD_STEP3=ON \
  -DNDGEOEFF_BUILD_PYTHON=OFF
cmake --build build-step3 -j

scripts/step3_etrim/run_local.sh \
  NtupleOutVetoAndTrimE_AssumeEqualEffAtAllOA_NOOscSpectrumNOCAFAna_FDRateAtND \
  /path/to/OutputHadronGeoEff.root /path/to/OutputFDGeoEff.root
```

Available executables:

- `NtupleOutVetoAndTrimE_AssumeEqualEffAtAllOA_NOOscSpectrumNOCAFAna_FDRateAtND`
- `NtupleOutVetoAndTrimE_AssumeEqualEffAtAllOA_WithOscSpectrumNOCAFAna_FDRateAtND`
- `NtupleOutVetoAndTrimE_AllOApos_WithOscSpectrumNOCAFAna_FDRateAtND`

Analysis macros are in `macros/step3_etrim/`. Grid submission scripts are in
`scripts/step3_etrim/`.

## Tests

```bash
PYTHONPATH=python python3 -m pytest tests/unit
```

See `tests/integration/README.md` for the full three-stage smoke-test procedure.

## Legacy files

Duplicated and experimental files from the previous layout are preserved under
`legacy/`. They are not part of the supported build.

## Additional documentation

The detailed physics workflow written by Ionna is described in [documentation](doc/README.md). Stage-specific legacy grid submission
notes are in [Step1](scripts/step1_hadron/README.md),
[Step2](scripts/step2_muon/README.md), and [Step3](scripts/step3_etrim/README.md).
