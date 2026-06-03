# Architecture

This document describes the current implementation of `dots`.

## Overview

`dots` is an opinionated, minimal Hyprland setup for developers. It currently targets CachyOS/Arch-based systems, installs package groups, links component configuration files, applies generated theme files, and exposes a small CLI under `bin/`.

## Repository Layout

```text
dots/
├── install.sh
├── bin/
├── components/
├── docs/
├── hosts/
├── packages/
└── themes/
```

## Main Entry Points

- `install.sh`: top-level installer and orchestrator.
- `bin/dots`: user-facing helper command.
- `bin/dots-install-packages`: installs package groups with `pacman`.
- `bin/dots-install-component`: runs a component installer.
- `bin/dots-theme-apply`: generates theme-dependent files.
- `bin/dots-enable-services`: enables desktop services.
- `bin/dots-doctor`: checks expected desktop commands.

## Components

Components live under `components/<name>/` and are installed independently.

Current components:

- `hypr`: Hyprland config and screenshot script.
- `waybar`: Waybar config and style.
- `wofi`: Wofi launcher config.
- `kitty`: Kitty terminal config.
- `mako`: Mako notification config.
- `nvim`: Neovim package installation and LazyVim-based config.
- `opencode`: Official opencode installer without managed config.
- `theme`: links theme files into `~/.config/theme` and applies the current palette.

Each component has an executable `install.sh`. Functional configuration is symlinked into `~/.config`. Existing target files are backed up as `*.backup.<timestamp>` before replacement.

## Themes

Themes live under `themes/<name>/colors.toml`.

The current default is:

```text
themes/tokyo-night/colors.toml
```

The theme file defines a `[colors]` table with keys such as `bg`, `text`, `accent`, and `edge`. `bin/dots-theme-apply` reads that file and writes generated output to:

- `~/.config/hypr/colors.conf`
- `~/.config/kitty/colors.conf`
- `~/.config/waybar/colors.css`
- `~/.config/wofi/style.css`

Generated files are not edited directly. Edit the palette and re-apply the theme instead.

## Packages

Package groups live under `packages/*.txt`. Each file is a plain list of package names. Blank lines and comments are ignored.

Current groups:

- `base`
- `desktop`
- `fonts`
- `dev`

`install.sh --packages base,desktop,fonts` calls `sudo pacman -S --needed` with all packages from those groups.

## Host Defaults

The default host profile lives under `hosts/current/`.

- `hosts/current/packages.txt`: package groups used by `--all`.
- `hosts/current/components.conf`: components, theme, and profile name used by `--all`.

Current `--all` behavior:

1. Install package groups from `hosts/current/packages.txt`.
2. Install components from `COMPONENTS` in `hosts/current/components.conf`.
3. Apply `THEME` from `hosts/current/components.conf`.

## Services

Services are intentionally not enabled by `install.sh --all`. They are enabled explicitly with:

```bash
./bin/dots services enable
```

That command enables `NetworkManager`, `bluetooth`, and `sddm` only when their unit files exist.

## Compatibility Note

The Hyprland config targets Hyprland `0.55.x`. It does not include the removed `dwindle:pseudotile` option. The `SUPER+P` keybind still calls the `pseudo` dispatcher.
