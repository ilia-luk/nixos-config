{pkgs, ...}: let
  myAliases = {
    ll = "eza --icons --group-directories-first --total-size -l -a -@ -T -L=1";
    cat = "bat";
    man = "batman";
    grep = "batgrep";
    watch = "batwatch";
    diff = "batdiff";
    top = "btm";
    fd = "fd -Lu";
    neofetch = "disfetch";
    fetch = "disfetch";
    gitfetch = "onefetch";
  };

  # myVariables = {
  #   LV_BRANCH = "release-1.4/neovim-0.9";
  # };

in {
  home.packages = with pkgs; [
    disfetch
    onefetch
    gnugrep
    gnused
    gawk
    eza
    bottom
    htop
    fd
    bc
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

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    shellAliases = myAliases;
    # variables = myVariables;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = myAliases;
  };
}
