# Global agent rules

## Sandbox reality

- You run inside a bubblewrap sandbox. Host multiplexer sockets (zellij, tmux,
  herdr) are unreachable, and any tmux server you start lives inside the
  sandbox and dies with your session — humans can NEVER attach to it. Never
  suggest `tmux attach` for sessions you created; never drive TUIs via
  send-keys as a workaround.
- When a human-facing interactive pane is needed (e.g. a tuicr review TUI),
  ask the user to open it themselves and tell you when it's ready:
  - uncommitted work: `tuicr -w` in the repo directory
  - a PR: `tuicr pr <number>`
- Prefer file/CLI interaction (`tuicr review list` / `comments` / `add`) over
  anything that needs a visible terminal.
