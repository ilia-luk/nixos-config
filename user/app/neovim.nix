{
  pkgs,
  config,
  ...
}:
with config.lib.stylix.colors; {
  home.packages = with pkgs; [
    unstable.neovim
  ];

  programs.neovim.enable = true;
}
