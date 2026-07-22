{ pkgs, config, ... }:
let
  zjstatus = pkgs.fetchurl {
    name = "zjstatus-v0.17.0-final-v5.wasm";
    url =
      "https://github.com/dj95/zjstatus/releases/download/v0.17.0/zjstatus.wasm";
    sha256 = "sha256-IgTfSl24Eap+0zhfiwTvmdVy/dryPxfEF7LhVNVXe+U=";
  };

  room = pkgs.fetchurl {
    name = "room-v1.1.0-final-v5.wasm";
    url = "https://github.com/rvcas/room/releases/download/v1.1.0/room.wasm";
    sha256 = "sha256-nYxZ1eOIkr1mFiAyWS9H/1i9jKnlRtORygMeyniS9QU=";
  };
in with config.lib.stylix.colors; {
  home.packages = [ pkgs.zellij ];

  # We enable the program but don't use the 'settings' or 'extraConfig' options
  programs.zellij.enable = true;

  # Manually write the config.kdl to avoid Home Manager translation errors
  xdg.configFile."zellij/config.kdl".text = ''
    theme "catppuccin"
    themes {
      catppuccin {
        fg "#${base05}"
        bg "#${base00}"
        black "#${base02}"
        red "#${base08}"
        green "#${base0B}"
        yellow "#${base0A}"
        blue "#${base0D}"
        magenta "#${base0E}"
        cyan "#${base0C}"
        white "#${base05}"
        orange "#${base09}"
      }
    }

    keybinds {
        shared_except "locked" {
           bind "Ctrl f" {
                LaunchOrFocusPlugin "file:${room}" {
                    floating true
                    ignore_case true
                    quick_jump true
                }
            }
        }
    }

    pane_frames true
    default_shell "nu"
    default_layout "default"
    copy_on_select true

    ui {
        pane_frames {
            rounded_corners true
        }
    }
  '';

  # Keep your existing Layout file definition for zjstatus
  xdg.configFile."zellij/layouts/default.kdl".text = ''
    layout {
        default_tab_template {
            children
            pane size=1 borderless=true {
                plugin location="file:${zjstatus}" {
                    color_rosewater "#f5e0dc"
                    color_flamingo "#f2cdcd"
                    color_pink "#f5c2e7"
                    color_mauve "#cba6f7"
                    color_red "#f38ba8"
                    color_maroon "#eba0ac"
                    color_peach "#fab387"
                    color_yellow "#f9e2af"
                    color_green "#a6e3a1"
                    color_teal "#94e2d5"
                    color_sky "#89dceb"
                    color_sapphire "#74c7ec"
                    color_blue "#89b4fa"
                    color_lavender "#b4befe"
                    color_text "#cdd6f4"
                    color_subtext1 "#bac2de"
                    color_subtext0 "#a6adc8"
                    color_overlay2 "#9399b2"
                    color_overlay1 "#7f849c"
                    color_overlay0 "#6c7086"
                    color_surface2 "#585b70"
                    color_surface1 "#45475a"
                    color_surface0 "#313244"
                    color_base "#1e1e2e"
                    color_mantle "#181825"
                    color_crust "#11111b"

                    format_left   "#[bg=$surface0,fg=$sapphire]#[bg=$sapphire,fg=$crust,bold] {session} #[bg=$surface0] {mode}#[bg=$surface0] {tabs}"
                    format_center "{notifications}"
                    format_right  "#[bg=$surface0,fg=$flamingo]#[fg=$crust,bg=$flamingo] #[bg=$surface1,fg=$flamingo,bold] {command_user}@{command_host}#[bg=$surface0,fg=$surface1]#[bg=$surface0,fg=$maroon]#[bg=$maroon,fg=$crust]   #[bg=$surface1,fg=$maroon,bold] {datetime}#[bg=$surface0,fg=$surface1]"
                    format_space  "#[bg=$surface0]"
                    
                    hide_frame_for_single_pane "true"

                    mode_normal        "#[bg=$green,fg=$crust,bold] NORMAL#[bg=$surface0,fg=$green]"
                    mode_locked        "#[bg=$red,fg=$crust,bold] LOCKED#[bg=$surface0,fg=$red]"
                    mode_pane          "#[bg=$teal,fg=$crust,bold] PANE#[bg=$surface0,fg=teal]"
                    mode_tab           "#[bg=$teal,fg=$crust,bold] TAB#[bg=$surface0,fg=$teal]"
                    mode_scroll        "#[bg=$flamingo,fg=$crust,bold] SCROLL#[bg=$surface0,fg=$flamingo]"
                    mode_resize        "#[bg=$yellow,fg=$crust,bold] RESIZE#[bg=$surfac0,fg=$yellow]"
                    mode_session       "#[bg=$pink,fg=$crust,bold] SESSION#[bg=$surface0,fg=$pink]"

                    tab_normal              "#[bg=$surface0,fg=$blue]#[bg=$blue,fg=$crust,bold]{index} #[bg=$surface1,fg=$blue,bold] {name}#[bg=$surface0,fg=$surface1]"
                    tab_active              "#[bg=$surface0,fg=$peach]#[bg=$peach,fg=$crust,bold]{index} #[bg=$surface1,fg=$peach,bold] {name}#[bg=$surface0,fg=$surface1]"
                    tab_separator           "#[bg=$surface0] "

                    command_host_command    "uname -n"
                    command_host_format     "{stdout}"
                    command_host_interval   "0"

                    command_user_command    "whoami"
                    command_user_format     "{stdout}"
                    command_user_interval   "10"

                    datetime          "{format}"
                    datetime_format   "%Y-%m-%d    %H:%M"
                    datetime_timezone "Asia/Bangkok"
                }
            }
        }
    }
  '';

  home.shellAliases.zj = "zellij";
}
