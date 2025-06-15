{ config, pkgs, ... }: {
  imports =
    [ ./pipewire.nix ./dbus.nix ./gnome-keyring.nix ./fonts.nix ./sddm.nix ];

  environment.systemPackages = with pkgs; [ wayland wl-clipboard-rs ];

  # Configure xwayland
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    xkb = {
      layout = "us, il";
      variant = "";
      options = "grp:alt_shift_toggle";
    };
  };

  # Configure environment
  environment.sessionVariables = {
    # If your cursor becomes invisible
    # WLR_NO_HARDWARE_CURSORS = "1";
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };
}
