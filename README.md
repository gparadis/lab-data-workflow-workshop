# Lab Data Workflow Workshop

A one‑stop, clone‑and‑go repository for your workshop on **Git + DataLad + S3 (Arbutus)**.
Designed to be used inside a shared CodeServer/VSCode environment on Ubuntu 24.04 running
in an LXD container on `fresh01` so everyone starts from the same baseline.

> **Workshop date:** TBD — Generated on 2025-09-19

## What’s inside?

- `setup/` — scripts to install requirements and configure Git & S3 creds
- `demo_dataset/` — a tiny dataset + Python script to simulate a data pipeline
- `arbutus_s3/` — S3 + DataLad special‑remote how‑tos (works with Arbutus S3)
- `workflows/` — step‑by‑step labs (Git only; DataLad local; DataLad + S3)
- `handouts/` — printable cheat sheet
- `slides/` — intro slides (Markdown)
- `LICENSES/` — code under MIT; docs under CC BY 4.0

## Quickstart (in the shared dev container)

Set up environment.

```bash
# 1) Clone this repository
git clone https://github.com/UBC-FRESH/lab-data-workflow-workshop
cd lab-data-workflow-workshop

# 2) Install tools (idempotent; safe to re-run)
./setup/install_datalad.sh

# 3) Configure your Git identity (once)
./setup/config_git_user.sh
```

Follow `workflows/01_git_only.md` to run a git-only workflow to work through what a basic (no DataLad) workflow looks like.

### Optional: configure S3 (Arbutus) for DataLad
1) Copy and edit `setup/s3_config_template.sh` (do **not** commit secrets!)
2) Follow `arbutus_s3/datalad_s3_setup.md` to add an S3 special‑remote for annexed data.
3) Follow `workflows/02_git_datalad_local.md` and `workflows/03_git_datalad_s3.md` to work through what the workflow looks like just using local DataLad (git annex) file storage and Arbutus S3 bucket special remote (git annex) files storage. 

## Repo licensing

- **Code**: MIT (see `LICENSES/LICENSE-MIT`)
- **Slides, handouts, docs**: CC BY 4.0 (see `LICENSES/LICENSE-CC-BY-4.0`)

## Safety notes

- Never commit secrets. Use env vars or the `~/.aws/credentials` file.
- For large files, rely on **git‑annex via DataLad** rather than committing to Git.
- This repo is deliberately small so it’s easy to demo and debug.
