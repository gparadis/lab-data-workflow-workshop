# Cheat Sheet — Git · DataLad · S3

## Git
```bash
git status
git checkout -b feature/xyz
git add -A
git commit -m "message"
git push -u origin HEAD
git pull --rebase
```

## DataLad
```bash
datalad create -c text2git
datalad status
datalad save -m "message"
datalad run -m "proc v1" "python3 script.py --flags"
datalad get path/to/file         # fetch content
datalad drop path/to/file        # drop local content (kept in remotes)
datalad push --to REMOTE_NAME
```

## git-annex (under the hood)
```bash
git annex whereis path/to/file
git annex enableremote REMOTE_NAME
```

## S3 (awscli)
```bash
aws s3 ls
aws s3 cp local.file s3://my-bucket/path/
```

## Safety
- Never commit secrets (keys, passwords).
- Keep big files in annex, not Git.
- Prefer scripted `datalad run` over manual steps for provenance.
