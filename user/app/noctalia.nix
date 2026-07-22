{ inputs, ... }: {
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia.enable = true;
  programs.noctalia.systemd.enable = true;

  programs.noctalia.settings = {
    shell = { launch_apps_as_systemd_services = true; };

    theme = {
      mode = "dark";
      source = "builtin";
      builtin = "Catppuccin";
    };

    wallpaper = {
      enabled = false;
      default.path = "/path/to/wallpapers/wallpaper.png";
    };
  };
}
