# Dotfiles Architecture

This document describes the target architecture for this dotfiles repository. It is a plan for implementation, not a statement that every directory or script already exists.

## Purpose

The repository should fully configure the desktop environment and daily tools while keeping the system modular, reproducible, and easy to extend.

The design should support:

- Full desktop installation.
- Installing only selected tools or components.
- Consistent colors across the desktop and applications.
- Theme switching through generated files.
- Future machine-specific overrides.
- Living documentation for decisions and component behavior.

## Design Principles

- Do not mirror `$HOME` directly.
- Organize configuration by tool or component.
- Keep theme definitions centralized.
- Generate derived visual files from templates.
- Keep functional configuration separate from generated theme output.
- Make the full installation a composition of smaller component installers.
- Keep host-specific support simple until multiple machines actually need it.

## Target Repository Layout

```text
dotfiles/
├── install.sh
├── dots
├── README.md
├── bin/
│   ├── dots
│   ├── dots-theme-apply
│   ├── dots-theme-current
│   ├── dots-theme-list
│   ├── dots-theme-set
│   ├── dots-install-component
│   └── brave-basic
├── components/
│   ├── hypr/
│   │   ├── install.sh
│   │   ├── config/
│   │   │   ├── hyprland.conf
│   │   │   ├── bindings.conf
│   │   │   ├── input.conf
│   │   │   ├── autostart.conf
│   │   │   └── monitors.conf
│   │   └── templates/
│   │       └── colors.conf.tpl
│   ├── kitty/
│   │   ├── install.sh
│   │   ├── config/
│   │   │   ├── kitty.conf
│   │   │   ├── fonts.conf
│   │   │   ├── keys.conf
│   │   │   ├── tabs.conf
│   │   │   └── window.conf
│   │   └── templates/
│   │       └── colors.conf.tpl
│   ├── waybar/
│   │   ├── install.sh
│   │   ├── config/
│   │   │   └── config.jsonc
│   │   └── templates/
│   │       ├── style.css.tpl
│   │       └── colors.css.tpl
│   ├── wofi/
│   │   ├── install.sh
│   │   ├── config/
│   │   │   └── config
│   │   └── templates/
│   │       └── style.css.tpl
│   ├── git/
│   │   ├── install.sh
│   │   └── config/
│   │       └── gitconfig
│   ├── shell/
│   │   ├── install.sh
│   │   └── config/
│   │       ├── bashrc
│   │       ├── zshrc
│   │       └── aliases
│   ├── brave/
│   │   ├── install.sh
│   │   ├── applications/
│   │   │   └── brave-browser-basic.desktop
│   │   └── scripts/
│   │       └── brave-basic
│   └── scripts/
│       ├── install.sh
│       └── config/
│           └── screenshot.sh
├── themes/
│   ├── current
│   ├── tokyo-night/
│   │   ├── colors.toml
│   │   ├── wallpaper.png
│   │   └── preview.png
│   ├── catppuccin/
│   │   ├── colors.toml
│   │   ├── wallpaper.png
│   │   └── preview.png
│   └── gruvbox/
│       ├── colors.toml
│       ├── wallpaper.png
│       └── preview.png
├── templates/
│   └── helpers.sh
├── hosts/
│   └── current/
│       ├── packages.txt
│       ├── components.conf
│       └── overrides/
├── packages/
│   ├── base.txt
│   ├── desktop.txt
│   ├── dev.txt
│   ├── fonts.txt
│   └── optional.txt
└── docs/
```

## Themes

Themes are the visual source of truth. Each theme should have its own directory under `themes/`.

```text
themes/tokyo-night/
├── colors.toml
├── wallpaper.png
└── preview.png
```

The active theme should be stored in `themes/current` as a plain text file containing the theme name.

Example:

```text
tokyo-night
```

Using a plain file is preferred over a symlink because it is portable, easy to inspect, and simple to modify from scripts.

## Theme Schema

The first version of `colors.toml` should stay small and practical.

```toml
name = "tokyo-night"
mode = "dark"

accent = "#7aa2f7"
cursor = "#c0caf5"
foreground = "#a9b1d6"
background = "#1a1b26"
selection_foreground = "#c0caf5"
selection_background = "#7aa2f7"

color0 = "#32344a"
color1 = "#f7768e"
color2 = "#9ece6a"
color3 = "#e0af68"
color4 = "#7aa2f7"
color5 = "#ad8ee6"
color6 = "#449dab"
color7 = "#787c99"
color8 = "#444b6a"
color9 = "#ff7a93"
color10 = "#b9f27c"
color11 = "#ff9e64"
color12 = "#7da6ff"
color13 = "#bb9af7"
color14 = "#0db9d7"
color15 = "#acb0d0"
```

