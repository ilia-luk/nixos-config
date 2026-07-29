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

- `env-sync` — pull the latest shared baseline from dotfiles
  (`nix flake update dotfiles` + `git add flake.lock`; direnv reloads on next
  prompt). Run after any dotfiles change to `wrapper-base.nix` or pi config.
- `repo-clone` — (re)clone the client repo if the folder is missing. Idempotent.
- Project-specific scripts live in `devenv.scripts/*.nix` — add a
  `watch_file` line in `.envrc` for each new module.

## Layout
