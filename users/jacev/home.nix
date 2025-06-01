# users/jacev/home.nix
{config, lib, pkgs, ...}:

{
  # Define username and our home directory
  home.username = "jacev";
  home.homeDirectory = "/home/jacev";

  # Import our user-specific theme
  # imports =  [
  #   ../../themes/kde/black-plasma.nix
  # ];

  home.packages = with pkgs; [
    kdePackages.breeze-gtk
    kdePackages.breeze-icons
  ];
  
  programs.home-manager.enable = true;

  # Do not change this!
  home.stateVersion = "24.05";
}
