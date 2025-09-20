# 02 — DataLad local workflow

## Goals
- Initialize a DataLad dataset (will stash large file content in a local sibling datastore)
- Save code, inputs, and outputs with provenance
- Re‑run with a single command

## Steps

```bash
# 0) Make a copy of demo_dataset that is not already tracked by git and delete any files in output subdirectory
cp -r demo_dataset demo_dataset_datalad_local
cd demo_dataset_datalad_local
rm output/*

# 1) Initialize DataLad repo and save (anologous to git commit)
datalad create -c text2git
datalad status
datalad save "Initial dataset state"
datalad status

# 2) Run the pipeline under DataLad control (records a command under a tag)
datalad run -m "process data v1" "python3 code/process_data.py --input data/input.csv --out outputs/processed.csv"

# 3) Verify status
datalad status

# 4) Grab the commit that recorded your run
RUN=$(git log --grep='\[DATALAD RUNCMD\].*process data v1' --pretty=%H -n 1)
echo $RUN

# 5) Show the recorded run (report only)
datalad rerun --report $RUN

# 6) Diff exactly what that run changed
datalad diff -f ${RUN}^ -t ${RUN}

# 7) Generate a reproduce script for that single run
datalad rerun --script reproduce_v1.sh $RUN
chmod +x reproduce_v1.sh

# 8) Modify code or input (e.g., edit code/process_data.py weightings, or add data rows to data/input.csv)
#    and then save edits so the tree is clean for the next run
datalad save -m "prep for v2: tweak code/input"

# 9) Re-run the pipeline under DataLad control (records a second command under a different tag)
datalad run -m "process data v2" "python3 code/process_data.py --input data/input.csv --out outputs/processed.csv"
```
