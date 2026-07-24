{ ... }:

{
  services.gnome = {
    gnome-keyring.enable = true;
    gcr-ssh-agent.enable = true;
  };

  # Security
  security.pam.services = {
    login.enableGnomeKeyring = true;
    hyprland.enableGnomeKeyring = true;
    passwd.enableGnomeKeyring = true;
    hyprlock.enableGnomeKeyring = true;
  };
}
