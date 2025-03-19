{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    fd
    lazygit
    ripgrep
  ];

  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      lua-language-server
      stylua
    ];

    # plugins = with pkgs.vimPlugins; [
    #   lazy-nvim
    # ];

    extraLuaConfig =
      ''
        vim.g.mapleader = " " -- Need to set leader before lazy for correct keybindings
	      require('config.lazy')
      '';
  };

  xdg.configFile."nvim" = {
    recursive = true;
    source = ./nvim;
  };
}
