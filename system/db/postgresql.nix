{ pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [
    postgresql_17
    unstable.dbeaver-bin
  ];

  services.postgresql = {
    enable = true;
    settings = {
      port = 5454;
      log_connections = true;
      log_statement = "all";
      logging_collector = true;
      log_disconnections = true;
      log_destination = lib.mkForce "syslog";
    };
    extensions = with pkgs.postgresql_17.pkgs; [ pgvector ];
    package = pkgs.postgresql_17;
    ensureUsers = [
      {
        name = "admin";
        ensureDBOwnership = true;
        ensureClauses = {
          superuser = true;
          createrole = true;
          createdb = true;
        };
      }
      {
        name = "postgres";
        ensureDBOwnership = true;
        ensureClauses = {
          superuser = true;
          createrole = true;
          createdb = true;
        };
      }
    ];
    ensureDatabases = [
      "mydatabase"
      "admin"
      "postgres"
    ];
    enableTCPIP = true;
    # trust auth deliberate: local dev only, mock data by definition.
    # Threat model accepted: any local process can reach these DBs;
    # the user account/session is the actual security perimeter here.
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
}
