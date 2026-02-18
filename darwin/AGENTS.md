# Agent Instructions

## When documenting
Always default to brief documentation, only highlighting what's necessary unless asked otherwise. But be sure to (when applicable) include mermaid graphs that help illustrate the data being documented.

## Branch Naming
When creating branches, prefix with `agent/`.

## Refine Step
After each completed change, run a refine step: relevant tests, formatting, linting, compiling, building.

## Building for GCP
- Use region `europe-north2` (Stockholm) for Cloud Run
- Set max instances to 1 to minimize costs
- Build Docker locally and push to GCR: `docker build -t gcr.io/PROJECT/IMAGE . && docker push gcr.io/PROJECT/IMAGE`
