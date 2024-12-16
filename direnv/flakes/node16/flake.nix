{
  description = "Ehouse flake for nodejs version 16";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixpkgs-old2305.url = "https://github.com/NixOS/nixpkgs/archive/nixos-23.05.tar.gz";
  };

  outputs = inputs @ { self, ... }: let
    system = "x86_64-linux";

    overlay-old2305 = final: prev: {
      old2305 = import inputs.nixpkgs-old2305 {
        system = system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
          permittedInsecurePackages = [ "nodejs-16.20.2" ];
        };
        overlays = [(
          self: super: {
            yarn = super.yarn.override {
              nodejs = pkgs.old2305.nodejs_16;
            };
          }
        )];
      };
    };
    pkgs = import inputs.nixpkgs {
      system = system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
      overlays = [
        overlay-old2305
      ];
    };

    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [old2305.nodejs_16 old2305.yarn];
        shellHook = ''
          unset LD_LIBRARY_PATH
          echo "node `${pkgs.old2305.nodejs_16}/bin/node --version`"
        '';
      };
  };
}
