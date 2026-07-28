{
  lib,
  pkgs,
  inputs,
  userSettings,
  ...
}:
let
  themePath = "../../../themes" + ("/" + userSettings.theme + "/" + userSettings.theme) + ".yaml";
  themePolarity = lib.removeSuffix "\n" (
    builtins.readFile (./. + "../../../themes" + ("/" + userSettings.theme) + "/polarity.txt")
  );
  backgroundUrl = builtins.readFile (
    ./. + "../../../themes" + ("/" + userSettings.theme) + "/backgroundurl.txt"
  );
  backgroundSha256 = builtins.readFile (
    ./. + "../../../themes/" + ("/" + userSettings.theme) + "/backgroundsha256.txt"
  );
in
{
  imports = [ inputs.stylix.homeModules.stylix ];

  home.file.".currenttheme".text = userSettings.theme;

  stylix.enable = true;
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
      name = userSettings.uiFont;
      package = userSettings.uiFontPkg;
    };
    sansSerif = {
      name = userSettings.uiFont;
      package = userSettings.uiFontPkg;
    };
    emoji = {
      name = "Noto Emoji";
      package = pkgs.noto-fonts-monochrome-emoji;
    };
    sizes = {
      terminal = 14;
      applications = 12;
      popups = 12;
      desktop = 12;
    };
  };

  stylix.targets.librewolf.enable = true;
  stylix.targets.librewolf.profileNames = userSettings.browserProfiles;

  fonts.fontconfig.defaultFonts = {
    monospace = [ userSettings.font ];
    sansSerif = [ userSettings.uiFont ];
    serif = [ userSettings.uiFont ];
  };
}
