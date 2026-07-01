#!/usr/bin/env bash
# Interactive setup: pick which instruction files to possess, roll the first
# personality, and optionally install a daily cron job.
set -e
cd "$(dirname "$0")"
ROLL="$PWD/roll.sh"

echo "🎰 claude-roulette setup"
echo

targets=()
while :; do
  if [ ${#targets[@]} -eq 0 ]; then
    printf "Instruction file to possess (e.g. ~/myproject/AGENTS.md): "
  else
    printf "Another file? (enter to finish): "
  fi
  read -r f
  [ -z "$f" ] && break
  f="${f/#\~/$HOME}"
  targets+=("$f")
done

echo
if [ ${#targets[@]} -eq 0 ]; then
  echo "No files given — using import mode instead."
  "$ROLL"
  echo
  echo "Add this line to the top of your CLAUDE.md (Claude Code only):"
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
