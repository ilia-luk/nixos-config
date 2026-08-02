{
  pkgs,
  config,
  systemSettings,
  ...
}:
with config.lib.stylix.colors;
let
  zjstatus = pkgs.fetchurl {
    name = "zjstatus-v0.22.0.wasm";
    url = "https://github.com/dj95/zjstatus/releases/download/v0.22.0/zjstatus.wasm";
    sha256 = "sha256-TeQm0gscv4YScuknrutbSdksF/Diu50XP4W/fwFU3VM=";
  };

  room = pkgs.fetchurl {
    name = "room-v1.2.1.wasm";
    url = "https://github.com/rvcas/room/releases/download/v1.2.1/room.wasm";
    sha256 = "sha256-kLSDpAt2JGj7dYYhYFh6BfvtzVwTrcs+0jHwG/nActE=";
  };

  tabTemplate = ''
    default_tab_template {
        children
        pane size=1 borderless=true {
            plugin location="file:${zjstatus}" {
                color_rosewater "#${base06}"
                color_flamingo "#${base0F}"
                color_pink "#${base17}"
                color_mauve "#${base0E}"
                color_red "#${base08}"
                color_maroon "#${base12}"
                color_peach "#${base09}"
                color_yellow "#${base0A}"
                color_green "#${base0B}"
                color_teal "#${base0C}"
                color_sky "#${base15}"
                color_sapphire "#${base16}"
                color_blue "#${base0D}"
                color_lavender "#${base07}"
                color_text "#${base05}"
                color_subtext1 "#${base18}"
                color_subtext0 "#${base19}"
                color_overlay2 "#${base24}"
                color_overlay1 "#${base23}"
                color_overlay0 "#${base22}"
                color_surface2 "#${base04}"
                color_surface1 "#${base03}"
                color_surface0 "#${base02}"
                color_base "#${base00}"
                color_mantle "#${base01}"
                color_crust "#${base11}"

                format_left   "#[bg=$surface0,fg=$sapphire]#[bg=$sapphire,fg=$crust,bold] {session} #[bg=$surface0] {mode}#[bg=$surface0] {tabs}"
                format_center "{notifications}"
                format_right  "#[bg=$surface0,fg=$flamingo]#[fg=$crust,bg=$flamingo] #[bg=$surface1,fg=$flamingo,bold] {command_user}@{command_host}#[bg=$surface0,fg=$surface1]#[bg=$surface0,fg=$maroon]#[bg=$maroon,fg=$crust]󰔠 #[bg=$surface1,fg=$maroon,bold] {datetime}#[bg=$surface0,fg=$surface1]"
                format_space  "#[bg=$surface0]"
                
                hide_frame_for_single_pane "false"

                mode_normal        "#[bg=$green,fg=$crust,bold] NORMAL#[bg=$surface0,fg=$green]"
                mode_locked        "#[bg=$red,fg=$crust,bold] LOCKED#[bg=$surface0,fg=$red]"
                mode_pane          "#[bg=$teal,fg=$crust,bold] PANE#[bg=$surface0,fg=$teal]"
                mode_tab           "#[bg=$teal,fg=$crust,bold] TAB#[bg=$surface0,fg=$teal]"
                mode_scroll        "#[bg=$flamingo,fg=$crust,bold] SCROLL#[bg=$surface0,fg=$flamingo]"
                mode_resize        "#[bg=$yellow,fg=$crust,bold] RESIZE#[bg=$surface0,fg=$yellow]"
                mode_session       "#[bg=$pink,fg=$crust,bold] SESSION#[bg=$surface0,fg=$pink]"

                tab_normal              "#[bg=$surface0,fg=$blue]#[bg=$blue,fg=$crust,bold]{index} #[bg=$surface1,fg=$blue,bold] {name}#[bg=$surface0,fg=$surface1]"
                tab_active              "#[bg=$surface0,fg=$peach]#[bg=$peach,fg=$crust,bold]{index} #[bg=$surface1,fg=$peach,bold] {name}#[bg=$surface0,fg=$surface1]"
                tab_separator           "#[bg=$surface0] "

                command_host_command    "uname -n"
                command_host_format     "{stdout}"
                command_host_interval   "3600"

                command_user_command    "whoami"
                command_user_format     "{stdout}"
                command_user_interval   "10"

                datetime          "{format}"
                datetime_format   "%Y-%m-%d    %H:%M"
                datetime_timezone "${systemSettings.timezone}"
            }
        }
    }
  '';
