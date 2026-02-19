{ lib, ... }:

{
  services.journald.extraConfig = ''
    SystemMaxUse=50M
    SystemMaxFiles=5'';
  services.journald.rateLimitBurst = 500;
  services.journald.rateLimitInterval = "30s";

  systemd.services.systemd-suspend.environment.SYSTEMD_SLEEP_FREEZE_USER_SESSIONS =
    "false";
  systemd.services."pre-sleep".wantedBy = lib.mkForce [ ];
}
