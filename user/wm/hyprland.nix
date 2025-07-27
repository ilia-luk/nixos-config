{ config, pkgs, ... }:
with config.lib.stylix.colors; {
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

  home.file.".config/hypr/mocha.conf".text = ''
    ################
    ## CATPPUCCIN ##
    ################

    $rosewater = rgb(${base06})
    $rosewaterAlpha = ${base06}

    $flamingo = rgb(${base0F})
    $flamingoAlpha = ${base0F}

    $pink = rgb(${base17})
    $pinkAlpha = ${base17}

    $mauve = rgb(${base0E})
    $mauveAlpha = ${base0E}

    $red = rgb(${base08})
    $redAlpha = ${base08}

    $maroon = rgb(${base12})
    $maroonAlpha = ${base12}

    $peach = rgb(${base09})
    $peachAlpha = ${base09}

    $yellow = rgb(${base0A})
    $yellowAlpha = ${base0A}

    $green = rgb(${base0B})
    $greenAlpha = ${base0B}

    $teal = rgb(${base0C})
    $tealAlpha = ${base0C}

    $sky = rgb(${base15})
    $skyAlpha = ${base15}

    $sapphire = rgb(${base16})
    $sapphireAlpha = ${base16}

    $blue = rgb(${base0D})
    $blueAlpha = ${base0D}

    $lavender = rgb(${base07})
    $lavenderAlpha = ${base07}

    $text = rgb(${base05})
    $textAlpha = ${base05}

    $subtext1 = rgb(${base06})
    $subtext1Alpha = ${base06}

    $subtext0 = rgb(${base18})
    $subtext0Alpha = ${base18}

    $overlay2 = rgb(${base24})
    $overlay2Alpha = ${base24}

    $overlay1 = rgb(${base23})
    $overlay1Alpha = ${base23}

    $overlay0 = rgb(${base22})
    $overlay0Alpha = ${base22}

    $surface2 = rgb(${base04})
    $surface2Alpha = ${base04}

    $surface1 = rgb(${base03})
    $surface1Alpha = ${base03}

    $surface0 = rgb(${base02})
    $surface0Alpha = ${base02}

    $base = rgb(${base00})
    $baseAlpha = ${base00}

    $mantle = rgb(${base10})
    $mantleAlpha = ${base10}

    $crust = rgb(${base11})
    $crustAlpha = ${base11}
  '';

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
      $passwordManager = 1password
      $mail = thunderbird
      $messenger = discord
      $browser = firefox


      #################
      ### AUTOSTART ###
      #################

      # Autostart necessary processes (like notifications daemons, status bars, etc.)
      # Or execute your favorite apps at launch like this:

      exec-once = nm-applet -- indicator
      exec-once = hypridle
      exec-once = hyprpanel
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
        col.active_border = 0xff'' + base08 + " " + "0xff" + base09 + " "
      + "0xff" + base0A + " " + "0xff" + base0B + " " + "0xff" + base0C + " "
      + "0xff" + base0D + " " + "0xff" + base0E + " " + "0xff" + base0F + " "
      + ''
        270deg

               col.inactive_border = 0xaa'' + base02 + ''

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

            shadow {
              enabled = true
              range = 4
              render_power = 3
              color = rgba(1a1a1aee)
            }
            
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
        bind = $mainMod, L, exec, hyprlock
        bind = $mainMod, T, exec, $terminal
        bind = $mainMod, Q, killactive,
        bind = $mainMod, M, exit,
        bind = $mainMod, E, exec, $fileManager
        bind = $mainMod, F, togglefloating,
        bind = $mainMod, R, exec, $menu
        bind = $mainMod, B, exec, $browser
        bind = $mainMod, P, pseudo, # dwindle
        bind = $mainMod, J, togglesplit, # dwindle

        # Hyprshot
        bind = $mainMod ALT, 2, exec, hyprshot -m output
        bind = $mainMod ALT, 3, exec, hyprshot -m window
        bind = $mainMod ALT, 4, exec, hyprshot -m region

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

        # change focus to another window and bring to top
        bind = $mainMod, Tab, cyclenext,
        bind = $mainMod, Tab, bringactivetotop,


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

