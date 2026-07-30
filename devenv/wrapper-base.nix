# Shared devenv module for client project wrappers — species 2: imported by
# reference ("${inputs.dotfiles}/devenv/wrapper-base.nix"), never copied.
# Wrappers configure it via the `wrapper.*` options below.
{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.wrapper;
  homeDir = builtins.getEnv "HOME";
  piBase = import "${inputs.dotfiles}/user/app/pi/base.nix" {
    inherit pkgs lib homeDir;
  };
  agent = inputs.pi.lib.mkCodingAgent {
    inherit pkgs;
    modules = [
      {
        pi.coding-agent = {
          environment = piBase.environment;
          jail = {
            enable = true;
            permissions = piBase.jailPermissions cfg.piPackages;
          };
        };
      }
    ];
  };

  # herdr identifies agents by process inspection; the bwrap jail's PID
  # namespace hides pi, so bake the documented HERDR_AGENT hint onto the
  # outermost wrapper (scoped to pi's process only, not a global export).
  agentForHerdr = pkgs.symlinkJoin {
    name = "pi-jailed-herdr";
    paths = [ agent.package ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/pi --set HERDR_AGENT pi
    '';
  };
in
{
  options.wrapper = {
    piPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Project toolchain granted inside pi's jail.";
    };
    banner = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Extra enterShell lines (project-specific version prints).";
    };
  };

  config = {
    devenv.root = lib.mkDefault (builtins.getEnv "PWD");
    devenv.state = lib.mkForce (builtins.getEnv "PWD" + "/.devenv");

    packages = [
      agentForHerdr
      pkgs.bashInteractive
      pkgs.tree
      pkgs.jq
    ];

    scripts = {
      env-sync.exec = ''
        set -e
        echo ">> syncing wrapper against dotfiles..."
        nix flake update dotfiles nixpkgs-unstable
        git add flake.lock
        echo ">> lock updated; direnv reloads on next prompt (or: direnv reload)"
      '';
      repo-clone.exec = ''
        set -e
        : "''${PROJECT_REPO_URL:?PROJECT_REPO_URL not set}"
        : "''${PROJECT_NAME:?PROJECT_NAME not set}"
        if [ -d "$PROJECT_NAME" ]; then echo ">> $PROJECT_NAME already cloned"
        else git clone "$PROJECT_REPO_URL" "$PROJECT_NAME"; fi
      '';
      herd.exec = ''
        exec herdr --session "''${PROJECT_NAME:?PROJECT_NAME not set (run inside a wrapper)}" "$@"
      '';
      # Stop + delete this project's herdr session for a clean start
      # (a detached server keeps pre-env-sync binaries alive until stopped).
      herd-reset.exec = ''
        set -e
        : "''${PROJECT_NAME:?PROJECT_NAME not set (run inside a wrapper)}"
        herdr session stop "$PROJECT_NAME" --json >/dev/null 2>&1 || true
        herdr session delete "$PROJECT_NAME" --json >/dev/null 2>&1 || true
        echo ">> herdr session '$PROJECT_NAME' stopped and deleted — 'herd' starts fresh"
      '';

      # Is anything alive in this project's herdr session?
      herd-status.exec = ''
        : "''${PROJECT_NAME:?PROJECT_NAME not set (run inside a wrapper)}"
        if herdr --session "$PROJECT_NAME" workspace list 2>/dev/null; then
          exit 0
        else
          echo ">> herdr session '$PROJECT_NAME' is not running"
        fi
      '';

      # Wrapper health check: env, clone, git hygiene, sync freshness,
      # pi wiring, herdr session staleness.
      wrapper-doctor.exec = ''
        ok()   { printf '  [ok]   %s\n' "$1"; }
        warn() { printf '  [warn] %s\n' "$1"; }
        fail() { printf '  [FAIL] %s\n' "$1"; }
        echo "wrapper-doctor: $PWD"

        # 1. wrapper env
        if [ -n "''${PROJECT_NAME:-}" ] && [ -n "''${PROJECT_REPO_URL:-}" ]; then
          ok "PROJECT_NAME=$PROJECT_NAME"
        else
          fail "PROJECT_NAME / PROJECT_REPO_URL not set — flake env block incomplete"
        fi

        # 2. client repo cloned
        if [ -d "''${PROJECT_NAME:-__unset__}" ]; then
          ok "client repo present: $PROJECT_NAME/"
        else
          warn "client repo not cloned — run: repo-clone"
        fi

        # 3. untracked files (invisible to flake eval — the classic bite)
        untracked="$(git status --porcelain 2>/dev/null | grep -c '^??' || true)"
        if [ "''${untracked:-0}" -gt 0 ]; then
          warn "$untracked untracked file(s) in wrapper — flakes only see tracked files (git add)"
        else
          ok "no untracked wrapper files"
        fi

        # 4. env-sync freshness: locked dotfiles rev vs origin main
        locked="$(jq -r '.nodes.dotfiles.locked.rev // empty' flake.lock 2>/dev/null)"
        remote="$(git ls-remote https://github.com/ilia-luk/nixos-config main 2>/dev/null | cut -f1)"
        if [ -z "$locked" ]; then
          warn "no dotfiles input in flake.lock?"
        elif [ -z "$remote" ]; then
          warn "could not reach github to compare dotfiles rev (offline?)"
        elif [ "$locked" = "$remote" ]; then
          ok "dotfiles lock is current ($(printf %.8s "$locked"))"
        else
          warn "dotfiles lock behind origin ($(printf %.8s "$locked") != $(printf %.8s "$remote")) — run: env-sync"
        fi

        # 5. pi wiring: wrapper's jailed+hinted pi should shadow the global one
        pipath="$(command -v pi || true)"
        case "$pipath" in
          *pi-jailed-herdr*) ok "pi = wrapper build (jailed, herdr-hinted)" ;;
          "")                fail "pi not on PATH" ;;
          *)                 warn "pi is NOT the wrapper build: $pipath (direnv not loaded? env-sync + reload?)" ;;
        esac

        # 6. herdr session staleness: running server binary vs current herdr
        if herdr --session "''${PROJECT_NAME:-}" workspace list >/dev/null 2>&1; then
          pid="$(pgrep -f "herdr.*--session ''${PROJECT_NAME}.*server" | head -1 || true)"
          [ -z "$pid" ] && pid="$(pgrep -f "herdr.*--session ''${PROJECT_NAME}" | head -1 || true)"
          cur="$(readlink -f "$(command -v herdr)" 2>/dev/null || true)"
          run="$(readlink -f "/proc/''${pid:-0}/exe" 2>/dev/null || true)"
          if [ -z "$pid" ] || [ -z "$run" ]; then
            warn "herdr session running but server pid/exe not identifiable"
          elif [ "$run" = "$cur" ]; then
            ok "herdr session running on current binary"
          else
            warn "herdr session runs a STALE binary ($run) — herd-reset for a fresh server"
          fi
        else
          ok "no herdr session running (herd starts one)"
        fi
      '';
      # Guard: wt has no business in the WRAPPER repo — worktrees belong to the
      # client repo inside it. Shadows worktrunk's binary on PATH in wrapper
      # shells; blocks every invocation whose git toplevel is the wrapper root
      # (incl. the interactive picker, which can create worktrees from its TUI).
      wt.exec = ''
        if [ "$(git rev-parse --show-toplevel 2>/dev/null)" = "$DEVENV_ROOT" ]; then
          echo "wt guard: this is the WRAPPER repo — cd into the project directory (the cloned client repo) first." >&2
          echo "  (escape hatch for debris cleanup: ${pkgs.unstable.worktrunk}/bin/wt)" >&2
          exit 1
        fi
        exec ${pkgs.unstable.worktrunk}/bin/wt "$@"
      '';
    };

    enterShell = ''
      echo ""
      echo "wrapper: ''${PROJECT_NAME:-?} | pi jailed: yes | sync: env-sync"
      ${cfg.banner}
      echo ""
    '';
  };
}
