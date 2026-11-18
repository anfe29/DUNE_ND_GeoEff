#!/bin/bash

echo "Running on $(hostname) at ${GLIDEIN_Site}. GLIDEIN_DUNESite = ${GLIDEIN_DUNESite}"

OUTDIR=/pnfs/dune/scratch/users/${GRID_USER}/test/output_test

echo "pwd: $(pwd)"
echo "ls -l INPUT_TAR_DIR_LOCAL: ${INPUT_TAR_DIR_LOCAL}"
ls -l "${INPUT_TAR_DIR_LOCAL}"

BUNDLE_DIR=${INPUT_TAR_DIR_LOCAL}/DUNE_ND_GeoEff
INPUT_DIR=${BUNDLE_DIR}/inputs
SETUP_SCRIPT=${BUNDLE_DIR}/scripts/grid/step2_muon/setup_FDcombEff.sh

if [ ! -e "${SETUP_SCRIPT}" ]; then
  echo "Error, setup script not found: ${SETUP_SCRIPT}"
  exit 1
fi
echo "Start to run . ${SETUP_SCRIPT}"
. "${SETUP_SCRIPT}"

cd ${_CONDOR_JOB_IWD}

PYTHON_ENV_DIR=""
if [ -d "${BUNDLE_DIR}/python_env" ]; then
  PYTHON_ENV_DIR="${BUNDLE_DIR}/python_env"
fi
if [ -n "${NDGEOEFF_PYTHON_ENV:-}" ]; then
  PYTHON_ENV_DIR="${NDGEOEFF_PYTHON_ENV}"
fi

if [ -n "${PYTHON_ENV_DIR}" ]; then
  echo "Using preinstalled Python environment: ${PYTHON_ENV_DIR}"
  export PYTHONPATH="${PYTHON_ENV_DIR}:${PYTHONPATH}"
else
  echo "No preinstalled Python environment found; installing dependencies in the job directory"
  PIP=/cvmfs/larsoft.opensciencegrid.org/products/python/v3_9_15/Linux64bit+3.10-2.17/bin/pip
  PYTHON_ENV_DIR="${_CONDOR_JOB_IWD}/python_env"
  "${PIP}" install --target="${PYTHON_ENV_DIR}" numpy==1.26.1
  "${PIP}" install --target="${PYTHON_ENV_DIR}" uproot==5.1.2
  "${PIP}" install --target="${PYTHON_ENV_DIR}" torch
  "${PIP}" install --target="${PYTHON_ENV_DIR}" scipy==1.11.3
  export PYTHONPATH="${PYTHON_ENV_DIR}:${PYTHONPATH}"
fi

echo "python version:"
python3 --version
python3 -c "import numpy; import scipy; import uproot; print(numpy.__version__, scipy.__version__, uproot.__version__)"

setup ifdhc

export IFDH_CP_MAXRETRIES=2
export XRD_CONNECTIONRETRY=32
export XRD_REQUESTTIMEOUT=14400
export XRD_REDIRECTLIMIT=255
export XRD_LOADBALANCERTTL=7200
export XRD_STREAMTIMEOUT=14400

ifdh mkdir_p "${OUTDIR}" || { echo "Error creating or checking ${OUTDIR}"; exit 2; }
echo "Finished checking outdir: ${OUTDIR}"

myinfile=""
basefile=""
inputfile=""
(( LINE_N = ${PROCESS} + 1 ))

for ifile in $(cat "${INPUT_DIR}/FDCAFs.txt" | head -${LINE_N} | tail -1); do
  myinfile="${myinfile} ${ifile}"
  basefile=$(basename $ifile)
  inputfile="${basefile%.root}"
  echo "Input file without .root extension: $inputfile"
done

echo "Got xrootd url: $myinfile"

echo "ifdh cp -D $myinfile ${_CONDOR_JOB_IWD}"
ifdh cp -D $myinfile ${_CONDOR_JOB_IWD}

echo "ls -l _CONDOR_JOB_IWD"
ls -l ${_CONDOR_JOB_IWD}

echo "python3 ${BUNDLE_DIR}/app/make_tree_fd.py ./*.root"
python3 "${BUNDLE_DIR}/app/make_tree_fd.py" ./*.root
LAR_RESULT=$?

if [ $LAR_RESULT -ne 0 ]; then
  echo "python3 exited with abnormal status $LAR_RESULT. See error outputs."
  exit $LAR_RESULT
fi

echo "Have output"
ls -l ${_CONDOR_JOB_IWD}

OUTFILE=${inputfile}_MuCombinedEff.root

if [ -f Output_FDGeoEff.root ]; then
  echo "mv Output_FDGeoEff.root $OUTFILE"
  mv Output_FDGeoEff.root $OUTFILE

  echo "Found output root file, now copy to scratch area: $OUTDIR"
  ifdh cp -D $OUTFILE $OUTDIR
  IFDH_RESULT=$?
  if [ $IFDH_RESULT -ne 0 ]; then
    echo "Error during output copyback. See output logs."
    exit $IFDH_RESULT
  fi
else
  echo "Error, output file not found. Exiting."
  exit 1
fi

echo "Completed successfully."
exit 0
