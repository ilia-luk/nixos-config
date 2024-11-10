{ pkgs, ... }:

{
  home.packages = with pkgs; [
      nodenv
  ];
}
