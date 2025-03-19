{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    fd
    lazygit
    ripgrep
  ];

  home.activation.cloneNvimConfig = 
    let 
      nvimConfigPath = "~/.config/nvim";
      repo = "https://github.com/k4ttitude/nvim.git";
      ref = "main";
    in
    lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD ${pkgs.git}/bin/git clone -b ${ref} ${repo} ${nvimConfigPath}
    '';
}
