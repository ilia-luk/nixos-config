{ config, lib, pkgs, ... }:
let
  # Only Nord's public connection material is read at evaluation time.
  mkProfile = name: uuid: file:
    let
      text = builtins.readFile file;
      lines = lib.splitString "\n" text;
      directive = key: lib.removePrefix "${key} " (
        lib.findFirst (lib.hasPrefix "${key} ") (throw "Missing ${key} in ${toString file}") lines
      );
      remote = lib.splitString " " (directive "remote");
      inline = tag: builtins.head (lib.splitString "</${tag}>" (
        builtins.elemAt (lib.splitString "<${tag}>\n" text) 1
      ));
    in {
      connection = {
        id = "NordVPN - ${name}";
        inherit uuid;
        type = "vpn";
        autoconnect = false;
      };
      vpn = {
        service-type = "org.freedesktop.NetworkManager.openvpn";
        connection-type = "password";
        username = "$NORDVPN_USERNAME";
        password-flags = "0";
        remote = builtins.elemAt remote 0;
        port = builtins.elemAt remote 1;
        dev = "tun";
        proto-tcp = "no";
        remote-cert-tls = "server";
        verify-x509-name = "subject:${directive "verify-x509-name"}";
        tls-version-min = "1.2";
        reneg-seconds = "0";
        ca = toString (pkgs.writeText "nordvpn-${name}-ca.pem" (inline "ca"));
        tls-crypt = toString (pkgs.writeText "nordvpn-${name}-tls-crypt.pem" (inline "tls-crypt"));
      };
      vpn-secrets.password = "$NORDVPN_PASSWORD";
      ipv4 = {
        method = "auto";
        # Prefer VPN DNS exclusively while connected.
        dns-priority = -50;
        never-default = false;
      };
      ipv6.method = "disabled";
    };
  reloadUnit = "NetworkManager-ensure-profiles.service";
in {
  networking.networkmanager = {
    plugins = [ pkgs.networkmanager-openvpn ];
    ensureProfiles = {
      environmentFiles = [ config.sops.templates."nordvpn.env".path ];
      profiles = {
        nordvpn-israel = mkProfile "Israel" "a9c2e5f1-718a-4b8f-9e27-04c62ef45101"
          ../../misc/il100.nordvpn.com.udp_2.6.ovpn;
        nordvpn-thailand = mkProfile "Thailand" "a9c2e5f1-718a-4b8f-9e27-04c62ef45102"
          ../../misc/th56.nordvpn.com.udp_2.6.ovpn;
      };
    };
  };

  # Rendered by sops-nix at activation, never decrypted into the Nix store.
  sops.templates."nordvpn.env" = {
    mode = "0400";
    content = ''
      NORDVPN_USERNAME=${config.sops.placeholder.nordvpn-service-username}
      NORDVPN_PASSWORD=${config.sops.placeholder.nordvpn-service-password}
    '';
    restartUnits = [ reloadUnit ];
  };

  systemd.services.NetworkManager-ensure-profiles = {
    after = [ "sops-nix.service" ];
    requires = [ "NetworkManager.service" ];
  };
}
