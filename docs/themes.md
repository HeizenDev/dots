# Themes

Themes provide shared colors for Hyprland, Kitty, Waybar, Wofi, and the legacy `~/.config/theme` location.

## Theme Format

Each theme is a directory under `themes/` with a `colors.toml` file:

```text
themes/current/colors.toml
```

The file is parsed by shell scripts and must use a simple TOML `[colors]` table:

```bash
[colors]
bg = "#111318"
surface = "#171b22"
text = "#e7edf5"
dim = "#8b96a5"
accent = "#00ff99"
accent_alt = "#33ccff"
edge = "#2a313d"
shadow = "#1a1a1a"
neutral = "#595959"
```

Only quoted string values in the `[colors]` table are supported by the current implementation.

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

- `~/.config/theme/palette.toml` to the active `themes/<name>/colors.toml`
- `~/.config/theme/apply-theme.sh` to `bin/dots-theme-apply`

## Editing Colors

Edit `themes/current/colors.toml`, then run:

```bash
./bin/dots theme apply current
```

Generated files should not be edited directly because the next theme apply will overwrite them.
