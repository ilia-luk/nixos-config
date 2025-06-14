{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ unstable.go ];
}
