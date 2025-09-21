# 02 — DataLad local workflow

## Goals
- Initialize a DataLad dataset (will stash large file content in a local sibling datastore)
- Save code, inputs, and outputs with provenance
- Re‑run with a single command

## Steps

```bash
# 0) Switch to main git branch and create a new feature branch
git switch main
git checkout -b feature/git-datalad-local-workflow

# 1) Initialize DataLad repo as a subdataset and save (anologous to git commit)
git rm -r --cached demo_dataset
git commit -m "Untrack demo_dataset in parent (retry for subdataset)"

# after: git rm -r --cached demo_dataset && git commit -m "untrack …"
datalad create -d . --force -c text2git demo_dataset

# one recursive save does both:
datalad save -r -m "Initialize subdataset with existing content and register in parent"

# 2) Run the pipeline under DataLad control (records a command under a tag)
cd demo_dataset
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

# 10) Back up to the parent root and run a run a DataLad save to update subdataset pointers and other metadata
cd ..                      # back to parent repo root
datalad status             # should show "modified: demo_dataset (dataset)"
datalad save -m "demo_dataset: record v1/v2 runs (update subdataset pointer)"

# 11) Make sure the subdataset has a GitHub sibling and is pushed
cd demo_dataset

# pick a repo name, then build the URL consistently
REPO_NAME=${GITHUB_REPO_NAME_LOCAL}
GH_URL="https://github.com/${GH_OWNER}/${REPO_NAME}.git"

# Create the sibling correctly for org vs user
if [ -n "${GITHUB_ORGANIZATION:-}" ]; then
  datalad create-sibling-github -d . --github-organization "$GH_OWNER" --name origin "$REPO_NAME"
else
  datalad create-sibling-github -d . --name origin "$REPO_NAME"
fi

# Push Git history (annex content still goes to S3 via publish-depends)
datalad push --to origin

# In the parent repo, register the subdataset URL so fresh clones work
cd ..
datalad subdatasets --set-property url "$GH_URL" demo_dataset
datalad save -m "Register subdataset URL $GH_URL"
```

You can now try cloning your forked repo into a clean environment and syncing data with DataLad

```bash
# clone the parent
git clone https://github.com/<acct>/lab-data-workflow-workshop.git
cd lab-data-workflow-workshop

# switch to feature branch
git switch feature/git-datalad-local-workflow

# DataLad-native install of subdatasets (no git submodule update needed)
datalad get -n -r .
datalad get -r .
```
