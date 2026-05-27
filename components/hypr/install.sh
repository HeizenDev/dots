#!/usr/bin/env bash
set -euo pipefail

repo_dir="${DOTS_DIR:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)}"
# shellcheck disable=SC1091
source "$repo_dir/bin/dots-lib"

dots_link "$repo_dir/components/hypr/config/hyprland.conf" "$HOME/.config/hypr/hyprland.conf"
dots_link "$repo_dir/components/hypr/config/scripts/screenshot.sh" "$HOME/.config/hypr/scripts/screenshot.sh"
