#!/usr/bin/env bash
set -euo pipefail

repo_dir="${DOTS_DIR:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)}"
# shellcheck disable=SC1091
source "$repo_dir/bin/dots-lib"

dots_link "$repo_dir/themes/current/colors.env" "$HOME/.config/theme/palette.env"
dots_link "$repo_dir/bin/dots-theme-apply" "$HOME/.config/theme/apply-theme.sh"
"$repo_dir/bin/dots-theme-apply" current
