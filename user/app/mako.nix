{ pkgs, config, userSettings, ... }:
with config.lib.stylix.colors; {
  home.packages = with pkgs; [ mako ];

  services.mako.enable = true;
  services.mako = {
    settings = {
      actions = 1;
      history = 1;
      width = 480;
      height = 192;
      anchor = "top-right";
      font = userSettings.font + " 14";
      margin = "29,32";
      padding = "16,24";
      text-color = "#${base05}ff";
      border-size = 2;
      border-color = "#${base0E}ff";
      border-radius = 8;
      progress-color = "source #${base0E}ff";
      background-color = "#${base00}bf";
      icons = true;
      max-icon-size = 64;
      ignore-timeout = false;
      layer = "top";
      markup = true;
      sort = "-time";
      default-timeout = 12000;
      "urgency=low" = { border-color = "#${base0B}"; };
      "urgency=normal" = { border-color = "#${base0E}"; };
      "urgency=high" = { border-color = "#${base08}"; };
    };
  };
}
