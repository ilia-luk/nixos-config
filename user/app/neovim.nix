{
  pkgs,
  config,
  ...
}:
with config.lib.stylix.colors;
{
  home.packages = with pkgs; [
    unstable.neovim-unwrapped
  ];

  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/user/app/nvim";
}
