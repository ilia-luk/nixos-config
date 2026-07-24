# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ config, pkgs, systemSettings, userSettings, ... }: {
  imports = [
    ../../system/hardware-configuration.nix
    ../../system/security/sops.nix
    ../../system/hardware/systemd.nix
    ../../system/hardware/time.nix
    ../../system/hardware/opengl.nix
    ../../system/hardware/bluetooth.nix
    ../../system/hardware/nvidia.nix
    ../../system/lang/node.nix
    ../../system/lang/python.nix
    ../../system/lang/rust.nix
    ../../system/lang/cc.nix
    ../../system/lang/go.nix
    ../../system/lang/haskell.nix
    ../../system/wm/hyprland.nix
    ../../system/security/firewall.nix
    # ../../system/security/openvpn.nix
    ../../system/style/stylix.nix
    ../../system/db/mongodb.nix
    ../../system/db/redis.nix
    ../../system/db/rabbitmq.nix
    ../../system/db/postgresql.nix
    ../../system/apps/docker.nix
    ../../system/apps/dropbox.nix
    ../../system/apps/wgnord.nix
    ../../system/apps/openvpn3.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = false;

  # Use latest kerenel
  boot.kernelPackages = pkgs.linuxPackages;

  # Define hostname
  networking.hostName = systemSettings.hostname;
  networking.networkmanager.enable = true;

  # Timezone and locale
  time.timeZone = systemSettings.timezone;
  i18n.defaultLocale = systemSettings.locale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = systemSettings.locale;
    LC_IDENTIFICATION = systemSettings.locale;
    LC_MEASUREMENT = systemSettings.locale;
    LC_MONETARY = systemSettings.locale;
    LC_NAME = systemSettings.locale;
    LC_NUMERIC = systemSettings.locale;
    LC_PAPER = systemSettings.locale;
    LC_TELEPHONE = systemSettings.locale;
    LC_TIME = systemSettings.locale;
  };

  # Decrypt user-password to /run/secrets-for-users/ so it can be used to create the user
  sops.secrets."${userSettings.username}-password".neededForUsers = true;
  users.mutableUsers =
    false; # Required for password to be set via sops during system activation!

  # User account
  users.users.${userSettings.username} = {
    isNormalUser = true;
    hashedPasswordFile =
      config.sops.secrets."${userSettings.username}-password".path;
    description = userSettings.name;
    extraGroups = [ "networkmanager" "wheel" "input" "dialout" ];
    packages = [ ];
    uid = 1000;
  };

  # Enable ssh
  programs.ssh = {
    startAgent = true;
    enableAskPassword = true;
    extraConfig = ''
      Host github
        AddKeysToAgent yes
        Hostname github.com
        IdentitiesOnly yes
        IdentityFile ~/.ssh/id_ed25519
    '';
  };

  # openssh.authorizedKeys.keys = [
  #   (builtins.readFile ./keys/id_ed25519.pub)
  #   (builtins.readFile ./keys/domusnetwork.pub)
  # ];

  # System packages
  environment.systemPackages = with pkgs; [
    nixfmt
    wget
    zsh
    nushell
    fish
    home-manager
    dig
    xh
    hyprshot
    gimp3
    inkscape
    diffnav
  ];

  # Enable zsh and nushell
  environment.shells = with pkgs; [ zsh nushell ];
  users.defaultUserShell = pkgs.nushell;

  # Enable nix-ld
  programs.nix-ld.enable = true;

  # Enable fontdir
  fonts.fontDir.enable = true;

  # Enable polkit
  security.polkit.enable = true;

  # Desktop portals
  xdg.portal.enable = true;

  # Limit boot to 5 generations of kernels
  boot.loader.systemd-boot.configurationLimit = 10;

  # Leave this unchanged for compatibility purposes
  system.stateVersion = "24.05";

  # Enable flakes
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    allowed-users = [ "@wheel" "ilia" ];
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys =
      [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys =
      [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };
}
