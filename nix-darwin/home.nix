# home.nix
# home-manager switch 

{ config, pkgs, ... }:

{
  home.username = "melvinlee";
  home.homeDirectory = "/Volumes/SSD/melvinlee";
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # Makes sense for user specific applications that shouldn't be available system-wide
  home.packages = with pkgs;[
    httpie # HTTPie is a command line HTTP client
    kind # Kubernetes IN Docker - local clusters for testing Kubernetes
    kubernetes-helm # The Kubernetes Package Manager
    kubectl # Kubernetes command-line tool
    kubectx # Faster way to switch between clusters and namespaces in kubectl
    helmfile # Deploy Kubernetes Helm Charts
    k9s # Kubernetes CLI To Manage Your Clusters In Style!
    bat # A cat(1) clone with wings. https://github.com/sharkdp/bat
    cmatrix # cmatrix is a curses based program that simulates the display from "The Matrix"
    glow # Render markdown on the CLI, with pizzazz!
    just # Just a command runner
    kubernetes-helmPlugins.helm-diff # A helm plugin that shows a diff explaining what a helm upgrade would change
    opentofu  # Open source Tofu
    awscli # Universal Command Line Interface for Amazon Web Services
    fzf # A command-line fuzzy finder
    podman # Podman is a daemonless container engine for developing, managing, and running OCI Containers on your Linux System
    fabric-ai # open-source framework for augmenting humans using AI
    devbox # DevBox is a command-line tool that allows you to easily create and manage isolated development environments using Docker
    talosctl # Talosctl is a command-line utility for interacting with a Talos cluster
    wget # A network utility to retrieve files from the Web
    direnv # direnv is a shell extension that manages environment variables depending on the current directory
    gh # GitHub CLI
    nodejs # Node.js is a JavaScript runtime built on Chrome's V8 JavaScript engine
    uv # An extremely fast Python package and environment manager
    glow #Glow is a terminal based markdown reader designed from the ground up to bring out the beauty—and power—of the CLI.
    github-copilot-cli # GitHub Copilot CLI brings the power of Copilot coding agent directly to your terminal
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
