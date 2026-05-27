#!/usr/bin/env bash
set -euo pipefail

repo_dir="${DOTS_DIR:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)}"
# shellcheck disable=SC1091
source "$repo_dir/bin/dots-lib"

for file in kitty.conf fonts.conf keys.conf window.conf tabs.conf; do
  dots_link "$repo_dir/components/kitty/config/$file" "$HOME/.config/kitty/$file"
done
