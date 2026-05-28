# Installation

This document describes how to install and operate `dots`.

## Fresh VM

The current installer targets CachyOS/Arch-based systems. Use this flow from a TTY on a fresh install without a desktop:

```bash
sudo pacman -Syu --needed git
git clone git@github.com:HeizenDev/dots.git ~/dots
cd ~/dots
./install.sh --all --dry-run
./install.sh --all --yes
./bin/dots services enable
reboot
```

If SSH access to GitHub is not configured, clone with HTTPS instead.

## Installer Commands

Install the full configured host profile:

```bash
./install.sh --all
```

Preview the full install without changing files:

```bash
./install.sh --all --dry-run
```

Install package groups only:

```bash
./install.sh --packages base,desktop,fonts
```

Install selected components only:

```bash
./install.sh --component hypr,waybar,kitty
```

Apply a theme only:

```bash
./install.sh --theme current
```

Use `--yes` to pass `--noconfirm` to `pacman` during package installation:

```bash
./install.sh --all --yes
```

## Dots Helper

The helper command wraps common operations:

```bash
./bin/dots install all
./bin/dots install packages base desktop fonts
./bin/dots install hypr waybar kitty
./bin/dots theme list
./bin/dots theme current
./bin/dots theme apply current
./bin/dots services enable
./bin/dots doctor
```

## Backups

When a component installer replaces an existing target, it moves the existing file to:

```text
<target>.backup.<timestamp>
```

This applies to regular files and symlinks.

## Validation

Run these commands after changes:

```bash
bash -n install.sh bin/* components/*/install.sh components/hypr/config/scripts/screenshot.sh
./install.sh --all --dry-run
./bin/dots doctor
```
