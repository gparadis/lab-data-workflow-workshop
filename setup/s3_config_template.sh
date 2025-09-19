#!/usr/bin/env bash
# Copy this to s3_config.sh and fill in, then: `source setup/s3_config.sh` (do NOT commit it).

export AWS_ACCESS_KEY_ID="YOUR_KEY_ID"
export AWS_SECRET_ACCESS_KEY="YOUR_SECRET_KEY"
export AWS_DEFAULT_REGION="YOUR_REGION"           # e.g., ca-central-1 (or as required by your endpoint)
export S3_ENDPOINT_URL="https://YOUR-ARBUTUS-ENDPOINT"  # e.g., https://object.arbutus.cloud

# For awscli and libraries honoring AWS_* variables:
export AWS_EC2_METADATA_DISABLED=true

echo "[*] Exported AWS env vars for this shell."
echo "    Reminder: do not commit this file."
