{ pkgs, ... }: {
  home.packages = [ pkgs.unstable.herdr ];

  xdg.configFile."herdr/config.toml".source = ./config.toml;
}
