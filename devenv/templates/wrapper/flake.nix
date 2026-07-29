{
  inputs = {
    nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
    dotfiles.url = "github:ilia-luk/nixos-config";
    pi.follows = "dotfiles/pi";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      devenv,
      systems,
      ...
    }@inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);

      # ── project configuration — the only block to edit ────────────
      projectName = "CHANGEME";
      projectRepoUrl = "git@github.com:CHANGEME/CHANGEME.git";
      projectPkgs =
        pkgs: with pkgs; [
          # toolchain for shell AND pi's jail, e.g.:
          # nodejs_24 pnpm
        ];
      # ──────────────────────────────────────────────────────────────
    in
    {
      devShells = forEachSystem (
        system:
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
              allowUnfreePredicate = _: true;
            };
            overlays = [
              (final: prev: {
                unstable = import inputs.nixpkgs-unstable {
                  inherit system;
                  config = prev.config;
                };
              })
            ];
          };
        in
        {
          default = devenv.lib.mkShell {
            inherit inputs pkgs;
            modules = [
              "${inputs.dotfiles}/devenv/wrapper-base.nix"

              ({ pkgs, lib, ... }: {
                wrapper.piPackages = projectPkgs pkgs;
                packages = projectPkgs pkgs;

                env = {
                  PROJECT_NAME = projectName;
                  PROJECT_REPO_URL = projectRepoUrl;
                };

                enterShell = ''
                  echo "repo: ${projectName} (${projectRepoUrl})"
                '';
              })

              # project-specific modules (db, services, extra scripts):
              # ./devenv.scripts/foo.nix
            ];
          };
        }
      );
    };
}
