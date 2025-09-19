#!/usr/bin/env bash
set -euo pipefail

read -rp "Full name for Git commits: " NAME
read -rp "Email for Git commits: " EMAIL

git config --global user.name "$NAME"
git config --global user.email "$EMAIL"

echo "[*] Git identity configured:"
git config --global user.name
git config --global user.email
