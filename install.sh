#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  cat <<'USAGE'
Usage:
  ./install.sh --all [--dry-run]
  ./install.sh --packages base,desktop [--dry-run]
  ./install.sh --component hypr,waybar [--dry-run]
  ./install.sh --theme tokyo-night [--dry-run]

Options:
  --all                  Install default host packages, components, and theme.
  --packages LIST        Install comma-separated package groups.
  --component LIST       Install comma-separated components.
  --theme NAME           Apply a theme from themes/<name>/colors.toml.
  --dry-run              Print actions without changing files.
  --yes                  Pass --noconfirm to pacman.
  -h, --help             Show this help.
USAGE
}

components=""
packages=""
theme=""
dry_run=0
assume_yes=0

while [ "$#" -gt 0 ]; do
  case "$1" in
    --all)
      # shellcheck disable=SC1090
      source "$repo_dir/hosts/current/components.conf"
      packages="$(tr '\n' ' ' < "$repo_dir/hosts/current/packages.txt")"
      components="$COMPONENTS"
      theme="${THEME:-tokyo-night}"
      ;;
    --packages)
      packages="${2:-}"
      shift
      ;;
    --component)
      components="${2:-}"
      shift
      ;;
    --theme)
      theme="${2:-}"
      shift
      ;;
    --dry-run)
      dry_run=1
      ;;
    --yes)
      assume_yes=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown option: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

if [ -z "$packages" ] && [ -z "$components" ] && [ -z "$theme" ]; then
  usage
  exit 2
fi

export DOTS_DIR="$repo_dir"
export DOTS_DRY_RUN="$dry_run"
export DOTS_ASSUME_YES="$assume_yes"
export DOTS_THEME="${theme:-tokyo-night}"

if [ -n "$packages" ]; then
  packages="${packages//,/ }"
  "$repo_dir/bin/dots-install-packages" $packages
fi

if [ -n "$components" ]; then
  components="${components//,/ }"
  for component in $components; do
    "$repo_dir/bin/dots-install-component" "$component"
  done
fi

if [ -n "$theme" ]; then
  "$repo_dir/bin/dots-theme-apply" "$theme"
fi
