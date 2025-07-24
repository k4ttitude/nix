{ pkgs, ... }:

let
  catppuccin = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "catppuccin";
    version = "unstable-2024-12-06";
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "tmux";
      rev = "179572333b0473020e45f34fd7c1fd658b2831f4";
      sha256 = "11zvrj0j8mm4qd7wb3adcscil9jdgcbnvi3rs447z8w2xn0akr7p";
    };
  };
in
{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    terminal = "xterm-256color";
    historyLimit = 100000;
    mouse = true;
    customPaneNavigationAndResize = true;
    escapeTime = 0;
    clock24 = true;
    sensibleOnTop = false;

    plugins = with pkgs.tmuxPlugins; [
      better-mouse-mode
      {
        plugin = catppuccin;
	      extraConfig = ''
          set -g @catppuccin_flavour "mocha" # or frappe, macchiato, mocha
          set -g @catppuccin_status_background "none"
          set -g @catppuccin_window_status_style "none"
          set -g @catppuccin_pane_status_enabled "off"
          set -g @catppuccin_pane_border_status "off"
	      '';
      }
      resurrect
      vim-tmux-navigator
    ];

    extraConfig = ''
      unbind C-b
      set-option -g prefix C-t

      bind ` last-window

      set -ga terminal-overrides ",xterm-256color:RGB"

      set-option -g allow-passthrough on
      set-option -g detach-on-destroy off
      set-option -ga update-environment TERM
      set-option -ga update-environment TERM_PROGRAM

      # style
      set -g status-position top
      # set -g status-style "bg=#{@thm_bg}"
      set -g status-justify "left"

      set -g window-status-format " #I#{?#{!=:#{window_name},Window},: #W,} "
      set -g window-status-style "bg=#{@thm_bg},fg=#{@thm_rosewater}"
      set -g window-status-last-style "bg=#{@thm_bg},fg=#{@thm_peach}"
      set -g window-status-activity-style "bg=#{@thm_red},fg=#{@thm_bg}"
      set -g window-status-bell-style "bg=#{@thm_red},fg=#{@thm_bg},bold"
      set -gF window-status-separator "#[bg=#{@thm_bg},fg=#{@thm_overlay_0}]│"
      
      set -g window-status-current-format " #I#{?#{!=:#{window_name},Window},: #W,} "
      set -g window-status-current-style "bg=#{@thm_peach},fg=#{@thm_bg},bold"

      set -g status-left-length 0
      set -g status-left ""
      # set -ga status-left "#{?client_prefix,#{#[bg=#{@thm_red},fg=#{@thm_bg},bold]  #S },#{#[bg=#{@thm_bg},fg=#{@thm_green}]  #S }}"
      # set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_overlay_0},none]│"
      # set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_maroon}]  #{pane_current_command} "
      # set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_overlay_0},none]│"
      # set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_blue}]  #{=/-32/...:#{s|$USER|~|:#{b:pane_current_path}}} "
      # set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_overlay_0},none]#{?window_zoomed_flag,│,}"
      # set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_yellow}]#{?window_zoomed_flag,  zoom ,}"

      set -g status-right-length 100
      set -g status-right "#[fg=#{@thm_blue}]#{=/-32/...:#{s|$USER|~|:#{b:pane_current_path}}} "
      set -ga status-right "#[fg=#{@thm_fg} bold](#S)"
      set -ga status-right "#{?client_prefix,#[fg=#{@thm_bg} bg=#{@thm_red} bold] PREFIX ,#{?#{==:#{pane_mode},copy-mode},#[fg=#{@thm_yellow} bold]COPY ,#[fg=#{@thm_green} bold] NORMAL }}"

      setw -g pane-border-status top
      setw -g pane-border-format ""
      setw -g pane-active-border-style "fg=#{@thm_sky}"
      setw -g pane-border-style "fg=#{@thm_surface_0}"
      setw -g pane-border-lines heavy
      
      # binds
      bind-key r source-file ~/.config/tmux/tmux.conf \; display-message "~/.config/tmux/tmux.conf reloaded"
      
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
