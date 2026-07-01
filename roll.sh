#!/usr/bin/env bash
# Pick a random personality and write it to personality.md.
# Usage: ./roll.sh [target-file]   (default: personality.md next to this script)
set -euo pipefail
cd "$(dirname "$0")"

target="${1:-personality.md}"

files=(personalities/*.md)
pick="${files[RANDOM % ${#files[@]}]}"

cp "$pick" "$target"
echo "🎰 Today's personality: $(basename "$pick" .md) -> $target"
