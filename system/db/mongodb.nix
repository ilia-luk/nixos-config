{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    mongodb
    robo3t
    mongodb-compass
  ];

  services.mongodb.enable = true;
}
