{ revision, config, pkgs, vars, ... }:
{
  nix.enable = true;
  nix.settings.experimental-features = "nix-command flakes";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  environment.systemPackages = with pkgs;
    [
      aichat
      bun
      deluge # torrent
      docker-compose
      doppler
      flyctl
      fzf
      ghostscript
      gitlab-ci-local
      gitlab-runner
      jankyborders
      lazydocker
      mkalias
      neovim
      pngpaste
      pnpm
      pyenv
      rustup
      yazi
      zoxide
    ];

  homebrew = {
    enable = true;
    taps = [
      "nikitabobko/tap"
    ];
    brews = [
      "mas"
      "pdftk-java"
      # node canvas
      "pkg-config" "cairo" "pango" "libpng" "giflib" "jpeg" "librsvg"
      "qmk/qmk/qmk"
    ];
    casks = [
      "cursor"
      "docker-desktop"
      "google-chrome"
      "kitty"
      "libreoffice"
      "aerospace"
      "obsidian"
      "openkey"
      "postman"
      "steam"
      "tableplus"
      "vlc"
      { name = "zen"; greedy = true; }
    ];
    masApps = {
      NordVPN = 905953485;
      Xcode = 497799835;
    };
    onActivation.cleanup = "zap";
  };

  fonts.packages = with pkgs; [ nerd-fonts.meslo-lg ];

  # Set Git commit hash for darwin-version.
  system.configurationRevision = revision;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  system.primaryUser = vars.user;

  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      "com.apple.swipescrolldirection" = false;
    };
    dock = {
      autohide = true;
      mineffect = "scale";
      persistent-apps = [
        "/Applications/Zen Browser.app"
        "/Applications/kitty.app"
      ];
      show-recents = false;
    };
    finder = {
      FXPreferredViewStyle = "clmv";
      _FXShowPosixPathInTitle = true;
      QuitMenuItem = true;
      ShowPathbar = true;
      ShowStatusBar = true;
    };
    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  users.users.${vars.user} = {
    name = vars.user;
    home = "/Users/${vars.user}";
  };

  system.activationScripts.applications.text = let
    env = pkgs.buildEnv {
      name = "system-applications";
      paths = config.environment.systemPackages;
      pathsToLink = "/Applications";
    };
  in
    pkgs.lib.mkForce ''
          # Set up applications.
          echo "setting up /Applications..." >&2
          rm -rf /Applications/Nix\ Apps
          mkdir -p /Applications/Nix\ Apps
          find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
          while read -r src; do
            app_name=$(basename "$src")
            echo "copying $src" >&2
      ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
          done
    '';

  imports = [ 
    ../apps/aerospace.nix
    ../apps/jankyborders.nix
    ../apps/zsh.nix
    ../apps/kitty.nix
    ../modules/langs/java.nix
    ../modules/pnpm.nix
    ../modules/psql.nix
  ];
}
