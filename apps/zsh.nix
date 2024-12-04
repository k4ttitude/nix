{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    # enableCompletion = true;
    # enableSyntaxHighlighting = true;
    # enableFastSyntaxHighlighting = true;
    interactiveShellInit = ''
      # check and clone .nvm
      if [[ -x "NVM_DIR" ]]; then
        NVM_DIR="$HOME/.nvm"
        echo "Using default NVM_DIR: $NVM_DIR"
      fi
      export NVM_DIR
      # unset LD_LIBRARY_PATH
      if [ ! -d "$NVM_DIR" ]; then
        git clone https://github.com/nvm-sh/nvm.git ~/.nvm
      fi

      # run fish shell
      if [[ $(ps -o command= -p "$PPID" | awk '{print $1}') != 'fish' ]]
      then
          exec fish -l
      fi
    '';
  };
}
