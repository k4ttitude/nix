{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    # enableCompletion = true;
    # enableSyntaxHighlighting = true;
    # enableFastSyntaxHighlighting = true;
    interactiveShellInit = ''
      if [[ $(ps -o command= -p "$PPID" | awk '{print $1}') != 'fish' ]]
      then
          exec fish -l
      fi
    '';
  };
}
