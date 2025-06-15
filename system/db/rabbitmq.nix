{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ erlang rabbitmq-server ];

  services.rabbitmq = {
    enable = false;
    plugins = [ "rabbitmq_tracing" ];
    managementPlugin.enable = true;
  };
}
