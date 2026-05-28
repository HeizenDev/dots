# AGENTS.md

## Source Of Truth
- Trust `install.sh`, `bin/dots*`, `bin/dots-lib`, `hosts/current/*`, `packages/*.txt`, and `themes/*/colors.toml` over README/docs when they conflict.
- Themes live in `themes/<name>/colors.toml` and define colors under `[colors]`; `install.sh --theme` reads that TOML file.
- `components/<name>/install.sh` scripts are the real per-component entrypoints.

## Commands
- `./install.sh --all` installs `hosts/current/packages.txt`, `hosts/current/components.conf`, and the current theme.
- `./install.sh --packages base,desktop` and `./install.sh --component hypr,waybar` take comma-separated lists.
- `./install.sh --theme current` applies a theme; `--dry-run` prints actions; `--yes` adds `--noconfirm` to `pacman`.
- `./bin/dots` is the user-facing wrapper: `dots install ...`, `dots theme {apply|list|current}`, `dots services enable`, `dots doctor`.
- Use `./bin/dots doctor` and the relevant `install.sh --dry-run` path to verify changes.

## Layout And Behavior
- Component installers source `bin/dots-lib` and use `dots_link`/`dots_copy`; existing targets are backed up as `*.backup.<timestamp>` before replacement.
- Theme application writes generated files into `~/.config/hypr`, `~/.config/kitty`, `~/.config/waybar`, and `~/.config/wofi`; do not hand-edit those outputs.
- `components/theme/install.sh` links the active palette and apply script into `~/.config/theme`; `install.sh --theme` applies the theme.
- `bin/dots-install-packages` reads plain text package group files and strips comments/whitespace before calling `sudo pacman -S --needed`.
- `bin/dots-enable-services` enables `NetworkManager`, `bluetooth`, and `sddm` only if the unit exists.

## Repo Conventions
- Keep private machine data, secrets, keys, and generated backups out of git; `.gitignore` already excludes the common local artifacts.
- Preserve the current host profile in `hosts/current/components.conf` unless you are intentionally changing the default machine setup.
