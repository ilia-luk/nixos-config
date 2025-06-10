{pkgs, ...}: {
  home.packages = with pkgs; [
    atuin
  ];

  programs.atuin.enable = true;
  programs.atuin.enableNushellIntegration = true;
}
