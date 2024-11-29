{ pkgs, lib, ... }:

{
  home.stateVersion = "24.11";

  systemd.user.sessionVariables = {
    EDITOR = "nvim";
  };

  home.packages = with pkgs; [
    kitty
    alacritty
  ];

  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
      hide_window_decorations = "titlebar-only";
    };
  };
}
