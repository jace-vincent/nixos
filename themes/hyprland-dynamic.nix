{ config, pkgs, ... }:
{
  # Hyprland Dynamic Wallpaper Theme
  # This theme provides a minimal Hyprland experience with dynamic theming based on wallpaper
  
  # Import Hyprland configuration
  imports = [
    ../hyprland.nix
  ];
  
  # Enhanced dynamic theming for Hyprland
  environment.systemPackages = with pkgs; [
    # Dynamic theming tools already included in packages.nix and hyprland.nix
    # This theme focuses on the aesthetic configuration
  ];
  
  # Theme metadata
  system.nixos.tags = [ "hyprland" "dynamic" "minimal" "wayland" ];
}
