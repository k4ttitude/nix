{ lib, pkgs, osConfig, ... }:

{
  home.stateVersion = "24.11";

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
    ./apps/nvim/default.nix
    ./apps/pyenv.nix
  ];
}
