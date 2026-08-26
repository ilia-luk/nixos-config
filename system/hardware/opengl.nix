{ pkgs, ... }:

{
  # OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    # for AMD graphic-cards to enable openCL
    # extraPackages = with pkgs; [
    #  rocmPackages.clr.icd
    # ];
  };
}
