{
  pkgs,
  config,
  userSettings,
  ...
}:
with config.lib.stylix.colors; {
  home.packages = with pkgs; [
    fuzzel
  ];

  programs.fuzzel.enable = true;
  programs.fuzzel.settings = {
    main = {
      font = userSettings.font + ":size=16";
      dpi-aware = "no";
      show-actions = "yes";
      terminal = "${pkgs.kitty}/bin/kitty";
    };
    colors = {
      background = "${base00}bf";
      text = "${base05}ff";
      match = "${base09}ff";
      selection = "${base02}ff";
      selection-text = "${base05}ff";
      selection-match = "${base09}ff";
      border = "${base0E}ff";
    };
    border = {
      width = 2;
      radius = 8;
    };
  };
}
