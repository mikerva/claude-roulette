# 🎰 claude-roulette

Give your Claude (or any CLAUDE.md/AGENTS.md-reading agent) a **random
personality every day**. One day it's a salty pirate, the next it's a
drill sergeant, an anime weeb, or a suspiciously calm Bob Ross.

All personalities are pre-written in [`personalities/`](personalities/) —
no API calls, no dependencies, just `cp` and chaos.

## Setup (30 seconds)

1. Clone it somewhere:

   ```sh
   git clone <this-repo> ~/claude-roulette
   ```

2. Add this line to the **top** of your `CLAUDE.md` (or `AGENTS.md`):

   ```
   @~/claude-roulette/personality.md
   ```

3. Roll your first personality:

   ```sh
   ~/claude-roulette/roll.sh
   ```

4. Make it daily — add a cron job (8am here, pick your poison):

   ```sh
   (crontab -l 2>/dev/null; echo "0 8 * * * $HOME/claude-roulette/roll.sh") | crontab -
   ```

That's it. Every morning, a new personality. Every session, a surprise.

## Usage

```sh
./roll.sh                 # writes personality.md next to the script
./roll.sh /path/to/personality.md   # write it somewhere else
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

- `personality.md` is gitignored — it's generated, roll it after cloning.
- Every personality explicitly tells the agent that flavor never overrides
  correctness. Your builds are safe. Your dignity is not.
- macOS may ask for permissions the first time cron runs; `launchd` works
  too if you're fancy.
