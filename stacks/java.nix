{ pkgs, ... }:
{
  environment.systemPackages = with pkgs;
    [
      # openjdk11
      openjdk23
    ];

  homebrew = {
    brews = [
      "jenv"
    ];
  };

  programs.zsh = {
    interactiveShellInit = ''
      eval "$(jenv init -)"
      jenv enable-plugin export
    '';
  };
}
