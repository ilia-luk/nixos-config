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
    ngrok
    shfmt
    shellcheck
  ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    shellAliases = myAliases;
    # variables = myVariables;
  };

  programs.nushell = { 
    enable = true;
    # The config.nu can be anywhere you want if you like to edit your Nushell with Nu
    # configFile.source = ./.../config.nu;
    # for editing directly to config.nu 
    extraConfig = ''
      let carapace_completer = {|spans|carapace $spans.0 nushell ...$spans | from json}
      $env.config = {
        show_banner: false,
        completions: {
          case_sensitive: false # case-sensitive completions
          quick: true    # set to false to prevent auto-selecting completions
          partial: true    # set to false to prevent partial filling of the prompt
          algorithm: "fuzzy"    # prefix or fuzzy
          external: {
            # set to false to prevent nushell looking into $env.PATH to find more suggestions
            enable: true 
            # set to lower can improve completion performance at the cost of omitting some options
            max_results: 100 
            completer: $carapace_completer # check 'carapace_completer' 
          }
        }
      } 
      $env.PATH = ($env.PATH | split row (char esep) | prepend /home/myuser/.apps | append /usr/bin/env)
    '';
    shellAliases = myAliases;
  };  

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = myAliases;
  };

  programs.htop.settings = {
    hide_userland_threads = 1;
    hide_threads = 1;
  };
}
