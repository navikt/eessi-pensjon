#!/usr/bin/env bash
set -eu

if ! command -v trufflehog >/dev/null 2>&1; then
    echo "TruffleHog is required. Install it with: brew install trufflehog" >&2
    exit 1
fi

root_dir="$(cd "$(dirname "$0")/.." && pwd)"
flags=(--no-verification --no-update --fail --fail-on-scan-errors)
status=0

for repo in "$root_dir" "$root_dir"/*; do
    [ -e "$repo/.git" ] || continue
    echo "Scanning Git history: $repo"
    if ! trufflehog git "file://$repo" "${flags[@]}"; then
        echo "Git scan reported findings or errors: $repo" >&2
        status=1
    fi
done

echo "Scanning working files (including untracked and ignored files): $root_dir"
if ! trufflehog filesystem "$root_dir" "${flags[@]}" \
    --exclude-paths "$root_dir/script/trufflehog-exclude-paths.txt"; then
    echo "Working-file scan reported findings or errors." >&2
    status=1
fi

exit "$status"
