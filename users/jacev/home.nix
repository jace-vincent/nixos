# users/jacev/home.nix
{config, pkgs, ...}:

{
  # Define username and our home directory
  home.username = "jacev";
  home.homeDirectory = "/home/jacev";

  # Import our user-specific theme
    imports =  [
      ../../themes/kde/black-plasma.nix # Choose a theme
      ../../modules/programs/zsh.nix # Your default shell
      ./programs/alacritty.nix 
      ./aliases.nix # Customize deeply
    ];

  programs.home-manager.enable = true;

  # Do not change this!
  home.stateVersion = "24.05";
}
