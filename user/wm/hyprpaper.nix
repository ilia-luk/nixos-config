{ config, pkgs, ... }: {
  home.packages = with pkgs; [ hyprpaper ];

  services.hyprpaper.enable = true;

  services.hyprpaper.settings = {
    ipc = "on";
    wallpaper = {
      monitor = "DP-1";
      path = "${config.stylix.image}";
      fit_mode = "cover";
    };
  };
}