Additional keys can be added later only when a component needs them.

## Templates And Generated Files

Files that depend on colors should not be edited manually after generation. They should be rendered from templates.

Examples:

```text
components/kitty/templates/colors.conf.tpl
components/waybar/templates/colors.css.tpl
components/hypr/templates/colors.conf.tpl
components/wofi/templates/style.css.tpl
```

Template example:

```text
foreground {{ foreground }}
background {{ background }}
cursor {{ cursor }}

color0 {{ color0 }}
color1 {{ color1 }}
color2 {{ color2 }}
```

The future theme apply command should read:

```text
themes/<theme>/colors.toml
```

And generate files such as:

```text
~/.config/kitty/colors.conf
~/.config/waybar/colors.css
~/.config/hypr/colors.conf
~/.config/wofi/style.css
```

## Components

Each component should be independently installable.

```text
components/<name>/
├── install.sh
├── config/
└── templates/
```

Each component installer should be responsible for:

- Creating required target directories.
- Linking or copying functional configuration.
- Rendering generated theme files when needed.
- Validating required commands when practical.
- Avoiding destructive changes unless explicitly requested.

## Symlinks, Copies, And Generated Files

Recommended policy:

- Editable personal configs should be symlinked from the repository.
- Theme-generated files should be written as generated output.
- Desktop files and system integration files should usually be copied.
- Secrets, tokens, browser profiles, SSH keys, and machine-private data should never be versioned.

Example:

```text
~/.config/kitty/kitty.conf -> dotfiles/components/kitty/config/kitty.conf
~/.config/kitty/colors.conf = generated from components/kitty/templates/colors.conf.tpl
```

## Installer

The central `install.sh` should orchestrate components. It should not contain all component logic directly.

Expected non-interactive usage:

```bash
./install.sh --all
./install.sh --component hypr
./install.sh --component kitty,waybar,wofi
./install.sh --theme tokyo-night
./install.sh --packages base,desktop,dev
./install.sh --dry-run
```

Expected interactive usage:

```bash
./install.sh
```

The interactive mode can later provide a TUI for selecting components, packages, and themes.

## Future CLI

A `dots` command should eventually provide daily operations.

```bash
dots install all
dots install hypr
dots install kitty waybar
dots theme list
dots theme current
dots theme set tokyo-night
dots theme apply
dots doctor
dots backup
```

The CLI should be composed of small scripts under `bin/`, following predictable command names.

## Hosts

The current focus is one VM/workstation, but the repository should leave room for future host-specific behavior.

Initial host support can be simple:

```text
hosts/current/
├── packages.txt
├── components.conf
└── overrides/
```

Example `components.conf`:

```bash
COMPONENTS="hypr kitty waybar wofi git shell brave"
THEME="tokyo-night"
PROFILE="desktop"
```

Do not introduce complex host abstractions until there is a real second machine with different needs.

## Packages

Package lists should be grouped by purpose.

```text
packages/base.txt
packages/desktop.txt
packages/dev.txt
packages/fonts.txt
packages/optional.txt
```

The installer can later map these lists to the current distribution package manager.

## Documentation Model

Documentation should be living documentation, not just a changelog.

Recommended documents:

```text
docs/index.md
docs/install.md
docs/themes.md
docs/components.md
docs/hypr.md
docs/kitty.md
docs/waybar.md
docs/decisions.md
```

Existing numbered notes should be preserved as historical context and component-specific implementation notes.

## Implementation Phases

### Phase 1: Restructure Documentation

- Keep this architecture document as the source for the implementation pass.
- Update the README to describe the target design.
- Preserve existing numbered docs as component notes.

### Phase 2: Create Skeleton

- Add `components/`, `themes/`, `packages/`, `hosts/`, and `bin/`.
- Move existing component files into the new component layout.
- Add minimal placeholder theme data.

### Phase 3: Implement Installer

- Implement central `install.sh` argument parsing.
- Implement component-level `install.sh` scripts.
- Add dry-run support.
- Add safe backup behavior before overwriting existing files.

### Phase 4: Implement Theme Rendering

- Define the first complete `colors.toml` schema.
- Add templates for Kitty, Waybar, Hyprland, and Wofi.
- Add `dots theme apply` or equivalent script.
- Regenerate all theme-derived files from one active theme.

### Phase 5: Add CLI

- Add `bin/dots` as the main user command.
- Add theme commands.
- Add component install commands.
- Add `dots doctor` for diagnostics.

### Phase 6: Add Host Support When Needed

- Keep `hosts/current` minimal.
- Add real host directories only after another machine requires different packages, components, or overrides.

## Final Rule

Functional files belong to components. Visual files that depend on colors belong to templates and are generated from the active theme.

This rule should guide implementation decisions throughout the repository.
