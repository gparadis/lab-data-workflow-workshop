#!/usr/bin/env bash
set -euo pipefail

# Required vars
: "${ORG:?Set ORG (e.g., UBC-FRESH)}"
: "${ORIGIN:?Set ORIGIN (e.g., origin)}"
: "${REMOTE:?Set REMOTE (e.g., arbutus-s3)}"
: "${REPO:?Set REPO (e.g., demo_dataset_datalad_s3)}"

echo "ORG=$ORG ORIGIN=$ORIGIN REMOTE=$REMOTE REPO=$REPO"

# Detect if repo already exists in the org
if git ls-remote --exit-code "https://github.com/${ORG}/${REPO}.git" >/dev/null 2>&1; then
  echo "Repo exists; reconfiguring sibling…"
  datalad create-sibling-github -d . \
    --github-organization "$ORG" \
    --name "$ORIGIN" \
    --publish-depends "$REMOTE" \
    --existing reconfigure \
    "$REPO"
else
  echo "Creating new GitHub repo and wiring sibling…"
  datalad create-sibling-github -d . \
    --github-organization "$ORG" \
    --name "$ORIGIN" \
    --publish-depends "$REMOTE" \
    "$REPO"
fi

datalad siblings
echo "Now push metadata:  datalad push --to \"$ORIGIN\""