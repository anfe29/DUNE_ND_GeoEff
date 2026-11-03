#!/bin/bash
#
#SBATCH --job-name=ND_hadron_muon
##SBATCH --output=ND_hadron_muon.log
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=Flynn.Y.Guo@stonybrook.edu
#SBATCH --nodelist=fir # --nodes=4 --gres=gpu
#SBATCH -c 30
#SBATCH --time=180:00:00
#!/bin/bash

cd "${NDGEOEFF_ROOT:?Set NDGEOEFF_ROOT to the repository root}"
export PYTHONPATH="$PWD/python:${PYTHONPATH:-}"
python3 -m ndgeoeff.step2_muon.make_tree_nd $1
wait
