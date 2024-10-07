{
  lib,
  pkgs,
  inputs,
  userSettings,
  ...
}: let
  themePath = "../../../themes" + ("/" + userSettings.theme + "/" + userSettings.theme) + ".yaml";
  themePolarity = lib.removeSuffix "\n" (builtins.readFile (./. + "../../../themes" + ("/" + userSettings.theme) + "/polarity.txt"));
  backgroundUrl = builtins.readFile (./. + "../../../themes" + ("/" + userSettings.theme) + "/backgroundurl.txt");
  backgroundSha256 = builtins.readFile (./. + "../../../themes/" + ("/" + userSettings.theme) + "/backgroundsha256.txt");
in {
  home.packages = with pkgs; [
    noto-fonts-monochrome-emoji
  ];

  imports = [inputs.stylix.homeManagerModules.stylix];

  home.file.".currenttheme".text = userSettings.theme;

  stylix.autoEnable = false;
  stylix.polarity = themePolarity;
  stylix.image = pkgs.fetchurl {
    url = backgroundUrl;
    sha256 = backgroundSha256;
  };
  stylix.base16Scheme = ./. + themePath;
  stylix.fonts = {
    monospace = {
      name = userSettings.font;
      package = userSettings.fontPkg;
    };
    serif = {
      name = userSettings.font;
      package = userSettings.fontPkg;
    };
    sansSerif = {
      name = userSettings.font;
      package = userSettings.fontPkg;
    };
    emoji = {
      name = "Noto Emoji";
      package = pkgs.noto-fonts-monochrome-emoji;
    };
    sizes = {
      terminal = 16;
      applications = 12;
      popups = 12;
      desktop = 12;
    };
  };
  stylix.targets.kitty.enable = true;
  stylix.targets.yazi.enable = true;
  stylix.targets.zellij.enable = true;
  stylix.targets.tmux.enable = true;
  stylix.targets.mako.enable = true;
  stylix.targets.fuzzel.enable = true;
  # stylix.targets.lazyvim.enable = true;
  stylix.targets.fzf.enable = true;
  stylix.targets.firefox.enable = true;
  stylix.targets.bat.enable = true;
  stylix.targets.hyprland.enable = true;
  # stylix.targets.hyprpaper.enable = true;
  stylix.targets.waybar.enable = true;

  fonts.fontconfig.defaultFonts = {
    monospace = [userSettings.font];
    sansSerif = [userSettings.font];
    serif = [userSettings.font];
  };
}
