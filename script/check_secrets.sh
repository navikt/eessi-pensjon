#!/usr/bin/env bash
set -eu

if ! command -v python3 >/dev/null 2>&1; then
    echo "Python 3 is required to format findings without credential values." >&2
    exit 1
fi

root_dir="$(cd "$(dirname "$0")/.." && pwd)"
exec python3 "$root_dir/script/check_secrets.py" "$@"
