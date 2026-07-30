{ pkgs, ... }:
let
  wt = pkgs.unstable.worktrunk;
  # declarative shell integration: capture what `wt config shell install`
  # would write, into nushell's vendor-autoload dir (auto-sourced by nu)
  wtNuInit = pkgs.runCommand "wt.nu" { } ''
    ${wt}/bin/wt config shell init nu > $out
  '';
in
{
  home.packages = [ wt ];

  xdg.dataFile."nushell/vendor/autoload/wt.nu".source = wtNuInit;

  xdg.configFile."worktrunk/config.toml".source = ./config.toml;
}
