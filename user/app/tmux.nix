{
  pkgs,
  config,
  ...
}:
with config.lib.stylix.colors; {
  home.packages = with pkgs; [
    tmux
  ];

  programs.tmux.enable = true;
  programs.tmux = {
    tmuxinator.enable = true;
    keyMode = "vi";
    mouse = true;
    clock24 = true;
    prefix = "C-b";
    terminal = "screen-256color";
    baseIndex = 1;
    aggressiveResize = true;
    escapeTime = 50;
    plugins = with pkgs; [
      tmuxPlugins.yank
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.vim-tmux-navigator
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = ''
          set -g @catppuccin_window_left_separator ""
          set -g @catppuccin_window_right_separator " "
          set -g @catppuccin_window_middle_separator " █"
          set -g @catppuccin_window_number_position "right"

          set -g @catppuccin_window_default_fill "number"
          set -g @catppuccin_window_default_text "#W"

          set -g @catppuccin_window_current_fill "number"
          set -g @catppuccin_window_current_text "#W"

          set -g @catppuccin_status_modules_right "directory application session"
          set -g @catppuccin_status_left_separator  " "
          set -g @catppuccin_status_right_separator ""
          set -g @catppuccin_status_fill "icon"
          set -g @catppuccin_status_connect_separator "no"

          set -g @catppuccin_directory_text "#{pane_current_path}"
          set -g @catppuccin_flavor "mocha"

          set -g @catppuccin_pane_border_style "fg=#${base03}"
          set -g @catppuccin_pane_active_border_style "fg=#${base03}"
        '';
      }
      # {
      #   plugin = tmuxPlugins.resurrect;
      #   extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      # }
      # {
      #   plugin = tmuxPlugins.continuum;
      #   extraConfig = ''
      #     set -g @continuum-restore 'on'
      #     set -g @continuum-save-interval '60' # minutes
      #   '';
      # }
    ];
    extraConfig = ''
       # Enable mouse
       set-option -g mouse
       set -g mouse on
       bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'select-pane -t=; copy-mode -e; send-keys -M'"
       bind -n WheelDownPane select-pane -t= \; send-keys -M

       # Set the default terminal mode to 256color mode
       set -g default-terminal "xterm-256color"
       set -ga terminal-overrides ",*256col*:Tc"

       # Setting window to capture entire visible space
       set-window-option -g aggressive-resize

       # Setting the delay between prefix and command
       set -s escape-time 1

       # Set the base index of windows tp 1 instead of 0
       set -g base-index 1

       # Set the base index for panes to 1 instead of 0
       set -g pane-base-index 1

       # Splitting panes with | and -
       bind | split-window -h -c "#{pane_current_path}"
       bind - split-window -v -c "#{pane_current_path}"

       # Reload the source file with Prefix r
       bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"

       # Moving between panes with Prefix h,j,k,l
       bind h select-pane -L
       bind j select-pane -D
       bind k select-pane -U
       bind l select-pane -R

       # Quick window selection
       bind -r C-h select-window -t:-
       bind -r C-l select-window -t:+

      # bind -n M-h select-pane -L
      # bind -n M-j select-pane -D
      # bind -n M-k select-pane -U
      # bind -n M-l select-pane -R

      # bind -n M-H previous-window
      # bind -n M-L next-window

       # Resizing panes with Prefix H,J,K,L
       bind -r H resize-pane -L 5
       bind -r J resize-pane -D 5
       bind -r K resize-pane -U 5
       bind -r L resize-pane -R 5

       # Enable vi keys
       setw -g mode-keys vi
       bind Escape copy-mode
       unbind p
       bind p paste-buffer

       # Log output to a text file on demand
       bind P pipe-pane -o "cat >>~/#W.log" \; display "Toggled logging to ~/#W.log"

       # Shortcut for synchronize-panes toggle
       bind C-s set-window-option synchronize-panes

       # Clear the screen with prefix Ctrl-l
       bind C-l send-keys 'C-l'

       # Don't rename windows automatically
       set-option -g allow-rename off
       setw -g automatic-rename off

       # 2x C-a goes back and fourth between most recent windows
       bind-key C-a last-window

       # For neovim
       set -g focus-events on

       # Update the status line every seconds
       set -g status-interval 1

       set -g visual-activity off
       set -g visual-bell off
       set -g visual-silence off
       setw -g monitor-activity off
       set -g bell-action none
    '';
  };

  home.shellAliases = {
    tm = "tmux";
    tms = "tmux new -s";
    tml = "tmux list-sessions";
    tma = "tmux attach -t";
    tmk = "tmux kill-session -t";
  };
}
