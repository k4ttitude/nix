{
  description = "k4tt nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
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
      nixpkgs.config.allowUnfree = true;
      nixpkgs.hostPlatform = "aarch64-darwin";

      # Auto upgrade nix package and the daemon service.
      # nix.package = pkgs.nix;
      services.nix-daemon.enable = true;
      nix.settings.experimental-features = "nix-command flakes";

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
	with pkgs; [
	  mkalias
	  fish
	  tmux
	  neovim
	  obsidian
	  jankyborders

	  openjdk11

	  pdftk
        ];

      homebrew = {
        enable = true;
	brews = [
	  "mas"
	];
	casks = [
	  "arc"
	  "kitty"
	  "nikitabobko/tap/aerospace"
	  "openkey"
	];
	onActivation.cleanup = "zap";
      };

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

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
            "/Applications/Arc.app"
          ];
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

      security.pam.enableSudoTouchIdAuth = true;

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
	./apps/tmux.nix
	./apps/fish.nix
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
