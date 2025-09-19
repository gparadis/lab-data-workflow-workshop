# Common errors & quick fixes

### 1) I accidentally committed large data directly to Git
- Solution: move the file into annex
  ```bash
  git annex add path/to/largefile
  git rm --cached path/to/largefile
  datalad save -m "Move large file into annex"
  ```

### 2) `Permission denied` or missing S3 credentials
- Check env vars: `env | grep AWS`
- If using `~/.aws/credentials`, verify profile & permissions.
- If using `~/.passwd-s3fs`, ensure `chmod 600`.

### 3) `git-annex initremote` complains about `host` or endpoint
- Some endpoints require host name only (no `https://`).
- Try: `host=${S3_ENDPOINT_URL#*://}`
- Ensure region matches what the service expects.

### 4) Data not downloading on `datalad get`
- Run `git annex whereis <file>` to see available remotes.
- Ensure special remote is enabled: `git annex enableremote s3-storage`.
- Confirm that `datalad push --to s3-storage` previously succeeded.
