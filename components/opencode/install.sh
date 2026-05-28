#!/usr/bin/env bash
set -euo pipefail

repo_dir="${DOTS_DIR:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)}"
# shellcheck disable=SC1091
source "$repo_dir/bin/dots-lib"

if [ "${DOTS_DRY_RUN:-0}" = 1 ]; then
  printf '[dry-run] curl -fsSL https://opencode.ai/install | bash\n'
  exit 0
fi

curl -fsSL https://opencode.ai/install | bash
