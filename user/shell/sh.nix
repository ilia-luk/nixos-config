{ pkgs, config, ... }:
let
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

in
{
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
    unstable.tree-sitter
  ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    shellAliases = myAliases;
    dotDir = config.home.homeDirectory;
    # variables = myVariables;
  };

  programs.nushell = {
    enable = true;
    # The config.nu can be anywhere you want if you like to edit your Nushell with Nu
    # configFile.source = ./.../config.nu;
    # for editing directly to config.nu
    envFile.text = ''
      $env.OPENAI_API_KEY = (cat ${config.sops.secrets.openai-api-key.path})
      $env.CLAUDE_API_KEY = (cat ${config.sops.secrets.claude-api-key.path})
    '';
    configFile.text = ''
      # Defaults
      source ~/.config/nushell/catppuccin-mocha.nu
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

  home.file.".config/nushell/catppuccin-mocha.nu".text = ''
    let theme = {
      rosewater: "#f5e0dc"
      flamingo: "#f2cdcd"
      pink: "#f5c2e7"
      mauve: "#cba6f7"
      red: "#f38ba8"
      maroon: "#eba0ac"
      peach: "#fab387"
      yellow: "#f9e2af"
      green: "#a6e3a1"
      teal: "#94e2d5"
      sky: "#89dceb"
      sapphire: "#74c7ec"
      blue: "#89b4fa"
      lavender: "#b4befe"
      text: "#cdd6f4"
      subtext1: "#bac2de"
      subtext0: "#a6adc8"
      overlay2: "#9399b2"
      overlay1: "#7f849c"
      overlay0: "#6c7086"
      surface2: "#585b70"
      surface1: "#45475a"
      surface0: "#313244"
      base: "#1e1e2e"
      mantle: "#181825"
      crust: "#11111b"
    }

    let scheme = {
      recognized_command: $theme.blue
      unrecognized_command: $theme.text
      constant: $theme.peach
      punctuation: $theme.overlay2
      operator: $theme.sky
      string: $theme.green
      virtual_text: $theme.surface2
      variable: { fg: $theme.flamingo attr: i }
      filepath: $theme.yellow
    }

    $env.config.color_config = {
      separator: { fg: $theme.surface2 attr: b }
      leading_trailing_space_bg: { fg: $theme.lavender attr: u }
      header: { fg: $theme.text attr: b }
      row_index: $scheme.virtual_text
      record: $theme.text
      list: $theme.text
      hints: $scheme.virtual_text
      search_result: { fg: $theme.base bg: $theme.yellow }
      shape_closure: $theme.teal
      closure: $theme.teal
      shape_flag: { fg: $theme.maroon attr: i }
      shape_matching_brackets: { attr: u }
      shape_garbage: $theme.red
      shape_keyword: $theme.mauve
      shape_match_pattern: $theme.green
      shape_signature: $theme.teal
      shape_table: $scheme.punctuation
      cell-path: $scheme.punctuation
      shape_list: $scheme.punctuation
      shape_record: $scheme.punctuation
      shape_vardecl: $scheme.variable
      shape_variable: $scheme.variable
      empty: { attr: n }
      filesize: {||
        if $in < 1kb {
          $theme.teal
        } else if $in < 10kb {
          $theme.green
        } else if $in < 100kb {
          $theme.yellow
        } else if $in < 10mb {
          $theme.peach
        } else if $in < 100mb {
          $theme.maroon
        } else if $in < 1gb {
          $theme.red
        } else {
          $theme.mauve
        }
      }
      duration: {||
        if $in < 1day {
          $theme.teal
        } else if $in < 1wk {
          $theme.green
        } else if $in < 4wk {
          $theme.yellow
        } else if $in < 12wk {
          $theme.peach
        } else if $in < 24wk {
          $theme.maroon
        } else if $in < 52wk {
          $theme.red
        } else {
          $theme.mauve
        }
      }
      date: {|| (date now) - $in |
        if $in < 1day {
          $theme.teal
        } else if $in < 1wk {
          $theme.green
        } else if $in < 4wk {
          $theme.yellow
        } else if $in < 12wk {
          $theme.peach
        } else if $in < 24wk {
          $theme.maroon
        } else if $in < 52wk {
          $theme.red
        } else {
          $theme.mauve
        }
      }
      shape_external: $scheme.unrecognized_command
      shape_internalcall: $scheme.recognized_command
      shape_external_resolved: $scheme.recognized_command
      shape_block: $scheme.recognized_command
      block: $scheme.recognized_command
      shape_custom: $theme.pink
      custom: $theme.pink
      background: $theme.base
      foreground: $theme.text
      cursor: { bg: $theme.rosewater fg: $theme.base }
      shape_range: $scheme.operator
      range: $scheme.operator
      shape_pipe: $scheme.operator
      shape_operator: $scheme.operator
      shape_redirection: $scheme.operator
      glob: $scheme.filepath
      shape_directory: $scheme.filepath
      shape_filepath: $scheme.filepath
      shape_glob_interpolation: $scheme.filepath
      shape_globpattern: $scheme.filepath
      shape_int: $scheme.constant
      int: $scheme.constant
      bool: $scheme.constant
      float: $scheme.constant
      nothing: $scheme.constant
      binary: $scheme.constant
      shape_nothing: $scheme.constant
      shape_bool: $scheme.constant
      shape_float: $scheme.constant
      shape_binary: $scheme.constant
      shape_datetime: $scheme.constant
      shape_literal: $scheme.constant
      string: $scheme.string
      shape_string: $scheme.string
      shape_string_interpolation: $theme.flamingo
      shape_raw_string: $scheme.string
      shape_externalarg: $scheme.string
    }
    $env.config.highlight_resolved_externals = true
    $env.config.explore = {
        status_bar_background: { fg: $theme.text, bg: $theme.mantle },
        command_bar_text: { fg: $theme.text },
        highlight: { fg: $theme.base, bg: $theme.yellow },
        status: {
            error: $theme.red,
            warn: $theme.yellow,
            info: $theme.blue,
        },
        selected_cell: { bg: $theme.blue fg: $theme.base },
    }
  '';

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
