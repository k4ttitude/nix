{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
      hide_window_decorations = "titlebar-only";
    };
  };
}
