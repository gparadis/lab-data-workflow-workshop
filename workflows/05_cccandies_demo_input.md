# 05 — Get the cccandies_demo_input subdataset from Arbutus S3 with DataLad

The subdataset `cccandies_demo_input` (~4 GB) is tracked with DataLad/git-annex and its file content lives in an Arbutus S3 special remote. Typical end-to-end download throughput is around 25–35 MB/s (about 30 MB/s). This guide shows how to install the subdataset and retrieve some large files to observe the transfer speed.

Prereqs
- DataLad and git-annex installed
  - Debian/Ubuntu: sudo apt-get install datalad git-annex
  - Conda: conda install -c conda-forge datalad git-annex
- If the S3 bucket is private in your environment, export AWS/S3 env vars (or source setup/02_datalad_config.sh). For a public bucket this is not required.

1) Install the subdataset (no data yet)
Run from the repository root:

```bash
# Install the subdataset without fetching file content (metadata only)
datalad get -n cccandies_demo_input
```

2) Enter the subdataset and ensure the S3 special remote is enabled

```bash
cd cccandies_demo_input
# Show configured siblings (Git remotes) and special remotes (annex)
datalad siblings

# If the arbutus-s3 special remote is not auto-enabled, enable it explicitly
# (safe to run even if already enabled)
git annex enableremote arbutus-s3 || true
```

3) Quick single-file speed check (one large TIFF)
Pick one file from a “full” imagery directory (tif/tsa41full or tif/tsa40full). If you’re unsure which file to pick, use the first entry in the directory listing:

```bash
# Choose a candidate large file (adjust folder if desired)
FILE=$(git ls-files tif/tsa41full | head -n 1)
echo "Testing with: $FILE"

# Ensure we download from S3 freshly (drop local copy if present)
datalad drop -f "$FILE" 2>/dev/null || true

# Time the transfer and compute observed MB/s
START=$(date +%s)
datalad get "$FILE"
END=$(date +%s)
SIZE=$(stat -c %s "$FILE")
DUR=$((END-START))
MBPS=$(awk "BEGIN{printf \"%.2f\", $SIZE/$DUR/1024/1024}")
echo "Downloaded $(numfmt --to=iec --suffix=B $SIZE) in ${DUR}s → ~${MBPS} MB/s"
```

Notes
- git-annex prints per-transfer speeds during the download; the computed MB/s above is an overall average.
- If your terminal does not show progress lines, you can add -c datalad.log.level=INFO to the datalad command.

4) Multi-file speed demo (optional)
To observe sustained throughput across multiple large files, fetch an entire directory recursively. Enable a few concurrent jobs to populate several files in parallel.

```bash
# Example: tsa41full imagery (adjust path to any large subdir you want)
time datalad -c datalad.runtime.max-annex-jobs=4 get -r tif/tsa41full
```

5) Verify integrity and remote availability (optional)

```bash
git annex whereis "$FILE"
```

6) Free up space when done (optional)

```bash
# Drop a single file
datalad drop "$FILE"
# Or drop a whole directory
datalad drop -r tif/tsa41full
```

Troubleshooting
- If enableremote fails, confirm you have network access to the Arbutus S3 endpoint and, if needed, credentials exported (see `arbutus_s3/datalad_s3_setup.md`).
- If downloads are very slow, check for competing bandwidth, confirm you’re on the Arbutus network, and avoid running many parallel jobs on an underpowered machine.
- For background on how the special remote is configured, see `workflows/03_git_datalad_s3.md` and `arbutus_s3/datalad_s3_setup.md`.
