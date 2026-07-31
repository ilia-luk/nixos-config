{ pkgs, ... }: {
  home.packages = [ pkgs.unstable.tuicr ];

  xdg.configFile."tuicr/config.toml".source = ./config.toml;
}
