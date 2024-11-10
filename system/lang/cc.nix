{ pkgs, ... }:

{
   environment.systemPackages = with pkgs; [
      # CC
      gcc
      gnumake
      cmake
      autoconf
      automake
      libtool
  ];
}
