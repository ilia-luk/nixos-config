{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ redis ];

  # no requirePass deliberate: local dev only, mock data — see note in postgresql.nix
  services.redis.servers."talos" = {
    enable = true;
    port = 6379;
    logLevel = "debug";
  };
}
