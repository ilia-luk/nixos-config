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
    ];

    scripts = {
      env-sync.exec = ''
        set -e
        echo ">> syncing wrapper against dotfiles..."
        nix flake update dotfiles
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
    };

    enterShell = ''
      echo ""
      echo "wrapper: ''${PROJECT_NAME:-?} | pi jailed: yes | sync: env-sync"
      ${cfg.banner}
      echo ""
    '';
  };
}
