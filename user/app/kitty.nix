{
  pkgs,
  config,
  lib,
  ...
}:
with config.lib.stylix.colors; let
  baseColor = base0E;
  activeColor = base09;
  tabLeftEdgeColor = "{fmt.fg._${base03}}{fmt.bg.default}";
  tabRightEdgeColor = "{fmt.fg._${base03}}{fmt.bg.default}";
  tabTextColor = "{fmt.fg._${baseColor}}{fmt.bg._${base03}}";
  tabLabelColor = "{fmt.fg._${activeColor}}{fmt.bg._${base03}}";

  tabActiveLeftEdgeColor = "{fmt.fg._${base03}}{fmt.bg.default}";
  tabActiveRightEdgeColor = "{fmt.fg._${baseColor}}{fmt.bg.default}";
  tabActiveTextColor = "{fmt.fg._${base01}}{fmt.bg._${baseColor}}";
  tabActiveLabelColor = "{fmt.fg._${activeColor}}{fmt.bg._${base03}}";
in {
  home.packages = with pkgs; [
    kitty
  ];
  programs.kitty.enable = true;
  programs.kitty.settings = {
    background = "#${base00}";
    foreground = "#${base05}";
    background_opacity = lib.mkForce "0.75";
    modify_font = "cell_width 90%";
    tab_bar_margin_width = "0";
    tab_bar_margin_height = "2 0";
    tab_bar_style = "separator";
    tab_bar_min_tabs = 2;
    tab_separator = "·";
    tab_bar_background = "none";
    tab_title_template = "${tabLeftEdgeColor}${tabLabelColor} ${tabTextColor}[{index}] {title[:15] + (title[15:] and '…')} ${tabRightEdgeColor} ";
    active_tab_title_template = "${tabActiveLeftEdgeColor}${tabActiveLabelColor}  ${tabActiveTextColor} {title[:40] + (title[40:] and '…')} ${tabActiveRightEdgeColor} ";
    color0 = "#${base00}";
    color8 = "#${base02}";
    color1 = "#${base08}";
    color9 = "#${base08}";
    color2 = "#${base0A}";
    color10 = "#${base0A}";
    color3 = "#${base0B}";
    color11 = "#${base0B}";
    color4 = "#${base09}";
    color12 = "#${base09}";
    color5 = "#${base0E}";
    color13 = "#${base0F}";
    color6 = "#${base0C}";
    color14 = "#${base0C}";
    color7 = "#${base05}";
    color15 = "#${base07}";
  };
}
