#!/usr/bin/env bash
# Roll a random personality and splice it into your agent instruction file(s).
#
#   ./roll.sh ~/proj/AGENTS.md [more files...]  # inject between markers (works with any agent)
#   ./roll.sh                                   # just write personality.md (for @import setups)
#
# Injection is idempotent: content between the markers is replaced on each roll.
set -euo pipefail
cd "$(dirname "$0")"

files=(personalities/*.md)
# Seed by date: any number of rolls on the same day give the same personality,
# so catch-up runs after sleep/boot are harmless.
day="${ROULETTE_DATE:-$(date +%F)}"
seed=$(printf '%s' "$day" | cksum | cut -d' ' -f1)
idx=$(( seed % ${#files[@]} ))
pick="${files[idx]}"

state=".last-roll"
if [ -f "$state" ]; then
  read -r last_day last_name < "$state" || true
  if [ "$last_day" = "$day" ] && [ -f "personalities/$last_name.md" ]; then
    pick="personalities/$last_name.md"   # same day: stay consistent
  elif [ "$(basename "$pick" .md)" = "$last_name" ]; then
    pick="${files[$(( (idx + 1) % ${#files[@]} ))]}"   # new day, same face: bump
  fi
fi

name=$(basename "$pick" .md)
echo "$day $name" > "$state"

START="<!-- claude-roulette:start (rolled daily; edits between markers get overwritten) -->"
END="<!-- claude-roulette:end -->"

if [ $# -eq 0 ]; then
  cp "$pick" personality.md
  echo "🎰 Today's personality: $name -> personality.md"
  exit 0
fi

for target in "$@"; do
  touch "$target"
  if grep -qF "$START" "$target"; then
    awk -v start="$START" -v end="$END" -v src="$pick" '
      $0 == start { print; while ((getline line < src) > 0) print line; skip=1; next }
      $0 == end   { skip=0 }
      !skip       { print }
    ' "$target" > "$target.tmp" && mv "$target.tmp" "$target"
  else
    { echo ""; echo "$START"; cat "$pick"; echo "$END"; } >> "$target"
  fi
  echo "🎰 Today's personality: $name -> $target"
done
