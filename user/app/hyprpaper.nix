{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    hyprpaper
  ];

  services.hyprpaper.enable = true;

  services.hyprpaper.settings = {
    preload = [
      config.stylix.image
    ];
    wallpaper = [
      "DP-1, ${config.stylix.image}"
    ];
  };
}
