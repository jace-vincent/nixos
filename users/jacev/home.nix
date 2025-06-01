# users/jacev/home.nix
{config, pkgs, ...}:

{
  # Define username and our home directory
  home.username = "jacev";
  home.homeDirectory = "/home/jacev";

  # Import our user-specific theme
  home.packages = with pkgs; [
  # ../../themes/kde/black-plasma.nix
    htop
  ];
  
  programs.home-manager.enable = true;

  # Do not change this!
  home.stateVersion = "24.05";
}
