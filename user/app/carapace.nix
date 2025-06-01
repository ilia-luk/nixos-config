{pkgs, ...}: {
  home.packages = with pkgs; [
    carapace
  ];

  programs.carapace.enable = true;
  programs.carapace.enableNushellIntegration = true;
}
