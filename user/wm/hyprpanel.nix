{ config, inputs, pkgs, systemSettings, userSettings, ... }: {
  programs.hyprpanel.enable = true;

  programs.hyprpanel = {
    # Configure and theme almost all options from the GUI.
    # See 'https://hyprpanel.com/configuration/settings.html'.
    # Default: <same as gui>
    settings = {

      # Configure bar layouts for monitors.
      # See 'https://hyprpanel.com/configuration/panel.html'.
      # Default: null

      bar.layouts = {
        "*" = {
          left = [ "dashboard" "ram" "cpu" "cputemp" "storage" "netstat" ];
          middle = [ "workspaces" "windowtitle" ];
          right = [
            "microphone"
            "volume"
            "network"
            "bluetooth"
            # "systray"
            "kbinput"
            "clock"
            "updates"
            "notifications"
          ];
        };
      };

      bar.launcher.autoDetectIcon = true;
      bar.workspaces.show_icons = true;

      menus.clock = {
        time = {
          military = true;
          hideSeconds = true;
        };
        weather.unit = "metric";
      };

      menus.dashboard.directories.enabled = false;
      menus.dashboard.stats.enable_gpu = false;

      theme.bar.transparent = true;

      theme.font = {
        name = userSettings.font;
        size = "16px";
      };
    };
  };
}
