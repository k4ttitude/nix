{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fd
    lazygit
    ripgrep
  ];

  programs.neovim = {
    enable = true;
    extraLuaConfig =
      ''
        vim.g.mapleader = " " -- Need to set leader before lazy for correct keybindings
	      require('config.lazy')
      '';
  };

  xdg.configFile."nvim" = {
    recursive = true;
    source = builtins.fetchGit {
      url = "https://github.com/k4ttitude/nvim.git";
      ref = "main";
      rev = "424d197ed34a25317f4955ea4e1255646369fab0";
    };
  };
}
