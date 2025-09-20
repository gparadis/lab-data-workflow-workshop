# 02 — DataLad local workflow

## Goals
- Initialize a DataLad dataset (will stash large file content in a local sibling datastore)
- Save code, inputs, and outputs with provenance
- Re‑run with a single command

## Steps

```bash
cd demo_dataset

# 1) Initialize DataLad (safe to repeat)
datalad create -c text2git

# 2) Run the pipeline under DataLad control (records a command under a tag)
datalad run -m "process data v1" "python3 code/process_data.py --input data/input.csv --out outputs/processed.csv"

# 3) Verify status and history
datalad status
datalad log

# 4) Modify code or input (e.g., edit code/process_data.py weightings, or add data rows to data/input.csv)

# 5) Re-run the pipeline under DataLad control (records a second command under a different tag)
datalad run -m "process data v2" "python3 code/process_data.py --input data/input.csv --out outputs/processed.csv"
```
