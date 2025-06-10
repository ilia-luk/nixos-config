{config, pkgs, ...}: {
  home.packages = with pkgs; [
    direnv
    nix-direnv
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    nix-direnv.enable = true;
    config = {
      global = {
        load_dotenv = true;
      };
      whitelist = {
        prefix = [
          "${config.home.homeDirectory}/dev/ehouse/"
        ];
      };
    };
  };
}
