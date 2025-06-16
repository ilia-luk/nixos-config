{ pkgs, config, ... }:
with config.lib.stylix.colors; {
  home.packages = with pkgs; [ tmux ];

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
    focusEvents = true;
    plugins = with pkgs; [
      tmuxPlugins.yank
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.vim-tmux-focus-events
      tmuxPlugins.tmux-fzf
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor "mocha"

          set -g @catppuccin_window_status_style 'rounded'
          set -g @catppuccin_window_number_position 'right'

          set -g @catppuccin_status_background "default"
          set -g @catppuccin_status_left_separator  ""
          set -g @catppuccin_status_right_separator " "
          set -g @catppuccin_status_connect_separator "no"

          set -g @catppuccin_pane_border_style "fg=#${base03}"
          set -g @catppuccin_pane_active_border_style "fg=#${base03}"

          set -g @catppuccin_date_time_text '%d.%m -- %H:%M'
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

      # Resizing panes with Prefix H,J,K,L
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Copy
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

      # Update the status line every seconds
      set -g status-interval 1

      set -g visual-activity off
      set -g visual-bell off
      set -g visual-silence off
      setw -g monitor-activity off
      set -g bell-action none

      # Define theme
      thm_bg="#${base00}"

      # set left and right status bar
      set -g allow-rename off
      set -g status-position bottom
      set -g status-interval 5
      set -g status-left-length 100
      set -g status-right-length 100
      set -g status-left '#{E:@catppuccin_status_session}'
      set -g status-right "#{E:@catppuccin_status_directory}"
      set -ag status-right "#{E:@catppuccin_status_application}"
      set -ag status-right "#{E:@catppuccin_status_uptime}"
      set -ag status-right '#{E:@catppuccin_status_date_time}'

      #set inactive/active window styles
      set -g window-style "fg=#${base00}"
      set -g window-active-style "fg=#${base00}"
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
