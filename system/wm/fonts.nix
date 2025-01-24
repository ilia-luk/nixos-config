{ pkgs, ... }:

{
  # Fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Inconsolata" "FiraCode" ]; })
    powerline
    inconsolata
    inconsolata-nerdfont
    iosevka
    font-awesome
    ubuntu_font_family
    terminus_font
    fira-code
    fira-sans
    fira-code-symbols
  ];
}
