{
  config,
  userSettings,
  pkgs,
  ...
}: {
  # This doesn't seem to work, should wait for proper package.
  environment.systemPackages = with pkgs; [
    wireguard-tools
    openresolv
    wgnord
  ];

  networking.firewall.checkReversePath = false;
}
