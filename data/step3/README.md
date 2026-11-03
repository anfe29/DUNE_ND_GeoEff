# Step 3 input/output data

The step 3 executables read several inputs by relative filename (for example
`FileWithCoeffsNuMu.root`, `Splines_FDEventRateAtND.root`, and
`PRISMPred_*.root`) and write outputs into the current working directory.

Run them from this directory, or use `scripts/step3_etrim/run_local.sh`, which
changes into this directory before executing the selected binary.
