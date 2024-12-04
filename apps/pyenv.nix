{ pkgs, ... }:

let PYENV_ROOT = "$HOME/.pyenv"; in
{
  programs.fish = {
    interactiveShellInit = ''
      set -Ux PYENV_ROOT ${PYENV_ROOT}
      fish_add_path ${PYENV_ROOT}/bin
      pyenv init - | source
    '';
  };
}
