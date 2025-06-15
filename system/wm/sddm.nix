{ config, pkgs, ... }:
let
  sddm-astronaut = pkgs.unstable.sddm-astronaut.override {
    embeddedTheme = "hyprland_kath";
    themeConfig = {
      ScreenWidth = 3840;
      ScreenHeight = 1800;
      Blur = true;
      FormPosition = "left";
      ForceHideCompletePassword = true;
    };
  };
in {
  # Configure display manager (login screen)
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    enableHidpi = true;
    theme = "sddm-astronaut-theme";
    package = pkgs.kdePackages.sddm;
    extraPackages = [ sddm-astronaut ];
  };
  environment.systemPackages = [ sddm-astronaut ];
}
