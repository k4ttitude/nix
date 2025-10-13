{ pkgs, vars, ... }:

{
  # environment.systemPackages = with pkgs; [
  #   libpq
  # ];

  homebrew = {
    brews = [
      "libpq"
    ];
  };

  home-manager.users.${vars.user} = {
    programs.fish.interactiveShellInit = ''
      # fish_add_path ${pkgs.libpq}/bin
      fish_add_path /opt/homebrew/opt/libpq/bin
    '';
  };
}
