{
  pkgs,
  config,
  userSettings,
  ...
}:
with config.lib.stylix.colors; {
  programs.waybar.enable = true;
  programs.waybar.package = pkgs.waybar.overrideAttrs (oldAttrs: {
    postPatch = ''
      # use hyprctl to switch workspaces
      sed -i 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch focusworkspaceoncurrentmonitor " + std::to_string(id());\n\tsystem(command.c_str());/g' src/modules/wlr/workspace_manager.cpp
      sed -i 's/gIPC->getSocket1Reply("dispatch workspace " + std::to_string(id()));/gIPC->getSocket1Reply("dispatch focusworkspaceoncurrentmonitor " + std::to_string(id()));/g' src/modules/hyprland/workspaces.cpp
    '';
  });
  programs.waybar.settings.mainBar = {
    layer = "top";
    position = "top";
    height = 35;
    margin = "7 7 3 7";
    spacing = 2;
    modules-left = ["custom/os" "custom/hyprprofile" "pulseaudio" "cpu" "memory"];
    modules-center = ["hyprland/workspaces"];
    modules-right = ["idle_inhibitor" "clock"];
    "custom/os" = {
      "format" = " {} ";
      "exec" = ''echo "" '';
      "interval" = "once";
      "on-click" = "nwggrid-wrapper";
    };
    "custom/hyprprofile" = {
      "format" = "   {}";
      "exec" = ''cat ~/.hyprprofile'';
      "interval" = 3;
      "on-click" = "hyprprofile-dmenu";
    };
    "keyboard-state" = {
      "numlock" = true;
      "format" = " {icon} ";
      "format-icons" = {
        "locked" = "󰎠";
        "unlocked" = "󱧓";
      };
    };
    "hyprland/workspaces" = {
      "format" = "{icon}";
      "format-icons" = {
        "1" = "󱚌";
        "2" = "󰖟";
        "3" = "";
        "4" = "󰎄";
        "5" = "󰋩";
        "6" = "";
        "7" = "󰄖";
        "8" = "󰑴";
        "9" = "󱎓";
        "scratch_term" = "_";
        "scratch_ranger" = "_󰴉";
        "scratch_musikcube" = "_";
        "scratch_btm" = "_";
        "scratch_pavucontrol" = "_󰍰";
      };
      "on-click" = "activate";
      "on-scroll-up" = "hyprctl dispatch workspace e+1";
      "on-scroll-down" = "hyprctl dispatch workspace e-1";
      #"all-outputs" = true;
      #"active-only" = true;
      "ignore-workspaces" = ["scratch" "-"];
      #"show-special" = false;
      #"persistent-workspaces" = {
      #    # this block doesn't seem to work for whatever reason
      #    "eDP-1" = [1 2 3 4 5 6 7 8 9];
      #    "DP-1" = [1 2 3 4 5 6 7 8 9];
      #    "HDMI-A-1" = [1 2 3 4 5 6 7 8 9];
      #    "1" = ["eDP-1" "DP-1" "HDMI-A-1"];
      #    "2" = ["eDP-1" "DP-1" "HDMI-A-1"];
      #    "3" = ["eDP-1" "DP-1" "HDMI-A-1"];
      #    "4" = ["eDP-1" "DP-1" "HDMI-A-1"];
      #    "5" = ["eDP-1" "DP-1" "HDMI-A-1"];
      #    "6" = ["eDP-1" "DP-1" "HDMI-A-1"];
      #    "7" = ["eDP-1" "DP-1" "HDMI-A-1"];
      #    "8" = ["eDP-1" "DP-1" "HDMI-A-1"];
      #    "9" = ["eDP-1" "DP-1" "HDMI-A-1"];
      #};
    };
    "idle_inhibitor" = {
      format = "{icon}";
      format-icons = {
        activated = "󰅶";
        deactivated = "󰾪";
      };
    };
    clock = {
      "interval" = 1;
      "format" = "{:%a %Y-%m-%d %I:%M:%S %p}";
      "timezone" = "America/Chicago";
      "tooltip-format" = ''
        <big>{:%Y %B}</big>
        <tt><small>{calendar}</small></tt>'';
    };
    cpu = {
      "format" = "{usage}% ";
    };
    memory = {"format" = "{}% ";};
    pulseaudio = {
      "scroll-step" = 1;
      "format" = "{volume}% {icon}  {format_source}";
      "format-bluetooth" = "{volume}% {icon}  {format_source}";
      "format-bluetooth-muted" = "󰸈 {icon}  {format_source}";
      "format-muted" = "󰸈 {format_source}";
      "format-source" = "{volume}% ";
      "format-source-muted" = " ";
      "format-icons" = {
        "headphone" = "";
        "hands-free" = "";
        "headset" = "";
        "phone" = "";
        "portable" = "";
        "car" = "";
        "default" = ["" "" ""];
      };
      "on-click" = "pypr toggle pavucontrol && hyprctl dispatch bringactivetotop";
    };
  };
  programs.waybar.style =
    ''
      * {
          /* `otf-font-awesome` is required to be installed for icons */
          font-family: FontAwesome, ''
    + userSettings.font
    + ''      ;
              font-size: 20px;
          }
          window#waybar {
              background-color: rgba(30, 30, 46, 0.55);
              border-radius: 8px;
              color: #${base07};
              transition-property: background-color;
              transition-duration: .2s;
          }
          tooltip {
            color: #${base07};
            background-color: rgba(30, 30, 46,  0.9);
            border-style: solid;
            border-width: 3px;
            border-radius: 8px;
            border-color: #${base08};
          }
          tooltip * {
            color: #${base07};
            background-color: rgba(30, 30, 46, 0.0);
          }
          window > box {
              border-radius: 8px;
              opacity: 0.94;
          }
          window#waybar.hidden {
              opacity: 0.2;
          }
          button {
              border: none;
          }
          #custom-hyprprofile {
              color: #${base0D};
          }
          /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
          button:hover {
              background: inherit;
          }
          #workspaces button {
              padding: 2px 7px 4px;
              background-color: transparent;
              color: #${base05};
          }
          #workspaces button:hover {
              color: #${base07};
          }
          #workspaces button.active {
              color: #${base06};
          }
          #workspaces button.focused {
              color: #${base0A};
          }
          #workspaces button.visible {
              color: #${base0E};
          }
          #workspaces button.urgent {
              color: #${base09};
          }
          #clock,
          #battery,
          #cpu,
          #memory,
          #disk,
          #temperature,
          #backlight,
          #network,
          #pulseaudio,
          #wireplumber,
          #custom-media,
          #tray,
          #mode,
          #idle_inhibitor,
          #scratchpad,
          #mpd {
              padding: 6px 10px;
      	margin: 2px 4px 4px;
              color: #${base07};
              border: none;
              border-radius: 8px;
              background-color: transparent;
          }
          #window,
          #workspaces {
              margin: 2px 4px 2px;
          }
          /* If workspaces is the leftmost module, omit left margin */
          .modules-left > widget:first-child > #workspaces {
              margin-left: 0;
          }
          /* If workspaces is the rightmost module, omit right margin */
          .modules-right > widget:last-child > #workspaces {
              margin-right: 0;
          }
          #clock {
              color: #${base0D};
          }
          #battery {
              color: #${base0B};
          }
          #battery.charging, #battery.plugged {
              color: #${base0C};
          }
          @keyframes blink {
              to {
                  background-color: #${base07};
                  color: #${base00};
              }
          }
          #battery.critical:not(.charging) {
              background-color: #${base08};
              color: #${base07};
              animation-name: blink;
              animation-duration: 0.5s;
              animation-timing-function: linear;
              animation-iteration-count: infinite;
              animation-direction: alternate;
          }
          label:focus {
              background-color: #${base00};
          }
          #cpu {
              color: #${base0D};
          }
          #memory {
              color: #${base0E};
          }
          #disk {
              color: #${base0F};
          }
          #backlight {
              color: #${base0A};
          }
          label.numlock {
              color: #${base04};
          }
          label.numlock.locked {
              color: #${base0F};
          }
          #pulseaudio {
              color: #${base0C};
          }
          #pulseaudio.muted {
              color: #${base04};
          }
          #tray > .passive {
              -gtk-icon-effect: dim;
          }
          #tray > .needs-attention {
              -gtk-icon-effect: highlight;
          }
          #idle_inhibitor {
              color: #${base04};
          }
          #idle_inhibitor.activated {
              color: #${base0F};
          }
    '';
}
