{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    openvpn
  ];

  services.openvpn.servers = {
    ehouseVPN  = { config = '' config ~/Downloads/ilia_client.ovpn ''; };
  };

  environment.etc.openvpn.source = "${pkgs.update-resolv-conf}/libexec/openvpn";
}
