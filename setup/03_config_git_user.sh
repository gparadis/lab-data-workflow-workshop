#!/usr/bin/env bash
# set -euo pipefail (crashes VSCode shell sometimes so disabling for now)

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

# Use a working credential helper (disable the VS Code socket helper)
git config --global --unset-all credential.helper || true

# Prefer gh if available; else fall back to 'store'
if command -v gh >/dev/null 2>&1; then
  echo "[*] Using GitHub CLI for git authentication"
  # Expect GH token in DATALAD_GITHUB_TOKEN or GH_TOKEN if you want to pre-seed
  if [ -n "${DATALAD_GITHUB_TOKEN:-}" ]; then
    gh auth login --with-token <<< "$DATALAD_GITHUB_TOKEN"
  fi
  gh auth setup-git
else
  echo "[*] Using git credential store (plaintext in ~/.git-credentials)"
  git config --global credential.helper store
fi

# Quality-of-life: auto create upstream on first push
git config --global push.autoSetupRemote true

# ---- resolve GitHub owner (org or user) ----
# If you want to force an org, export GITHUB_ORGANIZATION=UBC-FRESH beforehand.
# Else we'll use your user login.

get_gh_owner() {
  # 1) explicit org wins
  if [ -n "${GITHUB_ORGANIZATION:-}" ]; then
    echo "$GITHUB_ORGANIZATION"; return
  fi

  # 2) gh CLI (best UX)
  if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
    gh api user -q .login 2>/dev/null && return
  fi

  # 3) PAT in env (DataLad uses this too)
  if [ -n "${DATALAD_GITHUB_TOKEN:-}" ]; then
    curl -s -H "Authorization: token $DATALAD_GITHUB_TOKEN" https://api.github.com/user \
      | sed -n 's/.*"login"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n1 && return
  fi

  # 4) infer from an existing origin URL (ssh/https)
  o=$(git remote get-url origin 2>/dev/null || true)
  case "$o" in
    git@github.com:*/*)   echo "${o#git@github.com:}" | cut -d/ -f1; return ;;
    https://github.com/*) echo "${o#https://github.com/}" | cut -d/ -f1; return ;;
  esac

  echo "Set GITHUB_ORGANIZATION=<org> or login with 'gh auth login' (or export DATALAD_GITHUB_TOKEN)" >&2
  return 1
}

export GH_OWNER=$(get_gh_owner) || exit 1
echo "GitHub owner resolved to: $GH_OWNER"