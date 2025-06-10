{
  pkgs,
  config,
  ...
}:
with config.lib.stylix.colors; {
  home.packages = with pkgs; [
    zellij
  ];

  programs.zellij.enable = true;
  programs.zellij = {
    settings = {
      pane_frames = true;
      ui = {
        pane_frames = {
          rounded_corners = true;
        };
      };
      simplified_ui = false;
      copy_on_select = true;
      default_shell = "nu";
      theme = "catppuccin";
      themes = {
        catppuccin = {
          fg = "#${base03}";
          bg = "#${base04}";
          black = "#${base02}";
          red = "#${base08}";
          green = "#${base0B}";
          yellow = "#${base0A}";
          blue = "#${base0D}";
          magenta = "#${base0E}";
          cyan = "#${base0C}";
          white = "#${base05}";
          orange = "#${base09}";
        };
      };
    };
  };

  home.shellAliases = {
    zj = "zellij";
  };
}
