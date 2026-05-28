# Themes

Themes provide shared colors for Hyprland, Kitty, Waybar, Wofi, and the legacy `~/.config/theme` location.

## Theme Format

Each theme is a directory under `themes/` with a `colors.env` file:

```text
themes/current/colors.env
```

The file is sourced by shell scripts and must use simple `KEY=value` assignments:

```bash
BASE_BG=#111318
BASE_SURFACE=#171b22
BASE_TEXT=#e7edf5
BASE_DIM=#8b96a5
BASE_ACCENT=#00ff99
BASE_ACCENT_ALT=#33ccff
BASE_EDGE=#2a313d
BASE_SHADOW=#1a1a1a
BASE_NEUTRAL=#595959
```

Do not use TOML for themes in the current implementation.

## Applying A Theme

Apply the default theme:

```bash
./bin/dots theme apply current
```

Equivalent installer command:

```bash
./install.sh --theme current
```

## Generated Files

Applying a theme writes these files:

- `~/.config/hypr/colors.conf`
- `~/.config/kitty/colors.conf`
- `~/.config/waybar/colors.css`
- `~/.config/wofi/style.css`

The `theme` component also links:

- `~/.config/theme/palette.env` to `themes/current/colors.env`
- `~/.config/theme/apply-theme.sh` to `bin/dots-theme-apply`

## Editing Colors

Edit `themes/current/colors.env`, then run:

```bash
./bin/dots theme apply current
```

Generated files should not be edited directly because the next theme apply will overwrite them.
