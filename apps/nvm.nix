{ pkgs, ... }:

{
  programs.zsh = {
    interactiveShellInit = ''
      if [[ -x "NVM_DIR" ]]; then
        NVM_DIR="$HOME/.nvm"
        echo "Using default NVM_DIR: $NVM_DIR"
      fi
      export NVM_DIR
      if [ ! -d "$NVM_DIR" ]; then
        git clone https://github.com/nvm-sh/nvm.git ~/.nvm
      fi
    '';
  };
}
