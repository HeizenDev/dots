# Documentation

This directory contains living documentation for the dotfiles repository.

The repository is moving toward a modular architecture where tools live under components, visual consistency comes from themes, and installation is orchestrated through a central installer.

## Start Here

- [`architecture.md`](architecture.md): target architecture and implementation plan.
- Numbered documents: existing component notes and historical implementation context.

## Documentation Goals

- Explain how the repository is organized.
- Record technical decisions and their reasons.
- Describe how each component should be installed and maintained.
- Preserve validations, tradeoffs, and lessons learned.
- Keep enough context for another agent or future maintainer to continue implementation safely.

## Suggested Future Documents

- `install.md`: installer usage and supported flags.
- `themes.md`: theme schema, rendering process, and how to add themes.
- `components.md`: how to add or modify components.
- `decisions.md`: important architecture decisions.
- `hypr.md`: Hyprland-specific behavior.
- `kitty.md`: Kitty-specific behavior.
- `waybar.md`: Waybar-specific behavior.

## Convention

- Use English for new documentation.
- Prefer one document per major concept or component.
- Use numbered files for chronological implementation notes.
- Use named files for stable reference documents.
- Each implementation note should explain what changed, why it changed, how to reproduce it, and which dependencies it has.
