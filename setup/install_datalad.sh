#!/usr/bin/env bash
set -euo pipefail

echo "[*] Updating apt and installing system packages..."
sudo apt-get update -y
sudo apt-get install -y git git-annex datalad python3-pip s3fs awscli

echo "[*] Installing Python packages..."
python3 -m pip install --upgrade pip
python3 -m pip install pandas boto3 datalad-next

echo "[*] Versions:"
git --version || true
datalad --version || true
git-annex version || true
python3 --version || true
aws --version || true
s3fs --version || true

echo "[*] Done. If you will use S3, configure credentials next:"
echo "    - Edit: setup/s3_config_template.sh (copy to s3_config.sh and fill in)"
