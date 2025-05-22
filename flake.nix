{
  description = "k4tt nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = { 
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, home-manager }:
  let
    configuration = { config, pkgs, ... }: {
      nix.enable = true;
      nix.settings.experimental-features = "nix-command flakes";

      nixpkgs.config.allowUnfree = true;
      nixpkgs.hostPlatform = "aarch64-darwin";

      environment.systemPackages = with pkgs;
        [
          aichat
          bun
          docker-compose
          flyctl
	        fzf
          ghostscript
	        jankyborders
          lazydocker
          maven
	        mkalias
	        neovim
	        pdftk
          pngpaste
          pnpm
	        pyenv
          rustup
          yazi
        ];

      homebrew = {
        enable = true;
        taps = [
          "nikitabobko/tap"
        ];
	      brews = [
	        "mas"
          # node canvas
          "pkg-config" "cairo" "pango" "libpng" "giflib" "jpeg" "librsvg"
	      ];
	      casks = [
          "chromium"
          "cursor"
          "docker"
          "kitty"
          "libreoffice"
	        "aerospace"
          "obsidian"
	        "openkey"
          "postman"
          "steam"
          "tableplus"
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
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

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

      users.users.kattitude = {
        name = "kattitude";
	      home = "/Users/kattitude";
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
        ./apps/aerospace.nix
	      ./apps/jankyborders.nix
	      ./apps/zsh.nix
        ./apps/kitty.nix
        ./stacks/java.nix
      ];

    };
  in
  {
    darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration

	      nix-homebrew.darwinModules.nix-homebrew
	      {
	        nix-homebrew = {
	          enable = true;
	          # Apple Silicon Only
	          enableRosetta = true;
	          # User owning the Homebrew prefix
	          user = "kattitude";
	          # Automatically migrate existing Homebrew installations
	          autoMigrate = true;
	        };
	      }

        home-manager.darwinModules.home-manager
	      {
	        home-manager.useGlobalPkgs = true;
	        home-manager.useUserPackages = true;
	        home-manager.backupFileExtension = "bak";
	        home-manager.users.kattitude = import ./home.nix;
        }
      ];
    };

    darwinPackages = self.darwinConfigurations."mac".pkgs;
  };
}
