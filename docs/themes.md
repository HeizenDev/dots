# Themes

Themes provide shared colors for Hyprland, Kitty, Waybar, Wofi, Neovim, and the legacy `~/.config/theme` location.

## Theme Format

Each theme is a directory under `themes/` with a `colors.toml` file:

```text
themes/tokyo-night/colors.toml
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

Only quoted string values in the `[colors]` table are supported by the current implementation. Theme application fails before writing generated files if any required key is missing.

## Applying A Theme

Apply the default theme:

```bash
./bin/dots theme apply tokyo-night
```

Equivalent installer command:

```bash
./install.sh --theme tokyo-night
```

## Generated Files

Applying a theme writes these files:

- `~/.config/hypr/colors.conf`
- `~/.config/kitty/colors.conf`
- `~/.config/waybar/colors.css`
- `~/.config/wofi/style.css`
- `~/.config/opencode/tui.json`
- `~/.config/opencode/themes/dots.json`

Neovim uses the LazyVim colorscheme setting `dots`. That colorscheme reads `~/.config/theme/palette.toml` at startup and applies matching highlights from the active palette.

opencode uses the generated `dots` theme selected by `~/.config/opencode/tui.json`.

The `theme` component also links:

- `~/.config/theme/palette.toml` to the active `themes/<name>/colors.toml`
- `~/.config/theme/apply-theme.sh` to `bin/dots-theme-apply`

## Editing Colors

Edit a theme under `themes/<name>/colors.toml`, then run:

```bash
./bin/dots theme apply tokyo-night
```

Generated files should not be edited directly because the next theme apply will overwrite them.
