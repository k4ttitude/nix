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
    ./apps/fish.nix
    ./apps/kitty.nix
    ./apps/nvim/default.nix
    ./apps/pyenv.nix
    ./apps/rustup.nix
    ./apps/tmux.nix
  ];
}
