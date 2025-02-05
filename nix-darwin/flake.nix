{
  description = "My Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs; [
        neovim # Vim-fork focused on extensibility and usability
        cowsay # A configurable talking cow
        nushell # A modern shell written in Rust
      ];

      services.spacebar = {
        enable = true;
        package = pkgs.spacebar;
        config = {
          clock_format     = "%R";
          background_color = "0xff202020";
          foreground_color = "0xffa8a8a8";
        };
      };

      users.users.melvinlee.home = "/Volumes/SSD/melvinlee";
      home-manager.backupFileExtension = "backup";

      services.nix-daemon.enable = true;
      nix.settings.experimental-features = "nix-command flakes";

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      system.defaults = {
        dock.autohide = false;
        loginwindow.LoginwindowText = "devops-toolbox";
        screencapture.location = "~/Pictures/screenshots";
      };
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#mini
    darwinConfigurations."mini" = nix-darwin.lib.darwinSystem {
      #  system = "aarch64-darwin";
       modules = [
          configuration
          home-manager.darwinModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.melvinlee = import ./home.nix;
          }
        ];
    };
  };
}