in
{
  home.packages = [ pkgs.zellij ];

  # We enable the program but don't use the 'settings' or 'extraConfig' options
  programs.zellij.enable = true;

  # Manually write the config.kdl to avoid Home Manager translation errors
  xdg.configFile."zellij/config.kdl".text = ''
    theme "catppuccin"
    themes {
      catppuccin {
        text_unselected {
          base "#${base05}"
          background "#${base01}"
          emphasis_0 "#${base09}"
          emphasis_1 "#${base0C}"
          emphasis_2 "#${base0B}"
          emphasis_3 "#${base0E}"
        }
        text_selected {
          base "#${base05}"
          background "#${base04}"
          emphasis_0 "#${base09}"
          emphasis_1 "#${base0C}"
          emphasis_2 "#${base0B}"
          emphasis_3 "#${base0E}"
        }
        ribbon_selected {
          base "#${base01}"
          background "#${base0B}"
          emphasis_0 "#${base08}"
          emphasis_1 "#${base09}"
          emphasis_2 "#${base0E}"
          emphasis_3 "#${base0D}"
        }
        ribbon_unselected {
          base "#${base01}"
          background "#${base05}"
          emphasis_0 "#${base08}"
          emphasis_1 "#${base05}"
          emphasis_2 "#${base0D}"
          emphasis_3 "#${base0E}"
        }
        table_title {
          base "#${base0B}"
          background 0
          emphasis_0 "#${base09}"
          emphasis_1 "#${base0C}"
          emphasis_2 "#${base0B}"
          emphasis_3 "#${base0E}"
        }
        table_cell_selected {
          base "#${base05}"
          background "#${base04}"
          emphasis_0 "#${base09}"
          emphasis_1 "#${base0C}"
          emphasis_2 "#${base0B}"
          emphasis_3 "#${base0E}"
        }
        table_cell_unselected {
          base "#${base05}"
          background "#${base01}"
          emphasis_0 "#${base09}"
          emphasis_1 "#${base0C}"
          emphasis_2 "#${base0B}"
          emphasis_3 "#${base0E}"
        }
        list_selected {
          base "#${base05}"
          background "#${base04}"
          emphasis_0 "#${base09}"
          emphasis_1 "#${base0C}"
          emphasis_2 "#${base0B}"
          emphasis_3 "#${base0E}"
        }
        list_unselected {
          base "#${base05}"
          background "#${base01}"
          emphasis_0 "#${base09}"
          emphasis_1 "#${base0C}"
          emphasis_2 "#${base0B}"
          emphasis_3 "#${base0E}"
        }
        frame_selected {
          base "#${base0B}"
          background 0
          emphasis_0 "#${base09}"
          emphasis_1 "#${base0C}"
          emphasis_2 "#${base0E}"
          emphasis_3 0
        }
        frame_highlight {
          base "#${base09}"
          background 0
          emphasis_0 "#${base09}"
          emphasis_1 "#${base09}"
          emphasis_2 "#${base09}"
          emphasis_3 "#${base09}"
        }
        exit_code_success {
          base "#${base0B}"
          background 0
          emphasis_0 "#${base0C}"
          emphasis_1 "#${base01}"
          emphasis_2 "#${base0E}"
          emphasis_3 "#${base0D}"
        }
        exit_code_error {
          base "#${base08}"
          background 0
          emphasis_0 "#${base0A}"
          emphasis_1 0
          emphasis_2 0
          emphasis_3 0
        }
        multiplayer_user_colors {
          player_1 "#${base0E}"
          player_2 "#${base0D}"
          player_3 0
          player_4 "#${base0A}"
          player_5 "#${base0C}"
          player_6 0
          player_7 "#${base08}"
          player_8 0
          player_9 0
          player_10 0
        }
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
      ${tabTemplate}
    }
  '';

  xdg.configFile."zellij/layouts/wrapper.kdl".text = ''
    layout {
    ${tabTemplate}
        tab name="editor" focus=true {
            pane split_direction="vertical" {
                pane command="nvim" size="55%" {
                    args "."
                }
                pane stacked=true {
                    pane command="pi"
                    pane
                }
            }
        }
        tab name="services" cwd=".." {
            pane
        }
        tab name="agents" cwd=".." {
            pane command="herd"
        }
        tab name="reviews" cwd=".." {
            pane command="gh-dash"
        }
        tab name="shell" cwd=".." {
            pane
        }
    }
  '';

  home.shellAliases.zj = "zellij";
}
