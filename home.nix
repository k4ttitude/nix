{ lib, pkgs, osConfig, ... }:

{
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    fish
    tmux
  ];

  systemd.user.sessionVariables = {
    EDITOR = "nvim";
  };

  imports = [
    ./apps/fish/default.nix
    ./apps/nvim/default.nix
    ./apps/pyenv.nix
    ./apps/rustup.nix
    ./apps/tmux.nix
  ];
}
