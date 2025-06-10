{pkgs, ...}: let
  myAliases = {
    ll = "ls -a";
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
    configFile.text = ''
      # Defaults
      $env.config = ($env.config? | default {})
      $env.config.hooks = ($env.config.hooks? | default {})
      $env.EDITOR = 'nvim'

      # Zellij
      def zea [...x] { zellij attach ...$x }
      def zec [...x] { zellij -s ...$x }
      def zel [...x] { zellij list-sessions }
      def zek [...x] { zellij kill-session ...$x }
      def zed [...x] { zellij delete-session ...$x }

      # Starship
      def transient_prompt_right [] {
        {|| $"(^starship module cmd_duration)(^starship module time)"}
      }
      def transient_prompt_left [] {
        {|| $"(^starship module shell)"}
      }
      $env.TRANSIENT_PROMPT_COMMAND = (transient_prompt_left)
      $env.TRANSIENT_PROMPT_COMMAND_RIGHT = (transient_prompt_right)

      # Path
      $env.PATH = ($env.PATH | split row (char esep) | prepend /home/myuser/.apps | append /usr/bin/env)

      # Completions
      let fish_completer = {|spans|
        fish --command $"complete '--do-complete=($spans | str join ' ')'"
        | from tsv --flexible --noheaders --no-infer
        | rename value description
        | update value {
          if ($in | path exists) {$'"($in | str replace "\"" "\\\"" )"'} else {$in}
        }
      }

      let zoxide_completer = {|spans|
        $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
      }

      let carapace_completer = {|spans: list<string>|
        carapace $spans.0 nushell ...$spans
        | from json
        | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
      }

      let external_completer = {|spans|
        let expanded_alias = scope aliases
        | where name == $spans.0
        | get -i 0.expansion

        let spans = if $expanded_alias != null {
          $spans
          | skip 1
          | prepend ($expanded_alias | split row ' ' | take 1)
        } else {
          $spans
        }

        match $spans.0 {
          nu => $fish_completer
          git => $fish_completer
          __zoxide_z | __zoxide_zi => $zoxide_completer
          _ => $carapace_completer
        } | do $in $spans
      }

      $env.config = {
        show_banner: false,
        completions: {
          case_sensitive: false
          quick: true 
          partial: true
          algorithm: "fuzzy"
          external: {
            enable: true 
            max_results: 100 
            completer: $external_completer
          }
        }
      }

      { ||
        if (which direnv | is-empty) {
          return
        }
        direnv export json | from json | default {} | load-env
      }
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
