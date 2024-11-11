{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
      python3
      # python3.11-pip
  ];
}
