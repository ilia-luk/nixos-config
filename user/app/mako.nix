{ pkgs, config, userSettings, ... }:
with config.lib.stylix.colors; {
  home.packages = with pkgs; [ mako ];

  services.mako.enable = true;
  services.mako = {
    settings = {
      font = userSettings.font + " 16";
      margin = "12";
      padding = "12";
      textColor = "#${base05}ff";
      borderSize = 2;
      borderColor = "#${base0E}ff";
      borderRadius = 8;
      progressColor = "#${base0E}ff";
      backgroundColor = "#${base00}bf";
      icons = true;
      sort = "-time";
      defaultTimeout = 3000;
      extraConfig = ''
        [urgency=low]
        border-color=#${base0B}
        [urgency=normal]
        border-color=#${base0E}
        [urgency=high]
        border-color=#${base08}
      '';
    };
  };
}
