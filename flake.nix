{
  description = "k4tt nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    # homebrew-core = {
    #   url = "github:homebrew/homebrew-core";
    #   flake = false;
    # };
    # homebrew-cask = {
    #   url = "github:homebrew/homebrew-cask";
    #   flake = false;
    # };
    # homebrew-bundle = {
    #   url = "github:homebrew/homebrew-bundle";
    #   flake = false;
    # };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { config, pkgs, ... }: {
      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
	[
	  pkgs.mkalias
	  pkgs.neovim
	  pkgs.tmux
	  pkgs.fish
	  pkgs.obsidian
        ];

      homebrew = {
        enable = true;
	brews = [
	  "mas"
	];
	casks = [
	  "kitty"
	  "nikitabobko/tap/aerospace"
	];
	onActivation.cleanup = "zap";
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

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;
      services.aerospace.enable = true;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      system.defaults = {
      	NSGlobalDomain.AppleInterfaceStyle = "Dark";
        NSGlobalDomain.InitialKeyRepeat = 15;
        NSGlobalDomain.KeyRepeat = 2;
        NSGlobalDomain."com.apple.swipescrolldirection" = false;
	# controlcenter.AirDrop = false;
	# controlcenter.BatteryShowPercentage = false;
	# controlcenter.Bluetooth = false;
	# controlcenter.Display = false;
	# controlcenter.FocusModes = true;
        dock = {
          autohide = true;
          mineffect = "scale";
          persistent-apps = [
            "/Applications/Arc.app"
          ];
        };
	finder.FXPreferredViewStyle = "clmv";
	trackpad.Clicking = true;
	trackpad.TrackpadThreeFingerDrag = true;
      };
      system.keyboard = {
	enableKeyMapping = true;
	remapCapsLockToControl = true;
      };
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
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
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."mac".pkgs;
  };
}
