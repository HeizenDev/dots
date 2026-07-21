#!/usr/bin/env bash
set -euo pipefail

repo_dir="${DOTS_DIR:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)}"
# shellcheck disable=SC1091
source "$repo_dir/bin/dots-lib"

dots_link "$repo_dir/components/tmux/config/tmux.conf" "$HOME/.config/tmux/tmux.conf"
dots_link "$repo_dir/components/tmux/config/colors.conf" "$HOME/.config/tmux/colors.conf"
dots_link "$repo_dir/components/tmux/config/ssh_split.sh" "$HOME/.config/tmux/ssh_split.sh"
chmod +x "$HOME/.config/tmux/ssh_split.sh"
