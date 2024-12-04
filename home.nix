{ lib, pkgs, osConfig, ... }:

{
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    fish
    tmux
  ];

  systemd.user.sessionVariables = {
    EDITOR = "nvim";
  };

  imports = [
    ./apps/kitty.nix
    ./apps/fish.nix
    ./apps/tmux.nix
    ./apps/pyenv.nix
  ];
}
