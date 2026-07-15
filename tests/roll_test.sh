#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "$0")/.." && pwd)
fixture=$(mktemp -d)
trap 'rm -rf "$fixture"' EXIT

cp "$repo_root/roll.sh" "$fixture/roll.sh"
mkdir "$fixture/personalities"
cp "$repo_root"/personalities/*.md "$fixture/personalities/"

target="$fixture/AGENTS.md"
printf '%s\n' '# Existing instructions' > "$target"

run_roll() {
  (
    cd "$fixture"
    ROULETTE_DATE=2026-07-15 ./roll.sh "$target"
  )
}

assert_contains() {
  local expected=$1
  if ! grep -qF "$expected" "$target"; then
    printf 'Expected generated instructions to contain: %s\n' "$expected" >&2
    exit 1
  fi
}

assert_not_contains() {
  local unexpected=$1
  if grep -qF "$unexpected" "$target"; then
    printf 'Expected generated instructions not to contain: %s\n' "$unexpected" >&2
    exit 1
  fi
}

run_roll

assert_contains '# Existing instructions'
assert_contains 'Keep the default voice serious, clear, and useful.'
assert_contains 'Use personality cues sparingly and only when they fit the moment'
assert_contains 'Personality profiles are a repertoire, not a checklist.'
assert_contains 'Do not force a catchphrase, stylized greeting, nickname, accent, or joke'
assert_not_contains 'Stay in character in every message'
assert_not_contains 'Half-hearted roleplay is worse than none'

cp "$target" "$fixture/first-roll"
run_roll

cmp "$fixture/first-roll" "$target"

marker_count=$(grep -cF '<!-- claude-roulette:start' "$target")
if [ "$marker_count" -ne 1 ]; then
  printf 'Expected one managed marker block, found %s\n' "$marker_count" >&2
  exit 1
fi

echo 'roll_test: ok'
