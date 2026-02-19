# Agent Instructions

## When documenting
Always default to brief documentation, only highlighting what's necessary unless asked otherwise. But be sure to (when applicable) include mermaid graphs that help illustrate the data being documented.

## Branch Naming
When creating branches, prefix with `agent/`.

## Refine Step
After each completed change, run a refine step: relevant tests, formatting, linting, compiling, building.

## Building for GCP
- Use region `europe-north1` (Hamina/Finland) for Cloud Run
- Set max instances to 1 to minimize costs

## Python
When running one-off Python commands, use `uvx` (uv run) to avoid polluting the global pip environment:

```bash
uvx --with <package> python3 -c "..."
```

For example:
```bash
uvx --with pillow python3 -c "from PIL import Image; ..."
```
