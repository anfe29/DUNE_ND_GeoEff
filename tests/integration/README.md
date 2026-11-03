# Integration checks

Reference ROOT outputs are generated on a machine with the DUNE environment
(`source setup.sh`) and small input files. Store them under
`data/reference/` or `tests/reference/` before changing physics code.

Suggested smoke checks:

```bash
source setup.sh
cmake -S . -B build -DNDGEOEFF_BUILD_STEP3=OFF
cmake --build build -j

source scripts/env/setup_step3.sh
cmake -S . -B build-step3 -DNDGEOEFF_BUILD_STEP1=OFF \
  -DNDGEOEFF_BUILD_STEP3=ON -DNDGEOEFF_BUILD_PYTHON=OFF
cmake --build build-step3 -j

PYTHONPATH=python python3 -m pytest tests/unit
```
