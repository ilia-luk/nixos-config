{ inputs, config, lib, pkgs, userSettings, systemSettings, ... }: {
  imports = [
    ../app/kitty.nix
    # (import ../../app/dmenu-scripts/networkmanager-dmenu.nix {
    #   dmenu_command = "fuzzel -d"; inherit config lib pkgs;
    # })
    # ../input/nihongo.nix
  ];
  gtk.cursorTheme = {
    package = pkgs.quintom-cursor-theme;
    name = if (config.stylix.polarity == "light") then
      "Quintom_Ink"
    else
      "Quintom_Snow";
    size = 36;
  };

  # This is an example Hyprland config file.
  # Refer to the wiki for more information.
  # https://wiki.hyprland.org/Configuring/Configuring-Hyprland/

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland = { enable = true; };
    systemd = {
      enable = true;
      variables = [ "--all" ];
    };
    package = null;
    portalPackage = null;
    extraConfig = ''
      ################
      ### MONITORS ###
      ################

      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor=DP-1,3840x1600@60,0x0,1.0
      workspace=1, monitor:DP-1
      workspace=2, monitor:DP-1
      workspace=3, monitor:DP-1
      workspace=4, monitor:DP-1
      workspace=5, monitor:DP-1
      workspace=6, monitor:DP-1
      workspace=7, monitor:DP-1
      workspace=8, monitor:DP-1
      workspace=9, monitor:DP-1


      ###################
      ### MY PROGRAMS ###
      ###################

      # See https://wiki.hyprland.org/Configuring/Keywords/

      # Set programs that you use
      $terminal = kitty
      $fileManager = kitty yazi
      $menu = fuzzel


      #################
      ### AUTOSTART ###
      #################

      # Autostart necessary processes (like notifications daemons, status bars, etc.)
      # Or execute your favorite apps at launch like this:

      exec-once = nm-applet -- indicator
      exec-once = waybar
      # exec-once = hyprpaper


      #############################
      ### ENVIRONMENT VARIABLES ###
      #############################

      # See https://wiki.hyprland.org/Configuring/Environment-variables/

      env = XCURSOR_SIZE,24
      env = HYPRCURSOR_SIZE,24

      # nvidia patch
      env = LIBVA_DRIVER_NAME,nvidia
      env = XDG_SESSION_TYPE,wayland
      env = GBM_BACKEND,nvidia-drm
      env = __GLX_VENDOR_LIBRARY_NAME,nvidia


      #####################
      ### LOOK AND FEEL ###
      #####################

      # Refer to https://wiki.hyprland.org/Configuring/Variables/

      # https://wiki.hyprland.org/Configuring/Variables/#general
      general { 
        gaps_in = 6
        gaps_out = 12

        border_size = 2

        # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
        col.active_border = 0xff'' + config.lib.stylix.colors.base08 + " "
      + "0xff" + config.lib.stylix.colors.base09 + " " + "0xff"
      + config.lib.stylix.colors.base0A + " " + "0xff"
      + config.lib.stylix.colors.base0B + " " + "0xff"
      + config.lib.stylix.colors.base0C + " " + "0xff"
      + config.lib.stylix.colors.base0D + " " + "0xff"
      + config.lib.stylix.colors.base0E + " " + "0xff"
      + config.lib.stylix.colors.base0F + " " + ''
        270deg
                col.inactive_border = 0xaa'' + config.lib.stylix.colors.base02
      + ''

          # Set to true enable resizing windows by clicking and dragging on borders and gaps
          resize_on_border = false 

          # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
          allow_tearing = false

          layout = dwindle
        }

        # https://wiki.hyprland.org/Configuring/Variables/#decoration
        decoration {
          rounding = 8

          # Change transparency of focused and unfocused windows
          active_opacity = 1.0
          inactive_opacity = 1.0

          # drop_shadow = true
          # shadow_range = 4
          # shadow_render_power = 3
          # col.shadow = rgba(1a1a1aee)

          # https://wiki.hyprland.org/Configuring/Variables/#blur
          blur {
            enabled = true
            size = 5
            passes = 2
            ignore_opacity = true
            contrast = 1.17
            vibrancy = 0.1696
            brightness = ''
      + (if (config.stylix.polarity == "dark") then "0.8" else "1.25") + ''
            xray = true
          }
        }

        # https://wiki.hyprland.org/Configuring/Variables/#animations
        animations {
          enabled = true

          # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
          bezier = wind, 0.05, 0.9, 0.1, 1.05
          bezier = winIn, 0.1, 1.1, 0.1, 1.0
          bezier = winOut, 0.3, -0.3, 0, 1
          bezier = liner, 1, 1, 1, 1
          bezier = linear, 0.0, 0.0, 1.0, 1.0

          animation = windowsIn, 1, 6, winIn, popin
          animation = windowsOut, 1, 5, winOut, popin
          animation = windowsMove, 1, 5, wind, slide
          animation = border, 1, 10, default
          animation = borderangle, 1, 100, linear, loop
          animation = fade, 1, 10, default
          animation = workspaces, 1, 5, wind
          animation = windows, 1, 6, wind, slide
        }

        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        dwindle {
          pseudotile = true # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true # You probably want this
        }

        # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
        master {
          new_status = master
        }

        # https://wiki.hyprland.org/Configuring/Variables/#misc
        misc {
          # force_default_wallpaper = -1 # Set to 0 or 1 to disable the anime mascot wallpapers
          # disable_hyprland_logo = false # If true disables the random hyprland logo / anime girl background. :(

          force_default_wallpaper = 0
          disable_hyprland_logo = true
          mouse_move_enables_dpms = true
        }


        #############
        ### INPUT ###
        #############

        # https://wiki.hyprland.org/Configuring/Variables/#input
        input {
          kb_layout = us,il
          kb_variant =
          kb_model =
          kb_options = grp:alt_space_toggle
          kb_rules =

          repeat_delay = 350
          repeat_rate = 50
          accel_profile = adaptive
          follow_mouse = 2
          float_switch_override_focus = 0

          follow_mouse = 1

          sensitivity = 0 # -1.0 - 1.0, 0 means no modification.

          touchpad {
            natural_scroll = false
          }
        }

        # https://wiki.hyprland.org/Configuring/Variables/#gestures
        gestures {
          workspace_swipe = false
        }

        # Example per-device config
        # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
        device {
          name = epic-mouse-v1
          sensitivity = -0.5
        }


        ####################
        ### KEYBINDINGSS ###
        ####################

        # See https://wiki.hyprland.org/Configuring/Keywords/
        $mainMod = SUPER # Sets "Windows" key as main modifier

        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        bind = $mainMod, Q, exec, $terminal
        bind = $mainMod, C, killactive,
        bind = $mainMod, M, exit,
        bind = $mainMod, E, exec, $fileManager
        bind = $mainMod, V, togglefloating,
        bind = $mainMod, R, exec, $menu
        bind = $mainMod, P, pseudo, # dwindle
        bind = $mainMod, J, togglesplit, # dwindle

        # Move focus with mainMod + arrow keys
        bind = $mainMod, left, movefocus, l
        bind = $mainMod, right, movefocus, r
        bind = $mainMod, up, movefocus, u
        bind = $mainMod, down, movefocus, d

        # Switch workspaces with mainMod + [0-9]
        bind = $mainMod, 1, workspace, 1
        bind = $mainMod, 2, workspace, 2
        bind = $mainMod, 3, workspace, 3
        bind = $mainMod, 4, workspace, 4
        bind = $mainMod, 5, workspace, 5
        bind = $mainMod, 6, workspace, 6
        bind = $mainMod, 7, workspace, 7
        bind = $mainMod, 8, workspace, 8
        bind = $mainMod, 9, workspace, 9
        bind = $mainMod, 0, workspace, 10

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        bind = $mainMod SHIFT, 1, movetoworkspace, 1
        bind = $mainMod SHIFT, 2, movetoworkspace, 2
        bind = $mainMod SHIFT, 3, movetoworkspace, 3
        bind = $mainMod SHIFT, 4, movetoworkspace, 4
        bind = $mainMod SHIFT, 5, movetoworkspace, 5
        bind = $mainMod SHIFT, 6, movetoworkspace, 6
        bind = $mainMod SHIFT, 7, movetoworkspace, 7
        bind = $mainMod SHIFT, 8, movetoworkspace, 8
        bind = $mainMod SHIFT, 9, movetoworkspace, 9
        bind = $mainMod SHIFT, 0, movetoworkspace, 10

        # Example special workspace (scratchpad)
        bind = $mainMod, S, togglespecialworkspace, magic
        bind = $mainMod SHIFT, S, movetoworkspace, special:magic

        # Scroll through existing workspaces with mainMod + scroll
        bind = $mainMod, mouse_down, workspace, e+1
        bind = $mainMod, mouse_up, workspace, e-1

        # Move/resize windows with mainMod + LMB/RMB and dragging
        bindm = $mainMod, mouse:272, movewindow
        bindm = $mainMod, mouse:273, resizewindow


        ##############################
        ### WINDOWS AND WORKSPACES ###
        ##############################

        # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
        # See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules

        # Example windowrule v1
        # windowrule = float, ^(kitty)$

        # Example windowrule v2
        # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$

        windowrulev2 = suppressevent maximize, class:.* # You'll probably like this.

        cursor {
          no_hardware_cursors = true
          no_warps = false
          inactive_timeout = 30
        }
      '';
  };
}
# START OF LIBRE CONFIG:
#       exec-once = dbus-update-activation-environment DISPLAY XAUTHORITY WAYLAND_DISPLAY
#       exec-once = hyprctl setcursor '' + config.gtk.cursorTheme.name + " " + builtins.toString config.gtk.cursorTheme.size + ''
#
#       env = XDG_CURRENT_DESKTOP,Hyprland
#       env = XDG_SESSION_TYPE,wayland
#       env = XDG_SESSION_DESKTOP,Hyprland
#       env = WLR_DRM_DEVICES,/dev/dri/card2:/dev/dri/card1
#       env = GDK_BACKEND,wayland,x11,*
#       env = QT_QPA_PLATFORM,wayland;xcb
#       env = QT_QPA_PLATFORMTHEME,qt5ct
#       env = QT_AUTO_SCREEN_SCALE_FACTOR,1
#       env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
#       env = CLUTTER_BACKEND,wayland
#
#       exec-once = hyprprofile Default
#
#       exec-once = pypr
#       exec-once = ydotoold
#       #exec-once = STEAM_FRAME_FORCE_CLOSE=1 steam -silent
#       #exec-once = nm-applet
#       exec-once = blueman-applet
#       exec-once = GOMAXPROCS=1 syncthing --no-browser
#       exec-once = protonmail-bridge --noninteractive
#       exec-once = waybar
#
#       exec-once = hypridle
#       exec-once = sleep 5 && libinput-gestures
#       exec-once = obs-notification-mute-daemon
#
#       exec-once = hyprpaper
#
#
#        bind=SUPER,SPACE,fullscreen,1
#        bind=SUPERSHIFT,F,fullscreen,0
#        bind=SUPER,Y,workspaceopt,allfloat
#        bind=ALT,TAB,cyclenext
#        bind=ALT,TAB,bringactivetotop
#        bind=ALTSHIFT,TAB,cyclenext,prev
#        bind=ALTSHIFT,TAB,bringactivetotop
#        bind=SUPER,V,exec,wl-copy $(wl-paste | tr '\n' ' ')
#        bind=SUPERSHIFT,T,exec,screenshot-ocr
#        bind=CTRLALT,Delete,exec,hyprctl kill
#        bind=SUPERSHIFT,K,exec,hyprctl kill
#
#        bind = SUPER,R,pass,^(com\.obsproject\.Studio)$
#        bind = SUPERSHIFT,R,pass,^(com\.obsproject\.Studio)$
#
#        bind=SUPER,RETURN,exec,'' + userSettings.term + ''
#
#        bind=SUPER,A,exec,'' + userSettings.spawnEditor + ''
#
#        bind=SUPER,S,exec,'' + userSettings.browser + ''
#
#        bind=SUPERCTRL,S,exec,container-open # qutebrowser only
#
#        bind=SUPERCTRL,R,exec,phoenix refresh
#
#        bind=SUPER,code:47,exec,fuzzel
#        bind=SUPER,X,exec,fnottctl dismiss
#        bind=SUPERSHIFT,X,exec,fnottctl dismiss all
#        bind=SUPER,Q,killactive
#        bind=SUPERSHIFT,Q,exit
#        bindm=SUPER,mouse:272,movewindow
#        bindm=SUPER,mouse:273,resizewindow
#        bind=SUPER,T,togglefloating
#        bind=SUPER,G,exec,hyprctl dispatch focusworkspaceoncurrentmonitor 9; pegasus-fe;
#        bind=,code:148,exec,''+ userSettings.term + " "+''-e numbat
#
#        bind=,code:107,exec,grim -g "$(slurp)"
#        bind=SHIFT,code:107,exec,grim -g "$(slurp -o)"
#        bind=SUPER,code:107,exec,grim
#        bind=CTRL,code:107,exec,grim -g "$(slurp)" - | wl-copy
#        bind=SHIFTCTRL,code:107,exec,grim -g "$(slurp -o)" - | wl-copy
#        bind=SUPERCTRL,code:107,exec,grim - | wl-copy
#
#        bind=,code:122,exec,pamixer -d 10
#        bind=,code:123,exec,pamixer -i 10
#        bind=,code:121,exec,pamixer -t
#        bind=,code:256,exec,pamixer --default-source -t
#        bind=SHIFT,code:122,exec,pamixer --default-source -d 10
#        bind=SHIFT,code:123,exec,pamixer --default-source -i 10
#        bind=,code:232,exec,brightnessctl set 15-
#        bind=,code:233,exec,brightnessctl set +15
#        bind=,code:237,exec,brightnessctl --device='asus::kbd_backlight' set 1-
#        bind=,code:238,exec,brightnessctl --device='asus::kbd_backlight' set +1
#        bind=,code:255,exec,airplane-mode
#        bind=SUPER,C,exec,wl-copy $(hyprpicker)
#
#        bind=SUPERSHIFT,S,exec,systemctl suspend
#        bindl=,switch:on:Lid Switch,exec,loginctl lock-session
#        bind=SUPERCTRL,L,exec,loginctl lock-session
#
#        bind=SUPER,H,movefocus,l
#        bind=SUPER,J,movefocus,d
#        bind=SUPER,K,movefocus,u
#        bind=SUPER,L,movefocus,r
#
#        bind=SUPERSHIFT,H,movewindow,l
#        bind=SUPERSHIFT,J,movewindow,d
#        bind=SUPERSHIFT,K,movewindow,u
#        bind=SUPERSHIFT,L,movewindow,r
#
#        bind=SUPER,1,focusworkspaceoncurrentmonitor,1
#        bind=SUPER,2,focusworkspaceoncurrentmonitor,2
#        bind=SUPER,3,focusworkspaceoncurrentmonitor,3
#        bind=SUPER,4,focusworkspaceoncurrentmonitor,4
#        bind=SUPER,5,focusworkspaceoncurrentmonitor,5
#        bind=SUPER,6,focusworkspaceoncurrentmonitor,6
#        bind=SUPER,7,focusworkspaceoncurrentmonitor,7
#        bind=SUPER,8,focusworkspaceoncurrentmonitor,8
#        bind=SUPER,9,focusworkspaceoncurrentmonitor,9
#
#        bind=SUPERSHIFT,1,movetoworkspace,1
#        bind=SUPERSHIFT,2,movetoworkspace,2
#        bind=SUPERSHIFT,3,movetoworkspace,3
#        bind=SUPERSHIFT,4,movetoworkspace,4
#        bind=SUPERSHIFT,5,movetoworkspace,5
#        bind=SUPERSHIFT,6,movetoworkspace,6
#        bind=SUPERSHIFT,7,movetoworkspace,7
#        bind=SUPERSHIFT,8,movetoworkspace,8
#        bind=SUPERSHIFT,9,movetoworkspace,9
#
#        bind=SUPER,Z,exec,pypr toggle term && hyprctl dispatch bringactivetotop
#        bind=SUPER,F,exec,pypr toggle yazi && hyprctl dispatch bringactivetotop
#        bind=SUPER,N,exec,pypr toggle numbat && hyprctl dispatch bringactivetotop
#        bind=SUPER,M,exec,pypr toggle musikcube && hyprctl dispatch bringactivetotop
#        bind=SUPER,B,exec,pypr toggle btm && hyprctl dispatch bringactivetotop
#        bind=SUPER,code:172,exec,pypr toggle pavucontrol && hyprctl dispatch bringactivetotop
#        $scratchpadsize = size 80% 85%
#
#        $scratchpad = class:^(scratchpad)$
#        windowrulev2 = float,$scratchpad
#        windowrulev2 = $scratchpadsize,$scratchpad
#        windowrulev2 = workspace special silent,$scratchpad
#        windowrulev2 = center,$scratchpad
#
#        $savetodisk = title:^(Save to Disk)$
#        windowrulev2 = float,$savetodisk
#        windowrulev2 = size 70% 75%,$savetodisk
#        windowrulev2 = center,$savetodisk
#
#        $pavucontrol = class:^(pavucontrol)$
#        windowrulev2 = float,$pavucontrol
#        windowrulev2 = size 86% 40%,$pavucontrol
#        windowrulev2 = move 50% 6%,$pavucontrol
#        windowrulev2 = workspace special silent,$pavucontrol
#        windowrulev2 = opacity 0.80,$pavucontrol
#
#        $miniframe = title:\*Minibuf.*
#        windowrulev2 = float,$miniframe
#        windowrulev2 = size 64% 50%,$miniframe
#        windowrulev2 = move 18% 25%,$miniframe
#        windowrulev2 = animation popin 1 20,$miniframe
#
#        windowrulev2 = opacity 0.80,title:ORUI
#
#        windowrulev2 = opacity 1.0,class:^(org.qutebrowser.qutebrowser),fullscreen:1
#        windowrulev2 = opacity 0.85,title:^(My Local Dashboard Awesome Homepage - qutebrowser)$
#        windowrulev2 = opacity 0.85,title:\[.*\] - My Local Dashboard Awesome Homepage
#
#        layerrule = blur,waybar
#        layerrule = xray,waybar
#        blurls = waybar
#        layerrule = blur,launcher # fuzzel
#        blurls = launcher # fuzzel
#        layerrule = blur,gtk-layer-shell
#        layerrule = xray,gtk-layer-shell
#        blurls = gtk-layer-shell
#
#        bind=SUPER,code:21,exec,pypr zoom
#        bind=SUPER,code:21,exec,hyprctl reload
#
#        bind=SUPER,I,exec,networkmanager_dmenu
#        bind=SUPER,P,exec,keepmenu
#        bind=SUPERSHIFT,P,exec,hyprprofile-dmenu
#
#
#        xwayland {
#          force_zero_scaling = true
#        }
#
#        binds {
#          movefocus_cycles_fullscreen = false
#        }
#
#
#
# home.packages = (with pkgs; [
#    kitty
#    feh
#    killall
#    papirus-icon-theme
#    gsettings-desktop-schemas
#    gnome.zenity
#    wlr-randr
#    wtype
#    ydotool
#    wl-clipboard
#    hyprland-protocols
#    hyprpicker
#    hypridle
#    hyprpaper
#    fnott
#    fuzzel
#    keepmenu
#    pinentry-gnome3
#    wev
#    grim
#    slurp
#    xdg-utils
#    xdg-desktop-portal
#    xdg-desktop-portal-gtk
#    xdg-desktop-portal-hyprland
#    wlsunset
#    pavucontrol
#    pamixer
#    tesseract4
#    (pkgs.writeScriptBin "screenshot-ocr" ''
#      #!/bin/sh
#      imgname="/tmp/screenshot-ocr-$(date +%Y%m%d%H%M%S).png"
#      txtname="/tmp/screenshot-ocr-$(date +%Y%m%d%H%M%S)"
#      txtfname=$txtname.txt
#      grim -g "$(slurp)" $imgname;
#      tesseract $imgname $txtname;
#      wl-copy -n < $txtfname
#    '')
#    (pkgs.writeScriptBin "sct" ''
#      #!/bin/sh
#      killall wlsunset &> /dev/null;
#      if [ $# -eq 1 ]; then
#        temphigh=$(( $1 + 1 ))
#        templow=$1
#        wlsunset -t $templow -T $temphigh &> /dev/null &
#      else
#        killall wlsunset &> /dev/null;
#      fi
#    '')
#    ]);
#

