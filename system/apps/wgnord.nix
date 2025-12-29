{ pkgs, userSettings, ... }:

let
  user = userSettings.username;

  iface = "wgnord";
  table = "51820";

  stateDir = "/run/wgnord-hyprpanel";
  countryFile = "${stateDir}/country"; # "th" | "il"

  sudoBin = "/run/wrappers/bin/sudo";

  fixWireguardPerms = ''
    if [ -f /etc/wireguard/wgnord.conf ]; then
      chmod 600 /etc/wireguard/wgnord.conf || true
    fi
  '';

  # ---------- STATUS (runs as user; polled by HyprPanel) ----------
  wgnordStatus = pkgs.writeShellScriptBin "wgnord-status" ''
    set -euo pipefail
    ip=${pkgs.iproute2}/bin/ip
    grep=${pkgs.gnugrep}/bin/grep

    connected=0
    if "$ip" link show ${iface} >/dev/null 2>&1; then
      if "$ip" -4 rule show 2>/dev/null | "$grep" -q "lookup ${table}"; then
        connected=1
      fi
    fi

    sel="off"
    if [ -r "${countryFile}" ]; then
      sel="$(cat "${countryFile}" | tr -d '\n' | tr '[:upper:]' '[:lower:]' || true)"
    fi

    if [ "$connected" = "1" ]; then
      case "$sel" in
        th) echo '{"alt":"th","country":"TH","status":"connected"}' ;;
        il) echo '{"alt":"il","country":"IL","status":"connected"}' ;;
        *)  echo '{"alt":"on","country":"ON","status":"connected"}' ;;
      esac
    else
      echo '{"alt":"off","country":"OFF","status":"disconnected"}'
    fi
  '';

  # ---------- ROOT COMMANDS (must run as root; will be invoked by sudo) ----------
  wgnordConnectTH = pkgs.writeShellScriptBin "wgnord-connect-th" ''
    set -euo pipefail
    if [ "$(id -u)" -ne 0 ]; then
      echo "must be run as root" >&2
      exit 1
    fi

    mkdir -p "${stateDir}"
    chmod 0755 "${stateDir}"

    ${pkgs.wgnord}/bin/wgnord d || true
    ${pkgs.wgnord}/bin/wgnord c thailand
    ${fixWireguardPerms}

    echo th > "${countryFile}"
    chmod 0644 "${countryFile}"
  '';

  wgnordConnectIL = pkgs.writeShellScriptBin "wgnord-connect-il" ''
    set -euo pipefail
    if [ "$(id -u)" -ne 0 ]; then
      echo "must be run as root" >&2
      exit 1
    fi

    mkdir -p "${stateDir}"
    chmod 0755 "${stateDir}"

    ${pkgs.wgnord}/bin/wgnord d || true
    ${pkgs.wgnord}/bin/wgnord c israel
    ${fixWireguardPerms}

    echo il > "${countryFile}"
    chmod 0644 "${countryFile}"
  '';

  wgnordDisconnect = pkgs.writeShellScriptBin "wgnord-disconnect" ''
    set -euo pipefail
    if [ "$(id -u)" -ne 0 ]; then
      echo "must be run as root" >&2
      exit 1
    fi

    ${pkgs.wgnord}/bin/wgnord d || true
    ${fixWireguardPerms}
    rm -f "${countryFile}" || true
  '';

  # ---------- ROOT TOGGLES ----------
  wgnordToggleTH = pkgs.writeShellScriptBin "wgnord-toggle-th" ''
    set -euo pipefail
    if [ "$(id -u)" -ne 0 ]; then
      echo "must be run as root" >&2
      exit 1
    fi

    connected=0
    if ${pkgs.iproute2}/bin/ip link show ${iface} >/dev/null 2>&1; then
      if ${pkgs.iproute2}/bin/ip -4 rule show 2>/dev/null | ${pkgs.gnugrep}/bin/grep -q "lookup ${table}"; then
        connected=1
      fi
    fi

    sel=""
    if [ -r "${countryFile}" ]; then
      sel="$(cat "${countryFile}" | tr -d '\n' | tr '[:upper:]' '[:lower:]' || true)"
    fi

    if [ "$connected" = "1" ] && [ "$sel" = "th" ]; then
      exec ${wgnordDisconnect}/bin/wgnord-disconnect
    else
      exec ${wgnordConnectTH}/bin/wgnord-connect-th
    fi
  '';

  wgnordToggleIL = pkgs.writeShellScriptBin "wgnord-toggle-il" ''
    set -euo pipefail
    if [ "$(id -u)" -ne 0 ]; then
      echo "must be run as root" >&2
      exit 1
    fi

    connected=0
    if ${pkgs.iproute2}/bin/ip link show ${iface} >/dev/null 2>&1; then
      if ${pkgs.iproute2}/bin/ip -4 rule show 2>/dev/null | ${pkgs.gnugrep}/bin/grep -q "lookup ${table}"; then
        connected=1
      fi
    fi

    sel=""
    if [ -r "${countryFile}" ]; then
      sel="$(cat "${countryFile}" | tr -d '\n' | tr '[:upper:]' '[:lower:]' || true)"
    fi

    if [ "$connected" = "1" ] && [ "$sel" = "il" ]; then
      exec ${wgnordDisconnect}/bin/wgnord-disconnect
    else
      exec ${wgnordConnectIL}/bin/wgnord-connect-il
    fi
  '';

  # ---------- USER ACTIONS (HyprPanel runs these) ----------
  # Use /run/wrappers/bin/sudo (setuid) — NOT the /nix/store sudo
  wgnordActionTH = pkgs.writeShellScriptBin "wgnord-action-th" ''
    set -euo pipefail
    exec ${sudoBin} -n ${wgnordToggleTH}/bin/wgnord-toggle-th
  '';

  wgnordActionIL = pkgs.writeShellScriptBin "wgnord-action-il" ''
    set -euo pipefail
    exec ${sudoBin} -n ${wgnordToggleIL}/bin/wgnord-toggle-il
  '';

  wgnordActionDisc = pkgs.writeShellScriptBin "wgnord-action-disconnect" ''
    set -euo pipefail
    exec ${sudoBin} -n ${wgnordDisconnect}/bin/wgnord-disconnect
  '';

  # ---------- HyprPanel module ----------
  modulesJson = pkgs.writeText "hyprpanel-modules.json" (builtins.toJSON {
    "custom/wgnord" = {
      icon = {
        off = "󰖂";
        on = "󰖂";
        th = "󰖂";
        il = "󰖂";
        default = "󰖂";
      };

      label = "VPN {country}";
      tooltip = "Left: toggle TH | Right: toggle IL | Middle: disconnect";
      truncationSize = -1;

      interval = 1000;
      execute = "${wgnordStatus}/bin/wgnord-status";

      actions = {
        onLeftClick = "${wgnordActionTH}/bin/wgnord-action-th";
        onRightClick = "${wgnordActionIL}/bin/wgnord-action-il";
        onMiddleClick = "${wgnordActionDisc}/bin/wgnord-action-disconnect";
      };
    };
  });

