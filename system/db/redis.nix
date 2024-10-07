{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    redis
    redisinsight
  ];

  services.redis.servers."talos".enable = true;
  services.redis.servers."talos".port = 6379;
}
