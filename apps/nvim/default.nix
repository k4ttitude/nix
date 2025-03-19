{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    fd
    lazygit
    ripgrep
  ];

  home.activation.linkNvimConfig = 
    let 
      nvimConfigPath = "~/.config/nvim";
      localNvimConfig = "$HOME/nix/apps/nvim/nvim";
    in
    lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD rm -rf ${nvimConfigPath}
      $DRY_RUN_CMD ln -s ${localNvimConfig} ${nvimConfigPath}
    '';
}
