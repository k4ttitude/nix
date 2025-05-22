{
  description = "k4tt nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = { 
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs @ { self, nix-darwin, nixpkgs, nix-homebrew, home-manager }:

  let
    vars = {
      user = "kattitude";
    };
    # revision = self.rev or self.dirtyRev or null;
  in
  {
    darwinConfigurations = (
      import ./darwin/default.nix {
        inherit (nixpkgs) lib;
        inherit inputs nix-darwin nixpkgs nix-homebrew home-manager vars;
      }
    );
    darwinPackages = self.darwinConfigurations."mac".pkgs;
  };
}
