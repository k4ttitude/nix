{ pkgs, vars, ... }:

let
  pnpmHome = "~/.local/share/pnpm";

in
{
  environment.systemPackages = with pkgs; [
    pnpm
  ];

  home-manager.users.${vars.user} = {
    programs.fish.interactiveShellInit = ''
      set -gx PNPM_HOME ${pnpmHome}
      fish_add_path ${pnpmHome}
    '';
  };
}
