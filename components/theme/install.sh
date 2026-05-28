#!/usr/bin/env bash
set -euo pipefail

repo_dir="${DOTS_DIR:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)}"
theme="${DOTS_THEME:-current}"
# shellcheck disable=SC1091
source "$repo_dir/bin/dots-lib"

dots_link "$repo_dir/themes/$theme/colors.toml" "$HOME/.config/theme/palette.toml"
dots_link "$repo_dir/bin/dots-theme-apply" "$HOME/.config/theme/apply-theme.sh"
