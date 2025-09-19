# Mounting an S3 bucket with s3fs (optional)

> Use this only for human inspection or ad‑hoc copying. For reproducible data flow,
> prefer DataLad/git‑annex special remotes instead of mounting.

## Prereqs

- `s3fs` installed (see `setup/install_datalad.sh`)
- Credentials configured in environment (`AWS_*`) or `~/.passwd-s3fs`

Create `~/.passwd-s3fs` (one line: `ACCESS_KEY:SECRET_KEY`) and set strict perms:

```bash
echo "AKIA...:SECRET..." > ~/.passwd-s3fs
chmod 600 ~/.passwd-s3fs
```

## Mount

```bash
BUCKET=my-workshop-bucket
MP=$HOME/s3mnt
mkdir -p "$MP"

# If your endpoint is non‑AWS, pass it explicitly:
s3fs $BUCKET $MP -o endpoint=${S3_ENDPOINT_URL:-https://s3.amazonaws.com} -o url=${S3_ENDPOINT_URL:-https://s3.amazonaws.com} -o use_path_request_style -o iam_role=auto -o mp_umask=002
```

Check it:

```bash
df -h | grep s3fs || mount | grep s3fs
ls -lah $MP
```

Unmount:

```bash
fusermount -u $MP || sudo umount $MP
```
