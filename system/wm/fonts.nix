{ pkgs, ... }:

{
  # Fonts
  fonts.packages = with pkgs; [
    powerline
    nerd-fonts.inconsolata
    iosevka
    font-awesome
    ubuntu_font_family
    terminus_font
    nerd-fonts.fira-code
    fira-code
  ];
}
