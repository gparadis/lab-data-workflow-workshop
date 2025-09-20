# 01 — Git‑only workflow (warm‑up)

## Goals
- Practice basic Git operations (clone, branch, commit, push, PR)
- Run a tiny Python pipeline and track changes

## Steps

First fork the original `UBC-FRESH/lab-data-workflow-workshop` repo to your own GitHub account so you have full push/pull permissions and can experiment without making a mess in the original repo.

https://github.com/UBC-FRESH/lab-data-workflow-workshop

```bash
# 1) Clone your forked repo
git clone <YOUR_GITHUB_REPO_URL> lab-data-workflow-workshop
cd lab-data-workflow-workshop

# 2) Configure your identity (first time only)
./setup/config_git_user.sh

# 3) Create a feature branch
git checkout -b feature/<your-name>-tweak

# 4) Run the demo pipeline
python3 demo_dataset/code/process_data.py --input demo_dataset/data/input.csv --out demo_dataset/outputs/processed.csv

# 5) Inspect the new files
ls -lah demo_dataset/outputs

# 6) Commit and push
git add -A
git commit -m "Run pipeline and capture outputs"
git push -u origin HEAD

# 7) Open a Pull Request on GitHub
# (Demonstrate PR review flow in the workshop)
```
