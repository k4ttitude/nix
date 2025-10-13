{ inputs, nix-darwin, nix-homebrew, home-manager, vars, self, ... }:
let
  revision = self.ref or self.dirtyRev;
in
{
  mac = nix-darwin.lib.darwinSystem {
    specialArgs = { inherit inputs revision vars; };

    modules = [ 
      ({ config, pkgs, ... }: import ./configuration.nix { inherit config pkgs revision vars; })

      nix-homebrew.darwinModules.nix-homebrew
      {
        nix-homebrew = {
          enable = true;
          enableRosetta = true;
          user = vars.user;
          autoMigrate = true;
        };
      }

      home-manager.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "bak";
        home-manager.users.kattitude = import ../home/default.nix;
      }
    ];
  };
}
