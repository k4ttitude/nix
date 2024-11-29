{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    fishPlugins.plugin-git
    fishPlugins.fishtape
    fishPlugins.fzf-fish
    fzf
    fishPlugins.z
  ];

  programs.fish = {
    enable = true;

	  #  plugins = with pkgs; [
	  # #    { name = "z"; src = fetchFromGitHub {
	  # #        owner = "jethrokuan";
	  # # repo = "z";
	  # # # rev = "";
	  # # # sha256 = "";
	  # #      };
	  # #    }
	  #    { name = "plugin-git"; src = fishPlugins.plugin-git.src; }
	  #    { name = "fishtape"; src = fishPlugins.fishtape.src; }
	  #    { name = "fzf-fish"; src = fishPlugins.fzf-fish.src; }
	  #    { name = "fzf"; src = fzf.src; }
	  #    { name = "z"; src = fishPlugins.z.src; }
	  #  ];

    shellAliases = {
      g = "git";
      p = "pnpm";
      nv = "nvim";
    };

    interactiveShellInit = ''
      set -gx PAGER less
      set -gx EDITOR nvim
      set -gx VISUAL nvim

      fish_vi_key_bindings

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
      bind -M fzf -m insert \e cancel-commandline
    '';
  };
}
