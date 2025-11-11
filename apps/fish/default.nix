{ pkgs, ... }:

{
  home.packages = [ pkgs.oh-my-posh ];

  programs.fish = {
    enable = true;
    
    functions = {
      # _fzf_search_zoxide = builtins.readFile ./functions/_fzf_search_zoxide.fish;
    };

    plugins = with pkgs.fishPlugins; [
      { name = "plugin-git"; src = plugin-git.src; }
      { name = "fishtape"; src = fishtape.src; }
      { name = "fzf-fish"; src = fzf-fish.src; }
      { name = "fzf-fish-zoxide"; src = pkgs.writeTextDir "functions/_fzf_search_zoxide.fish" (builtins.readFile ./functions/_fzf_search_zoxide.fish); }
      { name = "dbui"; src = pkgs.writeTextDir "functions/dbui.fish" (builtins.readFile ./functions/dbui.fish); }
      { name = "bass"; src = bass.src; }
      {
        name = "fish-nvm";
	      src = pkgs.fetchFromGitHub {
          owner = "FabioAntunes";
	        repo = "fish-nvm";
          rev = "57ddb124cc0b6ae7e2825855dd34f33b8492a35b";
          sha256 = "00gbvzh4l928rbnyjaqi8fc6dcpr0q4m6rd265gxfy4aqph6j7f0";
        };
      }
    ];

    shellAliases = {
      g = "git";
      p = "pnpm";
      nv = "nvim";
      lzg = "lazygit";
      lzd = "lazydocker";
    };

    shellInit = "";

    interactiveShellInit = ''
      set -gx PAGER less
      set -gx EDITOR nvim
      set -gx VISUAL nvim

      fish_vi_key_bindings
      set -g fish_vi_force_cursor 1

      bind yy fish_clipboard_copy
      bind p fish_clipboard_paste

      bind -M insert \cl forward-bigword
      bind -M insert \ch backward-kill-bigword
      bind -M insert \cn history-prefix-search-forward
      bind -M insert \cp history-prefix-search-backward
      bind -M insert \ck 'clear; commandline -f repaint'
      bind -M normal \ck 'clear; commandline -f repaint'

      # fzf key bindings
      _fzf_uninstall_bindings

      bind -m fzf \cf ""
      bind -M insert -m fzf \cf ""

      bind -M fzf -m insert p _fzf_search_processes
      bind -M fzf -m insert v _fzf_search_variables
      bind -M fzf -m insert d _fzf_search_directory
      bind -M fzf -m insert l _fzf_search_git_log
      bind -M fzf -m insert s _fzf_search_git_status
      bind -M fzf -m insert z _fzf_search_zoxide
      bind -M fzf -m insert \e cancel-commandline

      # kitty_scrollback_edit_command_buffer
      bind --mode default \ce edit_command_buffer
      bind --mode visual \ce edit_command_buffer
      bind --mode insert \ce edit_command_buffer

      zoxide init fish | source
    '';
  };

  programs.oh-my-posh = {
    enable = true;
    enableFishIntegration = true;
    useTheme = "catppuccin_mocha";
  };
}
