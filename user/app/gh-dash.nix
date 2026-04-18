{ pkgs, config, ... }:
with config.lib.stylix.colors; {
  home.packages = with pkgs; [ unstable.gh-dash ];

  programs.gh-dash.enable = true;

  programs.gh-dash.settings = {

  };
}
