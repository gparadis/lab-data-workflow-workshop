# 04 — DataLad + GIN (git + annex)

## Goals
- Initialize a DataLad dataset (subdataset) so large files are annexed
- Create a GIN sibling that supports both Git metadata and annexed content
- Push both Git history and large-file content to GIN
- Re‑run and retrieve content from a fresh clone

## Prereqs
- You have a GIN account: https://gin.g-node.org/
- You can authenticate via SSH (recommended) or HTTPS. For SSH, upload your public key to GIN.
- DataLad is configured (see setup scripts used earlier in the workshop).

## Steps

### 0) Switch to main git branch and create a new feature branch

```bash
git switch main
git checkout -b feature/git-datalad-gin-workflow
```

### 1) Initialize DataLad repo as a subdataset (annex-enabled) and save

Undo Git tracking of `demo_dataset` in the parent (only on this branch), then create it as a DataLad subdataset. Unlike the local/GitHub workflow, we do NOT use `-c text2git` so that non-text/large files are tracked by git-annex (default).

```bash
git rm -r --cached demo_dataset
git commit -m "Untrack demo_dataset in parent (prepare for subdataset)"

# Create subdataset (default config => annex for large files)
datalad create -d . --force demo_dataset

datalad save -r -m "Initialize subdataset and register in parent"
```

### 2) Run the pipeline under DataLad control (records a command)

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

### 9) Back up to the parent and save updated subdataset pointer

```bash
cd ..                      # back to parent repo root
datalad status             # should show "modified: demo_dataset (dataset)"
datalad save -m "demo_dataset: record v1/v2 runs (update subdataset pointer)"
```

### 10) Create a GIN sibling for both Git and annex content, then push

GIN siblings provide both:
- A Git remote for history/metadata ("gin").
- A storage sibling for annexed content ("gin-storage").

```bash
# Ensure you have an SSH key and it’s added to GIN
test -f ~/.ssh/id_ed25519.pub || ssh-keygen -t ed25519 -C "$USER@$(hostname)"
cat ~/.ssh/id_ed25519.pub     # paste at https://gin.g-node.org/user/settings/keys
ssh -T git@gin.g-node.org     # accept host key; should say "Permission denied" but show your user => OK
```

Create the sibling, configure push dependencies, and push.

Choose a unique repo name under your GIN account.

```bash
REPO_NAME="${GITHUB_REPO_NAME_GIN}"
```

Create the GIN sibling (SSH recommended). This creates two siblings: `gin` and `gin-storage`. Print list of siblings after creating to see what is going on here.

```bash
cd demo_dataset
datalad create-sibling-gin "$REPO_NAME" -s gin --access-protocol ssh
datalad siblings
```

Note that we passed `--access-protocol https` to `create-sibling-gin` to use HTTPS access protocol (defaults to SSH) so we can just use a GIN access token. To use SSH access protocol you have to create an RSA key pair, upload the public half of the key pair to your GIN account, etc. Students often get all tangled up in the process of creatingt and deploying RSA key pairs, so we are skipping all of that for now by forcing DataLad to use the HTTPS protocol for the GIN sibling.

Push Git history/metadata (annex content will be sent to gin-storage via publish-depends). First push creates git-annex branch remotely and obtains annex UUID).

```bash
datalad push --to gin
```

Now register the subdataset URL in the parent so fresh clones know where to get it, then push the parent.

```bash
# Build the canonical SSH URL (adjust if you used HTTPS)
GIN_USERNAME="${GIN_USERNAME}"
GIN_URL="https://gin.g-node.org/${GIN_USERNAME}/${REPO_NAME}.git"

cd ..
datalad subdatasets --set-property url "$GIN_URL" demo_dataset
datalad save -m "Register subdataset URL $GIN_URL"

datalad push --to origin
```

Notes:
- Use `--private` in `create-sibling-gin` to create a private repository.
- If needed, you can create the repo in a GIN organization via that org’s UI, then wire it with `datalad siblings add`.

### 12) Clone into a fresh environment and retrieve content from GIN

```bash
# clone the parent from GitHub (as before)
git clone https://github.com/<acct>/lab-data-workflow-workshop.git
cd lab-data-workflow-workshop

# switch to this feature branch
git switch feature/git-datalad-gin-workflow

# Install subdatasets
datalad get -n -r .

cd demo_dataset

# Inspect recorded runs
git log --grep='\[DATALAD RUNCMD\]' --pretty='%h  %ad  %s' --date=short

# Retrieve annexed content (if not present)
datalad get outputs/processed.csv

# Optional: prove retrieval works by dropping then getting content
# datalad drop -r outputs/processed.csv
# datalad get outputs/processed.csv

# Grab exact commits and inspect
V1=$(git log --grep='process data v1' --pretty=%H -n 1)
echo "V1=$V1";
datalad rerun --report "$V1"
datalad diff -f ${V1}^ -t ${V1}
```

Common commands recap:
- `datalad siblings` — list configured siblings (expect `gin` and `gin-storage`).
- `datalad push --to gin` — push Git history; with publish-depends, annex content goes to `gin-storage`.
- `datalad get <path>` — fetch annexed file content from available content remotes (here, GIN storage).
