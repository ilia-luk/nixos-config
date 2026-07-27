{ pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [
    mongodb-ce
    mongosh
    mongodb-tools
    mongodb-compass
  ];

  # no authentication deliberate: local dev only, mock data — see note in postgresql.nix
  services.mongodb = {
    enable = true;
    package = pkgs.mongodb-ce;
    extraConfig = ''
      operationProfiling.mode: all
      systemLog.quiet: false
    '';
  };
}
