{ config, pkgs, ... }: {
  home.packages = with pkgs; [ hyprpaper ];

  services.hyprpaper.enable = true;

  services.hyprpaper.settings = {
    ipc = "on";
    splash = true;
    splash_offset = 2;
    preload = [ "${config.stylix.image}" ];
    wallpaper = [ "DP-1, ${config.stylix.image}" ];
  };
}
