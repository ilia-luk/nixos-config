{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ redis redisinsight ];

  services.redis.servers."talos" = {
    enable = true;
    port = 6379;
    logLevel = "debug";
  };
}
