# home.nix
# home-manager switch 

{ config, pkgs, ... }:

{
  home.username = "melvinlee";
  home.homeDirectory = "/Users/melvinlee";
  home.stateVersion = "23.05"; # Please read the comment before changing.

# Makes sense for user specific applications that shouldn't be available system-wide
  home.packages = with pkgs;[
    httpie
    kind
    checkov
  ];

  home.file = {
  };

  home.sessionVariables = {
  };

  programs.zsh.enable = true;

  home.sessionPath = [
    "/run/current-system/sw/bin"
    "$HOME/.nix-profile/bin"
  ];

  # programs.home-manager.enable = true;

}