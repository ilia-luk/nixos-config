{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    direnv
    nix-direnv
  ];

  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
    nix-direnv.enable = true;
    config = {
      whitelist = {
        prefix = [
          "${config.home.homeDirectory}/dev/domusnetwork/"
          "${config.home.homeDirectory}/dev/accountant/"
          "${config.home.homeDirectory}/dev/automation/"
        ];
      };
    };
  };
}