in {
  environment.systemPackages = with pkgs; [
    wgnord
    wireguard-tools
    openresolv
    iproute2
    gnugrep
    libnotify

    wgnordStatus
    wgnordConnectTH
    wgnordConnectIL
    wgnordDisconnect
    wgnordToggleTH
    wgnordToggleIL
    wgnordActionTH
    wgnordActionIL
    wgnordActionDisc
  ];

  networking.firewall.checkReversePath = false;

  systemd.tmpfiles.rules = [
    "d ${stateDir} 0755 root root - -"
    "z /etc/wireguard/wgnord.conf 0600 root root - -"

    "d /home/${user}/.config/hyprpanel 0755 ${user} ${user} - -"
    "L+ /home/${user}/.config/hyprpanel/modules.json - - - - ${modulesJson}"
  ];

  # Whitelist the store paths (you already see these in `sudo -l`)
  security.sudo.extraRules = [{
    users = [ user ];
    commands = [
      {
        command = "${wgnordToggleTH}/bin/wgnord-toggle-th";
        options = [ "NOPASSWD" ];
      }
      {
        command = "${wgnordToggleIL}/bin/wgnord-toggle-il";
        options = [ "NOPASSWD" ];
      }
      {
        command = "${wgnordDisconnect}/bin/wgnord-disconnect";
        options = [ "NOPASSWD" ];
      }
    ];
  }];
}
