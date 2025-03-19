{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    fd
    lazygit
    ripgrep
  ];

  home.activation.copyNvimConfig = 
    let 
      nvimConfigPath = "~/.config/nvim";
      nvimSetup = pkgs.writeShellScriptBin "setup-nvim" ''
        rm -rf ${nvimConfigPath}
        mkdir -p ${nvimConfigPath}
        cp -r ${toString ./.}/nvim/* ${nvimConfigPath}/
      '';
    in
    lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD ${nvimSetup}/bin/setup-nvim
    '';
}
