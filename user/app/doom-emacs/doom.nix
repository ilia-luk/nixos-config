 {
  inputs,
  ...
}: {
  programs.doom-emacs = {
    enable = true;
    doomDir = ./doom.d;  # or e.g. `./doom.d` for a local configuration
  };

  # services.emacs.enable = true;
}

