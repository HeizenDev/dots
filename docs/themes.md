# Themes

Themes provide shared colors for Hyprland, Waybar, Wofi, Neovim, opencode,
and (via the orchestrator) Alacritty, tmux, and Pi Agent. The active palette
is also linked to `~/.config/theme/palette.toml` for third-party consumers.

## Active Themes

`dots` ships with two themes:

- `tokyo-night` (default) — palette aligned with the user's current
  Alacritty, tmux, and Pi Agent color setup.
- `catppuccin-mocha` — standard Catppuccin Mocha hex values.

## Theme Format

Each theme is a directory under `themes/` with a `colors.toml` file:

```text
themes/tokyo-night/colors.toml
```

The file is parsed by shell scripts and must use a simple TOML `[colors]`
table. Only quoted string values are supported by the current implementation.
Theme application fails before writing generated files if any required key is
missing.

### Required Keys (9)

These are consumed by Hyprland, Waybar, Wofi, opencode, and the legacy Kitty
target. They are validated and required.

| Key | Role |
| --- | --- |
| `bg` | Base background |
| `surface` | Elevated background (panels, status bars) |
| `text` | Primary text |
| `dim` | Muted text and comments |
| `accent` | Primary accent (cursor, primary highlights) |
| `accent_alt` | Secondary accent (selection, gradients) |
| `edge` | Borders and separators |
| `shadow` | Drop shadow base |
| `neutral` | Neutral mid-tone |

### Extended Keys (23)

These are consumed by the new Alacritty, tmux, and Pi Agent writers added in
the 2026-Q3 rework. They are optional — per-target writers fall back to the
required keys when an extended key is missing — but both shipped themes
include all of them so the rendered output matches the source palette.

| Group | Keys |
| --- | --- |
| Cursor / selection | `cursor_text`, `selection_bg`, `selection_fg` |
| Depth tones (Pi) | `bg_subtle`, `bg_highlight`, `fg_muted`, `fg_gutter`, `comment` |
| Terminal ANSI — normal | `black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`, `white` |
| Terminal ANSI — bright | `bright_black`, `bright_red`, `bright_green`, `bright_yellow`, `bright_blue`, `bright_magenta`, `bright_cyan`, `bright_white` |

### Example

```toml
[colors]

# Required (9)
bg          = "#1a1b26"
surface     = "#24283b"
text        = "#c0caf5"
dim         = "#565f89"
accent      = "#7aa2f7"
accent_alt  = "#bb9af7"
edge        = "#414868"
shadow      = "#16161e"
neutral     = "#9aa5ce"

# Cursor / selection
cursor_text  = "#1a1b26"
selection_bg = "#283457"
selection_fg = "#c0caf5"

# Depth tones
bg_subtle    = "#1f2335"
bg_highlight = "#292e42"
fg_muted     = "#a9b1d6"
fg_gutter    = "#3b4261"
comment      = "#565f89"

# Terminal ANSI — normal
black   = "#15161e"
red     = "#f7768e"
green   = "#9ece6a"
yellow  = "#e0af68"
blue    = "#7aa2f7"
magenta = "#bb9af7"
cyan    = "#7dcfff"
white   = "#a9b1d6"

# Terminal ANSI — bright
bright_black   = "#414868"
bright_red     = "#f7768e"
bright_green   = "#9ece6a"
bright_yellow  = "#e0af68"
bright_blue    = "#7aa2f7"
bright_magenta = "#bb9af7"
bright_cyan    = "#7dcfff"
bright_white   = "#c0caf5"
```

## Applying A Theme

Apply the default theme:

```bash
./bin/dots theme apply tokyo-night
```

Equivalent installer command:

```bash
./install.sh --theme tokyo-night
```

After Step 6 of the 2026-Q3 rework, `dots theme apply` also sends live-reload
signals to the running apps (tmux, waybar, mako). Wofi is launched
per-invocation, so its next launch picks up the new colors. Alacritty watches
its config file when `live_config_reload = true` (the default in the shipped
alacritty component).

## Generated Files

Applying a theme writes these files:

- `~/.config/hypr/colors.conf`
- `~/.config/kitty/colors.conf` (legacy, only written if the kitty component is installed)
- `~/.config/waybar/colors.css`
- `~/.config/wofi/style.css`
- `~/.config/opencode/tui.json`
- `~/.config/opencode/themes/dots.json`
- `~/.config/alacritty/themes/<theme>.toml` (added in Step 2)
- `~/.config/tmux/colors.conf` (added in Step 3)
- `~/.pi/agent/themes/<theme>.json` (added in Step 4)

The `theme` component also links:

- `~/.config/theme/palette.toml` to the active `themes/<name>/colors.toml`
- `~/.config/theme/apply-theme.sh` to `bin/dots-theme-apply`

Neovim uses the LazyVim colorscheme setting `dots`. That colorscheme reads
`~/.config/theme/palette.toml` at startup and applies matching highlights from
the active palette.

opencode uses the generated `dots` theme selected by `~/.config/opencode/tui.json`.

## Editing Colors

Edit a theme under `themes/<name>/colors.toml`, then run:

```bash
./bin/dots theme apply tokyo-night
```

Generated files should not be edited directly because the next theme apply
will overwrite them.
