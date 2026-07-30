# Project Wrapper (Nix + devenv + direnv + pi)

A client-project wrapper: reproducible dev shell, jailed coding agent, and
update ceremonies — with the actual client repository cloned into a
subdirectory, keeping their git history free of any of this.

Shared baseline lives in the dotfiles repo (`devenv/wrapper-base.nix`) and is
imported by reference — improvements arrive via `env-sync`, never by copying.

## Creating a new project (from the template)

```bash
mkdir ~/dev/<project> && cd ~/dev/<project>
nix flake init -t github:ilia-luk/nixos-config#wrapper   # or: -t ~/.dotfiles#wrapper

# 1) edit the "project configuration" block at the top of flake.nix
#    (projectName, projectRepoUrl, projectPkgs)
# 2) rename the CHANGEME/ line in .gitignore to your projectName/

git init && git add -A     # flakes only see TRACKED files — add before loading
direnv allow               # builds the shell (first run takes a while)
repo-clone                 # clones the client repo into ./<projectName>/
cp .env.example .env       # then edit
```

Sanity check: `pi` starts themed, `!node --version` (or your stack's
equivalent) works inside its jail, and the enterShell banner names the project.

## Daily ceremonies

- `env-sync` — pull the latest shared baseline from dotfiles (updates the
  `dotfiles` and `nixpkgs-unstable` locks; direnv reloads on next prompt).
- `repo-clone` — (re)clone the client repo if the folder is missing. Idempotent.
- `wrapper-doctor` — read-only health check: env, clone, git hygiene, sync
  freshness, pi wiring, herdr staleness. Run it whenever something feels off.
- `herd` — attach/create this project's own herdr session (never the default).
- `herd-status` / `herd-reset` — inspect / stop+delete that session. Reset
  after `env-sync` if a detached session still runs old binaries.
- `wt` (worktrunk) — **run it from inside the cloned client repo, never the
  wrapper root**; worktrees land as `<projectName>.<branch>/` siblings inside
  the wrapper. At wrapper level, `wt` is guarded and will refuse.
- Project-specific scripts live in `devenv.scripts/*.nix` — add a
  `watch_file` line in `.envrc` for each new module.

## Layout

```bash
~/dev/<project>/ # wrapper root — pi's project root, YOUR files
├── flake.nix # project config block + module list
├── .envrc # direnv glue (--impure: PWD/HOME plumbing)
├── devenv.scripts/ # project-specific devenv modules
├── AGENTS.md # notes for the coding agent
└── <projectName>/ # the client repo (gitignored, cloned by repo-clone)
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
