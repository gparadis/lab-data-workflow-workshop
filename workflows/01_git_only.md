# 01 — Git‑only workflow (warm‑up)

## Goals
- Practice basic Git operations (clone, branch, commit, push, PR)
- Run a tiny Python pipeline and track changes

## Steps

### 1) Fork the original repo

Before we do anything else, fork the original `UBC-FRESH/lab-data-workflow-workshop` repo to your own GitHub account so you have full push/pull permissions and can experiment without making a mess in the original repo.

https://github.com/UBC-FRESH/lab-data-workflow-workshop

### 2) Clone your forked repo

```bash
git clone <YOUR_GITHUB_REPO_URL> lab-data-workflow-workshop
cd lab-data-workflow-workshop
```

### 3) Create a feature branch
```bash
git checkout -b feature/git-only-workflow
```

### 4) Run the demo pipeline
```bash
cd demo_dataset
python3 code/process_data.py --input data/input.csv --out outputs/processed.csv
```

### 5) Inspect the new files
```bash
ls -lah outputs
```

### 6) Commit and push

If you are using a VSCode interface, you could alternatively use the GitHub GUI tools to stage the modified files, enter a commit message, commit your changes, and push the new git feature branch up to the origin GitHub repo. If your environment is configured correctly, the commands below should do the same thing.

```bash
git add -A
git commit -m "Run pipeline and capture outputs"
git push -u origin HEAD
```

### 7) Open a Pull Request on GitHub

At this point in the workshop, sit back and watch the instructor demonstrate GitHub PR review workflow (skip this step if you are working through this in self-directed mode).
```
