# 03 — DataLad + S3 special remote

## Goals
- Configure S3 as the annex content store
- Push content to S3 (GitHub remains the Git remote)
- Retrieve content from a fresh clone

Follow `arbutus_s3/datalad_s3_setup.md` closely. High‑level steps:

0. *Skip this if you did this already from README quickstart instructions and still running in the same shell.* Export AWS/S3 env vars and configure  (`source setup/02_datalad_config.sh` and `source setup/03_config_git_user.sh`).
2. Inside `demo_dataset/`, ensure DataLad is initialized and saved.
3. Create the S3 special remote (`git annex initremote ...` or `datalad create-sibling-s3`).
4. `datalad push --to s3-storage`
5. From a fresh clone of the GitHub repo, `datalad get` to retrieve content.
