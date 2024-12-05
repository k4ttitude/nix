{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      window_padding_width = 4;

      # font
      font_family      = ''family="MesloLGM Nerd Font Mono"'';
      bold_font        = "auto";
      italic_font      = "auto";
      bold_italic_font = "auto";
      font_size        = 11.5;

      # chores
      hide_window_decorations = "titlebar-only";
      confirm_os_window_close = 0;

      # colors
      background_opacity = 0.85;
      
      background = "#2D2A2E";
      foreground = "#FCFCFA";
      
      cursor = "none";
      
      # black
      color0 = "#403E41";
      color8 = "#727072";
      
      # red
      color1 = "#FF6188";
      color9 = "#FF6188";
      
      # green
      color2 = "#A9DC76";
      color10 = "#A9DC76";
      
      # yellow
      color3 = "#FFD866";
      color11 = "#FFD866";
      
      # blue
      color4 = "#FC9867";
      color12 = "#FC9867";
      
      # magenta
      color5 = "#AB9DF2";
      color13 = "#AB9DF2";
      
      # cyan
      color6 = "#78DCE8";
      color14 = "#78DCE8";
      
      # white
      color7 = "#FCFCFA";
      color15 = "#FCFCFA";
    };
  };
}
