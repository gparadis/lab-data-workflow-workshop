# 03 — DataLad + S3 special remote

## Goals
- Configure S3 as the annex content store
- Push content to S3 (GitHub remains the Git remote)
- Retrieve content from a fresh clone

Follow `arbutus_s3/datalad_s3_setup.md` closely. High‑level steps:

1. Export AWS/S3 env vars (`source setup/s3_config.sh` — created from template).
2. Inside `demo_dataset/`, ensure DataLad is initialized and saved.
3. Create the S3 special remote (`git annex initremote ...` or `datalad create-sibling-s3`).
4. `datalad push --to s3-storage`
5. From a fresh clone of the GitHub repo, `datalad get` to retrieve content.
