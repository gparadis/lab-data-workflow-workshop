#!/usr/bin/env bash
# Copy this to s3_config.sh and fill in, edit to add missing AWS access key ID and secret access key, 
# and then `source setup/s3_config.sh`.
# Do NOT commit it--root .gitignore configured to ignore that filename so should be safe[ish] from commit).

export AWS_ACCESS_KEY_ID="YOUR_KEY_ID"                                  # from output of `openstack ec2 credentials create`, or provided by Arbutus project admininstrator
export AWS_SECRET_ACCESS_KEY="YOUR_SECRET_KEY"                          # from output of `openstack ec2 credentials create`, or provided by Arbutus project admininstrator
export AWS_DEFAULT_REGION="ca-west-1"                                   # do not modify this unless you are sure that you know what you are doing
export S3_ENDPOINT_URL="https://object-arbutus.cloud.computecanada.ca"  # do not modify this unless you are sure that you know what you are doing
export S3_BUCKET_NAME="UNIQUE_BUCKET_NAME"                              # bucket name must be unique within endpoint namespace
export GITHUB_ORGANIZATION="YOUR_GITHUB_ORGANIZATION_OR_USERNAME"       # modify this to match your situation
export GITHUB_REPO_NAME="UNIQUE_REPO_NAME"                      # repo name must be unique within the GitHub organization namespace

# For awscli and libraries honoring AWS_* variables:
export AWS_EC2_METADATA_DISABLED=true

echo "[*] Exported AWS env vars for this shell."
echo "    Reminder: do not commit this file."
