{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    interactiveShellInit = ''
      if [[ $(ps -o command= -p "$PPID" | awk '{print $1}') != 'fish' ]]
      then
          exec fish -l
      fi
    '';
  };
}
