{
  pkgs,
  config,
  ...
}:
with config.lib.stylix.colors; {
  home.packages = with pkgs; [
    unstable.neovim-unwrapped
  ];

#programs.neovim.enable = true;
}
