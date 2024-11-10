{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
      # Haskell
      haskellPackages.haskell-language-server
      haskellPackages.stack
  ];
}
