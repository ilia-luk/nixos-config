{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    erlang
    rabbitmq-server
  ];

  services.rabbitmq.enable = true;
  services.rabbitmq.managementPlugin.enable = true;
}
