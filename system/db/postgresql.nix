{pkgs, userSettings, ...}: {
  environment.systemPackages = with pkgs; [
    postgresql
    pgadmin
  ];

  services.postgresql = {
    enable = true;
    port = 15432;
    ensureUsers = [
      {
        name = "lamp";
        ensurePermissions = {
          "DATABASE lamp" = "ALL PRIVILEGES";
        };
      }
    ];
    ensureDatabases = [
      "lamp"
    ];
  };

  services.pgadmin = {
    enable = true;
    initialEmail = userSettings.email; 
    initialPasswordFile = pkgs.writeText "pgadminPW" ''
      admin
    '';
  };
}
