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
cp -r demo_dataset demo_dataset_datalad_s3
cd demo_dataset_datalad_s3
rm output/*
datalad create --force -c text2git  # initializes DataLad in this directory
```

## 2) Generate some fresh output and save the current state

```bash
datalad run -m "process data v1" "python3 code/process_data.py --input data/input.csv --out outputs/processed.csv"
datalad status
datalad save -m "Initial dataset state"
datalad status
```

## 3) Create S3 special remote

Replace placeholders with your values:

```bash
REMOTE_NAME="arbutus-s3"
BUCKET="${S3_BUCKET_NAME}"         # export via setup/s3_config.sh
ENDPOINT="${S3_ENDPOINT_URL}"      # export via setup/s3_config.sh
REGION="${AWS_DEFAULT_REGION}"     # export via setup/s3_config.sh

# Create an annex special remote using datalad-next (wraps git-annex initremote)
git annex initremote "$REMOTE_NAME" \
  type=S3 \
  encryption=none \
  bucket="$BUCKET" \
  host="${ENDPOINT}" \
  public=yes \
  publicurl="$ENDPOINT/$BUCKET" \
  host=object-arbutus.cloud.computecanada.ca \
  protocol=https \
  requeststyle=path \
  autoenable=true

# Create a GitHub repo in the GitHub organization (or user account) you set in setup/s3_config.sh and wire it up as 'origin'
datalad create-sibling-github -d . \
  --github-organization "${GITHUB_ORGANIZATION}" \
  --name origin \
  --publish-depends arbutus-s3 \
  lab_data_workflow_workshop_demo_dataset_datalad_s3

# verify siblings
datalad siblings
```

> Notes:
> - Some endpoints require `host` without scheme. If init fails, try `host=${ENDPOINT#*://}` to drop `https://`.
> - You can also use `datalad create-sibling-s3` as a higher‑level wrapper when appropriate.

## 4) Push content to S3

```bash
# Ensure GitHub remote 'origin' exists for the Git history (code & metadata).
git remote -v

# push Git history to GitHub, annex files automatically pushed to S3 sibling due to publish-depends
datalad push --to origin
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
