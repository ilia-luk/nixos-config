{
  pkgs,
  config,
  ...
}:
with config.lib.stylix.colors; {
  home.packages = with pkgs; [
    lazygit
  ];

  programs.lazygit.enable = true;
  programs.lazygit.settings = {
    gui = {
      theme = {
        activeBorderColor = ["#${base06}" "bold"];
        inactiveBorderColor = ["#${base04}"];
        optionsTextColor = ["#${base0D}"];
        selectedLineBgColor = ["#${base02}"];
        cherryPickedCommitBgColor = ["#${base03}"];
        cherryPickedCommitFgColor = ["#${base06}"];
        unstagedChangesColor = ["#${base0F}"];
        defaultFgColor = ["#${base05}"];
        searchingActiveBorderColor = ["#${base0A}"];
      };
      nerdFontsVersion = "3";
      authorColors = {
        "*" = "#${base07}";
      };
    };
  };
}
