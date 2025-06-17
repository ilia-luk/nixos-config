{ pkgs, ... }: {
  home.packages = with pkgs; [ feh ];

  programs.feh.enable = true;
  programs.feh.themes = {
    booth = [ "--full-screen" "--hide-pointer" "--slideshow-delay" "20" ];
    feh = [ "--image-bg" "black" ];
    imagemap = [
      "-rVq"
      "--thumb-width"
      "40"
      "--thumb-height"
      "30"
      "--index-info"
      "%n\\n%wx%h"
    ];
    present = [ "--full-screen" "--sort" "name" "--hide-pointer" ];
  };
}
