# 🎰 claude-roulette

Give your coding agent a **random personality every day**. One day it's a
salty pirate, the next it's a drill sergeant, an anime weeb, or a
suspiciously calm Bob Ross.

It works by splicing a personality into your agents' **global instruction
files** — `~/.claude/CLAUDE.md` (Claude Code), `~/.codex/AGENTS.md` (Codex),
`~/.gemini/GEMINI.md` (Gemini CLI), `~/.config/opencode/AGENTS.md`
(opencode) — so it applies to every project, lives outside your repos, and
never dirties a git status. All personalities are pre-written in
[`personalities/`](personalities/) — no API calls, no dependencies, just a
shell script and chaos.

## Setup (30 seconds)

```sh
git clone https://github.com/mikerva/claude-roulette ~/claude-roulette
~/claude-roulette/setup.sh
```

Setup detects which agents you have, asks which of their global files to
possess, rolls your first personality, and offers to install the daily
cron job. That's it. Every morning, a new personality. Every session, a
surprise. All your agents get the same personality — they can be weebs
together.

## Manual usage

```sh
./roll.sh ~/.claude/CLAUDE.md            # roll into any instruction file
./roll.sh ~/proj/AGENTS.md ~/.codex/AGENTS.md   # several at once, same personality
./roll.sh                                # write personality.md (for @import setups)
```

The first roll appends a marker block to the end of the file; later rolls
replace only what's between the markers. The rest of the file is never
touched.

You can also point it at a per-project AGENTS.md — just know that file is
usually checked into git, so daily rolls will show as dirty (and your
teammates will meet the drill sergeant). Global files have no such problem.

## The cast

aussie 🇦🇺 · farmer 🌾 · nerd 🤓 · weeb 🍥 · pirate 🏴‍☠️ · noir 🕵️ ·
surfer 🏄 · grandma 👵 · drill-sergeant 🎖️ · shakespeare 🎭 · corporate 📊 ·
conspiracy 👁️ · cowboy 🤠 · valley-girl 💅 · bob-ross 🎨 · angry-chef 👨‍🍳 ·
hacker-90s 🖥️ · butler 🎩

## Add your own

Drop a `.md` file in `personalities/` and it's in the rotation. Keep it
short, keep it funny, and describe a range of mannerisms rather than a phrase
the agent must repeat. End with a reminder that the personality is tone-only —
the code still has to be good. `roll.sh` automatically wraps every personality
in shared instructions that keep the default voice serious and use character
moments only when they fit the context. Your file only needs to describe the
character. PRs with new personalities are extremely welcome.

## Notes

- Personality is most visible at natural moments such as greetings, milestones,
  and task completion. It backs off when clarity or seriousness matters.
- Every personality explicitly tells the agent that flavor never overrides
  correctness. Your builds are safe. Your dignity is probably safe too.
- Re-running `setup.sh` is safe — it replaces its own cron line instead of
  stacking new ones.
- macOS may ask for permissions the first time cron runs; `launchd` works
  too if you're fancy.
