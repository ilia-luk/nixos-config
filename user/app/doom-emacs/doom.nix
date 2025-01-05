 {
  inputs,
  ...
}: {
  programs.doom-emacs = {
    enable = true;
    doomDir = ./doomdir;  # or e.g. `./doom.d` for a local configuration
  };

  services.emacs.enable = true;
}

