{ ... }: {
  programs.librewolf = {
    enable = true;
    profiles = {
      ilia = {
        isDefault = true;
        settings."gfx.webrender.software" = true;
      };
      xpression = {
        id = 1;
        settings."gfx.webrender.software" = true;
      };
      accounts-domus = {
        id = 2;
        settings."gfx.webrender.software" = true;
        # settings."privacy.clearOnShutdown.cookies" = false;  # uncomment if MFA-every-restart gets old
      };
      domusnetwork = {
        settings."gfx.webrender.software" = true;
        id = 3;
      };
    };
  };
}
