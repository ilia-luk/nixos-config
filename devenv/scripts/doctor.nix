# Wrapper health check: read-only diagnosis; names the fixing ceremony,
# never runs it.
{ pkgs, ... }:
{
  packages = [ pkgs.jq ];

  scripts.wrapper-doctor.exec = ''
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
}
