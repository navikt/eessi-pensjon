#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="$SCRIPT_DIR/../agent-input/raw.txt"
pbpaste > "$TARGET"
echo "OK — raw.txt oppdatert ($(wc -l < "$TARGET") linjer)"
