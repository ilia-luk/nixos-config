{ pkgs, ... }:

{
  # OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    # for AMD graphic-cards to enable openCL
    # extraPackages = with pkgs; [
    #  rocmPackages.clr.icd
    # ];
  };
}
