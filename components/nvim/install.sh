#!/usr/bin/env bash
set -euo pipefail

repo_dir="${DOTS_DIR:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)}"
# shellcheck disable=SC1091
source "$repo_dir/bin/dots-lib"

command=(sudo pacman -S --needed neovim)
if [ "${DOTS_ASSUME_YES:-0}" = 1 ]; then
  command+=(--noconfirm)
fi

dots_run "${command[@]}"
dots_link "$repo_dir/components/nvim/config" "$HOME/.config/nvim"
