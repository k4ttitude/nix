{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    terminal = "xterm-256color";
    # shell = "/etc/profiles/per-user/kattitude/bin/fish";
    historyLimit = 100000;
    mouse = true;
    customPaneNavigationAndResize = true;
    escapeTime = 0;
    clock24 = true;
    sensibleOnTop = false;

    plugins = with pkgs.tmuxPlugins; [
      better-mouse-mode
      # sensible
      resurrect
      catppuccin
    ];

    extraConfig = ''
      bind ` last-window
      # Use xterm-256color
      # set -g default-terminal "xterm-256color"
      set -ga terminal-overrides ",xterm-256color:RGB"
      
      set-option -g allow-passthrough on
      set-option -ga update-environment TERM
      set-option -ga update-environment TERM_PROGRAM
      

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
      

      bind-key r source-file ~/.tmux.conf \; display-message "~/.tmux.conf reloaded"
      
      # Toogle pane zoom
      unbind m
      bind m resize-pane -Z
      
      # New pane/window with cwd
      bind - split-window -c "#{pane_current_path}"
      bind | split-window -h -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"
    '';
  };
}
