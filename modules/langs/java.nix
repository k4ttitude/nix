{ pkgs, vars, ... }:
{
  environment.systemPackages = with pkgs;
    [
      maven
      openjdk11
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

  home-manager.users.${vars.user} = {
    programs.fish.interactiveShellInit = ''
      set -gx JAVA_23_HOME ${pkgs.openjdk23}
      set -gx JAVA_11_HOME ${pkgs.openjdk11}
    '';
  };
}
