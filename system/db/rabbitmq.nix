{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    erlang
    rabbitmq-server
  ];

  services.rabbitmq = {
    enable = true;
    plugins = [
      "rabbitmq_tracing"
    ];
    managementPlugin.enable = true;
  };
}
