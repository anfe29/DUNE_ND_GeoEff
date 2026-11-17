#!/bin/bash
#
#SBATCH --job-name=NDhist_files
#SBATCH --output=NDhist_files_%j.log
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=Flynn.Y.Guo@stonybrook.edu
#SBATCH --nodelist=birch # --nodes=4 --gres=gpu
#SBATCH --time=180:00:00
#!/bin/bash

cd "${NDGEOEFF_ROOT:?Set NDGEOEFF_ROOT to the repository root}"
root -l -b macros/step2_muon/histogram_files_ND.cpp
wait
