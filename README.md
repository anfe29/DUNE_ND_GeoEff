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

Starting from the working directory, clone the current repository:

```bash
git clone -b develop git@github.com:anfe29/DUNE_ND_GeoEff.git
```

If working on FNAL computers start an Apptainer:

```bash
/cvmfs/oasis.opensciencegrid.org/mis/apptainer/current/bin/apptainer shell --shell=/bin/bash -B /cvmfs,/exp,/nashome,/pnfs/dune,/opt,/run/user,/etc/hostname,/etc/hosts,/etc/krb5.conf --ipc --pid /cvmfs/singularity.opensciencegrid.org/fermilab/fnal-dev-sl7:latest
```

For each step, source the appropriate script from `scripts/env/`.

This sets up CMake, GCC, Eigen, ROOT 6.28, and Python 3. 


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

After starting an Apptainer source environment:

```bash
source scripts/env/setup_step1.sh
```

Build code with cmake.
```bash
cmake -S . -B build -DNDGEOEFF_BUILD_STEP3=OFF
cmake --build build --target runGeoEffFDEvtSim -j
```

Run the code in the `build` directory:
```bash
build/bin/runGeoEffFDEvtSim /path/to/inputFDntuple.root
```

This writes `Output_FDGeoEff.root` in the current directory.

To calculate the FD hadron containment efficiency from that output:

```bash
root -l -b -q macros/step1_hadron/FDEffCalc.C
```

Grid submission scripts can be found [here](scripts/step1_hadron/).

## Step 2 — muon/combined efficiency

After starting an Apptainer source environment:

```bash
source scripts/env/setup_step2.sh
```

To prepare python environment, make directory:

```bash
mkdir my_python_env
```

Install the Python dependencies:

```bash
pip install numpy==1.26.1 uproot==5.1.2 torch scipy ==1.11.3 --target=$(pwd)/my_python_env
```

Export `PYTHONPATH`:

```bash
export PYTHONPATH=$(pwd)/my_python_env:$PYTHONPATH
```

Run the code with:
```bash
python python/ndgeoff/step2_muon/make_tree_fd.py InputRootFile.root
```

The ND script writes `Output_NDGeoEff.root`; the FD script writes
`Output_FDGeoEff.root`. The trained network is bundled at
`python/ndgeoeff/step2_muon/assets/muonEff30.nn`.

Grid and Slurm scripts are located [here](scripts/step2_muon/).

## Step 3 — Etrim/PRISM analysis

Step 3 reads and writes several files by relative name. Run it from
`data/step3/`, or use the wrapper, which changes into that directory:

After starting an Apptainer source environment:

```bash
source scripts/env/setup_step3.sh
```

Build the necessary files:
```bash
cmake -S . -B build-step3 \
  -DNDGEOEFF_BUILD_STEP1=OFF \
  -DNDGEOEFF_BUILD_STEP3=ON \
  -DNDGEOEFF_BUILD_PYTHON=OFF
cmake --build build-step3 -j

Assuming equal effect on all off-axis positions, run with:
```bash
./NtupleOutVetoAndTrimE_AssumeEqualEffAtAllOA_NOOscSpectrumNOCAFAna_FDRateAtND HadronOutputFile  MuonOutputFile
```

Or with osccillations:
```bash 
./NtupleOutVetoAndTrimE_AssumeEqualEffAtAllOA_WithOscSpectrumNOCAFAna_FDRateAtND HadronOutputFile  MuonOutputFile
```

With all off-axis positions:
```bash
./NtupleOutVetoAndTrimE_AllOApos_WithOscSpectrumNOCAFAna_FDRateAtND HadronOutputFile  MuonOutputFile
```

Alternatively, with a wrapper:

```bash
scripts/step3_etrim/run_local.sh \
  NtupleOutVetoAndTrimE_AssumeEqualEffAtAllOA_NOOscSpectrumNOCAFAna_FDRateAtND \
  /path/to/OutputHadronGeoEff.root /path/to/OutputFDGeoEff.root
```

Available executables:

- `NtupleOutVetoAndTrimE_AssumeEqualEffAtAllOA_NOOscSpectrumNOCAFAna_FDRateAtND`
- `NtupleOutVetoAndTrimE_AssumeEqualEffAtAllOA_WithOscSpectrumNOCAFAna_FDRateAtND`
- `NtupleOutVetoAndTrimE_AllOApos_WithOscSpectrumNOCAFAna_FDRateAtND`

Analysis macros are in `macros/step3_etrim/`. Grid submission scripts are [here](scripts/step3_etrim/).

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
