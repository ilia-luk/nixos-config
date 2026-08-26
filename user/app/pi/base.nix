# Shared pi coding-agent baseline. Consumed by:
#  - HM module (user/app/pi/pi.nix)
#  - per-project mkCodingAgent compositions in devenv wrappers,
#    imported as a raw file from the flake source (no output eval).
{
  pkgs,
  lib,
  homeDir,
}:
let
  piKeys = {
    KIMI_API_KEY = "kimi-api-key";
    # ANTHROPIC_API_KEY = "claude-api-key";
    # OPENAI_API_KEY = "openai-api-key";
  };
in
{
  inherit piKeys;

  settings = {
    enableInstallTelemetry = false;
    defaultProjectTrust = "ask";
    theme = "stylix";
    defaultProvider = "openai-codex";
    defaultModel = "gpt-5.6-sol";
    packages = [ "npm:pi-web-access@0.23.0" ];
    npmCommand = [ "${pkgs.nodejs}/bin/npm" ];
  };

  environment = builtins.mapAttrs (_: name: {
    file = "${homeDir}/.config/sops-nix/secrets/${name}";
  }) piKeys;

  # extraPkgs: per-project toolchain appended to the common set
  jailPermissions =
    extraPkgs: combinators: with combinators; [
      network
      mount-cwd
      (add-pkg-deps (
        [
          pkgs.git
          pkgs.ripgrep
          pkgs.fd
          pkgs.jq
          pkgs.gnumake
          pkgs.tmux
          pkgs.diffutils
          pkgs.gnugrep
          pkgs.findutils
          pkgs.gnused
          pkgs.unstable.tuicr
          pkgs.unstable.codebase-memory-mcp
        ]
        ++ extraPkgs
      ))
      (try-readonly (noescape "~/.gitconfig"))
      (add-runtime (
        (lib.concatMapStrings (name: ''
          link="$HOME/.config/sops-nix/secrets/${name}"
          if [ -e "$link" ]; then
            rp="$(realpath "$link")"
            RUNTIME_ARGS+=(--ro-bind "$rp" "$rp" --ro-bind "$rp" "$link")
          fi
        '') (builtins.attrValues piKeys))
        + ''
          # HM-managed agent resources (themes, skills) are symlink CHAINS into
          # the store; bind every hop so resolution survives inside the jail
          # (no /nix/store mount by design).
          for t in "$HOME/.pi/agent/themes"/*.json "$HOME/.pi/agent/skills"/* "$HOME/.pi/agent/AGENTS.md" "$HOME/.pi/agent/prompts"; do
            [ -L "$t" ] || [ -e "$t" ] || continue
            cur="$t"
            while [ -L "$cur" ]; do
              tgt="$(readlink "$cur")"
              case "$tgt" in
                /*) cur="$tgt" ;;
                *) cur="$(dirname "$cur")/$tgt" ;;
              esac
              case "$cur" in
                /nix/store/*) RUNTIME_ARGS+=(--ro-bind "$cur" "$cur") ;;
              esac
            done
          done

          # mask client secret files inside the jail: present but empty.
          # (post-web-access: readable secrets + untrusted web content +
          # fetch tools = exfil triangle). Walks the mount root so nested
          # monorepo .envs are covered regardless of launch geometry;
          # .env.example stays readable (structure, not values).
          while IFS= read -r sf; do
            RUNTIME_ARGS+=(--bind /dev/null "$sf")
          done < <(find "$PWD" -maxdepth 4 \
              \( -name node_modules -o -name .git -o -name .devenv -o -name ".cbm" \) -prune -o \
              -type f \( -name ".env" -o -name ".env.*" \) ! -name ".env.example" -print 2>/dev/null)

          # tuicr review sessions: shared data plane between the human's TUI
          # (host) and the agent's `tuicr review` CLI (jail). Read-write, file
          # data only — no exec capability, unlike multiplexer sockets.
          mkdir -p "$HOME/.local/share/tuicr/reviews"
          RUNTIME_ARGS+=(--bind "$HOME/.local/share/tuicr/reviews" "$HOME/.local/share/tuicr/reviews")

          # pi-web-access config lives OUTSIDE the agent-dir mount (~/.pi/),
          # so the hop-bind glob can't deliver it — bind the resolved store
          # file AND the link path (sops-key pattern) so jailed pis get the
          # same workflow settings as host pis (default = curator = silent
          # ~20s stall per search in a jail).
          ws="$HOME/.pi/web-search.json"
          if [ -e "$ws" ]; then
            wsrp="$(realpath "$ws")"
            RUNTIME_ARGS+=(--ro-bind "$wsrp" "$wsrp" --ro-bind "$wsrp" "$ws")
          fi

          # codebase-memory graph cache: per-wrapper root (client isolation —
          # the index IS client code structure). rw so the jailed agent can
          # index and query; same-build coordination guaranteed because jail
          # and wrapper shell resolve cbm from the same wrapper lock.
          if [ -n "''${CBM_CACHE_DIR:-}" ]; then
            mkdir -p "$CBM_CACHE_DIR"
            RUNTIME_ARGS+=(--bind "$CBM_CACHE_DIR" "$CBM_CACHE_DIR" --setenv CBM_CACHE_DIR "$CBM_CACHE_DIR")
          fi

          # honest multiplexer posture: sockets are never bound into the jail,
          # so make the tuicr skill's environment detection report "none" and
          # take its documented wait-for-the-user fallback instead of failing.
          RUNTIME_ARGS+=(--unsetenv ZELLIJ --unsetenv TMUX --unsetenv HERDR_ENV)

          # git worktrees: a linked worktree's .git is a FILE pointing at the
          # primary repo's .git/worktrees/<name>; without that dir the jail
          # has no working git at all. Bind the primary .git (rw — index,
          # refs, and object writes live there) so agents launched in a
          # worktree are fully git-capable. Same-client data only; the
          # cross-client geometry is untouched.
          if [ -f "$PWD/.git" ]; then
            wt_gitdir="$(sed -n 's/^gitdir: //p' "$PWD/.git")"
            case "$wt_gitdir" in
              /*)
                git_common="$(cd "$wt_gitdir/../.." 2>/dev/null && pwd)"
                if [ -n "$git_common" ] && [ -d "$git_common" ]; then
                  RUNTIME_ARGS+=(--bind "$git_common" "$git_common")
                fi
                ;;
            esac
          fi
        ''
      ))
    ];
}
