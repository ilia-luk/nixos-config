{ ... }: {
  programs.librewolf = {
    enable = true;
    profiles = {
      ilia = {
        isDefault = true;
      };
      xpression = {
        id = 1;
      };
      accounts-domus = {
        id = 2;
        # settings."privacy.clearOnShutdown.cookies" = false;  # uncomment if MFA-every-restart gets old
      };
      domusnetwork = {
        id = 3;
      };
    };
  };
}
