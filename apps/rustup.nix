
{ pkgs, ... }:

let CARGO_ROOT = "$HOME/.cargo"; in
{
  programs.fish = {
    interactiveShellInit = ''
      set -Ux CARGO_ROOT ${CARGO_ROOT}
      fish_add_path ${CARGO_ROOT}/bin
    '';
  };
}
