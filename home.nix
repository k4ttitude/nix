{ pkgs, lib, ... }:

{
  home.stateVersion = "24.05";

  systemd.user.sessionVariables = {
    EDITOR = "nvim";
  };

  imports = [
    ./apps/kitty.nix
    # ./apps/fish.nix
  ];
}
