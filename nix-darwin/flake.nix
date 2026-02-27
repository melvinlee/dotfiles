{
  description = "My Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
      nix-homebrew,
    }:
    let
      configuration =
        { pkgs, ... }:
        {
          nixpkgs.config.allowUnfree = true;

          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = with pkgs; [
            neovim # Vim-fork focused on extensibility and usability
            cowsay # A configurable talking cow
            nushell # A modern shell written in Rust
            nixfmt-rfc-style # Nixfmt with RFC style
          ];

          homebrew = {
            enable = true;
            brews = [
              "stow" # GNU Stow is a symlink farm manager which takes distinct packages of software and/or data located in separate directories on the filesystem, and makes them appear to be installed in the same place.
              "ollama" 
              "qemu" # QEMU is a generic and open source machine emulator and virtualizer.
              "terraform" # Terraform is an open-source infrastructure as code software tool created by HashiCorp.
              "AlexsJones/llmfit/llmfit" # A terminal tool that right-sizes LLM models to your system's RAM, CPU, and GPU. Detects your hardware, scores each model across quality, speed, fit, and context dimensions, and tells you which ones will actually run well on your machine.
              "arimxyer/tap/models"  # A fast CLI and TUI for browsing AI models, benchmarks, and coding agents.
            ];
            casks = [
              "ghostty" # A simple and lightweight tool for creating and managing SSH tunnels
              "google-chrome" # The web browser from Google
              "hammerspoon" # Staggeringly powerful macOS desktop automation with Lua
              "orbstack"
              "the-unarchiver" # The Unarchiver is a small and easy to use program that can unarchive many different kinds of archive files 
              "vlc" # VLC media player
              "vagrant" # Vagrant is a tool for building and managing virtual machine environments in a single workflow
              "notion" # Notion is a note-taking and collaboration application
            ];
            onActivation.cleanup = "zap";
          };

          services.spacebar = {
            enable = true;
            package = pkgs.spacebar;
            config = {
              clock_format = "%R";
              background_color = "0xff202020";
              foreground_color = "0xffa8a8a8";
            };
          };

          users.users.melvinlee.home = "/Volumes/SSD/melvinlee";
          home-manager.backupFileExtension = "backup";
          system.primaryUser = "melvinlee";

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
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.melvinlee = import ./home.nix;
          }
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "melvinlee";
              autoMigrate = true;
            };
          }
        ];
      };
    };
}
