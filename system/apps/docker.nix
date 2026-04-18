{ pkgs, ... }: {
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  users.users.ilia.extraGroups = [ "docker" ];
}
