{ ... }:

{
  services.gnome = {
    gnome-keyring.enable = true;
    gcr-ssh-agent.enable = true;
  };

  # Security
  security.pam.services = {
    login.enableGnomeKeyring = true;
    hyprlock.enableGnomeKeyring = true;
  };
}
