{ config, pkgs, ... }: {
  home.packages = with pkgs; [ direnv nix-direnv ];

  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
    nix-direnv.enable = true;
    config = {
      global = { load_dotenv = true; };
      whitelist = {
        prefix = [
          "${config.home.homeDirectory}/dev/ehouse/"
          "${config.home.homeDirectory}/dev/domusnetwork/"
          "${config.home.homeDirectory}/dev/accountant/"
          "${config.home.homeDirectory}/dev/riverpool/"
        ];
      };
    };
  };
}
