# Workshop: Reproducible Research Data Workflow

## Why this workflow?
- Reproducibility, provenance, collaboration
- Clear separation of code (GitHub) and data (annex/S3)
- Scales from laptop to cloud

## Tools
- Git + GitHub
- DataLad (built on git‑annex)
- S3 (Arbutus) as durable object storage
- LXD + CodeServer for consistent environments

## Hands-on roadmap
1. Git‑only warm‑up
2. DataLad local dataset + `datalad run`
3. S3 special remote + pushing/pulling content

## Key practices
- Keep secrets out of Git
- Track large files with annex (not Git)
- Use small, scripted examples for teaching
