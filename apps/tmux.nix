{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    enableMouse = true;
    enableVim = true;
    extraConfig = ''
      bind ` last-window
    
        # Length of the history
        set -g history-limit 100000
        
        # Use xterm-256color
        set -g default-terminal "xterm-256color"
        set -ga terminal-overrides ",xterm-256color:RGB"
        
        # Suppose to decrease lag
        set-option -s escape-time 10
        set-option -g allow-passthrough on
        set-option -ga update-environment TERM
        set-option -ga update-environment TERM_PROGRAM
        
        # }}}
        
        # List of plugins
        set -g @plugin 'tmux-plugins/tpm'
        set -g @plugin 'tmux-plugins/tmux-sensible'
        set -g @plugin 'tmux-plugins/tmux-resurrect'
        set -g @plugin 'catppuccin/tmux'
        
        # catppuccin
        set -g @catppuccin_flavour 'mocha' # or frappe, macchiato, mocha
        set -g @catppuccin_window_status_enable "yes"
        set -g @catppuccin_window_status_icon_enable "no"
        
        set -g @catppuccin_window_right_separator "█  "
        set -g @catppuccin_window_left_separator " █"
        set -g @catppuccin_window_middle_separator "█ "
        set -g @catppuccin_window_number_position "left"
        
        set -g @catppuccin_window_default_text "#W"
        set -g @catppuccin_window_current_text "#W"
        set -g @catppuccin_window_default_fill "number"
        set -g @catppuccin_window_current_fill "number"
        
        set -g @catppuccin_status_modules "directory session"
        set -g @catppuccin_status_left_separator " █"
        set -g @catppuccin_status_right_separator ""
        set -g @catppuccin_status_fill "all"
        
        set -g @catppuccin_date_time_text "%H:%M"
        
        # Binding {{{
        
        bind-key r source-file ~/.tmux.conf \; display-message "~/.tmux.conf reloaded"
        
        # Switch panes
        unbind h
        unbind l
        unbind j
        unbind k
        bind h select-pane -L
        bind l select-pane -R
        bind j select-pane -U
        bind k select-pane -D
        
        # Resize pane
        bind-key -r H resize-pane -L
        bind-key -r J resize-pane -D
        bind-key -r K resize-pane -U
        bind-key -r L resize-pane -R
        
        # Toogle pane zoom
        unbind m
        bind m resize-pane -Z
        
        # New pane/window with cwd
        bind - split-window -c "#{pane_current_path}"
        bind | split-window -h -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"
        
        # }}}
        
        set-environment -g PATH "/opt/homebrew/bin:/bin:/usr/bin"
        run '~/.tmux/plugins/tpm/tpm'
    '';
  };
}
