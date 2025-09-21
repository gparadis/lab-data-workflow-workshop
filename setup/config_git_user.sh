#!/usr/bin/env bash
set -euo pipefail

read -rp "Full name for Git commits: " NAME
read -rp "Email for Git commits: " EMAIL

git config --global user.name "$NAME"
git config --global user.email "$EMAIL"

echo "[*] Git identity configured:"
git config --global user.name
git config --global user.email

# Make 'git push' on a new branch automatically create & track the same-named remote branch
git config --global push.autoSetupRemote true

# Nice-to-haves for consistency
git config --global init.defaultBranch main      # new repos default to 'main'
# git config --global remote.pushDefault origin  # uncomment only if every repo uses 'origin'