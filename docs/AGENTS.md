# Documentation Guide

This directory contains maintainer-facing documentation for the `dots` repository.

## Start Here

- `architecture.md`: current repository architecture and operating model.
- `install.md`: installer behavior and supported commands.
- `themes.md`: theme palette format and generated files.
- `components.md`: component layout and installation contract.

## Documentation Goals

- Describe the current implementation, not an aspirational design.
- Record technical decisions and their reasons.
- Explain how each component is installed and maintained.
- Preserve validations, tradeoffs, and lessons learned.
- Keep enough context for another maintainer or agent to continue safely.

## Conventions

- Use English for all repository documentation.
- Prefer one document per major concept or component.
- Keep user-facing instructions in the root `README.md`.
- Keep implementation details in `docs/`.
- Use named files for stable reference documents.
- Use numbered files only for chronological implementation notes.
- Each implementation note should explain what changed, why it changed, how to reproduce it, and which dependencies it has.
