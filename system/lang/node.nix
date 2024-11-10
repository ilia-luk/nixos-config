{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
      pnpm_8
      nodenv
  ];
}
