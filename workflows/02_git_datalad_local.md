# 02 — DataLad local workflow

## Goals
- Initialize a DataLad dataset
- Save code, inputs, and outputs with provenance
- Re‑run with a single command

## Steps

```bash
cd demo_dataset

# 1) Initialize DataLad (safe to repeat)
datalad create -c text2git

# 2) Run the pipeline under DataLad control (records a command)
datalad run -m "process data v1"     "python3 code/process_data.py --input data/input.csv --out outputs/processed.csv"

# 3) Verify status and history
datalad status
datalad log

# 4) Modify code or input, then re‑run
# e.g., edit code/process_data.py weightings, or add data rows
datalad run -m "process data v2"     "python3 code/process_data.py --input data/input.csv --out outputs/processed.csv"
```
