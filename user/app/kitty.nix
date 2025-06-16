{ userSettings, pkgs, config, lib, ... }:
with config.lib.stylix.colors;
let
  baseColor = base09;
  activeColor = base09;
  tabLeftEdgeColor = "{fmt.fg._${base02}}{fmt.bg.default}";
  tabRightEdgeColor = "{fmt.fg._${base03}}{fmt.bg.default}";
  tabTextColor = "{fmt.fg._${base02}}{fmt.bg._${base03}}";
  tabLabelColor = "{fmt.fg._${activeColor}}{fmt.bg._${base02}}";

  tabActiveLeftEdgeColor = "{fmt.fg._${base03}}{fmt.bg.default}";
  tabActiveRightEdgeColor = "{fmt.fg._${baseColor}}{fmt.bg.default}";
  tabActiveTextColor = "{fmt.fg._${base02}}{fmt.bg._${baseColor}}";
  tabActiveLabelColor = "{fmt.fg._${activeColor}}{fmt.bg._${base03}}";
in {
  home.packages = with pkgs; [ kitty ];
  programs.kitty.enable = true;
  programs.kitty.settings = {
    foreground = "#${base05}";
    background = "#${base00}";
    selection_foreground = "#${base00}";
    selection_background = "#${base06}";
    background_opacity = lib.mkForce "0.85";
    # Cursor colors
    cursor = "#${base06}";
    cursor_text_color = "#${base00}";
    # URL underline color when hovering with mouse
    url_color = "#${base05}";
    # Kitty window border colors
    active_border_color = "#${base07}";
    inactive_border_color = "#${base20}";
    bell_border_color = "#${base0A}";
    # Tab bar colors
    active_tab_foreground = "#${base21}";
    active_tab_background = "#${base0E}";
    inactive_tab_foreground = "#${base05}";
    inactive_tab_background = "#${base01}";
    tab_bar_background = "none";
    # Colors for marks (marked text in the terminal)
    mark1_foreground = "#${base00}";
    mark1_background = "#${base07}";
    mark2_foreground = "#${base00}";
    mark2_background = "#${base0E}";
    mark3_foreground = "#${base00}";
    mark3_background = "#${base16}";
    # Font
    modify_font = "cell_width 90%";
    font_family = userSettings.font;
    font_size = 14.0;
    # Tabs
    tab_bar_margin_width = "0";
    tab_bar_margin_height = "2 0";
    tab_bar_style = "separator";
    tab_bar_min_tabs = 2;
    tab_separator = "·";
    tab_title_template =
      "${tabLeftEdgeColor}${tabLabelColor} {index} ${tabTextColor} {title[:15] + (title[15:] and '…')} ${tabRightEdgeColor} ";
    active_tab_title_template =
      "${tabActiveLeftEdgeColor}${tabActiveLabelColor}  ${tabActiveTextColor} {title[:40] + (title[40:] and '…')} ${tabActiveRightEdgeColor} ";
    # The 16 terminal colors
    # black
    color0 = "#${base03}";
    color8 = "#${base04}";
    # red
    color1 = "#${base08}";
    color9 = "#${base08}";
    # green
    color2 = "#${base0B}";
    color10 = "#${base0B}";
    # yellow
    color3 = "#${base0A}";
    color11 = "#${base0A}";
    # blue
    color4 = "#${base0D}";
    color12 = "#${base0D}";
    # magenta
    color5 = "#${base17}";
    color13 = "#${base17}";
    # cyan
    color6 = "#${base0C}";
    color14 = "#${base0C}";
    # white
    color7 = "#${base18}";
    color15 = "#${base19}";
  };
}
