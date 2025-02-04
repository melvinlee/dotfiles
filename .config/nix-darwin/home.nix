# home.nix
# home-manager switch 

{ config, pkgs, ... }:

{
  home.username = "melvinlee";
  home.homeDirectory = "/Users/melvinlee";
  home.stateVersion = "23.05"; # Please read the comment before changing.

  nixpkgs.config.allowUnfree = true;

  # Makes sense for user specific applications that shouldn't be available system-wide
  home.packages = with pkgs;[
    httpie # HTTPie is a command line HTTP client
    kind # Kubernetes IN Docker - local clusters for testing Kubernetes
    checkov # Infrastructure as Code Static Analysis
    kubernetes-helm # The Kubernetes Package Manager
    helmfile # Deploy Kubernetes Helm Charts
    k9s # Kubernetes CLI To Manage Your Clusters In Style!
    bat # A cat(1) clone with wings. https://github.com/sharkdp/bat
    cmatrix # cmatrix is a curses based program that simulates the display from "The Matrix"
    glow # Render markdown on the CLI, with pizzazz!
    just # Just a command runner
    kubernetes-helmPlugins.helm-diff # A helm plugin that shows a diff explaining what a helm upgrade would change
    opentofu  # Open source Tofu
  ];

  home.file = {
  };

  home.sessionVariables = {
  };

  # programs.zsh.enable = true;

  home.sessionPath = [
    "/run/current-system/sw/bin"
    "$HOME/.nix-profile/bin"
  ];

  programs.home-manager.enable = true;

}
