# Lab Data Workflow Workshop

A one‑stop, clone‑and‑go repository for your workshop on **Git + DataLad + S3 (Arbutus)**.
Designed to be used inside a shared CodeServer/VSCode environment on Ubuntu 24.04 running
in an LXD container on `fresh01` so everyone starts from the same baseline. Should be runable
other linux-based environments, but has not be tested outside of this specific
target environment.

## What’s inside?

- `setup/` — scripts to install requirements and configure git + AWS S3 creds
- `demo_dataset/` — a tiny dataset + Python script to simulate a data processing pipeline
- `arbutus_s3/` — S3 + DataLad special‑remote how‑tos (works with Arbutus S3 object storage)
- `workflows/` — step‑by‑step labs (Git only; DataLad local; DataLad + S3)
- `handouts/` — printable cheat sheet
- `slides/` — intro slide bullet summary (Markdown)
- `LICENSES/` — code under MIT; docs under CC BY 4.0

## Quickstart (in the shared dev container)

First fork the original `UBC-FRESH/lab-data-workflow-workshop` repo to your own GitHub account so you have full push/pull permissions and can experiment without making a mess in the original repo.

https://github.com/UBC-FRESH/lab-data-workflow-workshop

Next, log into the codeserver (i.e., VSCode) interface in your dev container and set up the environment using the steps below.

Use the VSCode GitHub integration to clone the forked repo if you are working in a VSCode interface (simpler and cleaner).

```bash
# 0) Clone your forked repo 
git clone <YOUR_GITHUB_REPO_URL> lab-data-workflow-workshop # use the VSCode GitHub integration instead if available
cd lab-data-workflow-workshop

# 1) Install tools (idempotent; safe to re-run; assumes your has sudo privileges inside your dev container)
./setup/01_install_datalad.sh

# 3) Copy setup/02_datalad_config_template.sh to setup/02_datalad_config.sh, edit, and run
cp setup/02_datalad_config_template.sh setup/02_datalad_config.sh
# TO DO BEFORE RUNNING THE NEXT LINE: edit setup/02_datalad_config.sh (ask workshop leader for help if needed)
source setup/02_datalad_config.sh

# 3) Configure your Git identity and environment
source setup/03_config_git_user.sh
```

Follow the instructions in `workflows/*.md` to run through various data management workflow scenarios (i.e., a git-only workflow, a git + DataLad workflow using only local object storage, a git + DataLad workflow using special remote S3 bucket object storage in an Arbutus cloud account, etc.).  

## Repo licensing

- **Code**: MIT (see `LICENSES/LICENSE-MIT`)
- **Slides, handouts, docs**: CC BY 4.0 (see `LICENSES/LICENSE-CC-BY-4.0`)

## Safety notes

- Never commit secrets. Use env vars or the `~/.aws/credentials` file.
- For large files, rely on **git‑annex via DataLad** rather than committing to Git.
- This repo is deliberately small so it’s easy to demo and debug.
