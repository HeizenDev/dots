# dots

An opinionated Hyprland setup for developers.

`dots` installs a minimal Wayland desktop with Hyprland, Waybar, Wofi, Mako, Kitty, shared theme colors, and developer-friendly defaults. It is inspired by projects like Omarchy, but smaller, more personal, and focused on my preferred workflow.

## Install

The current installer targets CachyOS/Arch-based systems. From a fresh install without a desktop:

```bash
sudo pacman -Syu --needed git
git clone git@github.com:HeizenDev/dots.git ~/dots
cd ~/dots
./install.sh --all --dry-run
./install.sh --all --yes
./bin/dots services enable
reboot
```

Use HTTPS instead of SSH if the VM does not have GitHub SSH keys configured.

## Use

```bash
./install.sh --all
./install.sh --packages base,desktop,fonts
./install.sh --component hypr,waybar,kitty
./install.sh --theme current
./bin/dots doctor
```

The `dots` helper provides the same daily operations:

```bash
./bin/dots install all
./bin/dots install packages base desktop fonts
./bin/dots install hypr waybar kitty
./bin/dots theme list
./bin/dots theme apply current
./bin/dots services enable
./bin/dots doctor
```

## Customize

- Edit component configs in `components/<name>/config/`.
- Edit shared colors in `themes/current/colors.env`.
- Edit installed package groups in `packages/*.txt`.
- Edit default host selections in `hosts/current/`.

```bash
./bin/dots theme apply current
```

## Resources

- `docs/install.md`: installation and command reference.
- `docs/themes.md`: color palette and generated theme files.
- `docs/components.md`: component structure and extension guide.
- `docs/architecture.md`: current implementation details.

## Notes

The Hyprland config is compatible with Hyprland `0.55.x` and does not use the removed `dwindle:pseudotile` option.
