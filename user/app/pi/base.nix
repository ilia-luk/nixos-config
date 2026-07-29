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
          # themes are HM-managed symlink CHAINS into the store; bind every hop
          # so resolution survives inside the jail (no /nix/store mount by design)
          for t in "$HOME/.pi/agent/themes"/*.json; do
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
        ''
      ))
    ];
}
