# DataLad + S3 special remote (Arbutus compatible)

This sets up **S3 as a git‑annex special remote** for file content, while the Git repo
lives on GitHub. This is the recommended pattern for reproducible data.

## 0) Prereqs

- `datalad` and `git‑annex` installed
- `datalad-next` installed (`pip install datalad-next`)
- `AWS_*` env vars exported **or** credentials configured via `aws configure`

## 1) Create or clone your dataset

If starting fresh (inside this repository):

```bash
cd demo_dataset
datalad create -c text2git  # initializes DataLad in this directory
# (This repo already contains small text in Git; large files go to annex)
```

If the dataset already exists, `cd` into it.

## 2) Save the current state

```bash
datalad status
datalad save -m "Initial dataset state"
```

## 3) Create S3 special remote

Replace placeholders with your values:

```bash
REMOTE_NAME="s3-storage"
BUCKET="my-workshop-bucket"
ENDPOINT="${S3_ENDPOINT_URL}"      # export via setup/s3_config.sh
REGION="${AWS_DEFAULT_REGION}"     # export via setup/s3_config.sh

# Create an annex special remote using datalad-next (wraps git-annex initremote)
datalad -f json run-procedure cfg_s3   || true  # harmless if missing
git annex initremote "$REMOTE_NAME" type=S3     encryption=none     bucket="$BUCKET"     host="${ENDPOINT}"     public=no     fileprefix="annex/${USER}/demo"     datacenter="$REGION"     chunk=50MiB     partsize=50MiB     autoenable=true     importtree=no
```

> Notes:
> - Some endpoints require `host` without scheme. If init fails, try `host=${ENDPOINT#*://}` to drop `https://`.
> - You can also use `datalad create-sibling-s3` as a higher‑level wrapper when appropriate.

## 4) Push content to S3

```bash
# Ensure GitHub remote 'origin' exists for the Git history (code & metadata).
git remote -v

# Push annexed file content to S3:
datalad push --to "$REMOTE_NAME"
```

## 5) Test on a fresh clone

- Clone the Git repo from GitHub (NOT from S3).
- Inside the dataset directory, fetch file content on demand:

```bash
datalad get demo_dataset/outputs/processed.csv
```

If content is available in S3, this will retrieve it via the special remote.

## Troubleshooting

- If initremote complains about `host`, try removing the scheme or specifying `export AWS_S3_ENDPOINT` alternatives supported by git-annex.
- Ensure credentials are visible to the process (`env | grep AWS`).
- If large files accidentally landed in Git, move them to annex (`git annex add` then `git rm --cached`).
