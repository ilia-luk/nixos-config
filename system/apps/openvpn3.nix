{
  config,
  userSettings,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    openvpn3
  ];

  programs.openvpn3.enable = true;

  programs.zsh.shellAliases = {
    vpn-up = "openvpn3 session-start --config ~/Downloads/ilia_client.ovpn && openvpn3 session-auth";
  };
}
