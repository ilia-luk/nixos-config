{ config, pkgs, userSettings, ... }: {
  home.packages = with pkgs; [ hyprlock ];

  programs.hyprlock.enable = true;

  programs.hyprlock.settings = {
    general = {
      disable_loading_bar = true;
      grace = 2;
      hide_cursor = true;
      no_fade_in = false;
      pam_module = "hyprlock";
      pam_enabled = true;
      forward_pass = true;
    };
    animations = { enabled = true; };
    background = [{
      path = "${config.stylix.image}";
      blur_passes = 3;
      blur_size = 8;
    }];
    input-field = [{
      size = "320, 36";
      position = "0, 300";
      monitor = "";
      dots_center = true;
      fade_on_empty = false;
      font_family = userSettings.font;
      font_color = "rgba(255, 255, 255, 0.9)";
      inner_color =
        "rgba(255, 255, 255, 0.1)"; # Semi-transparent white for glass effect
      outer_color = "rgba(255, 255, 255, 0.2)"; # Slightly more opaque border
      outline_thickness = 2;
      placeholder_text = ''<span foreground="##cad3f5">Password...</span>'';
      shadow_passes = 4; # More shadow passes for depth
      shadow_size = 8; # Shadow size for glow effect
      shadow_color = "rgba(0, 0, 0, 0.2)"; # Subtle shadow
      # Glossy/glass effect settings
      rounding = 8; # Rounded corners
      border_size = 1;
      border_color = "rgba(255, 255, 255, 0.9)"; # Bright border for highlight
      # Add authentication feedback
      check_color = "rgba(34, 204, 136, 0.8)"; # Semi-transparent green
      fail_color = "rgba(204, 34, 34, 0.8)"; # Semi-transparent red
      fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
      fail_transition = 300;
      # Additional glass effects
      capslock_color = "rgba(255, 193, 7, 0.8)"; # Caps lock indicator
      numlock_color = "rgba(108, 117, 125, 0.8)"; # Num lock indicator
      halign = "center";
      valign = "bottom";
    }];
    # Clock/Time display
    label = [
      {
        monitor = "";
        text = ''cmd[update:1000] echo "$(date +"%H:%M")"'';
        color = "rgb(24, 25, 38)";
        font_size = 55;
        font_family = userSettings.font;
        position = "0, -150";
        halign = "center";
        valign = "top";
      }
      {
        monitor = "";
        text = ''cmd[update:43200000] echo "$(date +"%A, %d %B %Y")"'';
        color = "rgb(24, 25, 38)";
        font_size = 25;
        font_family = userSettings.font;
        position = "0, -250";
        halign = "center";
        valign = "top";
      }
      {
        monitor = "";
        text = "You shall not pass!";
        color = "rgba(255, 255, 255, 0.8)";
        font_size = 14;
        font_family = userSettings.font;
        position = "0, 348";
        halign = "center";
        valign = "bottom";
      }
    ];
  };
}
