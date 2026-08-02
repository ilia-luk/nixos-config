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
  imports = [
    ./scripts/ceremonies.nix
    ./scripts/herdr.nix
    ./scripts/worktrunk.nix
    ./scripts/doctor.nix
    ./scripts/dev-up.nix
  ];

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

    enterShell = ''
      echo ""
      echo "wrapper: ''${PROJECT_NAME:-?} | pi jailed: yes | sync: env-sync"
      ${cfg.banner}
      echo ""
    '';
  };
}
