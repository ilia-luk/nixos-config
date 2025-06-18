{ pkgs, lib, userSettings, ... }: {
  environment.systemPackages = with pkgs; [
    unstable.postgresql
    unstable.pgadmin
    unstable.dbeaver-bin
  ];

  services.postgresql = {
    enable = true;
    settings = {
      port = 5432;
      log_connections = true;
      log_statement = "all";
      logging_collector = true;
      log_disconnections = true;
      log_destination = lib.mkForce "syslog";
    };
    ensureUsers = [{
      name = "admin";
      ensureDBOwnership = true;
      ensureClauses = {
        superuser = true;
        createrole = true;
        createdb = true;
      };
    }];
    ensureDatabases = [ "mydatabase" "admin" ];
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      #...
      #type database DBuser origin-address auth-method
      local all       all     trust
      # ipv4
      host  all      all     127.0.0.1/32   trust
      # ipv6
      host all       all     ::1/128        trust
    '';
  };

  services.pgadmin = {
    enable = true;
    initialEmail = userSettings.email;
    initialPasswordFile = pkgs.writeText "pgadminPW" ''
      rootadmin
    '';
  };
}
