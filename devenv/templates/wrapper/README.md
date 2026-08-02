# Project Wrapper (Nix + devenv + direnv + pi)

A client-project wrapper: reproducible dev shell, jailed coding agent, and
update ceremonies — with the actual client repository cloned into a
subdirectory, keeping their git history free of any of this.

Shared baseline lives in the dotfiles repo (`devenv/wrapper-base.nix`) and is
imported by reference — improvements arrive via `env-sync`, never by copying.

## Creating a new project

```bash
cd ~/dev
wrapper-init <project> git@github.com:<org>/<repo>.git
cd <project>             # first shell build takes a while
repo-clone               # clones the client repo into ./<project>/
cp .env.example .env     # then edit
dev-up                   # themed five-tab project session
```

`wrapper-init` scaffolds from this template, fills `projectName`/`projectRepoUrl`
and the `.gitignore` pattern, git-inits (flakes only see tracked files), and
runs `direnv allow`. Two follow-ups per project:

1. add the toolchain to `projectPkgs` in flake.nix (feeds both the shell and
   pi's jail),
2. add the repo to gh-dash's `repoPaths` (`user/app/gh-dash.nix` in dotfiles)
   so the review keybinds resolve.

Manual path (what wrapper-init automates): mkdir + `nix flake init -t
~/.dotfiles#wrapper` + edit the project-configuration block + rename the
CHANGEME gitignore line + `git init && git add -A` + `direnv allow`.

Sanity check: `wrapper-doctor` reports green (expect only the not-cloned warn
before `repo-clone`); `pi` starts themed and `!node --version` (or your
stack's equivalent) works inside its jail.

## Daily ceremonies

- `env-sync` — pull the latest shared baseline from dotfiles (updates the
  `dotfiles` and `nixpkgs-unstable` locks; direnv reloads on next prompt).
- `repo-clone` — (re)clone the client repo if the folder is missing. Idempotent.
- `wrapper-doctor` — read-only health check: env, clone, git hygiene, sync
  freshness, pi wiring, herdr staleness. Run it whenever something feels off.
- `dev-up` — create or attach this project's zellij session: five tabs
  (editor with nvim + stacked pi/shell, services, agents running `herd`,
  reviews running `gh-dash`, shell at wrapper root). Run from a plain
  terminal; it guards against unedited placeholders and a missing clone.
- `herd` — attach/create this project's own herdr session (never the default).
- `herd-status` / `herd-reset` — inspect / stop+delete that session. Reset
  after `env-sync` if a detached session still runs old binaries.
- `wt` (worktrunk) — **run it from inside the cloned client repo, never the
  wrapper root**; worktrees land as `<projectName>.<branch>/` siblings inside
  the wrapper. At wrapper level, `wt` is guarded and will refuse.
- Project-specific scripts live in `devenv.scripts/*.nix` — add a
  `watch_file` line in `.envrc` for each new module.
- Reviewing with tuicr: `tuicr -w` (uncommitted) or `tuicr pr <n>` in the client repo;
  from `gh-dash` use the review binds. Agents read/write the same sessions via
  `tuicr review`. When an agent asks you to start tuicr, this is what it means.

## Code review workflows (tuicr × pi × gh-dash)

**PR review, human:** in gh-dash press `b` — floating tuicr on the PR.
Comment, then `:submit` to publish to GitHub, or `y` to export markdown.

**PR review, agent + human:** press `B` — tuicr opens on the left, a jailed
pi in a PR worktree on the right, pointed at the same session. The agent
posts findings (`--username pi`); reload the tuicr pane to see them, add
your own, submit. (Submitted comments publish under _your_ GitHub account.)

**Address PR feedback:** tell pi — "open the tuicr session for PR <n> and
address the comments." Covers colleagues' GitHub comments too (tuicr syncs
them into the session). If no session exists yet, open one (`tuicr pr <n>`
or the `b` bind) when pi asks.

**Review the agent's local work (human-led):** run `tuicr -w` in the repo,
comment, then tell pi "open my tuicr session and address my comments."

**Agent self-review (agent-led):** tell pi "review your code in tuicr."
It will ask you to open `tuicr -w`, then post its findings for you to read
in the TUI. Follow up with "address the comments" to act on them.

Notes: local sessions hold drafts only — submitting to GitHub exists in PR
sessions. The TUI loads drafts at startup; reload it to see comments added
while it was open. Agents cannot reach GitHub (no `gh` in the sandbox) —
pushing and submitting are always yours.

## Layout

```bash
~/dev/<project>/ # wrapper root — pi's project root, YOUR files
├── flake.nix # project config block + module list
├── .envrc # direnv glue (--impure: PWD/HOME plumbing)
├── devenv.scripts/ # project-specific devenv modules
├── AGENTS.md # notes for the coding agent
└── <projectName>.<branch>/ # worktrees (created via `wt` from inside the repo)
```

The coding agent (`pi`) runs bubblewrap-jailed: it sees this wrapper (rw),
its own config, declared secrets, and the toolchain from `projectPkgs` —
not your home directory and not other clients' wrappers.

## Troubleshooting

- **`error: path '...' does not exist` on reload** — a new file isn't
  git-tracked. `git add` it; flakes only see tracked files.
- **pi: theme/model missing or key errors** — baseline drift; run `env-sync`.
- **direnv didn't pick up a change** — `direnv reload`, or check the file has a `watch_file` line.

## Housekeeping

`.env`, `.devenv/`, `.direnv/`, and the cloned repo folder are gitignored —
keep it that way; `.env` may hold secrets and the client repo has its own home.
