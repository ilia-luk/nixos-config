{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
      yarn
      pnpm_8 
      nodejs_22
  ];
}
