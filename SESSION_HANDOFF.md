# Session Handoff

## Current State

- Repo: `/home/heizenx/workspace/projecs/dots`.
- Test VM: `archlinux-2`, CachyOS without desktop, accessed by SSH as `heizen@192.168.122.187`.
- Host access is handled by the user only. The assistant does not access the KVM/libvirt host.
- The baseline snapshot is `clean-base`.
- `TODO.md` is intentionally ignored and should not be touched unless explicitly requested.

## Snapshot Workflow

The user reverts snapshots from the host:

```bash
virsh --connect qemu:///system snapshot-revert --domain archlinux-2 --snapshotname clean-base --running
```

If needed:

```bash
virsh --connect qemu:///system start archlinux-2
```

After revert, verify SSH from this workspace:

```bash
ssh -o BatchMode=yes -o ConnectTimeout=10 heizen@192.168.122.187 'hostname; whoami; sudo -n true'
```

Before testing installers that fetch HTTPS resources, refresh the VM clock outside the repo installer. Old snapshots can keep stale time and fail TLS verification even when the scripts are correct:

```bash
ssh -o BatchMode=yes heizen@192.168.122.187 'sudo systemctl restart systemd-timesyncd; sleep 8; date -u -Is'
```

Sync the current repo state into the VM:

```bash
rsync -az --delete --exclude='.git/' --exclude='TODO.md' --exclude='*.backup.*' --exclude='.cache/' ./ heizen@192.168.122.187:/home/heizen/dots-test/
```

Run full installation tests from `/home/heizen/dots-test`.

## Tested Install Flow

The current goal is that this installs the full profile, including desktop, theme, Neovim, and opencode:

```bash
./install.sh --all --yes
./bin/dots services enable
```

Post-install checks:

```bash
./bin/dots doctor
systemctl is-enabled NetworkManager.service bluetooth.service sddm.service
test -L ~/.config/theme/palette.toml
test -L ~/.config/nvim
command -v nvim
nvim --version | sed -n '1p'
command -v opencode || test -x ~/.opencode/bin/opencode
~/.opencode/bin/opencode --version
```

## Important Implementation Notes

- Theme source of truth is `themes/<name>/colors.toml`.
- Theme TOML uses a `[colors]` table with quoted string values.
- `bin/dots-theme-apply` reads TOML and generates files under `~/.config/hypr`, `~/.config/kitty`, `~/.config/waybar`, and `~/.config/wofi`.
- Generated theme files should not be edited directly.
- `components/theme/install.sh` links `~/.config/theme/palette.toml` and `~/.config/theme/apply-theme.sh`; `install.sh --theme` applies the theme.
- `packages/desktop.txt` includes both `bluez` and `bluez-utils` so `bluetooth.service` exists.
- `components/nvim/install.sh` installs `neovim` with `pacman` and links `components/nvim/config` to `~/.config/nvim`.
- `components/opencode/install.sh` uses the official installer: `curl -fsSL https://opencode.ai/install | bash`.
- `components/opencode/install.sh` intentionally stays minimal and uses only the official installer. Snapshot-specific clock fixes happen before running `install.sh`, not inside repo components.

## Efficient Testing Pattern

1. Make small repo changes locally.
2. Run local syntax and dry-run validation:

```bash
bash -n install.sh bin/* components/*/install.sh components/hypr/config/scripts/screenshot.sh
./install.sh --all --dry-run
```

3. Ask the user to revert VM to `clean-base` when a clean install test is needed.
4. Sync repo to `/home/heizen/dots-test` with `rsync`.
5. Run the exact installation command on the VM.
6. Verify commands, symlinks, generated theme files, and services.
7. If installation succeeds and should be preserved, ask the user to create a post-install snapshot.

## Next Session Focus

- Add multiple themes under `themes/<name>/colors.toml`.
- Ensure themes stay consistent across Hyprland, Kitty, Waybar, Wofi, and development tools.
- Consider whether Neovim and opencode need theme-aware config, or whether terminal/theme integration is enough.
- Add validation for required TOML color keys so new themes fail clearly when incomplete.
