{ pkgs, ... }:

{
  homebrew.casks = [ "kitty" ];
  home-manager.users.kattitude = {
    home.file = {
      ".config/kitty/kitty.conf".source = ./kitty/kitty.conf;
    };
  };
}
