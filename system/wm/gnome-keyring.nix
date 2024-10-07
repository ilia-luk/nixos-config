{ ... }:

{
  services.gnome = {
    gnome-keyring.enable = true;
  };

  # Security
  security = {
    pam.services.login.enableGnomeKeyring = true;
  };
}
