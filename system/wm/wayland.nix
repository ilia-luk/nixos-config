{ config, pkgs, ... }: {
  imports = [
    ./pipewire.nix
    ./dbus.nix
    ./gnome-keyring.nix
    ./fonts.nix
    ./sddm.nix
  ];

  environment.systemPackages = with pkgs; [
    wayland
    wl-clipboard-rs
  ];

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
    # Gecko 153+ on legacy-580 NVIDIA: native Wayland-EGL path renders text
    # invisible (glyphs never paint). Force Gecko apps onto XWayland.
    # Convicted 2026-07-27 by bisection + with-env test; only affects
    # firefox/librewolf/thunderbird. Retest on gecko or nvidia-legacy bumps.
    MOZ_ENABLE_WAYLAND = "0";
  };
}
