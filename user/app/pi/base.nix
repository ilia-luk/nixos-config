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
    defaultProvider = "moonshot";
    defaultModel = "kimi-k3";
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
        ]
        ++ extraPkgs
      ))
      (try-readonly (noescape "~/.gitconfig"))
      (add-runtime (
        (lib.concatMapStrings (name: ''
          link="$HOME/.config/sops-nix/secrets/${name}"
          if [ -e "$link" ]; then
            RUNTIME_ARGS+=(--ro-bind "$(realpath "$link")" "$link")
          fi
        '') (builtins.attrValues piKeys))
        + ''
          # HM-managed agent resources (themes, skills) are symlink CHAINS into
          # the store; bind every hop so resolution survives inside the jail
          # (no /nix/store mount by design).
          for t in "$HOME/.pi/agent/themes"/*.json "$HOME/.pi/agent/skills"/* "$HOME/.pi/agent/AGENT.md"; do
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

          # tuicr review sessions: shared data plane between the human's TUI
          # (host) and the agent's `tuicr review` CLI (jail). Read-write, file
          # data only — no exec capability, unlike multiplexer sockets.
          mkdir -p "$HOME/.local/share/tuicr/reviews"
          RUNTIME_ARGS+=(--bind "$HOME/.local/share/tuicr/reviews" "$HOME/.local/share/tuicr/reviews")

          # honest multiplexer posture: sockets are never bound into the jail,
          # so make the tuicr skill's environment detection report "none" and
          # take its documented wait-for-the-user fallback instead of failing.
          RUNTIME_ARGS+=(--unsetenv ZELLIJ --unsetenv TMUX --unsetenv HERDR_ENV)
        ''
      ))
    ];
}
