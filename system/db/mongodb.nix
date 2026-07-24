{ pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [
    mongodb-ce
    mongosh
    mongodb-tools
    mongodb-compass
  ];

  services.mongodb = {
    enable = true;
    package = pkgs.mongodb-ce;
    extraConfig = ''
      operationProfiling.mode: all
      systemLog.quiet: false
    '';
  };
}
