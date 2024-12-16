{
  description = "Ehouse flake for nodejs version 22";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
  };

  outputs = inputs @ { self, ... }: let
    system = "x86_64-linux";

    pkgs = import inputs.nixpkgs {
      system = system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [nodejs_22];
        shellHook = ''
          echo "node `${pkgs.nodejs_22}/bin/node --version`"
        '';
      };
  };
}
