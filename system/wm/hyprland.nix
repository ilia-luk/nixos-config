{ inputs, pkgs, lib, ... }:

{
  # Import wayland config
  imports = [ 
    ./wayland.nix
    ./pipewire.nix
    ./dbus.nix
  ];

  # Get hyprland
  environment.systemPackages = with pkgs; [ xdg-desktop-portal-hyprland ];

  # Configure hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };
}
