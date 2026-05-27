#!/usr/bin/env bash
set -euo pipefail

repo_dir="${DOTS_DIR:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)}"
# shellcheck disable=SC1091
source "$repo_dir/bin/dots-lib"

dots_link "$repo_dir/components/waybar/config/config.jsonc" "$HOME/.config/waybar/config.jsonc"
dots_link "$repo_dir/components/waybar/config/style.css" "$HOME/.config/waybar/style.css"
