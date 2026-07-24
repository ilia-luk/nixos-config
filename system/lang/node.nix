{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    yarn
    pnpm
    nodejs_22
    html-tidy
    stylelint
    js-beautify
  ];
}
