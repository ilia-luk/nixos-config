{ pkgs, ... }:

{
  # Fonts
  fonts.packages = with pkgs; [
    powerline
    nerd-fonts.inconsolata
    iosevka
    font-awesome
    ubuntu-classic
    terminus_font
    nerd-fonts.fira-code
    fira-code
  ];
}
