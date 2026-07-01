# 🎰 claude-roulette

Give your coding agent a **random personality every day**. One day it's a
salty pirate, the next it's a drill sergeant, an anime weeb, or a
suspiciously calm Bob Ross.

Works with **any agent that reads an instruction file** — AGENTS.md
(Codex, Cursor, Zed, Amp, Gemini CLI, Claude Code, ...), CLAUDE.md,
GEMINI.md, take your pick. All personalities are pre-written in
[`personalities/`](personalities/) — no API calls, no dependencies,
just a shell script and chaos.

## Setup (30 seconds)

```sh
git clone https://github.com/mikerva/claude-roulette ~/claude-roulette
~/claude-roulette/setup.sh
```

The interactive setup asks which instruction file(s) to possess, rolls your
first personality, and offers to install the daily cron job. Prefer doing it
by hand? Same thing manually:

1. Clone it somewhere (see above).

2. Roll a personality into your instruction file:

   ```sh
   ~/claude-roulette/roll.sh ~/myproject/AGENTS.md
   ```

   This appends a marker block to the file and swaps a random personality
   into it on every roll. The rest of the file is never touched. You can
   pass several files at once to possess all your repos in one go.

3. Make it daily — add a cron job (8am here, pick your poison):

   ```sh
   (crontab -l 2>/dev/null; echo "0 8 * * * $HOME/claude-roulette/roll.sh $HOME/myproject/AGENTS.md") | crontab -
   ```

That's it. Every morning, a new personality. Every session, a surprise.

## Claude Code import mode (optional)

Claude Code supports `@` file imports, so instead of injecting you can run
`./roll.sh` with no arguments — it writes `personality.md` next to the
script — and put this at the top of your CLAUDE.md:

```
@~/claude-roulette/personality.md
```

## The cast

aussie 🇦🇺 · farmer 🌾 · nerd 🤓 · weeb 🍥 · pirate 🏴‍☠️ · noir 🕵️ ·
surfer 🏄 · grandma 👵 · drill-sergeant 🎖️ · shakespeare 🎭 · corporate 📊 ·
conspiracy 👁️ · cowboy 🤠 · valley-girl 💅 · bob-ross 🎨 · angry-chef 👨‍🍳 ·
hacker-90s 🖥️ · butler 🎩

## Add your own

Drop a `.md` file in `personalities/` and it's in the rotation. Keep it
short, keep it funny, and end it with a reminder that the personality is
tone-only — the code still has to be good. PRs with new personalities
are extremely welcome.

## Notes

- Rolls modify your instruction file, so your AGENTS.md will show as dirty
  in git. Commit the marker block once (with whatever personality it rolled);
  future rolls are what they are — embrace it, or point cron at a gitignored
  file and import it instead.
- Every personality explicitly tells the agent that flavor never overrides
  correctness. Your builds are safe. Your dignity is not.
- macOS may ask for permissions the first time cron runs; `launchd` works
  too if you're fancy.
