{ config, pkgs, userSettings, ... }:
with config.lib.stylix.colors; {
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
    background = [
      {
        path = "${config.stylix.image}";
        blur_passes = 3;
        blur_size = 8;
        color = "rgb(${base00})";
        zindex = -2;
      }
      {
        path = userSettings.lockOverlay;
        zindex = -1;
      }
    ];
    image = {
      monitor = "";
      path = userSettings.avatar;
      size = 100;
      border_size = 2;
      border_color = "rgb(${base05})";
      position = "0, 16";
      halign = "center";
      valign = "center";
    };
    input-field = [{
      monitor = "";
      size = "300, 60";
      position = "0, -110";
      outline_thickness = 10;
      dots_size = 0.2;
      dots_spacing = 0.2;
      dots_center = true;
      outer_color = "rgb(${base0E})";
      inner_color = "rgb(${base02})";
      font_color = "rgb(${base05})";
      fade_on_empty = false;
      placeholder_text = ''
        <span foreground="##${base05}"><i>󰌾 Logged in as </i><span foreground="##${base0E}">$USER</span></span>'';
      hide_input = false;
      check_color = "rgb(${base0E})";
      fail_color = "rgb(${base08})";
      fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
      capslock_color = "rgb(${base0A})";
      halign = "center";
      valign = "center";
    }];
    # Clock/Time display
    label = [
      {
        monitor = "";
        text = "Layout: $LAYOUT";
        color = "rgb(${base05})";
        font_size = 25;
        font_family = userSettings.font;
        position = "30, -30";
        halign = "left";
        valign = "top";
      }
      {
        monitor = "";
        text = ''cmd[update:1000] echo "$(date +"%H:%M")"'';
        color = "rgb(${base05})";
        font_size = 90;
        font_family = userSettings.font;
        position = "-30, 0";
        halign = "right";
        valign = "top";
      }
      {
        monitor = "";
        text = ''cmd[update:43200000] date +"%A, %d %B %Y"'';
        color = "rgb(${base05})";
        font_size = 25;
        font_family = userSettings.font;
        position = "-30, -150";
        halign = "right";
        valign = "top";
      }
      {
        monitor = "";
        text = "You shall not pass!";
        color = "rgb(${base05})";
        font_size = 14;
        font_family = userSettings.font;
        position = "0, -175";
        halign = "center";
        valign = "center";
      }
    ];
  };
}
