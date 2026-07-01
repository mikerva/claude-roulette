#!/usr/bin/env bash
# Interactive setup: possess your agents' GLOBAL instruction files (no dirty
# git status, one personality everywhere), roll the first personality, and
# optionally install a daily cron job.
set -e
cd "$(dirname "$0")"
ROLL="$PWD/roll.sh"

echo "🎰 claude-roulette setup"
echo

# Global instruction files for agents that appear to be installed
candidates=()
maybe() { if [ -d "$(dirname "$1")" ]; then candidates+=("$1|$2"); fi; }
maybe "$HOME/.claude/CLAUDE.md"           "Claude Code"
maybe "$HOME/.codex/AGENTS.md"            "Codex"
maybe "$HOME/.gemini/GEMINI.md"           "Gemini CLI"
maybe "$HOME/.config/opencode/AGENTS.md"  "opencode"

targets=()
if [ ${#candidates[@]} -gt 0 ]; then
  echo "Found these agents — their global instruction files apply to every"
  echo "project, live outside git, and never show up as dirty:"
  echo
  for c in "${candidates[@]}"; do
    path="${c%%|*}"; agent="${c##*|}"
    printf "Possess %s (%s)? [Y/n] " "${path/#$HOME/~}" "$agent"
    read -r yn
    case "${yn:-y}" in [Yy]*|"") targets+=("$path") ;; esac
  done
  echo
fi

while :; do
  printf "Any other instruction file to possess? (enter to skip): "
  read -r f
  [ -z "$f" ] && break
  f="${f/#\~/$HOME}"
  targets+=("$f")
done

echo
if [ ${#targets[@]} -eq 0 ]; then
  echo "Nothing to possess — writing personality.md for import mode instead."
  "$ROLL"
  echo
  echo "Add this line to the top of a CLAUDE.md (Claude Code only):"
  echo "  @$PWD/personality.md"
  args=""
else
  "$ROLL" "${targets[@]}"
  args=$(printf ' %q' "${targets[@]}")
fi

echo
printf "Install a daily cron job to re-roll every morning? [Y/n] "
read -r yn
case "${yn:-y}" in
  [Yy]*|"") ;;
  *) echo "Skipped. Re-roll anytime with: $ROLL$args"; exit 0 ;;
esac

printf "At what hour? [8] "
read -r hour
hour="${hour:-8}"

line="0 $hour * * * $ROLL$args"
{ crontab -l 2>/dev/null | grep -vF "$ROLL" || true; echo "$line"; } | crontab -
echo
echo "Installed: $line"
echo "Done. New personality every day at $hour:00. Good luck out there."
