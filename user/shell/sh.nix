{pkgs, ...}: let
  # My shell aliases
  myAliases = {
    ll = "eza --icons --group-directories-first --total-size -l -a -@ -T -L=1";
    cat = "bat";
    man = "batman";
    grep = "batgrep";
    watch = "batwatch";
    diff = "batdiff";
    htop = "btm";
    fd = "fd -Lu";
    neofetch = "disfetch";
    fetch = "disfetch";
    gitfetch = "onefetch";
  };
in {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    shellAliases = myAliases;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = myAliases;
  };

  home.packages = with pkgs; [
    disfetch
    onefetch
    gnugrep
    gnused
    gawk
    eza
    bottom
    fd
    bc
    direnv
    nix-direnv
    z-lua
    vim
    unzip
    ripgrep
    libnotify
    killall
    jq
    grc
    ack
  ];

  programs.direnv.enable = true;
  programs.direnv.enableZshIntegration = true;
  programs.direnv.nix-direnv.enable = true;
}
