# 02 — DataLad local workflow

## Goals
- Initialize a DataLad dataset (will stash large file content in a local sibling datastore)
- Save code, inputs, and outputs with provenance
- Re‑run with a single command

## Steps

### 0) Switch to main git branch and create a new feature branch

```bash
git switch main
git checkout -b feature/git-datalad-local-workflow
```

### 1) Initialize DataLad repo as a subdataset and save (anologous to git commit)

First, we undo git tracking of the `demo_dataset` subdirectory (only applies to this branch) so we 
track it as a DataLad subdataset of the parent repo instead.

```bash
git rm -r --cached demo_dataset
git commit -m "Untrack demo_dataset in parent (retry for subdataset)"
```

Now that the `demo_dataset` is untracked, we can use the `datalad create` command to initialize it
as a DataLad dataset (analogous to `git init`). We need to use the `--force` flag because the directory is non-empty.
The `-c text2git` argument configures the DataLad dataset do small text files (e.g., code, Markdown documents, etc.)
are tracked by DataLad as regular `git` files (i.e., *not* with `git-annex`, which is the standard thing DataLad does).
This is going make the project simpler to understand for the purposes of this workshop (i.e., the README file will be 
visible and legible from the GitHub web interface), but in production projects choose whatever configuration makes
sense for your project (see DataLad documentation for details).

```bash
datalad create -d . --force -c text2git demo_dataset
```

Run a recursive `datalad save` command, which both initializes the `demo_data` subdataset and registers the subdataset in the parent repo.

```bash
datalad save -r -m "Initialize subdataset with existing content and register in parent"
```

### 2) Run the pipeline under DataLad control (records a command under a tag)

```bash
cd demo_dataset
datalad run -m "process data v1" "python3 code/process_data.py --input data/input.csv --out outputs/processed.csv"
```

### 3) Verify status

```bash
datalad status
```

### 4) Grab the commit that recorded your run

```bash
RUN=$(git log --grep='\[DATALAD RUNCMD\].*process data v1' --pretty=%H -n 1)
echo $RUN
```

### 5) Show the recorded run (report only)

```bash
datalad rerun --report $RUN
```

### 6) Diff exactly what that run changed

```bash
datalad diff -f ${RUN}^ -t ${RUN}
```

### 7) Generate a reproduce script for that single run

```bash
datalad rerun --script reproduce_v1.sh $RUN
chmod +x reproduce_v1.sh
```

### 8) Modify CSV input file and rerun pipeline

Add a data row to `data/input.csv`---the point here is to have output from the second `datalad run` command be different from the first one so there is a contrast we can observe later--and save the dataset so the tree is clean for the next run.

```bash
echo "f,6.0,3.5" >> data/input.csv
datalad save -m "append new data row to the end of data/input.csv"
```

When you are done modifying the dataset, save edits so the tree is clean for the next run and re-run the data processing pipeline (using a different tag than the first run, so we can easily identify them in a later step).

```bash
datalad save -m "prep for v2: tweak code/input"
datalad run -m "process data v2" "python3 code/process_data.py --input data/input.csv --out outputs/processed.csv"
```

### 10) Back up to the parent root and run a run a DataLad save to update subdataset pointers and other metadata

```bash
cd ..                      # back to parent repo root
datalad status             # should show "modified: demo_dataset (dataset)"
datalad save -m "demo_dataset: record v1/v2 runs (update subdataset pointer)"
```

### 11) Make sure the subdataset has a GitHub sibling and is pushed

First, we use the `datalad create-sibling-github` command, which automates the process of creating
a new DataLad sibling.

A DataLad sibling is an entry in your dataset’s “address book” that points to another clone/location of the same dataset (e.g., a GitHub repo, a server over SSH). You use siblings to push and pull the dataset’s Git history and small files (metadata).

Large file content typically lives in git-annex special remotes (e.g., S3). Those are not siblings, but you can tie them to a sibling so that pushing to the sibling ensures content is available (via `--publish-depends`, which we will deal with later in the workshop).

Common DataLad things you might do related to this:

```bash
# See configured siblings for the current dataset
datalad siblings

# Add a sibling (existing remote)
datalad siblings add -s origin --url https://github.com/<user-or-org>/<repo>.git

# Create a new GitHub repo and wire it as a sibling (in one step)
datalad create-sibling-github -d . --name origin <repo-name>

# Remove a sibling
datalad siblings remove -s origin

# Push dataset metadata/history to a sibling
datalad push --to origin
```

Quick contrasts:
- **Sibling**: another location of the same dataset (peer/remote for Git metadata).
- **Subdataset**: nested dataset inside your dataset (like a Git submodule).
- **Special remote (annex)**: content store for large files (e.g., S3); complements siblings.

Now go ahead and create the new `origin` sibling (which will automatically create a new repo in your GitHub account).
These sibling creating commands are a bit finicky with respect to syntax, so to help you avoid getting all tangled up
in a DataLad errors we have set this up below in a way that should work if you ran the scripts in `setup` correctly at
at the start of the workshop (pulls some environment variables that got set in those scripts, and automatically 
detects if you are working from a GitHub organization or your individual GitHub account and adapts the `datalad create-sibling-github` command syntax to whichever case applies to you). 

```bash
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
```

Now push your new DataLad dataset out to GitHub, and then back up to the parent repo and register
the subdataset so we can clone from a different location and all the bits and pieces stay linked 
together and we can restore full copies of this environment in new clones.

```bash
# Push Git history (annex content still goes to S3 via publish-depends)
datalad push --to origin

# In the parent repo, register the subdataset URL so fresh clones work
cd ..
datalad subdatasets --set-property url "$GH_URL" demo_dataset
datalad save -m "Register subdataset URL $GH_URL"
```

### 12) Clone into a fresh environment

You can now try cloning your forked repo into a clean environment and syncing data with DataLad.

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

Print a quick list of all `datalad run` commands (you should see both v1 and v2 runs in there).

```bash
# short, readable list (hash, date, subject)
git log --grep='\[DATALAD RUNCMD\]' --pretty='%h  %ad  %s' --date=short
```

Grab the exact v1/v2 commits.

```bash
V1=$(git log --grep='process data v1' --pretty=%H -n 1)
V2=$(git log --grep='process data v2' --pretty=%H -n 1)
echo "V1=$V1"
echo "V2=$V2"
```

Show the recorded command & summary (no execution).
```bash
datalad rerun --report "$V1"
datalad rerun --report "$V2"
```

See exactly what each run changed.
```bash
datalad diff -f ${V1}^ -t ${V1}
datalad diff -f ${V2}^ -t ${V2}
```

(Optional) Show the full commit message / command blob.

```bash
git show -s --format=%B "$V1"
git show -s --format=%B "$V2"
```

(Optional) Emit reproducion scripts.

```bash
datalad rerun --script reproduce_v1.sh "$V1" && chmod +x reproduce_v1.sh
datalad rerun --script reproduce_v2.sh "$V2" && chmod +x reproduce_v2.sh
```