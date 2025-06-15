{ config, pkgs, lib, ... }:

{
  # Allow unfree software per-package
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced"
    ];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power managgement.
    # enable this if yyou have graphical corruption issues or application crashes after waking
    # up from sleep.
    powerManagement.enable = true;

    # Fine-grained power management.
    powerManagement.finegrained = false;

    # Use Nvidia open source kerenel module.
    open = false;

    # Enable the Nvidia settings menu, accessible via `nvidia-settings`.
    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  # This fixes a bug in the kernel for nvidia drivers introducting unknown device
  # that upon changing hyprland workspace 2 crashes the system because it switches
  # to the unknown device.
  boot.kernelParams = [
    "loglevel=4"
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
    "nvidia.NVreg_OpenRmEnableUnsupportedGpus=1"
  ];
}
