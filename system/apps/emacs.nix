{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    emacs
  ];

  services.emacs = {
    enable = true;
  };
}
