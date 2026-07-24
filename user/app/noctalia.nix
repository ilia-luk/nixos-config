{ inputs, ... }: {
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia.enable = true;
  programs.noctalia.systemd.enable = true;

  programs.noctalia.settings = {
    accessibility.ui_scale = 1.3;

    audio.enable_sounds = true;

    bar.default = {
      background_opacity = 0.85;
      border = "shadow";
      capsule_opacity = 0.9;
      capsule_padding = 12.0;
      capsule_thickness = 0.75;
      start = [
        "control-center"
        "screenshot"
        "spacer_2"
        "cpu"
        "temp"
        "ram"
        "network_rx"
        "network_tx"
      ];
      center = [
        "launcher"
        "privacy"
        "workspaces"
      ];
      end = [
        "tray"
        "notifications"
        "clipboard"
        "network"
        "bluetooth"
        "volume"
        "keyboard_layout"
        "clock"
        "session"
      ];
      font_weight = 400;
      margin_ends = 600;
      margin_opposite_edge = 4;
      padding = 16;
      scale = 1.3;
      shadow = false;
      thickness = 36;
      widget_spacing = 12;
    };

    control_center.width = 1200;

    nightlight.enabled = true;

    notification.offset_x = 16;

    shell = {
      launch_apps_as_systemd_services = true;
      app_icon_color = "secondary";
      avatar_path = "/home/ilia/Media/Pictures/profile.jpg";
      external_ip_enabled = true;
      font_family = "Ubuntu";
      screen_time_enabled = true;
      animation.speed = 0.65;
      panel = {
        clipboard_placement = "attached";
        list_item_background = true;
        polkit_placement = "attached";
        transparency_mode = "soft";
      };
      screenshot = {
        confirm_region = true;
        show_cursor = true;
      };
    };

    theme = {
      mode = "dark";
      source = "builtin";
      builtin = "Catppuccin";
      community_palette = "Catppuccin Macchiato Mauve";
      wallpaper_scheme = "m3-content";
      templates = {
        enable_builtin_templates = false;
        enable_community_templates = false;
      };
    };

    wallpaper.enabled = false;

    weather.refresh_minutes = 60;

    widget = {
      battery.enabled = false;
      bluetooth.capsule = true;
      brightness.enabled = false;
      clipboard.capsule = true;
      clock = {
        color = "tertiary";
        format = "{:%a %d %b - %H:%M}";
        interactive = false;
      };
      "control-center" = {
        capsule = true;
        color = "tertiary";
        glyph = "snowflake";
      };
      cpu.interactive = false;
      keyboard_layout.capsule = true;
      launcher.capsule = true;
      media.enabled = false;
      network = {
        capsule = true;
        show_label = false;
        vpn_status = "both";
      };
      network_rx.interactive = false;
      network_tx.interactive = false;
      notifications.capsule = true;
      privacy.interactive = false;
      ram.interactive = false;
      screenshot.capsule = true;
      session = {
        capsule = true;
        color = "error";
      };
      spacer_2.type = "spacer";
      temp.interactive = false;
      tray.capsule = true;
      volume.capsule = true;
      wallpaper.enabled = false;
      workspaces.capsule = true;
    };
  };
}
